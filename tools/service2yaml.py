#!/usr/bin/env python3
## convert _service.xml to/from riscv_proj_list.yaml
## USAGE: service2yaml <RISC-V_DIR> <PROJ_LIST.yaml> -- convert _service to yaml
##        service2yaml -r <RISC-V_DIR> <PROJ_LIST.yaml> -- convert yaml to _services
## yaml format
## <PROJ_LIST> -> <PACKAGE>,<PACKAGE>,...
## <PACKAGE> -> [[<SRC_TAR_URL>, <REVISION>, <EXCLUDE>], [<SPEC_REPO_URL>, <REVISION>, <EXCLUDE>]]
## yaml sample:
## packages:
## - name: opensbi
##   spec:
##     url: src-openeuler/opensbi
## - name: risc-v-kernel
##   src:
##     url: openeuler/kernel  #refers to https://gitee.com/openeuler/kernel
##     revision: v5.5.19
##     version: 5.5.19
##     exclude: .git
##     compression: bz2
##     file2compress: *.tar
##   spec:
##     url: src-openeuler/risc-v-kernel #refers to https://gitee.com/src-openeuler/kernel
##     exclude: .git
##


import argparse
import atexit
import datetime
import glob
import hashlib
import logging
import os
import re
import shutil
import subprocess
import sys
import tarfile
from xml.dom.minidom import *
import yaml
import getopt

def import_xml_parser():
    #global ET
    try:
        import lxml.etree as ET
        xml_parser = ET.XMLParser(remove_comments=False)
    except ImportError:
        import xml.etree.ElementTree as ET
        xml_parser = None
        if not hasattr(ET, 'ParseError'):
            try:
                import xml.parsers.expat
            except:
                raise RuntimeError("Couldn't load XML parser error")
    return xml_parser
def handle_service_tar_scm(service):
    tar_scm_str = "  src:\n"
    for param in service.findall("param[@name='url']"):
        #handle get tarball from git url
        url = param.text
        #extract string between ':' and '.git' 
        url = url[url.find(':')+1:url.find('.git')]
        tar_scm_str += "   url: " + url + '\n'
    for param in service.findall("param[@name='revision']"):
        #handle_revision
        revision = param.text
        tar_scm_str += "   revision: " + revision + '\n'
    for param in service.findall("param[@name='version']"):
        #handle_version
        version = param.text
        tar_scm_str += "   version: " + version + '\n'
    for param in service.findall("param[@name='exclude']"):
        #handle_version
        exclude = param.text
        tar_scm_str += "   exclude: " + exclude + '\n'
    return tar_scm_str
def handle_service_tar_scm_repo_docker(service):
    tar_scm_repo_docker_str = "  src:\n"
    for param in service.findall("param[@name='scm']"):
        if (param.text == "git"):
            for param in service.findall("param[@name='url']"):
                #handle get tarball from git url
                url = param.text
                #extract string between ':' and '.git' 
                url = url[url.find(':')+1:url.find('.git')]                    
                tar_scm_repo_docker_str += "   url: " + url + '\n'
        else:
            for param in service.findall("param[@name='url']"):
                #handle get tarball from repo url
                url = param.text
                #extract string at the last '/' 
                url = url[url.rfind('/') + 1:len(url)]
                tar_scm_repo_docker_str += "   url: " + "src-openeuler/" + url + '\n'
    for param in service.findall("param[@name='filename']"):
        #handle_filename
        filename = param.text
        tar_scm_repo_docker_str += "   filename: " + filename + '\n'
    for param in service.findall("param[@name='revision']"):
        #handle_revision
        revision = param.text
        tar_scm_repo_docker_str += "   revision: " + revision + '\n'
    for param in service.findall("param[@name='version']"):
        #handle_version
        version = param.text
        tar_scm_repo_docker_str += "   version: " + version + '\n'
    for param in service.findall("param[@name='exclude']"):
        #handle_exclude
        exclude = param.text
        tar_scm_repo_docker_str += "   exclude: " + exclude + '\n'
    return tar_scm_repo_docker_str
def handle_service_tar_scm_repo(service):
    ret_str = "  src:\n"
    for param in service.findall("param[@name='url']"):
        #handle get tarball from git url
        url = param.text
        #extract string between ':' and '.git' 
        url = url[url.find(':')+1:url.find('.git')]            
        ret_str += "   url: " + url + '\n'
    for param in service.findall("param[@name='revision']"):
        #handle_revision
        revision = param.text
        ret_str += "   revision: " + revision + '\n'
    for param in service.findall("param[@name='version']"):
        #handle_version
        version = param.text
        ret_str += "   version: " + version + '\n'
    for param in service.findall("param[@name='exclude']"):
        #handle_exclude
        exclude = param.text
        ret_str += "   exclude: " + exclude + '\n'
    for param in service.findall("param[@name='filename']"):
        #handle_filename
        filename = param.text
        ret_str += "   filename: " + filename + '\n'
    return ret_str
def handle_service_recompress(service):
    ret_str = ""
    for param in service.findall("param[@name='compression']"):
        #handle recompress type
        recompress_type = param.text
        ret_str += "   compression: " + recompress_type + '\n'
    for param in service.findall("param[@name='file']"):
        file2compress = param.text
        ret_str += "   file2compress: " + "\"" + file2compress + "\"" + '\n'
    return ret_str
def handle_service_extract_file(service):
    ret_str = ""
    for param in service.findall("param[@name='archive']"):
        #handle  extract_file type
        archive_type = param.text
        ret_str += "   archive: " + "\""+ archive_type + "\"" + '\n'
    for param in service.findall("param[@name='files']"):
        file2archive = param.text
        ret_str += "   file2archive: " + "\"" + file2archive + "\"" +'\n'
    return ret_str
def handle_service_tar_scm_kernel_repo(service):
    ret_str = "  spec:\n"
    for param in service.findall("param[@name='url']"):
        #handle src server repo
        url = param.text
        url = url[url.rfind('/') + 1:len(url)]
        ret_str += "   url: " + "src-openeuler/" + url + '\n'
    for param in service.findall("param[@name='exclude']"):
        exclude = param.text
        ret_str += "   exclude: " + exclude + '\n'
    return ret_str
def handle_xml_service(service):
    ret_str = ""
    service_type = service.attrib['name']
    if service_type == "tar_scm":
        ret_str += handle_service_tar_scm(service)
    elif service_type == "tar_scm_repo_docker":
        ret_str += handle_service_tar_scm_repo_docker(service)
    elif service_type == "tar_scm_repo":
        ret_str += handle_service_tar_scm_repo(service)
    elif service_type == "recompress":
        ret_str += handle_service_recompress(service)
    elif service_type == "extract_file":
        ret_str += handle_service_extract_file(service)
    elif service_type == "tar_scm_kernel_repo":
        ret_str += handle_service_tar_scm_kernel_repo(service)
    else:
        print("unrecongnized service type"+service_type)
    return ret_str

def xml2yaml(xmlfile):
    """ Convert _service.xml to appending to riscv_proj_list.yaml """
    xml_parser = import_xml_parser()
    try:
        import xml.etree.ElementTree as ET
        xml_data_tree = ET.parse(xmlfile, parser=xml_parser)
    except Exception as e:
        print(e)
        raise
    if xml_data_tree is None:
        print("parse xml tree root error")
    else:
        root = xml_data_tree.getroot()
        scm_services = root.findall("service")
        service_str = ""
        for service in scm_services:
            service_str += handle_xml_service(service)
        return service_str
    return "unhandle errors in xml2yaml!"
def create_xml_node(doc,param,attribute,text):
    node = doc.createElement(param)
    node.setAttribute('name',attribute)
    node.appendChild(doc.createTextNode(text))
    return node
    
def yaml2xml(yamlfile,output_dir):
    yaml_file = open(yamlfile)
    yaml_dict = yaml.safe_load(yaml_file)
    packages = yaml_dict["packages"]
    for package in packages:
        name = package["name"]
        package_path = output_dir+'//'+name
        if not os.path.exists(package_path):
            os.mkdir(package_path)
        src = package["src"]
        url_text = src["url"]
        revision_text = src["revision"]
        exclude_text = src["exclude"]
        archive_text = src["archive"]
        file2archive_text = src["file2archive"]
        
        doc=Document()
        root = doc.createElement('services')
        doc.appendChild(root)      
        tar_scm_service = doc.createElement('service')
        tar_scm_service.setAttribute('name','tar_scm')
        root.appendChild(tar_scm_service)
        
        tar_scm_service.appendChild(create_xml_node(doc,'param','scm','git'))
        tar_scm_service.appendChild(create_xml_node(doc,'param','url','git@gitee.com:' + url_text + '.git'))
        tar_scm_service.appendChild(create_xml_node(doc,'param','exclude',exclude_text))
        tar_scm_service.appendChild(create_xml_node(doc,'param','revision',revision_text))
    
        extract_file_service = doc.createElement('service')
        extract_file_service.setAttribute('name','extract_file')
        root.appendChild(extract_file_service)
        
        extract_file_service.appendChild(create_xml_node(doc,'param','archive',archive_text))
        extract_file_service.appendChild(create_xml_node(doc,'param','files',file2archive_text))
        
        with open(package_path+'//_service', 'wb') as f:
            f.write(doc.toprettyxml(indent='\t', encoding='utf-8')[39:])
        f.close()
        
def check_file(args):
    if len(args) != 2:
        print('error: params error')
        sys.exit()
    input_file=args[0]
    output_file=args[1]
    return input_file,output_file

def usage():
    print('convert _service.xml to/from riscv_proj_list.yaml')
    print('usage example: ')
    print('service2yaml -t <RISC-V_DIR> <PROJ_LIST.yaml>')
    print('service2yaml -r <PROJ_LIST.yaml> <RISC-V_DIR> ')
    print('options')
    print(' -h: for help')
    print(' -t: convert _service to yaml')
    print(' -r: convert yaml to _services')

def main(argv):
    try:
        options, args = getopt.getopt(argv, "htr", ["help"])
    except getopt.GetoptError:
        print('error: invalid params')
        sys.exit()
    if not options:
        print('error: options cannot be empty')
    for option, value in options:
        if option in ("-h", "--help"):
            usage()
            sys.exit()
        elif option in ("-r"):
            input_file,output_file=check_file(args)
            yaml2xml(input_file,output_file)
            sys.exit()
        elif option in ("-t",):
            service_dir = input_file
            yamlfile = output_file
            str_buf = "packages:\n"
            for pkg_dir in sorted(os.listdir(service_dir)):
                package = pkg_dir
                if package.startswith('.'):
                    continue
                str_buf += "- name: " + package + '\n'
                for file in os.listdir(service_dir + "/" + package):
                    if file != "_service":
                        continue
                    str_buf += xml2yaml(service_dir + "/" + package + "/" + file)
            f = open(yamlfile, "a")
            print(str_buf, file = f)
            f.close()
if __name__ == '__main__':
    main(sys.argv[1:])

