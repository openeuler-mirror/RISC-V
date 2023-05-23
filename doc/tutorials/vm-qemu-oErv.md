# 通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统

> 修订日期 2023-05-23

## 安装支持 RISC-V 架构的 QEMU 模拟器

### 使用发行版提供的预编译软件包

一般来说，常见 GNU/Linux 发行版软件源中都提供了包含 `qemu-system-riscv64` 的软件包。各发行版间以及其各个大小版本间对应的包名可能略有不同，详情可移步 [pkgs.org](https://pkgs.org) 进行查询。

> 通常可以通过 `lsb_release -a` 来查询自己正在使用哪个发行版和具体的大版本 (或与之对应的 codename)

- Ubuntu 22.04 提供 6.2 版本:  `$ sudo apt install qemu-system-misc`
  - 注: 20.04 及以前的版本过旧
- Debian 11 仓库提供较旧的 5.2 版本: `$ sudo apt install qemu-system-misc`
  - Debian 11 官方 backports 仓库 (在修订时) 提供 7.2 版本，可参考这里的 [指引](https://backports.debian.org/Instructions/) 启用 backports 仓库获取新版本软件包: `$ sudo apt install -t bullseye-backports qemu-system-misc`
  - 注: 10 及以前的版本过旧
- openEuler 22.03 提供 6.2 版本: `$ sudo dnf install qemu-system-riscv`
  - 注: 21.09 及以前的版本过旧
- Fedora 38 提供 7.2.1 版本: `$ sudo dnf install qemu-system-riscv`
- Arch Linux (在修订时) 提供 8.0 版本: `$ sudo pacman -Syu qemu-full`
- openSUSE Tumbleweed (在修订时) 提供 7.1 版本: `$ sudo dnf install qemu`

如果官方仓库 (及各种 **您信任的** 第三方仓库) 中未收录 QEMU 或版本过旧 (低于 5.0)，或者发行版提供的软件包构建时未开启本项目所需的 slirp 网络模块（如运行时出现报错：`network backend 'user' is not compiled into this binary` ），请移步下一部分从 [QEMU 项目主页](https://www.qemu.org/) 获取源代码进行手动构建。

> QEMU 从 7.2.0 版本之后[移除了 slirp 子模块](https://wiki.qemu.org/ChangeLog/7.2#Removal_of_the_%22slirp%22_submodule_(affects_%22-netdev_user%22))，会影响用户模式的网络功能，需要提前加上依赖包和配置选项。

### 手动编译安装

> 修订者注: 建议优先考虑发行版提供的软件包或在有能力的情况下自行打包，**不鼓励** 非必要情况的编译安装。
>
> 下述内容以 Ubuntu 为例

- 安装必要的构建工具
  `$ sudo apt install build-essential git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev ninja-build libslirp-dev`
- 创建 /usr/local 下的目标目录 `$ sudo mkdir -p /usr/local/bin/qemu-riscv64`
- 下载 QEMU 源码包 (此处以 7.2 版本为例) `$ wget https://download.qemu.org/qemu-7.2.0.tar.xz`
- 解压源码包并切换目录 `$ tar xvJf qemu-7.2.0.tar.xz && cd qemu-7.2.0`
- 配置编译选项 `$ sudo ./configure --enable-slirp --target-list=riscv64-softmmu,riscv64-linux-user --prefix=/usr/local/bin/qemu-riscv64`
  > `riscv64-softmmu` 为系统模式，`riscv64-linux-user` 为用户模式。为了测试方便建议两个都编译，以免后续需要时重复编译
- 编译安装 `$ sudo make && sudo make install`
- 执行 `$ qemu-system-riscv64 --version`，如出现类似如下输出表示 QEMU 成功安装并正常工作。

```` bash
QEMU emulator version 7.2.0
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
````

## 下载 openEuler RISC-V 系统镜像 & 启动系统

对于不同的版本我们均有提供 QEMU 文档，请查阅本 Repo 的 [release 目录](https://gitee.com/openeuler/RISC-V/tree/master/release)来获取不同的版本。

例如，欲了解如何下载 openEuler RISC-V 23.03 并通过 QEMU 仿真 RISC-V 环境启动，请访问 [release 目录下的 openEuler-23.03 文件夹](https://gitee.com/openeuler/RISC-V/tree/master/release/openEuler-23.03)。

### [可选] 启动参数调整

- `vcpu` 为 qemu 运行线程数，与 CPU 核数没有严格对应，建议维持为 8 不变
- `memory` 为虚拟机内存数目，可随需要调整
- `drive` 为虚拟磁盘路径，可随需要调整
- `fw` 为启动 payload
- `ssh_port` 为转发的 SSH 端口，默认为 12055，可随需要调整。

## 登录虚拟机

> 建议在登录成功之后立即修改 root 用户密码
>
> 在 console 直接登录可能出现输入异常

- 用户名: `root`
- 默认密码: `openEuler12#$`

- 登录方式: 命令行 `ssh -p 12055 root@localhost` (或使用您偏好的 ssh 客户端)

登录成功之后，可以看到如下的信息：

```
Last login: Mon Jun 27 15:08:35 2022


Welcome to 5.10.0

System information as of time:  Mon Jun 27 07:11:54 PM CST 2022

System load:    0.08
Processes:      130
Memory used:    1.3%
Swap used:      0.0%
Usage On:       23%
IP address:     10.0.2.15
Users online:   2


[root@openEuler-riscv64 ~]#
```

## 虚拟机扩容

> 此部分内容参考了教程[《RISC-V openEuler包移植从零开始》](https://gitee.com/yunxiangluo/riscv-openeuler/blob/master/chapter1/class1/README.md#338-%E7%A3%81%E7%9B%98%E6%89%A9%E5%AE%B9) 与博客文章[《在 QEMU 内运行 openEuler RISC-V 移植版》](https://wiki.251.sh/openeuler_risc-v_qemu_install#%E6%88%91%E7%9A%84%E8%99%9A%E6%8B%9F%E7%8E%AF%E5%A2%83%E6%B2%A1%E7%A9%BA%E9%97%B4%E4%BA%86)，在此感谢几位作者老师的总结

工作过程中虚拟机磁盘空间不足的情况偶有发生，此时应对其进行扩容。扩容操作分为三步：

> 虚拟硬盘的格式为 .qcow2 时请自行替换文件名后缀
>
> 此处以扩容 40G 为例

1. 安装所需工具

- 在宿主机上安装 `qemu-img` 工具
  - 各个发行版间可能会有所不同，以 Ubuntu 和 Debian 为例：`apt install qemu-utils`
  - 执行 `qemu-img --help` 验证安装
- 在 openEuler RISC-V 虚拟机上安装 `growpart` 工具
  - 若磁盘空间不足以安装此工具，可先进行清理一些无用文件，如 `osc` 缓存的软件包
  - 执行 `dnf install cloud-utils-growpart` 进行安装
  - 执行 `growpart --help` 验证安装

2. 扩容虚拟硬盘

- 关闭 openEuler RISC-V 虚拟机
- 执行 `qemu-img resize openeuler-qemu.raw +40G`

3. 扩容磁盘分区和文件系统

- 启动 openEuler RISC-V 虚拟机
- 执行 `lsblk` 查看分区情况

```
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda    254:0    0   50G  0 disk 
└─vda1 254:1    0   10G  0 part /

```

- 扩展分区 vda1，执行 `growpart /dev/vda 1`
- 执行 `lsblk` 可以看到 / 所在的 vda1 分区已经扩展到了预期大小

```
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda    254:0    0   50G  0 disk 
└─vda1 254:1    0   50G  0 part /

```

- 扩展文件系统，执行 `resize2fs /dev/vda1`
- 执行 `df -h` 验证 / 分区的大小

## [可选] 准备 QEMU x86_64 环境

当需要查看对比 openEuler 主线软件包情况时，可安装对应的 QEMU 虚拟机。这里以 x86_64 、主线版本 2203 LTS 为例说明准备方法。

- 下载镜像:

```
$ wget https://mirror.iscas.ac.cn/openeuler/openEuler-22.03-LTS/virtual_machine_img/x86_64/openEuler-22.03-LTS-x86_64.qcow2.xz
$ xz -d openEuler-22.03-LTS-x86_64.qcow2.xz
$ wget https://mirror.iscas.ac.cn/openeuler/openEuler-22.03-LTS/OS/x86_64/images/pxeboot/initrd.img
$ wget https://mirror.iscas.ac.cn/openeuler/openEuler-22.03-LTS/OS/x86_64/images/pxeboot/vmlinuz
```

- 启动虚拟机:

```
$ qemu-system-x86_64 \
  -nographic -smp 8 -m 4G \
  -kernel vmlinuz \
  -initrd initrd.img \
  -hda openEuler-22.03-LTS-x86_64.qcow2 \
  -nic user,model=e1000 \
  -append 'root=/dev/sda2 rw console=ttyS0 systemd.default_timeout_start_sec=600 selinux=0 highres=off mem=4096M earlycon'
```

root 口令与上面相同。虚拟机的网络、时间(除时区)、软件源等已设置好，开机即可用。
