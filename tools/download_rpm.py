#!/usr/bin/env python3

# This is a simple tool to download rpm packages from repo.
#
# usage:
# execute command:
#      download_rpm.py <the url of repo> <keywords>
#
# eg:
#      download_rpm.py https://mirror.iscas.ac.cn/openeuler/openEuler-20.03-LTS-SP1/everything/aarch64/Packages bash
#      to pull rpms from repo which have substring "bash"
#
#      download_rpm.py https://mirror.iscas.ac.cn/openeuler/openEuler-20.03-LTS-SP1/everything/aarch64/Packages
#      if <keywords> was not specified, this tool will download all rpms of the repo.
#.
import os
import subprocess
import sys
def download_rpm(url, name = None):
    status,rpm_list = subprocess.getstatusoutput("curl -L %s | awk -F '\"' '{print $6}'" % url)
    for item in rpm_list.split('\n'):
        if item[len(item)-4:] == ".rpm":
            if name !=None :
                if name in item:
                    status,output = subprocess.getstatusoutput("wget %s/%s" % (url,item))
                    print(output)
            else:
                status,output = subprocess.getstatusoutput("wget %s/%s" % (url,item))
                print(output)

def main():
    url = sys.argv[1]
    if len(sys.argv) == 3:
        name = sys.argv[2]
        download_rpm(url, name)
    else:
        download_rpm(url)
if __name__ == '__main__':
    main()
