#!/bin/bash

# The script is created for starting a riscv64 qemu virtual machine with specific parameters

## Configuration
vcpu=8 # CPU 核心数。
memory=8 # 运行存储大小，单位 GiB。
memory_append=`expr $memory \* 1024`
drive="openEuler-23.03-V1-xfce-qemu-preview.qcow2" # 根文件系统路径
kernel="fw_payload_oe_uboot_2304.bin" # 内核文件路径
bios="none" # BIOS 文件路径，设置为 none 表示 kernel 已包含相关文件。
ssh_port=12055 # 控制端口映射：将虚拟机内部的端口 22 映射到外部的 ssh_port。设置为空表示不启用该功能。
vnc_port=12056 # 控制 VNC 端口。设置为空表示不启用该功能。
spice_port=12057 # 控制 Cpice 端口。设置为空表示不启用该功能。
remoteip=localhost # 控制随后显示脚本的本机地址。
[[ $spice_port ]] && audiobackend="spice" || audiobackend="none" # 当 Spice 启用时，设置音频后端为 spice，否则为 none。可按需改动。
sleeptime=0 # 启动前等待时间

cmd="qemu-system-riscv64 \
  -nographic -machine virt \
  -smp "$vcpu" -m "$memory"G \
  -audiodev "$audiobackend",id=snd0 \
  -kernel "$kernel" \
  -bios "$bios" \
  -drive file="$drive",format=qcow2,id=hd0 \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-vga \
  -device virtio-rng-device,rng=rng0 \
  -device virtio-blk-device,drive=hd0 \
  -device virtio-net-device,netdev=usernet \
  -device qemu-xhci -usb -device usb-kbd -device usb-tablet -device usb-audio,audiodev=snd0 \
  -append 'root=/dev/vda1 rw console=ttyS0 swiotlb=1 loglevel=3 systemd.default_timeout_start_sec=600 selinux=0 highres=off mem="$memory_append"M earlycon' "

echo -e "\033[37mUsing the following configuration: \033[0m"
echo ""
echo -e "\033[37mvCPU Cores:      \033[0m \033[34m"$vcpu"\033[0m"
echo -e "\033[37mMemory:          \033[0m \033[34m"$memory"\033[0m"
echo -e "\033[37mDisk Path:       \033[0m \033[34m"$drive"\033[0m"
echo -e "\033[37mKernal Path:     \033[0m \033[34m"$kernel"\033[0m"
echo -e "\033[37mBIOS Path:       \033[0m \033[34m"$bios"\033[0m"

if [ $ssh_port ]
then
echo -e "\033[37mSSH Port:        \033[0m \033[34m"$ssh_port"\033[0m"
cmd="${cmd} -netdev user,id=usernet,hostfwd=tcp::"$ssh_port"-:22 "
else
cmd="${cmd} -netdev user,id=usernet "
fi

if [ $vnc_port ]
then
echo -e "\033[37mVNC Port:        \033[0m \033[34m"$vnc_port"\033[0m"
cmd="${cmd} -vnc :"$((vnc_port-5900))
fi

if [ $spice_port ]
then
echo -e "\033[37mSPICE Port:      \033[0m \033[34m"$spice_port"\033[0m"
cmd="${cmd} -device virtio-serial-pci \
-device virtserialport,chardev=spicechannel0,name=com.redhat.spice.0 \
-chardev spicevmc,id=spicechannel0,name=vdagent \
-spice port=${spice_port},disable-ticketing=on"
fi
echo ""
if [ $ssh_port ]
then
echo -e "\033[37mUse the following command to connect SSH server:\0\033[0m\033[34m ssh root@"$remoteip" -p "$ssh_port"\033[0m"
fi
if [ $vnc_port ]
then
echo -e "\033[37mUse the following address to connect VNC server:\0\033[0m\033[34m "$remoteip":"$vnc_port"\033[0m"
fi
if [ $spice_port ]
then
echo -e "\033[37mUse the following address to connect SPICE server:\0\033[0m\033[34m spice://"$remoteip":"$spice_port"\033[0m"
fi
echo ""
echo -e "\033[37mUsing the following command to start VM: \033[0m"
echo ""
echo $cmd
echo ""
sleep $sleeptime
echo -e "\033[37mStarting VM... \033[0m"
eval $cmd
echo -e "Exit."
