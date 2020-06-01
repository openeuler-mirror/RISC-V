#!/bin/bash

source globals.inc
set -e

#if false; then
mkdir -p $DOWN_SRCS_DIR
pushd $DOWN_SRCS_DIR
wget -r -np -nH -R index.html $DOWN_SRCS_DIR
popd
#fi

echo 'Finish download SRPMS of openEuler!'
