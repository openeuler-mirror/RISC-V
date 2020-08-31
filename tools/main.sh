#!/bin/bash
. globals.inc
. autobuildpkgs.sh

set -e
set -x
set -u

for baseName in `cat tasks/openeuler.list`
do
    srpm=${TASK_SRCS_DIR}/${baseName}
    buildPKG $srpm
    #echo $srpm
    #sleep 1
done

