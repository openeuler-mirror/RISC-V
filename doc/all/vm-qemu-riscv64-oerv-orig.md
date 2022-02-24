# openEuler RISC-V 版本的获取和运行

## 介绍
本文档介绍如何获取和运行 openEuler RISC-V 移植版。

## 环境需求

openEuler for RISC-V 版本在 QEMU 模拟器中运行。qemu 模拟器本身可以运行
与 x86-64 或者 arm64 的物理机或者虚拟机之中。推荐的 QEMU 模拟器版本：

- QEMU 版本：>= 4.0.0, <=5.0

## 获取 openEuler RISC-V 移植版系统镜像

在 openEuler 官网可以获得 openEuler RISC-V 移植版发布的 openEuler RISC-V 镜像
以及 repo 源

```
https://repo.openeuler.org/openEuler-preview/RISC-V/Image/
https://openeuler.org/zh/download/
```

如下两个文件是启动 openEuler RISC-V 移植版所必需的：

- fw_payload_oe.elf ：利用 openSBI 将 linux 内核的 image 作为 payload 所制作的
用于 QEMU 启动的 *kernel image*
- openEuler-preview.riscv64.qcow2 ：包含 openEuler RISC-V 移植版的 rootfs 的虚拟机
磁盘镜像

还可以从以下网址获取到 openEuler RISC-V 的历史版本以及 repo 源

```
https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/
```

## 准备 Host OS 上的 QEMU 模拟器

首先需要在 host Linu x环境中有 qemu-system-riscv64 的二进制程序。常见的 Linux
发行版的官方仓库中一般提供了 qemu-system-riscv64 这个软件包。

如果您使用的 Linux
Host OS 的软件仓库中没有这个包，那么需要手动从 QEMU 的源码构建。具体的构
建方式请参照 QEMU 的官方指导所述：
- [Build QEMU for Platforms/RISCV](https://wiki.qemu.org/Documentation/Platforms/RISCV)

## 通过 QEMU 启动 openEuler RISC-V

QEMU 的启动命令行如下，这里以主机端口转发的方式实现网络功能

```
$ qemu-system-riscv64 \
  -nographic -machine virt \
  -smp 8 -m 2G \
  -kernel fw_payload_oe.elf \
  -drive file=oe-rv-rv64g-30G.qcow2,format=qcow2,id=hd0 \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-rng-device,rng=rng0 \
  -device virtio-blk-device,drive=hd0 \
  -device virtio-net-device,netdev=usernet \
  -netdev user,id=usernet,hostfwd=tcp::12055-:22 \
  -append 'root=/dev/vda1 rw console=ttyS0 systemd.default_timeout_start_sec=600 selinux=0 highres=off mem=4096M earlycon'
```

当系统启动之后，可以在 Host Linux 上通过 ssh 登录到运行于 QEMU 模拟器中的 openEuler OS：

```
$ ssh -p 12055 root@localhost
```

默认的登陆用户名/密码是：root/openEuler12#$

进入系统之后的相关操作请查阅 openEuler 的相关文档。

