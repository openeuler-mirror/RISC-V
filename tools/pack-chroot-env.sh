#!/bin/sh

# Usage: sh mkfs-oe.sh <path-to-rpm-dir>
# Build an image for vm. The supplied '<path-to-rpm-dir>' will
# be used as is, as '<root-of-image>/repo/rpms'.
#

set -e
set -x

tmp_mnt_dir="/tmp/buildenv-mnt"

mkdir -p /var/tmp/
rm -f /var/tmp/oe-benv-rv.raw

# Create parted and formatted disk
truncate -s 40G /tmp/oe-benv-rv.raw
losetup -P $(losetup -f) /tmp/oe-benv-rv.raw
loopdev=$(losetup -a | grep oe-benv-rv.raw | awk -F: '{print $1;}')
sudo fdisk $loopdev << EOF
n
p
1


w
EOF

mkfs -t ext4 ${loopdev}p1

# Create the installroot
mkdir -p $tmp_mnt_dir
mount -o loop /${loopdev}p1 $tmp_mnt_dir

mkdir -p $tmp_mnt_dir/build_env
cp -a $1 $tmp_mnt_dir/build_env
sync
umount $tmp_mnt_dir

losetup -d $loopdev

# Currently lack of qemu-img on openEuler RISC-V, 
# you can do this step in a x86 or aarch64 host 
qemu-img convert -f raw -O qcow2 /tmp/oe-benv-rv.raw oe-benv-rv.qcow2
rm -rf /tmp/oe-benv-rv.raw
