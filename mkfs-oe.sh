#!/bin/sh

# Usage: sh mkfs-oe.sh
# Build an rootfs image with minimal packages list.
# The output rootfs support systemd, dnf and ssh.
# This script includes installing RISC-V rpms into 
# a sysroot directory, which make it should be executed
# in RISC-V system, or x86/aarch64 system that support
# cross-arch dnf installation.

# . globals.inc


INSTALL_RPMS="$CORE_RPMS $BUILD_TOOLS"
set -e
set -x

mkdir -p /var/tmp/
rm -f /var/tmp/oe-rv.raw

# Create parted and formatted disk
truncate -s 2G /var/tmp/oe-rv.raw
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
mkdir  -p /var/tmp/mnt
mount -o loop /${loopdev}p1 /var/tmp/mnt

mkdir /var/tmp/mnt/{dev,proc,sys}
mkdir /var/tmp/mnt/dev/pts
mount -t proc proc  /var/tmp/mnt/proc
mount -t sysfs sysfs /var/tmp/mnt/sys
mount -t devpts pts  /var/tmp/mnt/dev/pts  
mount -o bind /dev /var/tmp/mnt/dev

rpm --root /var/tmp/mnt --initdb


dnf install  --installroot /var/tmp/mnt   $INSTALL_RPMS 
cp /etc/yum.repos.d/oe-rv.repo /var/tmp/mnt/etc/yum.repos.d/

echo "Set default passwd to openEuler12#$"

echo "root:openEuler12#$" | chpasswd -R /var/tmp/mnt/
echo openEuler-RISCV-rare > /var/tmp/mnt/etc/hostname

sync
sleep 5

umount -l /var/tmp/mnt/dev 
umount -l /var/tmp/mnt/dev/pts
umount /var/tmp/mnt/sys
umount /var/tmp/mnt/proc
umount /var/tmp/mnt

losetup -d $loopdev
qemu-img convert -f raw -O qcow2 /var/tmp/oe-rv.raw /var/tmp/oe-rv.qcow2
rm -rf /var/tmp/oe-rv.raw
