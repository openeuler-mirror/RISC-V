#!/bin/bash

function prepare_img()
{
    rm -f oe-rv.raw
    truncate -s 10G oe-rv.raw
    losetup -fP oe-rv.raw
    loopdev=$(losetup -a | grep -v deleted | grep oe-rv.raw | awk -F: '{print $1;}')
    echo "n
    p
    1
    
    
    w
    " | fdisk $loopdev && mkfs.ext4 ${loopdev}p1
}

function mount_img()
{
    rm -rf rootfs
    mkdir rootfs
    mount -o loop ${loopdev}p1 rootfs
}

function install_rpms()
{
    mkdir -p rootfs/{dev,proc,sys,etc}
    mkdir -p rootfs/dev/pts
    mount -t proc proc rootfs/proc
    mount -t sysfs sysfs rootfs/sys
    mount -t devpts pts rootfs/dev/pts
    mount -o bind /dev rootfs/dev
    rpm --root rootfs --initdb
    rm -rf RISC-V
    git clone https://gitee.com/openeuler/RISC-V.git
    mkdir -p rootfs/etc/yum.repos.d
    cp RISC-V/tools/osmaker/qemuimg/oe-rv.repo rootfs/etc/yum.repos.d/oe-rv.repo
    echo $(cat rootfs/etc/yum.repos.d/oe-rv.repo)
    rpmslist=$(cat RISC-V/tools/osmaker/qemuimg/pkg.list)
    echo $rpmslist
    yum install -y --installroot $(pwd)/rootfs $rpmslist 2>&1 |tee pkginstall_log.txt
    rm rootfs/etc/yum.repos.d/openEuler.repo
}

function config_services()
{
    #systemd-timesyncd
    cp /etc/systemd/timesyncd.conf rootfs/etc/systemd/timesyncd.conf
    sed -i 's/#NTP=/NTP=ntp.aliyun.com ntp1.aliyun.com time1.cloud.tencent.com time2.cloud.tencent.com/g' rootfs/etc/systemd/timesyncd.conf
    sed -i 's/#FallbackNTP=time1.google.com time2.google.com time3.google.com time4.google.com/FallbackNTP=time1.google.com time2.google.com time3.google.com time4.google.com/g' rootfs/etc/systemd/timesyncd.conf 
    sed -i 's/#RootDistanceMaxSec=5/RootDistanceMaxSec=5/g' rootfs/etc/systemd/timesyncd.conf
    sed -i 's/#PollIntervalMinSec=32/PollIntervalMinSec=32/g' rootfs/etc/systemd/timesyncd.conf
    sed -i 's/#PollIntervalMaxSec=2048/PollIntervalMaxSec=2048/g' rootfs/etc/systemd/timesyncd.conf
    #add account
    echo "root:openEuler12#$" | chpasswd -R $(pwd)/rootfs/
    echo openEuler-riscv64 > $(pwd)/rootfs/etc/hostname
    sleep 5
}

function config_extlinux()
{
    mkdir -p rootfs/extlinux
    cat > rootfs/extlinux/extlinux.conf << EOF
    default openEuler-riscv
    label   openEuler-riscv
            kernel /boot/Image
            append 'root=/dev/vda1 rw console=ttyS0 systemd.default_timeout_start_sec=600 selinux=0 highres=off mem=4096M earlycon'
EOF
}

function umount_all()
{
    umount -l rootfs/dev
    umount -l rootfs/dev/pts
    umount rootfs/sys
    umount rootfs/proc
    umount rootfs
    losetup -d $loopdev
}

function compress_rootfs()
{
    rm -f oe-rv.tar.gz
    losetup -fP oe-rv.raw
    loopdev=$(losetup -a | grep -v deleted | grep oe-rv.raw | awk -F: '{print $1;}')
    mount -o loop ${loopdev}p1 rootfs
    tar -cvpzf oe-rv.tar.gz rootfs
    umount rootfs
    losetup -d $loopdev
}


prepare_img
echo "prepare_img complete"
mount_img
echo "mount_img complete"
install_rpms
echo "istall_rpms complete"
config_services
echo "config_services complete"
config_extlinux
echo "config_extlinux complete"
umount_all
echo "umount_all complete"
compress_rootfs
echo "compress_rootfs complete"

