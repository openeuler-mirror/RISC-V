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
    revision = "master"
    for p in params:
        attr = p.getAttribute("name")
        if attr == "url":
            url = p.childNodes[0].data
        if attr == "revision":
            try:
                revision = p.childNodes[0].data
            except IndexError:
                print("##################################")
                print("Handle revision error for [%s]" % name)
                print("##################################")
                pass

    print("_url: %s" % url)
    force_https = os.getenv('FORCE_GITEE_HTTPS', "")
    if force_https != "":
        url = url.replace("git@gitee.com:", "https://gitee.com/")
        print("USE https: %s" % url)
        print("_revision: %s" % revision)

    _cmd = "git clone %s" % url
    print("_cmd: %s" % _cmd)
    subprocess.getstatusoutput("git clone %s" % url)
    subprocess.getstatusoutput("cd %s && git checkout %s && git reset --hard" % (name, revision))
    if not os.path.exists(name):
        print("-----")
        print("Get source of [ %s ] failed." % name)
        print("-----")


def _main():
    rpath = "../configuration/obs_meta/openEuler:Mainline:RISC-V"
    base = os.path.join(os.path.dirname(sys.argv[0]), rpath)

    if sys.argv[1] == "all":
        _pull_all(base)
    else:
        _pull(base, sys.argv[1])

if __name__== '__main__':
    try:
        _main()
    except KeyboardInterrupt:
        pass
