#!/bin/bash

hostname oel-qemu-builder
echo oel-qemu-builder > /etc/hostname

echo '************************'
echo 'In QEMU Build Platform.'
echo '************************'

exec >& /root_in_qemu.log
#exec 2>&1 | tee /root_in_qemu.log

# Cleanup function called on failure or exit.
function cleanup ()
{
    set +e
    # sync disks
    sync
    sleep 3
    sync
    # The VM will be blocked because of bug in 'systemd poweroff', so force immediate poweroff.
    poweroff -f
}
trap cleanup INT QUIT TERM EXIT ERR

set -x
#set -e

user=qemubuilder
topdir=/builddir/build

# For dnf to reread the 'local' repo.
dnf clean all
dnf makecache --verbose

# Create a 'qemubuilder' user.
useradd -d /builddir $user
su -c "mkdir $topdir" $user

# Set _topdir to point to the build directory.
echo "%_topdir $topdir" > /builddir/.rpmmacros
# Install the SRPM.
su -c "rpm -i /var/tmp/@SRPM@" $user

# Install the package BuildRequires.......
dnf -y builddep $topdir/SPECS/@NAME@.spec --define "_topdir $topdir"

# Pick up any updated packages since qemu-image was built:
dnf -y update --best ||:

# Install the basic build environment.
dnf -y group install buildsys-build

exec >& /build_in_qemu.log

# Close stdin in case build is interactive.
exec < /dev/null

rm -rf /rpmbuild
mkdir -p /rpmbuild

su -c "rpmbuild -ba $topdir/SPECS/@NAME@.spec \
           --define \"debug_package %{nil}\" \
           --undefine _annotated_build \
           --define \"_missing_doc_files_terminate_build %{nil}\" \
           --define \"_emacs_sitestartdir /usr/share/emacs/site-lisp/site-start.d\" \
           --define \"_emacs_sitelispdir /usr/share/emacs/site-lisp\" \
           --nocheck \
  " $user

touch /buildok

# cleanup() is called automatically here.
