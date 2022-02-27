# 编译并运行自定义内核

## 介绍

当开发者尝试自行修改内核配置，或者添加内核功能时，可能需要用到本文档所述的内容，即将自行编译的 Linux 内核基于 openSBI 制作成 QEMU 可以加载执行的*内核镜像*。

关于如何用 QEMU 运行 openEuler4RISCV 镜像，请参照[通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](../tutorials/vm-qemu-oErv.md)。

## openSBI

openSBI 的官方仓库链接为：[https://github.com/riscv/opensbi.git](https://github.com/riscv/opensbi.git)。

关于 openSBI 的简单描述，摘录自 openSBI 的 README.md：

> The **RISC-V Supervisor Binary Interface (SBI)** is the recommended interface between:
>
> 1. A platform-specific firmware running in M-mode and a bootloader, a hypervisor or a general-purpose OS executing in S-mode or HS-mode.
> 2. A hypervisor running in HS-mode and a bootloader or a general-purpose OS executing in VS-mode.

## 编译 fw_payload.elf

参见[通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](../tutorials/vm-qemu-oErv.md)的描述，fw_payload.elf 是提供给 QEMU 作为*内核*的镜像。在本文中，不覆盖 “如何自定义并编译 Linux 内核” 这方面的内容。假设您已经编译得到了可运行于 RISC-V 架构硬件的 Linux 内核 image。

在 host 系统上，假设已经有 Linux kernel image，路径为：`/build-farm/risc-v-kernel-build/arch/riscv/boot/Image`。

那么，cd 到 openSBI 的源码目录中，首先确认所使用的版本，假设我们使用 v0.9 版本。则首先切换到 v0.9 的 tag 上：

```
$ git checkout v0.9
```

然后运行如下命令进行编译：

```
$ make PLATFORM=generic CROSS_COMPILE=riscv64-linux-gnu- FW_PAYLOAD=y O=./ll-out FW_PAYLOAD_PATH=/build-farm/risc-v-kernel-build/arch/riscv/boot/Image
```

PLATFORM 的取值，可参见 platform 目录中的子目录，FW_PAYLOAD_PATH 告诉 SBI 所使用的 Linux 内核 image。

编译完成后，得到 fw_payload.elf 文件：`ll-out/platform/generic/firmware/fw_payload.elf`。

## 通过 QEMU 启动自定义内核

参见[通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](../tutorials/vm-qemu-oErv.md)文档，运行 qemu-system-riscv64 命令行时用 `-kernel` 参数指定上文中的 fw_payload.elf 即可。
