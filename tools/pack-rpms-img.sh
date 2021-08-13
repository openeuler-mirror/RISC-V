#!/bin/sh

# Usage: sh mkfs-oe.sh <path-to-rpm-dir>
# Build an image for vm. The supplied '<path-to-rpm-dir>' will
# be used as is, as '<root-of-image>/repo/rpms'.
#

set -e
set -x

mkdir -p /var/tmp/
rm -f /var/tmp/oe-repo-rv.raw

# Create parted and formatted disk
truncate -s 40G /tmp/oe-repo-rv.raw
losetup -P $(losetup -f) /tmp/oe-repo-rv.raw
loopdev=$(losetup -a | grep oe-repo-rv.raw | awk -F: '{print $1;}')
sudo fdisk $loopdev << EOF
n
p
1


w
EOF

mkfs -t ext4 ${loopdev}p1

# Create the installroot
mkdir -p /tmp/repo-mnt
mount -o loop /${loopdev}p1 /tmp/repo-mnt

mkdir -p /tmp/repo-mnt/repo
cp -a $1 /tmp/repo-mnt/repo/rpms
sync
umount /tmp/repo-mnt

losetup -d $loopdev

# Currently lack of qemu-img on openEuler RISC-V, 
# you can do this step in a x86 or aarch64 host 
qemu-img convert -f raw -O qcow2 /tmp/oe-repo-rv.raw oe-repo-rv.qcow2
rm -rf /tmp/oe-repo-rv.raw
