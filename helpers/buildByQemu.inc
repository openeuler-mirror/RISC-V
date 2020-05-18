#!/bin/bash

function buildByQemu()
{
    local WORK_DIR=$1
    local QEMU_DISK_IMAGE=$2
    local buildDir=$3
    local name=$4
    local baseName=$5

    #
    # 准备QEMU镜像环境，并调整大小满足编译期间的磁盘空间需求
    #
    cp $WORK_DIR/$QEMU_DISK_IMAGE $buildDir/${name}-disk.img
    #truncate -s "$QEMU_DISK_SIZE" $buildDir/${name}-disk.img
    #e2fsck -fp $buildDir/${name}-disk.img
    #resize2fs $buildDir/$name-disk.img

    sed -e "s,@SRPM@,$baseName,g" \
        -e "s,@NAME@,$name,g" \
        < ./helpers/qemuFirstBoot.sh > $buildDir/${name}-boot.sh
    # rpm repo used to build SRPM in qemu builder VM.
    sed -e "s,@RPMREPOWEBSRV@,$WEB_RPM_REPO_SRV,g" < ./assets/local.repo.in > $buildDir/local.repo

    # Copy in the firstboot script, SRPM and repo.
    virt-customize -v -a $buildDir/$name-disk.img \
      --firstboot $buildDir/$name-boot.sh \
      --copy-in $buildDir/$baseName:/var/tmp \
      --copy-in $buildDir/local.repo:/etc/yum.repos.d/

    # Boot the guest.
    qemu-system-riscv64 \
        -nographic -machine virt $QEMU_EXTRA -m $QEMU_MEM_SIZE \
        -kernel $WORK_DIR/bbl \
        -object rng-random,filename=/dev/urandom,id=rng0 \
        -append "rw root=/dev/vda" \
        -drive file=$buildDir/$name-disk.img,format=raw,if=none,id=hd0 \
        -device virtio-blk-device,drive=hd0 \
        -device virtio-net-device,netdev=usernet \
        -netdev user,id=usernet

    #
    # 从QEMU拷贝 root_in_qemu.log, build_in_qemu.log到主机.
    # root_in_qemu.log是在qemu里boot script脚本执行输出的log，包括安装编译环境;
    # build_in_qemu.log是在qemu李rpmbuild编译软件包的log.
    #
    guestfish -a $buildDir/$name-disk.img -i <<EOF
      -download /root_in_qemu.log $WORK_OUT/logs/$baseName/root_in_qemu.log
      -download /build_in_qemu.log $WORK_OUT/logs/$baseName/build_in_qemu.log
      -download /buildok $buildDir/buildok
EOF
}
