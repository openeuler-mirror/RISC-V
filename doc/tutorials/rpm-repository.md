# 配置 rpm 软件源

## 基础配置

目前 openEuler RISC-V 有两个可用度较高的 rpm 软件源。

这两个源均仍维持当初编译时的状态，没有跟进更新。

- 位置：软件所镜像源（科技网）

    更新日期 2020-10-27

    版本较旧，所含软件包覆盖范围较广
  
  `https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/oe-RISCV-repo/`

- 位置：openEuler 官方软件源（华为云）

    更新日期 2020-11-19

    版本较新，所含软件包覆盖范围稍差

  `https://repo.openeuler.org/openEuler-preview/RISC-V/everything/`

配置方式

- 修改 /etc/yum.repos.d/oe-rv.repo 为如下内容

```
[base]
name=base
baseurl=https://isrc.iscas.ac.cn/mirror/openeuler-sig-riscv/oe-RISCV-repo/
enabled=1
gpgcheck=0

[oe-preview]
name=oe-preview
baseurl=https://repo.openeuler.org/openEuler-preview/RISC-V/everything/
enabled=1
gpgcheck=0
```

## 测试新软件源

新 rpm 软件源已上线，目前还在初期测试阶段。

预计将随着开发过程持续更新。

- 位置：软件所镜像源（科技网）

  `https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/`

## 临时使用/测试 OBS 上打好的软件包

> ⚠️ 此方法不适用于 OBS 赖以进行本地编译的 chroot 容器
>
> ⚠️ 此操作风险较高，使用前请做好备份
>
> ⚠️ 来自 OBS 的软件包可能因版本冲突/依赖缺失而无法工作

目前 OBS 系统的 "版本项目" 和 "其他项目"（包含个人项目）分布在两台不同的机器上。

- openEuler RISC-V Mainline 项目构建出的软件包
  - standard_riscv64 分支

    `http://119.3.219.20:82/openEuler:/Mainline:/RISC-V/standard_riscv64/`

  - advanced_riscv64 分支

    `http://119.3.219.20:82/openEuler:/Mainline:/RISC-V/advanced_riscv64/`

- 个人项目构建出的软件包

    `http://121.36.3.168:82/home:[USERNAME]:[REPONAME]/[ARCH]`

配置方式

- 新建或修改 /etc/yum.repos.d/obs.repo，以如下内容为例

```
[obs_mainline_repo]
name=obs_mainline_repo
baseurl=http://119.3.219.20:82/openEuler:/Mainline:/RISC-V/standard_riscv64/
enabled=1
gpgcheck=0

[obs_custom_repo]
name=obs_custom_repo
baseurl=http://121.36.3.168:82/home:/pandora:/solvable/standard_riscv64/
enabled=1
gpgcheck=0
```