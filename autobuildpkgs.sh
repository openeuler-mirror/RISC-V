#!/bin/bash

. globals.inc
. helpers/buildByQemu.inc

set -e
set -x
set -u


function buildPKG()
{
    # e.g. RPMPackages/shadow-4.7-10.oe1.src.rpm, 源码包完整路经
    local srpm="$1"

    # e.g. shadow-4.7-10.oe1.src.rpm
    local baseName="$(basename $1)"
    #
    # e.g. shadow
    # Warning: Header V3 RSA/SHA1 Signature, key ID b25e7f66: NOKEY
    #
    local name="$(rpm -q --qf '%{NAME}\n' -p $srpm)"
    mkdir -p $WORK_OUT/logs/$baseName
    local logFile=outer_script.log

    #if ${DEBUG}; then
    #    :
    #else
        #exec >& $WORK_OUT/logs/$baseName/$logFile
        exec 2>&1 | tee $WORK_OUT/logs/$baseName/$logFile
    #fi

    local buildDir=$WORK_OUT/builds/$baseName

    mkdir -p $buildDir
    #cp $srpm $buildDir

    succeedSrc=$WORK_OUT/succeed.list
    touch $succeedSrc
    noarchSrc=$WORK_OUT/noarch.list
    touch $noarchSrc
    allSrcReached=$WORK_OUT/allsrcreached.list
    touch $allSrcReached
    failedSrcInBuild=$WORK_OUT/failedinbuild.list
    touch $failedSrcInBuild
    failedSrcPreBuild=$WORK_OUT/failedprebuild.list
    touch $failedSrcPreBuild
    failedSrcBootQemu=$WORK_OUT/failedsrcbootqemu.list
    touch $failedSrcBootQemu
    failedSrcAll=$WORK_OUT/failedsrcall.list
    touch $failedSrcAll

    echo $baseName>>$allSrcReached

    #
    # noarch包，不需要重新编译，直接从openEuler的repo或者obs下载, 615个noarch
    # Warning: Header V3 RSA/SHA1 Signature, key ID b25e7f66: NOKEY
    #
    #if rpm -qip "$buildDir/$baseName" | grep -sq '^Architecture: noarch$'; then
    if rpm -qip "$srpm" | grep -sq '^Architecture: noarch$'; then
        #TODO: download binary rpms from openEuler repo directly.
	pushd $buildDir
	#TODO: move *.noarch.rpm to $builddir
	touch noarch # mark
	popd
	echo $baseName>>$noarchSrc
	echo $baseName>>$succeedSrc
	touch $WORK_OUT/needs_update_repo #标记有新包构建产生，需要更新rpm repo
	#exit 0
	return 0
    fi

    cp $srpm $buildDir

    # 非noarch的包，需要编译
    case "$PLAT" in
    qemu)
	#buildByQemu $WORK_DIR $QEMU_DISK_IMAGE $buildDir $name $baseName

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
        virt-customize -a $buildDir/$name-disk.img \
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

         # 检查编译执行结果.
        if [ -f $buildDir/buildok ]; then
            # 编译成功.
	    echo $baseName>>$succeedSrc
        elif [ -f $WORK_OUT/logs/$baseName/build_in_qemu.log ]; then
            # 编译软件包阶段失败: rpmbuild编译执行失败.
            echo $baseName>>$failedSrcInBuild
            echo $baseName>>$failedSrcAll
            #exit 1
	    return 0
        elif [ -f $WORK_OUT/logs/$baseName/root_in_qemu.log ]; then
            # 未进入编译阶段失败: 执行boot script过程中，执行rpmbuild前失败.
            echo $baseName>>$failedSrcPreBuild
            echo $baseName>>$failedSrcAll
            #exit 1
	    return 0
        else
	    #
            # 发生了严重错误，未产生boot script执行和编译期间日志，很可能是其的哦个boot script前失败,
	    # 所以该错误不属于安装编译依赖环境错误，也不属于编译期间错误，应该重新执行相应SRPM软件包编译.
	    #
            echo $baseName>>$failedSrcBootQemu
            echo $baseName>>$failedSrcAll
            #exit 1
	    return 0
        fi
    
        # 编译成功的耗时.
        awk -v dt=$SECONDS 'BEGIN{ dd=int(dt/86400); dt2=dt-86400*dd; dh=int(dt2/3600); dt3=dt2-3600*dh; dm=int(dt3/60); ds=dt3-60*dm; printf "Build time: %d days %02d hours %02d minutes %02d seconds\n", dd, dh, dm, ds}'

        # 编译成功, 将生成的RPM文件从虚拟机拷贝到编译主机.
        virt-copy-out -a $buildDir/$name-disk.img /builddir/build/RPMS /builddir/build/SRPMS $buildDir/
    
        cp $WORK_OUT/SRPMS/*.src.rpm $WORK/SRPMS/
        cp $WORK_OUT/RPMS/noarch/*.noarch.rpm $WORK/RPMS/noarch/
        cp $WORK_OUT/RPMS/riscv64/*.riscv64.rpm $WORK/RPMS/riscv64/
    
        touch $WORK/needs_update_repo

        return 0
        ;;
    cross)
        echo "Cross compiling not supported yet."
	return 1
	;;
    hardware)
        echo "Cross compiling not supported yet."
	return 1
	;;
    *)
        echo "Unknown compiling platform."
        return 1 
    esac
}

if false; then
if ${DEBUG}; then
    while read baseName 
    do
	srpm=${TASK_SRCS_DIR}/${baseName}
        buildPKG $srpm
	#echo $srpm
    done < tasks/openeuler.list
fi
fi

if false; then
for baseName in `cat tasks/openeuler.list`
do
    srpm=${TASK_SRCS_DIR}/${baseName}
    buildPKG $srpm
    #echo $srpm
    sleep 1
done
fi
