# 了解项目
## 项目简介
## 项目目标
## 项目现状
## 主要任务





# 社区动态

## 版本信息
## 支持的硬件
## 所有动态




# 如何查看项目资源
### 主要项目资源简介
标黄的为工作中常用的：

| 名称 | 类型 | 说明 | 访问地址 |
| --- | --- | --- | --- |
| 源码仓（全量） | gitee仓库 | 源码仓里面存放的是所有引入gitee的软件包的源代码，每个软件包在源码仓中以一个【仓库】的方式存在； | [https://gitee.com/src-openeuler](https://gitee.com/src-openeuler)  |
| openEuler RISC-V | gitee仓库 | openEuler RISC-V主要工作仓库，包括如何获取及使用openEuler RISC-V的文档、工程配置以及工具 | [https://gitee.com/openeuler/RISC-V](https://gitee.com/openeuler/RISC-V) |
| rv_spare（源码仓中转） | gitee仓库 | 在对构建失败的包做fork和PR流程中，为了管理需要增加的中间仓库，作为未被openeuler 接收之前的中转；（需要权限） | https://gitee.com/riscv-spare/projects |
| OBS Projects | OBS | 按照Project的概念，按照操作系统类型、版本等不同方式进行划分；每个openEuler RISCV的版本都对应一个project； | https://build.openeuler.org/project/ |
| [openEuler:Mainline](https://build.openeuler.org/project/show/openEuler:Mainline) | OBS | 包含了稳定、核心软件包（未包含全量的软件包） | https://build.openeuler.org/project/show/openEuler:Mainline |
| [openEuler:Mainline:RISC-V](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V) | OBS | 由[openEuler:Mainline](https://build.openeuler.org/project/show/openEuler:Mainline)衍生而来，稳定核心包基于riscv的构建 | [https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V) |





### gitee仓库
#### [openEuler](https://gitee.com/openeuler)/[RISC-V](https://gitee.com/openeuler/RISC-V)：[https://gitee.com/openeuler/RISC-V](https://gitee.com/openeuler/RISC-V)
openEuler RISC-V仓库托管了有关于openEuler RISC-V相关的信息，包括如何获取及使用openEuler RISC-V的文档、工程配置以及工具。

#### 源码仓：全量版本(源码仓)：[https://gitee.com/src-openeuler](https://gitee.com/src-openeuler)  [仓库] 7675个
openEuler RISC-V移植版所使用的代码力求与src-openEuler工程中代码仓的master分支保持一致，因此在适配RISC-V架构的过程中所遇到的修改会尽量推送代码仓的master分支；如果openEuler的master分支暂时没有接纳所推送的代码，就暂时使用所推送的代码分支作为源码仓，待master接纳后使用master分支代码。
openEuler RISC-V移植版所包含的软件包代码仓、版本信息在configuration目录下的[软件包列表文件](https://gitee.com/openeuler/RISC-V/blob/master/configuration/RISC-V_list.yaml)中可以获得。


#### 列在openEuler社区维护的创建专门深度维护的源码repo？分别都是干啥的？

- opensbi
- risc-v-kernel
- openEuler-riscv-pk-NutShell
- openEuler-Kernel-NutShell
- openEuler-systemd-NutShell
- openEuler-riscv-glibc-NutShell
### issue
openEuler riscv项目目前主要的工作任务、需求收集、问题反馈的沟通渠道之一。
[https://gitee.com/openeuler/RISC-V/issues/I1U0YD?from=project-issue](https://gitee.com/openeuler/RISC-V/issues/I1U0YD?from=project-issue)


### 二进制包下载
#### RPM repo镜像仓库和软件源服务
[https://repo.openeuler.org/openEuler-preview/RISC-V/](https://repo.openeuler.org/openEuler-preview/RISC-V/) 
[https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/](https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/) 


### 文档


### OBS project构建系统
OBS Projects：[https://build.openeuler.org/project/](https://build.openeuler.org/project/)
[openEuler:Mainline:RISC-V](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V)：[https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V](https://build.openeuler.org/project/show/openEuler:Mainline:RISC-V) 




# 如何加入社区成为贡献者
## 社区在做什么？
> 社区有哪些事情，事情分类与能力要求说明



## 如何加入？
> 如何参与RISCV SIG的活动



## 这类任务怎么去做？
> 每一类事情的执行思路、工作流程、操作指导（参考笔记）
>
> 构建失败
> 文档
> 开发板






## 我能做什么？——》当前有哪些待开展的任务？
> 任务分类+任务分级：任务分发

参与openEuler RISC-V移植版的构建


# 如何使用openEuler RISCV操作系统
## 如何获取openEuler RISCV操作系统

- openEuler RISCV OS的最新版本与下载
- openEuler RISCV OS的历史版本与下载
## 如何在非riscv架构上使用openEuler RISCV 系统
### QEMU-RISC-V 64虚拟机


## openEuler RISCV 支持的硬件与使用
> openEuler RISCV OS在不同开发板上的安装与使用：按照oE riscv版本、开发板不同版本可能出现很多组合

### NutShell(果壳, UCAS) COOSCA1.0
> 这是当前默认支持的硬件测试环境.

- 果壳技术文档、技术论坛等
- 如何在果壳上部署测试openEuler OS
- 问题反馈
### SiFive HiFive Unleashed


### 全志哪吒D1

