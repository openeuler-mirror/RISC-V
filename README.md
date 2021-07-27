# RISC-V 

#### 介绍
本软件仓中托管了有关于openEuler RISC-V相关的信息，包括如何获取及使用openEuler RISC-V的文档、工程配置以及工具。
#### 动态
- **2021年4月**  RISC-V 处理器开发商优矽科技加入 openEuler 社区 [链接](https://gitee.com/flame-ai/hello-openEuler/issues/I3CHPZ#note_4752587_link)
- **2021年3月**  《SIGer》青少年开源文化期刊 [第#4期](https://gitee.com/flame-ai/siger/blob/master/%E7%AC%AC4%E6%9C%9F%20Better%20RISC-V%20For%20Better%20Life.md)、[第#10期 《南征北战》](https://gitee.com/yuandj/siger/blob/master/%E7%AC%AC10%E6%9C%9F%20%E5%8D%97%E5%BE%81%E5%8C%97%E6%88%98%EF%BC%88%E4%B8%8A12%EF%BC%89.md)
- **2021年3月**  openEuler RISC-V 使能runc 容器。[链接](https://openeuler.org/zh/blog/yang_yanchao/2021-3-12-start-a-containerd-on-riscv.html)
- **2021年2月**  准备添加RISC-V TEE的支持
- **2020年12月** 2020 openEuler 高校开发者大赛，试题4。[链接](https://www.bilibili.com/video/BV1WD4y1X7HT?p=5)
- **2020年12月** 2020 openEuler summit 峰会展示在果壳上执行openEuler RISC-V。
- **2020年11月** 在[openeuler镜像仓](https://repo.openeuler.org/openEuler-preview/RISC-V/Image/)发布第二版rootfs和kernel镜像，可以在qemu中启动镜像，体验openEuler RISC-V移植版。      
- **2020年10月** 中科院成功移植openEuler RISC-V到果壳（nutshell）     
- **2020年9月** 在华为全联接（HC）2020大会上发布了openEuler RISC-V，国内首发RISC-V版Linux。
- **2020年8月** 在[OBS构建系统](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V)开始构建openEuler RISC-V软件包。	
- **2020年6月** 在[中科院的镜像仓](https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/)发布了第一版rootfs和kernel镜像。[新闻](http://crva.ict.ac.cn/crvs2020/index/slides/3-9.pdf)
#### 参与RISC-V SIG的活动
RISC-V 相关的活动由RISC-V sig负责。你可以通过如下方式参与RISC-V SIG：
- 建立或回复 issue：欢迎通过建立或回复 issue 来讨论，RISC-V SIG 所独立维护的仓库列表可在 [sig-RISC-V](https://gitee.com/openeuler/community/tree/master/sig/sig-RISC-V) 中查看。除了独立维护的仓库之外，若在src-openEuler 的其他软件仓中有和RISC-V相关的问题，请同时在本仓openEuler/RISC-V和相关软件仓中提ISSUE，方便共同解决。
- SIG 组例会：每周二上午会进行例会讨论，会议链接会通过openEuler-Dev的邮件列表发送
- Maillist 联系：目前RISC-V SIG没有独立的maillist，可使用openEuler-Dev（ dev@openeuler.org ）的邮件列表进行讨论，若话题讨论足够丰富的话会考虑申请独立的RISC-V maillist。
- 微信：联系我们加入RISC -V sig的微信群，一起进行讨论，欢迎分享你的想法         
    <img src="./documents/sig-RISC-V-WeChatContact-QRcode.jpg" width="30%" height="30%">
#### 目录结构

- [documents](./documents/): 使用文档
  - [openEuler RISC-V的获取和运行](documents/Installing.md)
  - [参与openEuler RISC-V的构建](documents/RPMbuild_RISC-V.md)
- [configuration](./configuration): openEuler RISC-V包含的软件包列表
  - [Yaml格式的软件包列表](configuration/RISC-V_list.yaml)
  - [OBS 工程的软件包配置](configuration/RISC-V_meta)
- [tools](./tools): openEuler RISC-V构建相关的工具
  - [制作openEuler RISC-V rootfs的工具](tools/mkfs-oe.sh)

#### RPM repo镜像仓库和软件源服务

提供二进制RPM包, 和源码包SRPM托管，提供软件源服务. 
```
https://repo.openeuler.org/openEuler-preview/RISC-V/
```

```
https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/
```

#### 镜像下载

提供根文件系统rootfs、虚拟磁盘镜像、内核镜像、openSBI、BBL等二进制镜像服务。用于在虚拟机环境快速搭建编译构建环境、想在虚拟机环境快速体验openEuler OS的RISC-V移植版本、想在推荐的硬件平台上快速体验openEuler OS的移植版本的开发者和爱好者.

- QEMU RISC-V 64仿真环境: https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images
- NutShell(果壳, UCAS) COOSCA1.0硬件环境： https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images/NutShellUCAS

#### 源码仓

openEuler RISC-V移植版所使用的代码力求与src-openEuler工程中代码仓的master分支保持一致，因此在适配RISC-V架构的过程中所遇到的修改会尽量推送代码仓的master分支；如果openEuler的master分支暂时没有接纳所推送的代码，就暂时使用所推送的代码分支作为源码仓，待master接纳后使用master分支代码。

openEuler RISC-V移植版所包含的软件包代码仓、版本信息在configuration目录下的[软件包列表文件](configuration/RISC-V_list.yaml)中可以获得。

### 列在openEuler社区维护的创建专门深度维护的源码repo

- opensbi
- risc-v-kernel
- openEuler-riscv-pk-NutShell
- openEuler-Kernel-NutShell
- openEuler-systemd-NutShell
- openEuler-riscv-glibc-NutShell


#### 虚拟机仿真平台

目前，openEuler RISC-V的移植版所支持的目标平台包括：
- 执行在x86_64, aarch64 平台上的QEMU-RISC-V 64虚拟机，这也是开发过程中首选的初步开发测试环境;

#### 硬件平台支持

- NutShell(果壳, UCAS) COOSCA1.0，这是当前默认支持的硬件测试环境.
- SiFive HiFive Unleashed, 进行。

#### 如何在NutShell(果壳, UCAS) COOSCA1.0上部署测试openEuler OS
- 素材准备
  - [RV_BOOT.UCAS_COOSCA1.0_V1.BIN](https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images/NutShellUCAS/RV_BOOT.UCAS-COOSCA1.0_V1.BIN): 移植支持NutShell UCAS COOSCA1.0的内核和BBL打包文件.
  - [oe-UCAS_COOSCA1.0-rootfs.v1.tar.gz](https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images/NutShellUCAS/oe-UCAS_COOSCA1.0-rootfs.v1.tar.gz): 移植适配在NutShell UCAS COOSCA1.0运行的根文件系统.
  - NutShell CPU处理器 (PL-Progarmmable Logic bitstream): 建议直接使用打包好的硬件二进制文件[BOOT.BIN](https://github.com/OSCPU/NutShell/blob/master/fpga/boot/pynq/BOOT.BIN)，包括FSBL和处理器. 详情请参考[NutShell(果壳, UCAS)](https://github.com/OSCPU/NutShell)网站.
  - [FPGA](documents/3PYNQ-Z2.jpeg): Xilinx PYNQ-Z2，用于仿真NutShell UCAS COOSCA1.0 (FPGA bitstream)的硬件平台，并提供外设等.
- 部署
  - microSD卡格式化：1) 建议SD卡容量不小于6GB； 2) 划分为2个分区，分别为/dev/mmcblk0p1和/dev/mmcblk0p2(用SD ADAPTER读卡器访问可见的设备名称，如果通过USB读卡器访问，名称可能是/dev/sdX, 比如/dev/sd1, /dev/sd2). 3）第一个分区格式化为FAT32，容量大于100MB，第二个分区格式化为EXT4.
  - 处理器硬件相关部署：挂载第一个分区，然后将BOOT.BIN拷贝到该分区.
  - OS Bootloader和OS Kernel部署：将RV_BOOT.UCAS-COOSCA1.0_V1.BIN拷贝到第一个分区，并重命名为RV_BOOT.BIN.
  - 根文件系统部署: 将oe-UCAS_COOSCA1.0-rootfs.v1.tar.gz解压到/dev/mmcblk0p2分区，注意根目录对齐.
- 启动PYNQ-Z2(启动系统)
  - 通过Micro-USB供电.
  - 打开电源开关（紧邻Micro-USB的拨动按钮）.
- 获取从ttyPS0设备可登录访问的控制台
  - sudo picocom -b 115200 /dev/ttyUSB1
  - root登录：如果一切顺利，将依次看到BBL引导、内核引导、根文件系统引导、systemd和systemd service启动，在systemd service启动阶段，你将获得一个运行在ttyPS0上的控制台，并提示你输入用户名和密码登录系统.
- 预先快速一览
  - 引导到BBL: [图0boot2bbl.JPG](documents/0boot2bbl.JPG).
  - 引导到OS(内核和rootfs): [图1welcome2openEuler20.03LTS.JPG](documents/1welcome2openEuler20.03LTS.JPG).
  - 登录后检查操作系统信息和处理器信息: [图2loginttyPS0.png](documents/2loginttyPS0.png).

即使手中没有RISC-V硬件也没关系，得益于QEMU的存在，你可以在几乎任意Linux环境中体验openEuler的RISC-V移植版，详细使用方法见这篇文档
- [openEuler RISC-V的安装和启动](documents/Installing.md)

#### 参与openEuler RISC-V移植版的构建

当前openEuler RISC-V的移植版所支持的软件包数量相比于openEuler 的20.03 LTS和20.09 都要少的多，我们的目标是尽可能丰富openEuler RISC-V移植版所包含的软件包数量，使能绝大多数软件包。
可参考如下文档，参与到openEuler RISC-V移植版的软件包构建工作中来。
- [参与openEuler RISC-V的构建](documents/RPMbuild_RISC-V.md)
