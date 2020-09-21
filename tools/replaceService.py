#!/usr/bin/env python3

# repalce "tar_scm_kernel" with "tar_scm" in _service and insert extract_file into _service
# USAGE：python3 replaceService.py <OBS_DIR> or python3 replaceService.py <OBS_DIR> <SAVE_DIR>
# if you want to save the names of packages which do not have _service files or do not use tar_scm_kernel
# you can use python3 replaceService.py <OBS_DIR> <SAVE_DIR>
# <SAVE_DIR> is the path you define to save the packages names
# if not you can use python3 replaceService.py <OBS_DIR>
# <OBS_DIR> is the path of your OBS project

import sys
import os
import shutil

def handle_service(service,save):
    file = service + "/" + "_service"
    temp_file = file + ".temp"
    
    if(not os.path.exists(file)):
        if (save != ""):
            is_exist = save_not_exist_packages(service,save)
        return
    else:
        lens_origin,lens_insert = replace_service(file,temp_file)
        if (save != ""):
            save_not_replace_packages(lens_origin,lens_insert,service,save)         
    os.remove(file)
    os.rename(temp_file, file)

def save_not_exist_packages(service,save):
    """save the names of packages which do not have the _service file"""
    not_exist_file = save + "/not_exist_file"
    print("not exist:" + service)
    with open(not_exist_file, mode='a+') as fw:
        fw.write(service+"\n")
    fw.close()
    
def save_not_replace_packages(lens_origin,lens_insert,service,save):
    """"save the names of packages which do not use tar_scm_kernel or have been replaced """
    not_change_file = save + "/not_change_file"
    with open(not_change_file, mode='a+') as fw:
        if (lens_origin == lens_insert):
            print("not change:" + service)
            fw.write(service+"\n")
        fw.close()
    
def replace_service(file,temp_file):
    """replace tar_scm_kenel to tar_scm and insert extract_file"""
    with open(file, mode='r') as fr, open(temp_file, mode='w') as fw:
        origin_line = '<service name="tar_scm_kernel">'
        update_line = '<service name="tar_scm">'
        #hit_line = '</service>'
        insert_lines = '    <service name="extract_file">\n' + '      <param name="archive">*.tar</param>\n' + '      <param name="files">*/*</param>\n' + '    </service>\n'
        lines = fr.readlines()
        lens_origin = len(lines)
        #print(lens_origin)
        """
        some service files have been replacesd already or do not use tar_scm_kernel
        so only files having tar_scm_kernel will be inserted extract_file
        """
        for l in lines:
            if origin_line in l:
                #print(service+" changes and inserts extract file")
                lines.insert(lens_origin-2,insert_lines)
        lens_insert = len(lines)
        #print(lens_insert)
        fr.close()
        for line in lines:
            fw.write(line.replace(origin_line,update_line))
        fw.close()
        return lens_origin,lens_insert

if __name__ == '__main__':
    obs_dir = sys.argv[1]
    if (len(sys.argv)>2):
        save_dir = sys.argv[2]
    else:
        save_dir = ""
    for package in sorted(os.listdir(obs_dir)):
        #print(dir)
        if package.startswith('.'):
            continue
        service_dir = obs_dir + "/" + package
        #print(service_dir)
        handle_service(service_dir,save_dir)
