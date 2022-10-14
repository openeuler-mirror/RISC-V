
# 使用QEMU安装openEuler-22.03-V1

注：
1. root用户密码`openEuler12#$`
2. openeuler用户密码`openEuler12#$`,默认用户，可使用Eclipse
3. 本版本操作系统预装Eclipse软件，Eclispe屏保解锁密码默认是`master`

### 1. 编译安装支持视频输出的QEMU

- 略。详见[通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/openeuler-mirror/RISC-V/blob/master/doc/tutorials/vm-qemu-oErv.md)
- 注：建议优先考虑发行版提供的软件包或在有能力的情况下自行打包，不鼓励非必要情况的编译安装。镜像的安装部分有所不同，请参考以下镜像的下载安装。

### 2. 系统镜像的使用

### 2.1 镜像下载

##### 2.1.1 下载内容

- 下载 QEMU 目录下的[openEuler-22.03-V1-riscv64-qemu-xfce.qcow2.tar.zst](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V1-riscv64/QEMU/openEuler-22.03-V1-riscv64-qemu-xfce.qcow2.tar.zst), [fw_payload_oe_qemuvirt.elf](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V1-riscv64/QEMU/fw_payload_oe_qemuvirt.elf), [preview_start_vm_xfce.sh](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V1-riscv64/QEMU/preview_start_vm_xfce.sh), 
- [下载地址](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V1-riscv64/QEMU/)

##### 2.1.2 部署和启动

###### 2.1.2.1 直接启动支持xfce的脚本

>已验证启动脚本在 Ubuntu22.04 ，Debian11.4环境下正常运行 

- 确认当前目录内包含`fw_payload_oe_qemuvirt.elf`, 磁盘映像压缩包，和启动脚本`preview_start_vm_xfce.sh`。
- 解压映像压缩包或使用解压工具解压磁盘映像。
- 调整启动参数
- 执行启动脚本

注：解压需要10.7G硬盘空间

```bash
sudo apt install zstd -y
tar -I zstdmt -xvf ./openEuler-22.03-V1-riscv64-qemu-xfce.qcow2.tar.zst
```

- 执行 `bash preview_start_vm_xfce.sh`

注：QEMU下启动Xfce较慢，请耐心等待

脚本图像输出参数方面可能根据宿主机的环境变化而有些不同。若终端报错，可根据终端提醒，对脚本中'-display'与'-device virtio-vga/'两项进行更改，脚本参数更改具体据环境而变，可自行搜索学习，另外的方法为绕过直接图像输出使用vnc或spice等方式登陆远程桌面，详情可见附录(通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统)。

###### 2.1.2.2 使用spice远程连接桌面

>目前该方案测试过的环境包括 WSL1(Ubuntu 20.04.4 LTS and Ubuntu 22.04.1 LTS) , Ubuntu 22.04.1 live-server LTS 和 Debian11.4。

运行脚本中可能会出现‘pa‘报错的情况，应该是本地机的qemu加载PulseAudio不成功的原因，可通过使用spice连接远程桌面来避免qemu直接加载PulseAudio而报错，且spice也支持声音共享

- 下载并更换支持 spice 端口的[脚本](./start_vm.bash)。

点开后点击右上角的 raw

![figure_69](./images/figure_69.png)

复制打开的页面网址就可以使用 wget 了

注意Windows Powershell的wget需要指定输出文件名

![figure_70](./images/figure_70.png)

或者直接复制脚本代码然后本地新建文本文档然后黏贴另存为.sh文件

- 调整脚本参数并运行脚本，注意此脚本并不会直接打开qemu的图形化窗口，需要使用 spice 连接后才会弹出窗口
- 安装 virt-viewer 并使用 spice 连接虚拟机[脚本](./spice_view.bash)

linux环境下（以Debian为例）

命令行输入
```bash
sudo apt install virt-viewer            #安装virt-viewer
remote-viewer spice://localhost:12057   #使用spice连接虚拟机
```

windows下
- 安装 Virt-Viewer
点击[此处](https://virt-manager.org/download/)前往下载地址，下载 virt-viewer 11.0 。如果速度较慢请考虑科学上网。

- 连接到 SPICE
粘贴地址点击连接即可。操作界面和远程桌面类似。


### 3. 附录及参考文章
[在 WSL 通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/ArielHeleneto/Work-PLCT/tree/master/qemuOnWSL) by [ArielHeleneto](https://github.com/ArielHeleneto)

[通过 QEMU 仿真 RISC-V 环境并启动 OpenEuler RISC-V 系统](https://github.com/ArielHeleneto/Work-PLCT/blob/master/awesomeqemu/README.md) by [ArielHeleneto](https://github.com/ArielHeleneto)

