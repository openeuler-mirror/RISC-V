#usage:
# create a directory named src
# copy this file to src
# execute command:
#      python3 pull_src.py <path_of_openEuler:Mainline:RISC-V> <the_pacakege_you_want_to_pull>
import os
from xml.dom.minidom import parse
import xml.dom.minidom
import subprocess
import sys

def gitee_pull(base, name):
    fullname = os.path.join(base, name, "_service")
    DOMTree = xml.dom.minidom.parse(fullname)
    root = DOMTree.documentElement
    services = root.getElementsByTagName("service")
    params = services[0].getElementsByTagName("param")
    url = params[1].childNodes[0].data
    revision = params[3].childNodes[0].data
    if len(revision) != 40:
        subprocess.getstatusoutput("git clone %s -b %s"%(url, revision))
    else:
        subprocess.getstatusoutput("git clone %s"%url)
        subprocess.getstatusoutput("cd %s"%url)
        subprocess.getstatusoutput("git reset --hard %s"%revision)
    
def main():
    base = os.path.realpath(sys.argv[1])
    gitee_pull(base, sys.argv[2])

if __name__== '__main__':
    main()
