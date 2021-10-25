# RISC-V 

#### Introduction
This repository hosts information about openEuler RISC-V. It includes how to obtain and use documents, project configurations, and tools of openEuler RISC-V.  
#### News Update
- **April, 2021**:  UC Techip, a RISC-V processor developer, joined the openEuler community. [Link](https://gitee.com/flame-ai/hello-openEuler/issues/I3CHPZ#note_4752587_link)  
- **March, 2021**: The *SIGer*, a journal of open source culture for teens, released its [Issue 4: *Better RISC-V For Better Life*](https://gitee.com/flame-ai/siger/blob/master/%E7%AC%AC4%E6%9C%9F%20Better%20RISC-V%20For%20Better%20Life.md) and [Issue 10: *From Victory To Victory*](https://gitee.com/yuandj/siger/blob/master/%E7%AC%AC10%E6%9C%9F%20%E5%8D%97%E5%BE%81%E5%8C%97%E6%88%98%EF%BC%88%E4%B8%8A12%EF%BC%89.md).  
- **March, 2021**:  openEuler RISC-V enabled the runC container runtime. [Link](https://gitee.com/flame-ai/siger/blob/master/%E7%AC%AC4%E6%9C%9F%20Better%20RISC-V%20For%20Better%20Life.md)  
- **February, 2021**:  Ready to add support for RISC-V TEE.  
- **December, 2020**: Released question 4 for the 2020 openEuler University Developer Competition. [Link](https://www.bilibili.com/video/BV1WD4y1X7HT?p=5)  
- **December, 2020**: Demonstrated the implementation of openEuler RISC-V on NutShell, at the 2020 openEuler Summit. [Link](https://openeuler.org/zh/blog/yang_yanchao/2021-3-12-start-a-containerd-on-riscv.html)  
- **November, 2020**: Released the second version of rootfs and kernel images in the [openEuler mirror repository](https://repo.openeuler.org/openEuler-preview/RISC-V/Image/). You can start images in QEMU to experience the ported openEuler RISC-V.   
- **October, 2020**: The Chinese Academy of Sciences successfully ported openEuler RISC-V to NutShell.  
- **September, 2020**: Launched openEuler RISC-V at Huawei Connect 2020. It is the first Linux of RISC-V in China.  
- **August, 2020**: Started to build the openEuler RISC-V software package in the [OBS construction system](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V).  
- **June, 2020**: Released the first version of rootfs and kernel images in [repositories of Chinese Academy of Sciences](https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/). [News](http://crva.ict.ac.cn/crvs2020/index/slides/3-9.pdf)  
#### Participating in RISC-V SIG Activities
The RISC-V SIG is responsible for RISC-V activities. You can participate in the RISC-V SIG in the following ways:  
- Create or reply to issues. We welcome your discussions in the form of issues in the repositories (see [sig-RISC-V](https://gitee.com/openeuler/community/tree/master/sig/sig-RISC-V)) independently maintained by the RISC-V SIG. In addition to the independently maintained repositories, if you have issues about RISC-V in other repositories of src-openEuler, please submit issues in the current openEuler/RISC-V repository and related repositories so that we can solve them together.  
- Regular meetings of the RISC-V SIG. We have regular meetings every Tuesday morning. The meeting links are sent through the email list of openEuler-Dev.  
- Mailing list. Currently the RISC-V SIG does not have a dedicated mailing list. You can use the openEuler-Dev mailing list instead (dev@openeuler.org). We are considering to establish a dedicated RISC-V mailing list if we've received a sufficient number of discussions.  
- WeChat: Scan the QR code to join us:  
    <img src="./documents/sig-RISC-V-WeChatContact-QRcode.jpg" width="30%" height="30%">
#### **Structure of Content**

- [Documents](./documents/): how to use openEuler RISC-V
  - [Obtain and run openEuler RISC-V](documents/Installing.md)
  - [Participate in building openEuler RISC-V](documents/RPMbuild_RISC-V.md)
- [Configurations](./configuration): openEuler RISC-V software package list
  - [Software packages in YAML format](configuration/RISC-V_list.yaml)
  - [Software package configurations of the OBS project](configuration/RISC-V_meta)
- [Tools](./tools): tools for building openEuler RISC-V
  - [Tools for creating openEuler RISC-V rootfs](tools/mkfs-oe.sh)

#### RPM mirror repository and software source services 

Binary RPM packages, source RPM (SRPM) hosting, and software sources.  
```
https://repo.openeuler.org/openEuler-preview/RISC-V/
```

```
https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/
```

#### Mirror Download

openEuler RISC-V provides binary image services, such as rootfs, virtual disk images, kernel images, openSBI, and BBL. The image services can be used to quickly set up a compilation environment on VMs, and port openEuler RISC-V to the VMs or an applicable hardware platform.  

- QEMU RISC-V 64 simulation environment: https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images/
- NutShell (UCAS) COOSCA 1.0 hardware environment: https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images/NutShellUCAS/

#### Source Code Repository

The code used by the openEuler RISC-V ported version is intended to be consistent with the master branch of the src-openEuler code repository. Any code modification made for adapting openEuler to the RISC-V architecture will be pushed to the master branch. If the master branch has not accepted the pushed code at the moment, the branch of the pushed code will be temporarily used as the source repository. After the master branch accepts the code, the master branch is used.  

The software package code repository and version information of the openEuler RISC-V ported version are available at the [the package list file](configuration/RISC-V_list.yaml) in the **Configuration** directory.  

### Source Code Repositories Maintained by the openEuler Community

- opensbi
- risc-v-kernel
- openEuler-riscv-pk-NutShell
- openEuler-Kernel-NutShell
- openEuler-systemd-NutShell
- openEuler-riscv-glibc-NutShell


#### VM Simulation Platforms

Currently, the ported version of openEuler RISC-V supports the following target platforms:   
- QEMU-RISC-V 64 VMs running on x86_64 and AArch64 platforms. They are the preferred preliminary development and test environment.   

#### Hardware Platforms

- NutShell (UCAS) COOSCA 1.0, which is the default hardware test environment
- SiFive HiFive Unleashed

#### Deploying and Testing openEuler on NutShell (UCAS) COOSCA 1.0
- Preparations
  - [RV_BOOT.UCAS_COOSCA1.0_V1.BIN](https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images/NutShellUCAS/RV_BOOT.UCAS-COOSCA1.0_V1.BIN):  used to port the NutShell UCAS COOSCA1.0 kernel and BBL package files.
  - [oe-UCAS_COOSCA1.0-rootfs.v1.tar.gz](https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/images/NutShellUCAS/oe-UCAS_COOSCA1.0-rootfs.v1.tar.gz): used to port the root file system running on NutShell UCAS COOSCA 1.0.
  - NutShell CPU Processor (PL-Programmable Logic Bitstream): You are advised to use the packaged hardware binary file [BOOT.BIN](https://github.com/OSCPU/NutShell/blob/master/fpga/boot/pynq/BOOT.BIN) directly, which covers the FSBL and CPU. For details, visit [NutShell (UCAS)](https://github.com/OSCPU/NutShell).
  - [FPGA](documents/3PYNQ-Z2.jpeg): Xilinx PYNQ-Z2, used to simulate the NutShell UCAS COOSCA 1.0 (FPGA bitstream) hardware platform and provide peripherals.
- Deployment
  - Format the microSD card: (1) It is recommended that the capacity of the microSD card be greater than or equal to 6 GB. (2) Create two partitions: **/dev/mmcblk0p1** and **/dev/mmcblk0p2** (the device names displayed if you use an SD adapter card reader. If you use a USB card reader, the names may be **/dev/sdX** like **/dev/sd1** and **/dev/sd2**). (3) Format the first partition as FAT32 with a capacity greater than 100 MB. Format the second partition as EXT4.
  - Deploy the processor hardware. Mount the first partition and copy **BOOT.BIN** to the partition.
  - Deploy the OS Bootloader and OS kernel. Copy **RV_BOOT.UCAS-COOSCA1.0_V1.BIN** to the first partition and rename it to **RV_BOOT.BIN**.
  - Deploy the root file system. Decompress **oe-UCAS_COOSCA1.0-rootfs.v1.tar.gz** to the **/dev/mmcblk0p2** partition. Check that the root directory is correct.
- Starting the PYNQ-Z2 (starting the system)
  - Use the Micro-USB to supply power.
  - Turn on the power switch (the rocker button close to the Micro-USB port).
- Obtaining the console accessible from ttyPS0
  - sudo picocom -b 115200 /dev/ttyUSB1
  - Log in as the root user. If everything goes smoothly, you will see BBL boot, kernel boot, root file system boot, systemd, and systemd service boot in sequence. When systemd service is booting up, you will get a console running on ttyPS0, and you will be prompted to enter your user name and password to log in.
- Quick previews
  - BBL boot: [image: 0boot2bbl.JPG](documents/0boot2bbl.JPG).
  - OS boot (kernel and rootfs): [image: 1welcome2openEuler20.03LTS.JPG](documents/1welcome2openEuler20.03LTS.JPG).
  - Checking OS and CPU information after login: [image: 2loginttyPS0.png](documents/2loginttyPS0.png).

It does not matter even if you do not have RISC-V hardware. Thanks to QEMU, you can experience the ported version of openEuler RISC-V in almost any Linux environment. For details, refer to:  
- [Installation and startup of openEuler RISC-V](documents/Installing.md)

#### Participating in Building the Ported Version of openEuler RISC-V

The current ported version of openEuler RISC-V supports a much smaller number of software packages than openEuler 20.03 LTS and 20.09. Our goal is to maximize the number of software packages included in the ported version of openEuler RISC-V, so that the vast majority of packages are available.  

If you are interested in participating in building software packages of the ported version of openEuler RISC-V, please refer to the following documentation:   

- [Participate in building openEuler RISC-V](documents/RPMbuild_RISC-V.md)