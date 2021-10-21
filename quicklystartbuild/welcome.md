本文档的目标人群是加入openeuler riscv sig（简称oe-rv）组的新人，目的是让新加入的小伙伴能够快速的了解项目是做什么的，目前的现状，主要的资源，如何加入和基础的学习资源有哪些。



## 一、了解项目

### 1. 项目背景

参考文档：[项目介绍](https://gitee.com/openeuler/RISC-V/blob/master/quicklystartbuild/introduction.md)



### 2.项目最新进展

可以通过会议纪要和双周总结了解项目一些历史信息：

1. openeuler 每2周的周四上午9:30-10:00召开双周例会： [SIG-RISC-V双周例会会议纪要](https://etherpad.openeuler.org/p/sig-RISC-V-meetings)  

2. 项目双周进展总结详见：https://gitee.com/openeuler/RISC-V/blob/master/weeklyreports 目录下文档



## 二、快速入门

### 1. 加入openeuler riscv sig组

​	请先注册gitee账号，并签署CLA（[官方参考](https://gitee.com/openeuler/community/blob/master/zh/contributors/README.md)  或 [CLA的一些注意事项](https://gitee.com/openeuler/RISC-V/blob/master/quicklystartbuild/sign-gitee-CLA.md)），关注官方仓库：https://gitee.com/openeuler/RISC-V 



### 2. 相关工作仓库有哪些？

| 名称 | 类型 | 说明 | 访问地址 |
| --- | --- | --- | --- |
| openeuler源码仓（全量） | gitee仓库 | openeuler源码仓里面存放的是所有引入openeuler os的软件包的源代码，每个软件包在源码仓中以一个【仓库】的方式存在； | [https://gitee.com/src-openeuler](https://gitee.com/src-openeuler)  |
| openEuler RISC-V | gitee仓库 | openEuler RISC-V主要工作仓库，包括如何获取及使用openEuler RISC-V的文档、工程配置以及工具 | [https://gitee.com/openeuler/RISC-V](https://gitee.com/openeuler/RISC-V) |
| openeuler riscv源码仓(openeuler-risc-v） | gitee仓库 | 在对构建失败的包做fork和PR流程中，为了管理需要增加的中间仓库，作为未被openeuler 接收之前的中转；（需要权限） | https://gitee.com/openeuler-risc-v |
| OBS Projects | OBS | 按照Project的概念，按照操作系统类型、版本等不同方式进行划分；每个openEuler RISCV的版本都对应一个project； | https://build.openeuler.org/project/ |
| [openEuler:Mainline](https://build.openeuler.org/project/show/openEuler:Mainline) | OBS | 包含了稳定、核心软件包（未包含全量的软件包） | https://build.openeuler.org/project/show/openEuler:Mainline |
| [openEuler:Mainline:RISC-V](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V) | OBS | oe-rv对应的构建工程，由[openEuler:Mainline](https://build.openeuler.org/project/show/openEuler:Mainline)衍生而来，稳定核心包基于riscv的构建 | [https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V) |



说明：

1. gitee是源代码和文档等托管平台，obs是构建平台；obs构建的包的源码来自于gitee托管的源码仓
2. openEuler RISC-V移植版所使用的代码力求与src-openEuler工程中代码仓的master分支保持一致，因此在适配RISC-V架构的过程中所遇到的修改会尽量推送代码仓的master分支；如果openEuler的master分支暂时没有接纳所推送的代码，就暂时使用所推送的代码分支作为源码仓，待master接纳后使用master分支代码。openEuler RISC-V移植版所包含的软件包代码仓、版本信息在configuration目录下的[软件包列表文件](https://gitee.com/openeuler/RISC-V/blob/master/configuration/RISC-V_list.yaml)中可以获得。
3. openEuler riscv源码仓是为了加速riscv pull request审核流程而设置的一个中间仓库，用于维护在openeuler riscv构建环境下需要维护的源码包。（oe-rv需要修改的包才放openeuler-risc-v，不需要修改的源码包依然使用src-openeuler源码仓的源码）



### 3. 学习构建相关知识

1. 关于openEuler OBS构建：

-  [[顶置]解决RISC-V的构建失败问题](https://gitee.com/openeuler/RISC-V/issues/I1U0YD?from=project-issue)

  > 如何fix failed包的思路

- [openeuler官网构建包教程](https://docs.openeuler.org/zh/docs/20.09/docs/ApplicationDev/%E6%9E%84%E5%BB%BARPM%E5%8C%85.html)

  > 如何构建一个软件包

- [openEuler官方录制的B站视频](https://space.bilibili.com/527064077/channel/detail?cid=159892&ctype=0)

  > openeuler是基于obs构建平台进行构建的，因此需要学习obs工具的使用。建议看【玩转openEuler系列直播之基础知识】的【[【玩转openEuler系列直播 5】openEuler构建之OBS使用指导](https://www.bilibili.com/video/BV1YK411H7E2)】；
  >
  > 其它openEuler B站的视频，有时间也可以多学习。

- [OBS官方用户指导：obs-user-guide](https://openbuildservice.org/help/manuals/obs-user-guide/)

  > obs构建平台如何使用



2. openeuler riscv资源：

- 镜像：https://repo.openeuler.org/openEuler-preview/RISC-V/Image/
- 源：https://repo.openeuler.org/openEuler-preview/RISC-V/everything/



3. [openEuler packaging guidelines](https://gitee.com/openeuler/community/blob/master/zh/contributors/packaging.md)



### 4. 开始使用obs平台构建

​	建议先了解下流程：https://gitee.com/openeuler/RISC-V/blob/master/quicklystartbuild/workflow-for-build-a-package.md



## 三、openeuler社区

- [openEuler官网](https://openeuler.org/zh/) 
- [openeuler gitee社区](https://gitee.com/openeuler)



