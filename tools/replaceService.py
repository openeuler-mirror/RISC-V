#!/usr/bin/env python3

# repalce "tar_scm_kernel" with "tar_scm" in _service and insert extract_file into _service
# USAGE：python3 replaceService.py <OBS_DIR>

import sys
import os
import shutil

def handle_service(service):
    #replace tar_scm_kenel with tar_scm and insert extract_file
    file = service + "/" + "_service"
    temp_file = file + '.temp'
    with open(file, mode='r') as fr, open(temp_file, mode='w') as fw:
        origin_line = '<service name="tar_scm_kernel">'
        update_line = '<service name="tar_scm">'
        insert_lines = '    <service name="extract_file">\n' + '      <param name="archive">*.tar</param>\n' + '      <param name="files">*/*</param>\n' + '    </service>\n'
        lines = fr.readlines()
        # some service files have been changed already 
        # so only files having tar_scm_kernel will be inserted extract_file
        lens = len(lines)
        for l in lines:
            if origin_line in l:
                #insert extract_file
                lines.insert(lens-2,insert_lines)
        fr.close()
        for line in lines:
            # replace tar_scm_kenel with tar_scm
            fw.write(line.replace(origin_line,update_line))
        fw.close()
    os.remove(file)
    os.rename(temp_file, file)
if __name__ == '__main__':
    obs_dir = sys.argv[1]
    for dir in sorted(os.listdir(obs_dir)):
        package = dir
        if package.startswith('.'):
            continue
        service_dir = obs_dir + "/" + package
        handle_service(service_dir)
