# VISA-OS roadmap

V0.4 (2021-06-30)

支持应用VISA rpm编译构建;



V0.3 (2021-05-30)

发布openEuler VISA虚拟机镜像, 该镜像可以同时运行在X86, ARM64, RISC-V架构虚拟机;



V0.2 (2021-04-30)

发布openEuler VISA虚拟机镜像, 该镜像可以同时运行在X86, ARM64架构虚拟机;



v0.1 (2021-03-30)

发布openEuler VISA虚拟机镜像, 该镜像可以同时运行在X86架构虚拟机;



## plan

### 基础构建环境选择X86环境

构建kernel;  FATELF模式;

构建grub; FATELF模式; UEFI启动的时候, 只发现1个efi文件; efi文件在安装的时候确认arch; 

构建glibc; FATELF模式;

构建systemd; FATELF模式;

构建LLVM; FATELF模式;

构建openssh; FATELF模式;

构建最小启动OS, 500+个基础包;



### 基于FAT，逐个构建IR软件包

VISA rpm构建机制设计（obs模式）;  先暂停, 先手工制作虚拟机镜像;



## design

LLVM IR运行启动之前的包, 建议先用FATELF模式;