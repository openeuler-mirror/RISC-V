#!/usr/bin/env python3

# This tools is a simple helper to pull source of specified pkg
#
# usage:
# execute command:
#      <path_to_this_repo>/tools/pull_src.py <the_pacakege_you_want_to_pull>
#
# eg:
#      <path_to_this_repo>/tools/pull_src.py bash
#      to pull source code of 'bash'
#
#      specifically, use 'all' to pull full collection
#      <path_to_this_repo>/tools/pull_src.py all
#      to get all source code.
#

import os
from xml.dom.minidom import parse
import xml.dom.minidom
import subprocess
import sys

def _pull_all(base):
    for root, dirs, files in os.walk(base):
        for pkg in dirs:
            _pull(base, pkg)

def _pull(base, name):
    fullname = os.path.join(base, name, "_service")
    DOMTree = xml.dom.minidom.parse(fullname)
    root = DOMTree.documentElement
    services = root.getElementsByTagName("service")
    params = services[0].getElementsByTagName("param")
    url = ""
    revision = ""
    for p in params:
        attr = p.getAttribute("name")
        if attr == "url":
            url = p.childNodes[0].data
        if attr == "revision":
            revision = p.childNodes[0].data

    print("_url: %s" % url)
    print("_revision: %s" % revision)

    _cmd = "git clone %s" % url
    print("_cmd: %s" % _cmd)
    subprocess.getstatusoutput("git clone %s" % url)
    subprocess.getstatusoutput("cd %s && git checkout %s && git reset --hard" % (name, revision))

def _main():
    base = os.path.realpath(sys.argv[0])
    base = os.path.dirname(base)
    base = os.path.dirname(base)
    base = base + "/configuration/obs_meta/openEuler:Mainline:RISC-V"
    if sys.argv[1] == "all":
        _pull_all(base)
    else:
        _pull(base, sys.argv[1])

if __name__== '__main__':
    _main()
