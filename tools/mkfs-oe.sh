#!/bin/sh

# Usage: sh mkfs-oe.sh
# Build an rootfs image with minimal packages list.
# The output rootfs support systemd, dnf and ssh.
# This script includes installing RISC-V rpms into 
# a sysroot directory, which make it should be executed
# in RISC-V system, or x86/aarch64 system that support
# cross-arch dnf installation.
. ./globals.inc

INSTALL_RPMS="$CORE_RPMS $BUILD_TOOLS"
BIN_SH=`realpath $0`
CONF_DIR=`dirname $BIN_SH`
LOOPDEV=

set -e
set -x

function help()
{
    echo "usage: $BIN_SH "
    echo "Build a rootfs image for openEuler RISC-V"
    exit 0
}

if [ $# != 0 ]; then
    help
fi

function prepare_disk()
{
    mkdir -p /var/tmp/
    rm -f /var/tmp/oe-rv.raw
    # Create parted and formatted disk
    truncate -s 10G /var/tmp/oe-rv.raw
    losetup -P $(losetup -f) /var/tmp/oe-rv.raw
    LOOPDEV=$(losetup -a | grep oe-rv.raw | awk -F: '{print $1;}')
    fdisk $LOOPDEV << EOF
    n
    p
    1
    
    
    w
EOF
    mkfs -t ext4 ${LOOPDEV}p1
}

function install_rpms()
{
    # Create the installroot
    mkdir  -p /var/tmp/mnt
    mount -o loop /${LOOPDEV}p1 /var/tmp/mnt

    mkdir -p /var/tmp/mnt/{dev,proc,sys}
    mkdir -p /var/tmp/mnt/dev/pts
    mount -t proc proc  /var/tmp/mnt/proc
    mount -t sysfs sysfs /var/tmp/mnt/sys
    mount -t devpts pts  /var/tmp/mnt/dev/pts  
    mount -o bind /dev /var/tmp/mnt/dev

    rpm --root /var/tmp/mnt --initdb

    sed -e "s,@RPMREPOWEBSRV@,$WEB_RPM_REPO_SRV,g" < ./assets/openEuler-rv64.repo.in > /etc/yum.repo.d/oe-riscv.repo

    dnf install -y --installroot /var/tmp/mnt $INSTALL_RPMS 
    cp /etc/yum.repos.d/oe-rv.repo /var/tmp/mnt/etc/yum.repos.d/

    echo "Set default passwd to openEuler12#$"

    echo "root:openEuler12#$" | chpasswd -R /var/tmp/mnt/
    echo openEuler-RISCV-rare > /var/tmp/mnt/etc/hostname

    sync
    sleep 5
}

function umount_all()
{
    umount -l /var/tmp/mnt/dev 
    umount -l /var/tmp/mnt/dev/pts
    umount /var/tmp/mnt/sys
    umount /var/tmp/mnt/proc
    umount /var/tmp/mnt

    losetup -d $LOOPDEV
}

trap umount_all INT QUIT TERM EXIT ERR
prepare_disk
install_rpms
umount_all
# Currently lack of qemu-img on openEuler RISC-V, 
# you can do this step in a x86 or aarch64 host 
#qemu-img convert -f raw -O qcow2 /var/tmp/oe-rv.raw /var/tmp/oe-rv.qcow2
#rm -rf /var/tmp/oe-rv.raw
