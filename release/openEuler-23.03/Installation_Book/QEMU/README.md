# 使用Qemu安装openEuler RISC-V 23.03

## 注意事项

- `root` 的用户密码是 `openEuler12#$`。
- 默认用户 `openeuler` 的用户密码是 `openEuler12#$`。

## 使用 Qemu 安装 openEuler RISC-V 23.03

### 编译安装支持视频输出的 Qemu

请参阅 [通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/openeuler-mirror/RISC-V/blob/master/doc/tutorials/vm-qemu-oErv.md)。

建议优先考虑发行版提供的软件包或在有能力的情况下自行打包，不鼓励非必要情况的编译安装。镜像的安装部分有所不同，请参考以下镜像的下载安装。

### 系统镜像下载

本次测试的 openEuler-23.03-V1-riscv64 的镜像位于 [中科院软件所镜像站](http://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-23.03-V1-riscv64/)

#### 文件及其用途

在 QEMU 目录中有用于测试的镜像，启动脚本。

- `openEuler-23.03-V1-xfce-qemu-preview.qcow2.zst` 带有 xfce 桌面镜像的根文件系统。
- `openEuler-23.03-V1-base-qemu-preview.qcow2.zst` 不带有桌面的镜像的根文件系统。
- `fw_payload_oe_uboot_2304.bin` 启动用内核
- `start_vm_xfce.sh` 启动带有 xfce 桌面镜像的根文件系统用脚本。
- `start_vm.sh` 启动不带有桌面的镜像的根文件系统用脚本。

### 部署和启动

#### 直接启动带有 xfce 桌面镜像的根文件系统用脚本。

> 已验证启动脚本在 Ubuntu 22.04，Debian 11.4 环境下正常运行 

- 确认当前目录内包含 `fw_payload_oe_uboot_2304.bin`、磁盘映像压缩包、启动脚本 `start_vm_xfce.sh`和大于 5 GiB 的剩余可用空间。
- 解压映像压缩包或使用解压工具解压磁盘映像。
- 调整启动参数。
- 执行启动脚本。

使用下面的命令解压缩。

```bash
sudo apt install zstd -y
unzstd openEuler-23.03-V1-xfce-qemu-preview.qcow2.zst
```

然后执行 `bash start_vm_xfce.sh` 启动虚拟机。


#### 使用 Spice 远程连接桌面

> 目前该方案测试过的环境包括 WSL1(Ubuntu 20.04.4 LTS and Ubuntu 22.04.1 LTS) , Ubuntu 22.04.1 live-server LTS 和 Debian11.4。

- 下载并更换支持 spice 端口的[脚本](./start_vm.sh)。
- 调整脚本参数并运行脚本，注意此脚本并不会直接打开 Qemu 的图形化窗口，需要使用 `spice` 或 `VNC` 连接后才会弹出窗口
- 安装 virt-viewer 并使用 spice 连接虚拟机

##### Linux 环境（以Debian为例）

使用以下命令启动 virt-viewer 连接到 Spice Server。

```bash
sudo apt install virt-viewer            #安装virt-viewer
remote-viewer spice://localhost:12057   #使用spice连接虚拟机
```

##### Windows 环境

- 安装 Virt-Viewer。点击[此处](https://virt-manager.org/download/)前往下载地址，下载 virt-viewer 并安装。
- 连接到 Spice Server，粘贴地址点击连接即可。操作界面和远程桌面类似。

## 参考

- [通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/openeuler-mirror/RISC-V/blob/master/doc/tutorials/vm-qemu-oErv.md)
- [通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/ArielHeleneto/Work-PLCT/tree/master/awesomeqemu) by [ArielHeleneto](https://github.com/ArielHeleneto)
