# RISC-V 

#### 介绍
本软件仓中托管了有关于openEuler RISC-V相关的信息，包括如何获取及使用openEuler RISC-V的文档、工程配置以及工具。

#### 参与RISC-V SIG的活动
RISC-V 相关的活动由RISC-V sig负责。你可以通过如下方式参与RISC-V SIG：
- 建立或回复 issue：欢迎通过建立或回复 issue 来讨论，RISC-V SIG 所独立维护的仓库列表可在 [sig-RISC-V](https://gitee.com/openeuler/community/tree/master/sig/sig-RISC-V) 中查看。除了独立维护的仓库之外，若在src-openEuler 的其他软件仓中有和RISC-V相关的问题，请同时在本仓openEuler/RISC-V和相关软件仓中提ISSUE，方便共同解决。
- SIG 组例会：每周二上午会进行例会讨论，会议链接会通过openEuler-Dev的邮件列表发送
- Maillist 联系：目前RISC-V SIG没有独立的mainlist，可使用openEuler-Dev（ dev@openeuler.org ）的邮件列表进行讨论，若话题讨论足够丰富的话会考虑申请独立的RISC-V maillist。

#### 目录结构

- [documents](./documents/): 使用文档
  - [openEuler RISC-V的获取和运行](documents/Installing.md)
  - [参与openEuler RISC-V的构建](documents/RPMbuild_RISC-V.md)
- [configuration](./configuration): openEuler RISC-V包含的软件包列表
  - [Yaml格式的软件包列表](configuration/RISC-V_list.yaml)
  - [OBS 工程的软件包配置](configuration/RISC-V_meta)
- [tools](./tools): openEuler RISC-V构建相关的工具
  - [制作openEuler RISC-V rootfs的工具](tools/mkfs-oe.sh)

#### 镜像仓库和repo源

 一个临时的镜像仓库和repo源可通过如下地址获取：
```
https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/
```

#### 源码仓

openEuler RISC-V移植版所使用的代码力求与src-openEuler工程中代码仓的master分支保持一致，因此在适配RISC-V架构的过程中所遇到的修改会尽量推送代码仓的master分支；如果openEuler的master分支暂时没有接纳所推送的代码，就暂时使用所推送的代码分支作为源码仓，待master接纳后使用master分支代码。

openEuler RISC-V移植版所包含的软件包代码仓、版本信息在configuration目录下的[软件包列表文件](configuration/RISC-V_list.yaml)中可以获得。


#### 使用镜像

目前，openEuler RISC-V的移植版所支持的目标平台包括：
- 执行在x86_64/aarch64 平台的QEMU-kvm RISC-V模拟器；
- Sifive Unleashed U54;

即使手中没有RISC-V硬件也没关系，得益于QEMU的存在，你可以在几乎任意Linux环境中体验openEuler的RISC-V移植版，详细使用方法见这篇文档
- [openEuler RISC-V的安装和启动](documents/Installing.md)

#### 参与openEuler RISC-V移植版的构建

当前openEuler RISC-V的移植版所支持的软件包数量相比于openEuler 的20.03 LTS和20.09 都要少的多，我们的目标是尽可能丰富openEuler RISC-V移植版所包含的软件包数量，使能绝大多数软件包。
可参考如下文档，参与到openEuler RISC-V移植版的软件包构建工作中来。
- [参与openEuler RISC-V的构建](documents/RPMbuild_RISC-V.md)

