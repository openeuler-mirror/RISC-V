# ORSP001 openEuler RISC-V SIG Proposal 001

## Meta info

提议者：吴伟、张旭舟、席静、王俊强

时间：2022-02-17

## 背景 / Background

目前 openEuler RISC-V 的构建打包修复主要在 Mainline/RISC-V 主线工程上。 Mainline/RISC-V 是在 openEuler 21.09 版本的某一个时间点 branchout 出来的。目前包含了 openEuler 8000+ 包中的 4000+，存在 OBS 基础设施构建速度太慢、仍有约 400+ 包未被修复的问题。

随着 openEuler 22.03 的发布准备， openEuler RISC-V SIG 也创建了 openEuler/22.03/RISC-V/Next 工程并尝试赶上 22.03 的发版进度。经过与 openEuler QA SIG 等发版相关的 SIG 讨论，目前尚无明确商业用途，不建议跟随 22.03 发版。

另一方面，目前 openEuler 官方页面提供下载的镜像仍是基于 20.03 的版本，相关的软件包已经没有继续升级。

## 问题 / Issues

1. 目前 OBS 上构建 RISC-V 包的速度太慢，完整构建一次可能需要一周时间，而 x86 等架构仅需20小时左右。这导致 RISC-V 架构上包迭代速度比其它架构低一个数量级，影响包修复速度。
2. 目前存在多个未完成（状态不一致）的工程： 从21.09时期的 openEuler/Mainline 某个时间点切出来的Mainline/RISC-V、2021Q4 开始尝试追 openEuler/22.03/Next 而建立的工程。目前团队规模和修包速度无法支持多个工程同时修复。
3. 目前 OBS 服务分给个人用户的机器资源很少，RISC-V 架构修包需要排队等待验证。
4. 目前 src-openEuler/ 仓库代码合入门禁只有 x86 和 arm64，没有 RISC-V，导致 openEuler/Mainline 代码更新很容易 break 掉 RISC-V 架构。
5. 目前可用的镜像还是2003版本，仅有QEMU版本，缺乏每日构建镜像。

## 提议 / Proposal

1. （单一主线）openEuler RISC-V 放弃跟随22.03发布， 不再进行 Mainline 和 22.03/Next 双线PR； 每个代码仓进维护一个开发主线（master）。
2. （两步追赶）Mainline/RISC-V 的软件版本从 21.09 逐渐更新对标到 openEuler x86 的 22.03 版本，构建状态稳定之后转入跟进 openEuler/Mainline 工程。
3. （基础架构）openEuler RISC-V SIG 与 TARSIER 团队共同搭建 RISC-V OBS 服务，在 22Q1 具备 24 小时构建 5000+ RISC-V 软件包的能力；确保修包的伙伴提交任务后能够在 2 分钟内获得服务器资源构建；构建 workers 的算力超过 1000 vcores。
4. （releng） 在当前 openEuler RISC-V 镜像脚本基础上实现每日自动化构建，并支持 QEMU、Nezha/D1、Unmatched 三种环境。
5. （pre-CI） 搭建同时支持3种架构CI的门禁，主动监测 openEuler 所有代码仓库，在 PR 合入之前检测出是否在 RISC-V 架构上出现 regression。
6. （批量提交） openEuler RISC-V SIG 不再向 src-openEuler 零散提交PR，而是等到下一次版本发布之前统一提交。
7. （典型场景） 支持 RISC-V Lab 的 docker 应用场景；支持 Unmatched 及未来的 RISC-V 笔记本桌面场景，支持 XFce 桌面环境和 Firefox 浏览器。
8. （超前适配） openEuler RISC-V 的软件包不应低于 openEuler mainline 版本。
9. （补丁托管） 继续以 gitee/openEuler-riscv/ 为中间仓，逐步镜像所有需要 porting 的软件包。
10. （kernel策略） 目前 openEuler RISC-V 在 QEMU、D1、Unmatched 上使用的是不同的 kernel 来源。后续将进行 kernel 的统一，并直接追到 kernel upstream 的最新稳定版或rc版，以获得最新的 RISC-V 支持。

## 时间线 / Timeline

2022Q1: 完成单一主线合并、补丁集中托管、基础架构能力升级、每日镜像构建。

2022Q2: 完成所有4k+包的修复，将支持/修复范围对标到 openEuler 所有软件包。

2022Q3: 完成对 openEuler 所有代码仓库的主动 CI 监测。

## 资源 / Resources

- openEuler RISC-V SIG 负责方向及路线规划、与 openEuler 各 SIG 进行沟通协调。
- 中国科学院软件研究所 Tarsier 团队投入不少于 600 人月及必要的硬件资源。