# 通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统

> 修订日期 2026-04-15

## 安装支持 RISC-V 架构的 QEMU 模拟器

### 使用发行版提供的预编译软件包

一般来说，常见 GNU/Linux 发行版软件源中都提供了包含 `qemu-system-riscv64` 的软件包。各发行版间以及其各个大小版本间对应的包名可能略有不同，详情可移步 [pkgs.org](https://pkgs.org) 进行查询。

> 通常可以通过 `cat /etc/os-release` 来查询自己正在使用哪个发行版和具体的大版本 (或与之对应的 codename)

- Ubuntu 26.04 LTS 提供 10.2.1 版本:  `$ sudo apt install qemu-system-riscv`
- Ubuntu 24.04 LTS 提供 8.2.2 版本:  `$ sudo apt install qemu-system-misc`
  - 注意：版本过旧，无法启动 RVA23 版本镜像
- Debian 13 (trixie) 提供 10.0.8 版本: `$ sudo apt install qemu-system-misc`
- openEuler 24.03 LTS 提供 8.2.0 版本: `$ sudo dnf install qemu-system-riscv`
  - 注意：版本过旧，无法启动 RVA23 版本镜像
- Fedora 43 提供 10.1.5 版本: `$ sudo dnf install qemu-system-riscv`
- Arch Linux (在修订时) 提供 10.2.2 版本: `$ sudo pacman -Syu qemu-full`
- openSUSE Tumbleweed (在修订时) 提供 10.2.2 版本: `$ sudo zypper install qemu-extra`

> **注意**: openEuler 24.03 LTS SP3 RVA23 版本**要求 QEMU 版本不低于 10.0**。

如果官方仓库 (及各种 **您信任的** 第三方仓库) 中未收录 QEMU 或版本过旧 (低于 10.0)，或者发行版提供的软件包构建时未开启本项目所需的 slirp 网络模块（如运行时出现报错：`network backend 'user' is not compiled into this binary` ），请移步下一部分从 [QEMU 项目主页](https://www.qemu.org/) 获取源代码进行手动构建。

> QEMU 使用 libslirp 库提供用户模式网络 (`-netdev user`) 功能。自 QEMU 7.2.0 起，slirp 作为独立的外部库 (libslirp) 提供，不再内嵌于 QEMU 源码中。使用发行版预编译包时，libslirp 支持通常已包含在内，无需额外操作。若从源码编译，需安装 `libslirp-dev` (Debian/Ubuntu) 或 `libslirp-devel` (Fedora/RHEL) 开发包；推荐 libslirp 4.9.0 及以上版本。

### 手动编译安装

> 修订者注: 建议优先考虑发行版提供的软件包或在有能力的情况下自行打包，**不鼓励** 非必要情况的编译安装。
>
> 下述内容以 Ubuntu 为例

- 安装必要的构建工具
  `$ sudo apt install build-essential git libglib2.0-dev libfdt-dev libpixman-1-dev zlib1g-dev ninja-build meson python3 python3-venv libslirp-dev`
- 创建 /usr/local 下的目标目录 `$ sudo mkdir -p /usr/local/bin/qemu-riscv64`
- 下载 QEMU 源码包 (此处以 10.0 版本为例) `$ wget https://download.qemu.org/qemu-10.2.2.tar.xz`
- 解压源码包并切换目录 `$ tar xvJf qemu-10.2.2.tar.xz && cd qemu-10.2.2`
- 创建构建目录并配置编译选项
  ```
  $ mkdir build && cd build
  $ ../configure --target-list=riscv64-softmmu,riscv64-linux-user --enable-slirp --prefix=/usr/local/bin/qemu-riscv64
  ```
  > `riscv64-softmmu` 为系统模式，`riscv64-linux-user` 为用户模式。为了测试方便建议两个都编译，以免后续需要时重复编译。
- 编译安装 (在 build 目录下执行) `$ make && sudo make install`
- 执行 `$ qemu-system-riscv64 --version`，如出现类似如下输出表示 QEMU 成功安装并正常工作。

```` bash
QEMU emulator version 10.2.2
Copyright (c) 2003-2026 Fabrice Bellard and the QEMU Project developers
````

## 下载 openEuler RISC-V 系统镜像 & 启动系统

openEuler RISC-V 提供了多个版本的 QEMU 镜像。自 openEuler 24.03 LTS 起，镜像启动方式由 U-Boot 变更为 UEFI，请注意根据您使用的版本选择对应的启动方式。

### 版本概览

| 版本 | 类型 | 启动方式 | QEMU 最低版本 | 状态 |
|------|------|----------|--------------|------|
| 24.03 LTS SP3 | LTS 较长周期 | UEFI | 10.0 | 维护中 ✅ **推荐** |
| 24.03 LTS SP2 | LTS 较短周期 | UEFI | 8.1 | EOL 归档 |
| 24.03 LTS SP1 | LTS 较长周期 | UEFI | 8.1 | 维护中 |
| 24.03 LTS (又称 SP0)| LTS 较长周期 | UEFI | 8.1 | EOL 归档 |
| 24.09 | 创新（非 LTS） | UEFI | 8.1 | EOL 归档 |
| 25.03 | 创新（非 LTS） | UEFI | 8.1 | EOL 归档 |
| 23.03 | 创新（非 LTS） | U-Boot | 6.2 | EOL 归档 |

更多版本及详情请查阅本 Repo 的 [release 目录](https://atomgit.com/openeuler/RISC-V/tree/master/release)。

### UEFI 启动 (openEuler 24.03 LTS 及更新版本)

> openEuler 24.03 LTS 是首个支持 UEFI 标准的 RISC-V 发行版，使用 EDK2 固件通过 pflash 方式加载，取代了此前基于 U-Boot 的 `-kernel` 启动方式。

> openEuler 24.03 LTS 系列自 SP3 起支持基线抬升至 RVA23 Profile 必选扩展范围，称 RVA23 版本，另会根据情况不定期推出 RVA20 版本供用户使用。

#### 下载镜像（RVA23 版本）

以 openEuler 24.03 LTS SP3 为例，镜像文件位于 [openEuler 官方下载站](https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS-SP3/virtual_machine_img/riscv64/)：

需要下载以下文件：
- `openEuler-24.03-LTS-SP3-RVA23-riscv64.qcow2.xz` — 虚拟机磁盘镜像
- `RISCV_VIRT_CODE_RVA23.fd` — UEFI 固件代码 (32 MiB)
- `RISCV_VIRT_VARS_RVA23.fd` — UEFI 固件变量 (32 MiB)
- `start_vm_RVA23.sh` — 启动脚本

```bash
$ wget https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS-SP3/virtual_machine_img/riscv64/openEuler-24.03-LTS-SP3-RVA23-riscv64.qcow2.xz
$ wget https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS-SP3/virtual_machine_img/riscv64/RISCV_VIRT_CODE_RVA23.fd
$ wget https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS-SP3/virtual_machine_img/riscv64/RISCV_VIRT_VARS_RVA23.fd
$ wget https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS-SP3/virtual_machine_img/riscv64/start_vm_RVA23.sh
$ xz -d openEuler-24.03-LTS-SP3-RVA23-riscv64.qcow2.xz
```

#### 启动虚拟机

执行 `bash start_vm.sh` 启动虚拟机。

#### RVA20 版本（可选）

openEuler 24.03 LTS SP3 还提供了 RVA20 版本镜像，适用于较旧或未完全支持 RVA23 扩展集的设备。RVA20 版本使用专用的固件和启动脚本：

- `openEuler-24.03-LTS-SP3-riscv64.qcow2.xz`
- `RISCV_VIRT_CODE_RVA20.fd`
- `RISCV_VIRT_VARS_RVA20.fd`
- `start_vm_RVA20.sh`

### U-Boot 启动 (openEuler 23.09 及更早版本)

> 此启动方式适用于归档版本的旧镜像，新用户建议优先使用上述 UEFI 启动方式。

以 openEuler 23.03 为例，镜像文件位于 [中科院软件所镜像站](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-23.03-V1-riscv64/)。

需要下载以下文件：
- `openEuler-23.03-V1-base-qemu-preview.qcow2.zst` — 虚拟机磁盘镜像 (无桌面)
- `fw_payload_oe_uboot_2304.bin` — 启动用内核
- `start_vm.sh` — 启动脚本

```bash
$ sudo apt install zstd -y
$ unzstd openEuler-23.03-V1-base-qemu-preview.qcow2.zst
$ bash start_vm.sh
```

### [可选] 启动参数调整

- `vcpu` 为 qemu 运行线程数，与 CPU 核数没有严格对应，建议维持为 8 不变
- `memory` 为虚拟机内存数目，可随需要调整
- `drive` 为虚拟磁盘路径，可随需要调整
- `fw1`/`fw2` 为 UEFI 固件文件 (UEFI 启动方式，24.03 LTS 及更新版本)
  - `fw1` 为 `RISCV_VIRT_CODE.fd` (固件代码，只读)
  - `fw2` 为 `RISCV_VIRT_VARS.fd` (固件变量，可写)
- `fw` 为启动 payload (U-Boot 启动方式，23.09 及更早版本)
- `ssh_port` 为转发的 SSH 端口，默认为 12055，可随需要调整
- `cpu` 为 CPU 型号，默认为 `rv64`；RVA23 变体使用 `rva23s64,sv39=on`

> UEFI 启动方式使用 `-machine virt,pflash0=...,pflash1=...,acpi=off` 和 `-blockdev` 参数加载固件，由启动脚本自动配置。U-Boot 启动方式使用 `-kernel` 参数加载 fw_payload。

## 登录虚拟机

> 建议在登录成功之后立即修改 root 用户密码
>
> 在 console 直接登录可能出现输入异常

- 用户名: `root`
- 默认密码: `openEuler12#$`

- 登录方式: 命令行 `ssh -p 12055 root@localhost` (或使用您偏好的 ssh 客户端)

登录成功之后，可以看到如下的信息：

```
Last login: Mon Apr 14 10:30:00 2026


Welcome to 6.6.0

System information as of time:  Mon Apr 13 07:11:54 PM CST 2026

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

> UEFI 方式启动的镜像分区布局可能与 U-Boot 镜像不同，请先使用 `lsblk` 确认实际分区情况。若根分区文件系统为 XFS，请使用 `xfs_growfs` 替代 `resize2fs` 进行文件系统扩展。

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
vda    254:0    0   80G  0 disk
└─vda1 254:1    0   40G  0 part /

```

- 扩展分区 vda1，执行 `growpart /dev/vda 1`
- 执行 `lsblk` 可以看到 / 所在的 vda1 分区已经扩展到了预期大小

```
NAME   MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
vda    254:0    0   80G  0 disk
└─vda1 254:1    0   80G  0 part /

```

- 扩展文件系统，执行 `resize2fs /dev/vda1`
- 执行 `df -h` 验证 / 分区的大小

## [可选] 准备 QEMU x86_64 或 arm64 环境

当需要对比 openEuler 主线软件包，或者进行内核对比测试等情况时，可安装对应的 QEMU x86_64 或 arm64 虚拟机环境。这里以主线版本 openEuler-24.03-LTS-SP3 为例说明准备方法。

1. QEMU x86_64

- 下载镜像:

```
$ wget https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS-SP3/virtual_machine_img/x86_64/openEuler-24.03-LTS-SP3-x86_64.qcow2.xz
$ xz -d openEuler-24.03-LTS-SP3-x86_64.qcow2.xz
$ wget https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS-SP3/OS/x86_64/images/pxeboot/initrd.img
$ wget https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS-SP3/OS/x86_64/images/pxeboot/vmlinuz
```

- 启动虚拟机:

```
$ qemu-system-x86_64 \
  -nographic -smp 8 -m 4G \
  -kernel vmlinuz \
  -initrd initrd.img \
  -hda openEuler-24.03-LTS-SP3-x86_64.qcow2 \
  -net user,hostfwd=::2222-:22 -net nic \
  -append 'root=/dev/sda2 console=ttyS0'
```

- root 口令与上面相同。虚拟机的网络、时间(除时区)、软件源等已设置好，开机即可用。

2. QEMU arm64

- 下载镜像：

```
$ wget https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS-SP3/virtual_machine_img/aarch64/openEuler-24.03-LTS-SP3-aarch64.qcow2.xz
$ xz -d openEuler-24.03-LTS-SP3-aarch64.qcow2.xz
$ wget https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS-SP3/OS/aarch64/images/pxeboot/initrd.img
$ wget https://dl-cdn.openeuler.openatom.cn/openEuler-24.03-LTS-SP3/OS/aarch64/images/pxeboot/vmlinuz
```

- 启动虚拟机：

```
$ qemu-system-aarch64 \
  -nographic \
  -M virt -cpu cortex-a57 \
  -smp 8 -m 4G \
  -kernel vmlinuz \
  -initrd initrd.img \
  -hda openEuler-24.03-LTS-SP3-aarch64.qcow2 \
  -nic user,model=e1000,hostfwd=tcp::2222-:22 \
  -append 'root=/dev/vda2 console=ttyAMA0'
```
- root 口令与上面相同。虚拟机的网络、时间(除时区)、软件源等已设置好，开机即可用。

## 资源链接

- openEuler RISC-V 仓库 (AtomGit): https://atomgit.com/openeuler/RISC-V
- openEuler 官方下载站: https://dl-cdn.openeuler.openatom.cn/
- openEuler 官方文档: https://docs.openeuler.org/
- QEMU 项目主页: https://www.qemu.org/

> 本项目已从 Gitee 迁移至 AtomGit 平台。旧地址 https://gitee.com/openeuler/RISC-V 仅供参考。
