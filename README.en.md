# RISC-V 

#### Introduction <ok>
This repository hosts information about openEuler RISC-V. It includes how to get and use the documentation, project configuration and tools of openEuler RISC-V.
#### News Update
- **April, 2021**  UC Techip, a  RISC-V processor developer, joined the OpenEuler community.  [Link](https://gitee.com/flame-ai/hello-openEuler/issues/I3CHPZ#note_4752587_link)
- **March, 2021** *SIGer*, a journal of open source culture for teens, [Issue 4: *Better RISC-V For Better Life*](https://gitee.com/flame-ai/siger/blob/master/%E7%AC%AC4%E6%9C%9F%20Better%20RISC-V%20For%20Better%20Life.md) and [Issue 10: *From Victory To Victory*](https://gitee.com/yuandj/siger/blob/master/%E7%AC%AC10%E6%9C%9F%20%E5%8D%97%E5%BE%81%E5%8C%97%E6%88%98%EF%BC%88%E4%B8%8A12%EF%BC%89.md)
- **March, 2021**  OpenEuler RISC-V enables runc container [Link](https://gitee.com/flame-ai/siger/blob/master/%E7%AC%AC4%E6%9C%9F%20Better%20RISC-V%20For%20Better%20Life.md)
- **February, 2021**  Ready to add support for RISC-V TEE
- **December, 2020** *2020 openEule University Developer Competition*，Question 4. [Link](https://www.bilibili.com/video/BV1WD4y1X7HT?p=5)
- **December, 2020** Demonstrate executing openEuler RISC-V on NutShell at the 2020 openEuler Summit.[Link](https://openeuler.org/zh/blog/yang_yanchao/2021-3-12-start-a-containerd-on-riscv.html)
- **November, 2020** In [openeuler's mirror repository](https://repo.openeuler.org/openEuler-preview/RISC-V/Image/) the second version of rootfs and kernel's mirror were released. You can start he mirror in QEMU and experience ported version of openEuler RISC-V.       
- **October, 2020** The Chinese Academy of Sciences has successfully ported openEuler RISC-V to the NutShell.     
- **September, 2020** 在华为全联接（HC）2020大会上发布了openEuler RISC-V，国内首发RISC-V版Linux。 OpenEuler RISC-V was released at Huawei Full Connectivity (HC) 2020 Conference. It is the first RISC-V version of Linux released in China.
- **August, 2020** Start building software packages of openEuler RISC-V in [OBS construction system](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V).	
- **June, 2020** The first version of rootfs and kernel mirror was released in [repositories of Chinese Academy of Sciences](https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/). [News](http://crva.ict.ac.cn/crvs2020/index/slides/3-9.pdf)
#### Participate in events of RISC-V SIG <ok>
RISC-V SIG is responsible for RISC-V related events. You can participate in RISC-V SIG the following ways:
- Create or reply to issues：You are welcome to discuss by creating or replying to issues. A list of repositories that independently maintained by RISC-V SIG is available in [sig-RISC-V](https://gitee.com/openeuler/community/tree/master/sig/sig-RISC-V). In addition to the independently maintained repositories, if there are any RISC-V related problems in other repositories of src-openEuler, please issue them in openEuler/RISC-V and related repositories, so that we can solve them together.
- SIG group regular meetings: Every Tuesday morning, there will be a regular meeting discussion . A link to the meeting will be sent through the openEuler-Dev mailing list.
- Mail list contact: Currently, there is no independent mail list for RISC-V SIG. You can discuss using the openEuler-Dev (dev@openeuler.org) mailing list. However, if the discussion of the topic is rich enough, applying for an independent RISC-V mail list will be considered.
- WeChat: Contact us to join the WeChat group of RISC-V SIG and have discussions here. Please feel free to share your thoughts.          
    <img src="./documents/sig-RISC-V-WeChatContact-QRcode.jpg" width="30%" height="30%">
#### Directory Structure <ok>

- [documents](./documents/): usage documents
  - [To get and use openEuler RISC-V](documents/Installing.md)
  - [Participate in building openEuler RISC-V](documents/RPMbuild_RISC-V.md)
- [configuration](./configuration): a list of software packages that openEuler RISC-V includes
  - [A list of packages in YAML format](configuration/RISC-V_list.yaml)
  - [Package configuration for OBS application](configuration/RISC-V_meta)
- [tools](./tools): build-related tools of openEuler RISC-V 
  - [Tools for making openEuler RISC-V rootf](tools/mkfs-oe.sh)

#### RPM repo mirror repository and services of software source <ok>

Binary RPM package, source package SRPM hosting and software source services are provided.
```
https://repo.openeuler.org/openEuler-preview/RISC-V/
```

```
https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/
```

#### Mirror Download <ok>

Root file system(rootfs), virtual disk mirroring, kernel mirroring, openSBI, and binary mirror service like BBL are provided. These are for developers and enthusiasts who want to quickly set up the build environment for compilation, to have a quick experience of the RISC-V port version of OpenEuler OS in a virtual machine environment, and to have a quick experience of the ported version of openEuler OS on the recommended hardware platform.

- QEMU RISC-V 64 simulation environment: https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images
- NutShell(果壳, UCAS) COOSCA1.0 hardware environment： https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images/NutShellUCAS

#### Source-code repository  <ok>

The code used in ported version of openEuler RISC-V is intended to be consistent with the master branch of the codebase in src-openEule. Thus, the changes encountered during the adaptation of the RISC-V architecture will be pushed to the master branch of the codebase as much as possible. If the master branch of openEuler does not accept the pushed code at the moment, then branch of the pushed code will be used as source-code repository temporality. After master has accepted it, code of master branch will be used.

 The software packages codebase and version information that the ported version of openEuler RISC-V includes are available in [the package list file](configuration/RISC-V_list.yaml) under the Configuration directory.

### 列在openEuler社区维护的创建专门深度维护的源码repo <???>

- opensbi
- risc-v-kernel
- openEuler-riscv-pk-NutShell
- openEuler-Kernel-NutShell
- openEuler-systemd-NutShell
- openEuler-riscv-glibc-NutShell


#### Virtual machine simulation platform <ok>

Currently, ported version of openEuler RISC-V supports the following target platforms:
- Implement QEMU-RISC-V 64 virtual machine running on x86_64, aarch64 platform. It is also the preferred initial development test environment during development.

#### Hardware platform support <ok>

- NutShell(果壳, UCAS) COOSCA1.0: This is the currently default supported hardware testing environment.
- SiFive HiFive Unleashed

#### How to deploy tests for openeuler OS on Nutshell (果壳, UCAS) COOSCA1.0 <ok>
- Material preparation
  - [RV_BOOT.UCAS_COOSCA1.0_V1.BIN](https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images/NutShellUCAS/RV_BOOT.UCAS-COOSCA1.0_V1.BIN):  Port kernel and BBL package files that support Nutshell UCAS COOSCA1.0.
  - [oe-UCAS_COOSCA1.0-rootfs.v1.tar.gz](https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images/NutShellUCAS/oe-UCAS_COOSCA1.0-rootfs.v1.tar.gz): Port the root file system adapted to run on Nutshell UCAS Coosca 1.0.
  - NutShell CPU Processor (PL-Progarmmable Logic bitstream): It is recommended to use the packaged hardware binaries[BOOT.BIN](https://github.com/OSCPU/NutShell/blob/master/fpga/boot/pynq/BOOT.BIN) directly,including FSBL and the processor.  See the [NutShell(果壳, UCAS)](https://github.com/OSCPU/NutShell) website for details.
  - [FPGA](documents/3PYNQ-Z2.jpeg): Xilinx Pynq-Z2, used to simulate NutShell UCAS Coosca 1.0 (FPGA Bitstream) hardware platform, and provide peripherals, etc
- Deployment 
  - Format microSD card: 1) SD card capacity is recommended to be no less than 6GB. 2) It is divided into two partitions, which are /dev/mmcblk0p1 and /dev/mmcblk0p2(use the SD ADAPTER reader to access the visible device name, or if you use the USB reader, the name may be /dev/sdx, such as /dev/sd1, /dev/sd2). 3) The first partition is formatted as FAT32 with a capacity greater than 100MB, and the second partition is formatted as EXT4.
  - Processor hardware-dependent deployment: Mount the first partition and then copy BOOT.BIN to it.
  - OS Bootloader and OS Kernel deployments: Copy rv_boot.ucas-coosca1.0_v1.bin to the first partition and rename it to RV_BOOT.BIN. 
  - Root file system deployment: Extract the oe-ucas_coosca1oe-UCAS_COOSCA1.0-rootfs.v1.tar. gz to /dev/mmcblk0p2 partition, keeping an eye on root alignment.
  - Powered by micro-USB.
  - Turn on the power switch (the toggle button next to the micro-USB)
- To get the console that is log-in accessible from the ttyPS0 device
  - sudo picocom -b 115200 /dev/ttyUSB1
  - Root login: If all goes well, you'll see BBL guide, kernel guide, root file system guide, systemd, and systemd service start up. At systemd service start up, you'll get a console running on ttyPS0 and prompted to enter a user name and password to log in.
- A quick preview
  - Guide to the BBL: [image: 0boot2bbl.JPG](documents/0boot2bbl.JPG).
  - Guide to OS(kernel and rootfs): [image: 1welcome2openEuler20.03LTS.JPG](documents/1welcome2openEuler20.03LTS.JPG).
  - Check operating system information and processor information after logging in: [imgae: 2loginttyPS0.png](documents/2loginttyPS0.png).

Even if you don't have RISC-V hardware in your hand, thanks to QEMU, you can try out OpenEuler's RISC-V port in almost any Linux environment. See this document for details on how to use it.
- [Installation and startup of openEuler RISC-V](documents/Installing.md)

#### Participate in building ported version of openEuler RISC-V

The current ported version of openEuler RISC-V supports a much smaller number of software packages than openEuler 20.03 LTS and 20.09. Our goal is to maximize the number of software packages included in the ported version of openEuler RISC-V, so that the vast majority of packages are available.
If you are interested in participating in building software packages of ported version of openEuler RISC-V, please refer to the following documentation
- [Participate in builidng openEuler RISC-V](documents/RPMbuild_RISC-V.md)