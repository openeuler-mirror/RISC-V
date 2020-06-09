#!/bin/sh

# Usage: sh mkfs-oe.sh
# Build an rootfs image with minimal packages list.
# The output rootfs support systemd, dnf and ssh.
# This script includes installing RISC-V rpms into 
# a sysroot directory, which make it should be executed
# in RISC-V system, or x86/aarch64 system that support
# cross-arch dnf installation.

. globals.inc

CORE_RPMS="systemd vim coreutils net-tools systemd-udev libssh openssh passwd git NetworkManager dnf wget procps-ng dnf-plugins-core rpm-build"

set -e
set -x

mkdir -p /var/tmp/
rm -f /var/tmp/*

# Create parted and formatted disk
truncate -s 10G /var/tmp/oe-rv.raw
losetup -P $(losetup -f) /var/tmp/oe-rv.raw
loopdev=$(losetup -a | grep oe-rv.raw | awk -F: '{print $1;}')
fdisk $loopdev << EOF
n
p
1


w
EOF
mkfs -t ext4 ${loopdev}p1

# Create the installroot
mkdir  /var/tmp/mnt
mount -o loop /${loopdev}p1 /var/tmp/mnt
mkdir /var/tmp/mnt/{dev,proc,sys}
mount -t proc /proc  /var/tmp/mnt/proc
mount --rbind /sys /var/tmp/mnt/sys
mount --rbind /dev /var/tmp/mnt/dev 
mount --make-rslave /var/tmp/mnt/dev
mount --make-rslave /var/tmp/mnt/sys

rpm --root /var/tmp/mnt --initdb

sed -e "s,@RPMREPOWEBSRV@,$WEB_RPM_REPO_SRV,g" < ./assets/openEuler-rv64.repo.in > /etc/yum.repo.d/oe-riscv.repo
dnf install  --installroot /var/tmp/mnt --repo oe-rv  $CORE_RPMS -y

echo "Change default passwd to empty"
sed -i '1s/*//'  /var/tmp/mnt/etc/shadow
echo openEuler-RISCV-rare > /var/tmp/mnt/etc/hostname

sync
sleep 5

umount -R /var/tmp/mnt/dev 
umount -R /var/tmp/mnt/sys
umount  /var/tmp/mnt/proc
umount /var/tmp/mnt

losetup -d $loopdev
qemu-img convert -f raw -O qcow2 /var/tmp/oe-rv.raw /var/tmp/oe-rv-rare.qcow2
rm -rf /var/tmp/oe-rv.raw
