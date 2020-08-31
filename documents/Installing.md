# openEuler RISC-V 移植版的获取和运行

#### 介绍
本文档介绍如何获取和运行openEuler RISC-V移植版。

### 环境需求

QEMU 模拟器环境
- 操作系统：x86_64/aarch64 Linux
- QEMU 版本：> 4.0.0

#### 获取openEuler RISC-V 移植版系统镜像

目前在以下网址可以获取到一个临时的版本以及repo源
```
https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/
```
其中两个文件是启动openEuler RISC-V 移植版所必需的：
- fw_payload_oe.elf 利用openSBI将kernel-5.5的image作为payload所制作的用于QEMU启动的image
- oe-rv-rv64g-30G.qcow2 openEuler RISC-V移植版的rootfs镜像

#### 通过QEMU启动一个openEuler RISC-V
首先你需要在你的host Linux环境中有 qemu-system-riscv64 的二进制程序，如果你的Linux环境的repo源中没有提供这个二进制，那么则需要手动从QEMU的源码构建出来，具体的构建方式如QEMU的官方指导所述：
- [Build QEMU for Platforms/RISCV](https://wiki.qemu.org/Documentation/Platforms/RISCV)

QEMU 的启动方式，这里以主机端口转发的方式实现网络功能
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
  -netdev user,id=usernet,hostfwd=tcp::12055-:22
```
当系统启动之后，可以通过ssh登陆guest OS
```
 ssh -p 12055 root@localhost
```
默认的登陆用户名/密码是：root/openEuler12#$；
进入系统之后，所有的操作与openEuler系统一致，请查阅openEuler的相关文档。

