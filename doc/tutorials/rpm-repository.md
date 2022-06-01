# 配置软件源

## 新软件源 (测试中)

openEuler RISC-V 的新软件源已上线，目前还在测试阶段。

预计将随着开发过程持续更新。

> 软件源内容借助 `中国科学院软件研究所 ISCAS 开源镜像站` 等镜像站点向最终用户进行分发，每日同步一次以上。
>
> 在此感谢镜像站维护者们的大力支持。

### 镜像地址
软件所 ISCAS 开源镜像站（科技网）

`https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/`

### 新软件源使用说明

> ⚠️ 测试阶段软件源的结构和内容会依照开发需求不定时调整变动
>
> 更新时间 `2022-06-01`

#### `devel` 目录

- `devel` 目录下含有开发版快照镜像 (snapshot) 与对应的软件仓库。
- 构建产物在 `devel/$DATE/$VERSION/` 下，包括各个构建对象的镜像、软件源、rootfs tarball 与日志。
- 仓库内容来自 CI 的 Dev 分支，每日构建一次以上。
- 仓库内容仅经过 CI 单次测试，不保证可用性。

#### `testing` 目录

- `testing` 目录下含有测试版快照镜像 (snapshot) 与对应的软件仓库。
- 构建产物在 `testing/$DATE/$VERSION/` 下，包括各个构建对象的镜像、软件源、rootfs tarball 与日志
- 仓库内容来自 CI 的 Test 分支，每双周或按需构建。
- 仓库内容经过 CI 的数次测试，具有基本可用性。

#### `stable` 目录

- `stable` 目录下含有稳定版快照镜像 (snapshot) 与对应的软件仓库。
- 构建产物在 `stable/$DATE/$VERSION/` 下，包括各个构建对象的镜像、软件源、rootfs tarball 与日志。
- 仓库内容来自为 Testing 基础上的修复版本，预计月度释出。
- 仓库内容经过 CI 的数次测试与人工测试，具有一定可用性。

#### `release` 目录

- `release` 目录下含有稳定版快照镜像 (snapshot) 与对应的软件仓库。
- 构建产物在 `release/$MAJOR_VERSION/` 下，包括各个构建对象的镜像、软件源、rootfs tarball 与日志。
- 仓库内容为 openEuler RISC-V 大版本发布内容，将在 openEuler 大版本发布的时间节点择机发布。
- 仓库内容经过 CI 的数次测试与多次人工测试，具有可用性。

#### `deprecated` 目录

- `deprecated` 目录为先前构建的遗留内容，将择机移除。

#### `development` 目录

- `development` 目录为 `deprecated` 目录的软连接，以保证向后兼容性

#### 示例配置

> ⚠️ 与快照版本对应的软件源信息已在镜像内配置好，一般情况下无需改动

``` bash
[22.03]
name=22.03
baseurl=https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/devel/20220601/v0.1/repo/22.03/
enabled=1
gpgcheck=0
```

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

``` bash
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

## 更旧的配置

> **下述内容仅供参考**
>
> 目前依然生效（`2022-05-05`）但 **不推荐使用**

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

``` bash
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