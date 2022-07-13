# 通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统

> 修订日期 2022-06-27

## 安装支持 RISC-V 架构的 QEMU 模拟器

### 使用发行版提供的预编译软件包

一般来说，常见 GNU/Linux 发行版软件源中都提供了包含 `qemu-system-riscv64` 的软件包。各发行版间以及其各个大小版本间对应的包名可能略有不同，详情可移步 [pkgs.org](https://pkgs.org) 进行查询。

> 通常可以通过 `lsb_release -a` 来查询自己正在使用哪个发行版和具体的大版本 (或与之对应的 codename)

- Ubuntu 22.04 提供 6.2 版本:  `$ sudo apt install qemu-system-misc`
  - 注: 20.04 及以前的版本过旧
- Debian 11 仓库提供较旧的 5.2 版本: `$ sudo apt install qemu-system-misc`
  - Debian 11 官方 backports 仓库提供 7.0 版本，可参考这里的 [指引](https://backports.debian.org/Instructions/) 启用 backports 仓库获取新版本软件包: `$ sudo apt install -t bullseye-backports qemu-system-misc`
  - 注: 10 及以前的版本过旧
- openEuler 22.03 提供 6.2 版本: `$ sudo dnf install qemu-system-riscv`
  - 注: 21.09 及以前的版本过旧
- Fedora 36 提供 6.2 版本: `$ sudo dnf install qemu-system-riscv`
- Arch Linux (在修订时) 提供 7.0 版本: `$ sudo pacman -Syu qemu-full`
- openSUSE Tumbleweed (在修订时) 提供 6.2 版本: `$ sudo dnf install qemu`

如果官方仓库 (及各种 **您信任的** 第三方仓库) 中未收录 QEMU 或版本过旧 (低于 5.0)，可以移步下一部分从 [QEMU 项目主页](https://www.qemu.org/) 获取源代码进行手动构建。

### 手动编译安装

> 修订者注: 建议优先考虑发行版提供的软件包或在有能力的情况下自行打包，**不鼓励** 非必要情况的编译安装。
>
> 下述内容以 Ubuntu 为例

- 安装必要的构建工具

  `$ sudo apt install build-essential git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev ninja-build`
- 创建 /usr/local 下的目标目录 `$ sudo mkdir -p /usr/local/bin/qemu-riscv64`
- 下载最新的 QEMU 源码包 (修订时为 7.0.0 版本) `$ wget https://download.qemu.org/qemu-7.0.0.tar.xz`
- 解压源码包并切换目录 `$ tar xvJf qemu-7.0.0.tar.xz && cd qemu-7.0.0`
- 配置编译选项 `$ sudo ./configure --target-list=riscv64-softmmu,riscv64-linux-user --prefix=/usr/local/bin/qemu-riscv64`
  > `riscv64-softmmu` 为系统模式，`riscv64-linux-user` 为用户模式。为了测试方便，可以两个都安装
- 编译安装 `$ sudo make && sudo make install`
- 执行 `$ qemu-system-riscv64 --version`，如出现类似如下输出表示 QEMU 成功安装并正常工作。

```` bash
QEMU emulator version 7.0.0
Copyright (c) 2003-2022 Fabrice Bellard and the QEMU Project developers
````

## 下载 openEuler RISC-V 系统镜像

> 注: 旧版本 `20.03` 的系统镜像安装移步至 [20.03 系统镜像下载](https://gitee.com/openeuler/RISC-V/blob/dced224a78ff47e547d4d00fcf3023177c7f4a5f/doc/tutorials/vm-qemu-oErv.md#%E4%B8%8B%E8%BD%BD-openeuler-risc-v-%E7%B3%BB%E7%BB%9F%E9%95%9C%E5%83%8F)

- 下载说明: 至少应当下载启动 payload (`fw_payload_oe_qemuvirt.elf`)，GUI 和 headless 中一种镜像和对应的启动脚本
- 下载目录: [openEuler-RISC-V/testing/*DATE*/*VER*/QEMU/](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/testing/)
- 版本说明: 构建日期 `DATE` 形如 `20220622` ，当日构建版本 `VER` 形如 `v0.2`
  - 如 20220622 的 v0.2 版本 QEMU 镜像文件位于 [openEuler-RISC-V/testing/20220622/v0.2/QEMU/](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/testing/20220622/v0.2/QEMU/)
- 内容说明:
  - `fw_payload_oe_qemuvirt.elf`: 利用 openSBI 将 kernel-5.10 的 image 作为 payload 所制作的 QEMU 启动所需文件
  - `openeuler-qemu-xfce.raw.tar.zst`: openEuler RISC-V QEMU GUI 镜像压缩包
  - `start_vm_xfce.sh`: GUI 虚拟机启动脚本
  - `openeuler-qemu.raw.tar.zst`: openEuler RISC-V QEMU headless 镜像压缩包
  - `start_vm.sh`: headless 虚拟机启动脚本

## 启动 openEuler RISC-V 虚拟机

> 以启动 headless 虚拟机为例
>
> 需要系统中有 zstd 相关支持库

- 确认当前目录内包含 `fw_payload_oe_qemuvirt.elf`, `openeuler-qemu.raw.tar.zst` 和 `start_vm.sh`
- 解压镜像压缩包 `$ tar -I 'zstdmt' -xvf ./openeuler-qemu.raw.tar.zst`
- 执行启动脚本 `$ bash start_vm.sh`

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
