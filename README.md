# RISC-V 

#### 介绍
本软件仓中托管了有关于openEuler RISC-V相关的信息，包括如何获取及使用openEuler RISC-V的文档、工程配置以及工具。

#### 参与RISC-V SIG的活动
RISC-V 相关的活动由RISC-V sig负责。你可以通过如下方式参与RISC-V SIG：
- 建立或回复 issue：欢迎通过建立或回复 issue 来讨论，RISC-V SIG 所独立维护的仓库列表可在 [sig-RISC-V](https://gitee.com/openeuler/community/tree/master/sig/sig-RISC-V) 中查看。除了独立维护的仓库之外，若在src-openEuler 的其他软件仓中有和RISC-V相关的问题，请同时在本仓openEuler/RISC-V和相关软件仓中提ISSUE，方便共同解决。
- SIG 组例会：每周二上午会进行例会讨论，会议链接会通过openEuler-Dev的邮件列表发送
- Maillist 联系：目前RISC-V SIG没有独立的mainlist，可使用openEuler-Dev（ dev@openeuler.org ）的邮件列表进行讨论，若话题讨论足够丰富的话会考虑申请独立的RISC-V maillist。

#### 目录结构

- [tools](./tools): openEuler RISC-V构建相关的工具
  - [制作openEuler RISC-V rootfs的工具](tools/mkfs-oe.sh)
- [configuration](./configuration): openEuler RISC-V包含的软件包列表
  - [Yaml格式的软件包列表](configuration/RISC-V_list.yaml)
  - [OBS 工程的软件包配置](configuration/RISC-V_meta)
- [documents](./documents/): 使用文档
  - [openEuler RISC-V的获取和运行](documents/openEuler镜像的构建.md)
  - [参与openEuler RISC-V的构建](documents/交叉编译内核.md)
  - [更新日志](documents/changelog.md)


#### 镜像仓库和repo源

一个临时的镜像仓库和repo源可通过如下地址获取：
```
https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/
```

#### 使用镜像

目前，openEuler RISC-V的移植版所支持的目标平台包括：
- 执行在x86_64/aarch64 平台的QEMU-kvm RISC-V模拟器；
- Sifive Unleashed U54;

即使手中没有RISC-V硬件也没关系，得益于QEMU的存在，你可以在几乎任意Linux环境中体验openEuler的RISC-V移植版，详细使用方法见这篇文档
- [openEuler RISC-V的安装和启动](documents/openEuler镜像的构建.md)

#### 参与openEuler RISC-V移植版的构建

当前openEuler RISC-V的移植版所支持的软件包数量相比于openEuler 的20.03 LTS和20.09 都要少，我们的目标是尽可能丰富openEuler RISC-V移植版所包含的软件包数量，使能绝大多数软件包。
可参考如下文档，参与到openEuler RISC-V移植版的软件包构建工作中来。
- [参与openEuler RISC-V的构建](documents/交叉编译内核.md)

