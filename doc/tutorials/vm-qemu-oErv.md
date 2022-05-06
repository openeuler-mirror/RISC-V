# 通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统

## 安装 `qemu-riscv64`
> 参考文档：[https://wiki.qemu.org/Documentation/Platforms/RISCV](https://wiki.qemu.org/Documentation/Platforms/RISCV)


以 Ubuntu 为例，查看软件源上是否有qemu-rv64的二进制安装包：
```
$ sudo apt update
$ sudo apt-cache search all | grep qemu
oem-qemu-meta - Meta package for QEMU
qemu - fast processor emulator, dummy package
qemu-system - QEMU full system emulation binaries
aqemu - QEMU 和 KVM 的 Qt5 前端
grub-firmware-qemu - GRUB firmware image for QEMU
nova-compute-qemu - OpenStack Compute - compute node (QEmu)
qemu-guest-agent - Guest-side qemu-system agent
qemu-system-x86-xen - QEMU full system emulation binaries (x86)
qemu-user - QEMU user mode emulation binaries
qemu-user-binfmt - QEMU user mode binfmt registration for qemu-user
qemu-user-static - QEMU user mode emulation binaries (static version)
qemubuilder - pbuilder using QEMU as backend
```

一般来说，常见 GNU/Linux 发行版软件源中都提供了包含 `qemu-system-riscv64` 的软件包，如果软件源中并未收录 `QEMU`，则可以自行下载源码包手动构建安装：

> 源码包下载：[https://download.qemu.org/](https://download.qemu.org/)


### I. 下载 QEMU 源代码并构建


`$ sudo apt install build-essential`
安装必要的构建工具

`$ wget https://download.qemu.org/qemu-<latest>.tar.xz`
 下载最新 QEMU 源码包，**请将 `<latest>` 替换为目前最新的 QEMU 版本**

`$ tar xvJf qemu-<latest>.tar.xz`
解压刚刚下载的源码包

`$ cd qemu-<latest>`



`./configure --target-list=riscv64-softmmu,riscv64-linux-user --prefix=/home/xx/program/riscv64-qemu`
`riscv-64-linux-user`为用户模式，可以运行基于 RISC-V 指令集编译的程序文件, `softmmu`为镜像模拟器，可以运行基于 RISC-V 指令集编译的linux镜像，为了测试方便，可以两个都安装

`$ make`
`$ make install`
如果 `--prefix` 指定的目录位于根目录下，则需要在 `./configure` 前加入 `sudo`


### II. 配置环境变量

`$ vim ~/.bashrc`
在文末添加：
````
export QEMU_HOME=/home/xx/program/riscv64-qemu
export PATH=$QEMU_HOME/bin:$PATH
````
**注意一定要将 `QEMU_HOME` 路径替换为 `--prefix` 定义的路径**

`$ source ~/.bashrc`
`$ echo $PATH`



### III. 验证安装是否正确

`$ qemu-system-riscv64 --version`

如出现类似如下输出表示 QEMU 工作正常
````
QEMU emulator version 5.0.0
Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
````



## 下载 openEuler RISC-V 系统镜像
恭喜你已经成功编译安装了最新版的 QEMU，接下来我们需要下载 openEuler RISC-V 的系统镜像。

由于我们的目标是运行最新版的 openEuler RISC-V OS，我们采用最新的发行版 22.03：

注：  `20.03`的系统镜像安装移步至[20.03系统镜像下载](https://gitee.com/openeuler/RISC-V/blob/dced224a78ff47e547d4d00fcf3023177c7f4a5f/doc/tutorials/vm-qemu-oErv.md#%E4%B8%8B%E8%BD%BD-openeuler-risc-v-%E7%B3%BB%E7%BB%9F%E9%95%9C%E5%83%8F)

提供两种安装方式
### 浏览器下载
下载地址：[https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/development/2203/Image/](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/development/2203/Image/)

![image.png](images/download-image2203.png)
### linux命令行安装

```bash
mkdir oervimg
cd oervimg
wget https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/development/2203/Image/run.sh
wget https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/development/2203/Image/fw_payload_oe.elf
wget https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/development/2203/Image/openEuler-22.03.riscv64.qcow2
```
其中的三个文件说明如下：
* **fw_payload_oe.elf**
利用 openSBI 将 kernel-5.10 的 image 作为 payload 所制作的用于 QEMU 启动的 image。

* **openEuler-22.03.riscv64.qcow2**
openEuler RISC-V 移植版的 rootfs 镜像。

* **run.sh**
利用 `qemu-riscv64` 运行openEuler RISC-V 系统镜像的脚本

## 通过QEMU启动一个openEuler RISC-V

在上一步下载的文件所在的目录下执行`bash run.sh`

run.sh文件说明
```
#!/bin/bash

qemu-system-riscv64 \
  -nographic -machine virt \
  -smp 8 -m 2G \
  -bios fw_payload_oe.elf \
  -drive file=openEuler-22.03.riscv64.qcow2,format=qcow2,id=hd0 \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-rng-device,rng=rng0 \
  -device virtio-blk-device,drive=hd0 \
  -device virtio-net-device,netdev=usernet \
  -netdev user,id=usernet,hostfwd=tcp::22222-:22
````
注意 `-smp` 选项为CPU核数，`-m` 为虚拟机内存大小 请根据宿主机配置酌情修改。

这里以主机端口转发的方式实现网络功能。为 SSH 转发的 22222 端口也可改为自己需要的端口号


## 欢迎使用

- 登录用户：`root`
- 默认密码：`openEuler12#$`

建议在登录成功之后立即修改 root 用户密码

登陆成功之后，可以看到如下的信息：
```
root@localhost's password:
Last login: Fri Apr 29 07:27:22 2022 from 10.0.2.2


Welcome to 5.10.0

System information as of time:  Fri Apr 29 07:28:59 UTC 2022

System load:    0.11
Processes:      114
Memory used:    2.5%
Swap used:      0.0%
Usage On:       12%
IP address:     10.0.2.15
Users online:   1


[root@openEuler-riscv64 ~]#

```

建议在 Host Linux 上通过 ssh 登录到运行于 QEMU 模拟器中的 openEuler OS（直接使用，可能会出现vim键盘输入异常）：

```
$ ssh -p 22222 root@localhost
```

## [可选] 准备 QEMU x86_64 环境

当需要查看对比openEuler主线软件包情况时，可安装对应的QEMU虚拟机。这里以x86_64、主线版本2203为例说明准备方法。

获取预制的映像文件：
```
$ wget https://mirror.iscas.ac.cn/openeuler/openEuler-22.03-LTS/virtual_machine_img/x86_64/openEuler-22.03-LTS-x86_64.qcow2.xz
$ xz -d openEuler-22.03-LTS-x86_64.qcow2.xz
$ wget https://mirror.iscas.ac.cn/openeuler/openEuler-22.03-LTS/OS/x86_64/images/pxeboot/initrd.img
$ wget https://mirror.iscas.ac.cn/openeuler/openEuler-22.03-LTS/OS/x86_64/images/pxeboot/vmlinuz
```

运行：
```
$ qemu-system-x86_64 \
  -nographic -smp 8 -m 4G \
  -kernel vmlinuz \
  -initrd initrd.img \
  -hda openEuler-22.03-LTS-x86_64.qcow2 \
  -nic user,model=e1000 \
  -append 'root=/dev/sda2 rw console=ttyS0 systemd.default_timeout_start_sec=600 selinux=0 highres=off mem=4096M earlycon'
```

root口令与上面相同。虚拟机的网络、时间(除时区)、软件源等已设置好，开机即可用。
