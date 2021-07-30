#!/usr/bin/env python3

# This tools is a simple helper to pull source of specified pkg
#
# usage:
# execute command:
#      <path_to_this_repo>/tools/pull_src.py <the_pacakege_you_want_to_pull>
#
# eg:
#      <path_to_this_repo>/tools/pull_src.py bash
#

import os
from xml.dom.minidom import parse
import xml.dom.minidom
import subprocess
import sys

def _pull(base, name):
    fullname = os.path.join(base, name, "_service")
    DOMTree = xml.dom.minidom.parse(fullname)
    root = DOMTree.documentElement
    services = root.getElementsByTagName("service")
    params = services[0].getElementsByTagName("param")
    url = params[1].childNodes[0].data
    revision = params[2].childNodes[0].data
    print("_url: %s" % url)
    print("_revision: %s" % revision)

    if revision != ".git":
        _cmd = "git clone %s -b %s " % (url, revision)
        print("_cmd: %s" % _cmd)
        subprocess.getstatusoutput("git clone %s -b %s" % (url, revision))
    else:
        _cmd = "git clone %s" % url
        print("_cmd: %s" % _cmd)
        subprocess.getstatusoutput("git clone %s" % url)
        subprocess.getstatusoutput("cd %s" % url)
        subprocess.getstatusoutput("git reset --hard %s" % revision)

def _main():
    base = os.path.realpath(sys.argv[0])
    base = os.path.dirname(base)
    base = os.path.dirname(base)
    base = base + "/configuration/obs_meta/openEuler:Mainline:RISC-V"
    _pull(base, sys.argv[1])

if __name__== '__main__':
    _main()
