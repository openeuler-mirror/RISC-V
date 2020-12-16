#!/usr/bin/env python3
## convert _service.xml to/from riscv_proj_list.yaml
## USAGE: service2yaml <RISC-V_DIR> <PROJ_LIST.yaml> -- convert _service to yaml
##      [TODO]  service2yaml -r <RISC-V_DIR> <PROJ_LIST.yaml> -- convert yaml to _services
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

import yaml

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

if __name__ == "__main__":
    service_dir = sys.argv[1]
    yamlfile = sys.argv[2]
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
