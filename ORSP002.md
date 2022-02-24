# ORSP001 openEuler RISC-V SIG Proposal 002

## Meta info

提议者：吴伟

时间：2022-02-24

## 背景 / Background

目前 openEuler RISC-V 还不是 openEuler 社区官方支持的架构，并且还没有形成一个可以给普通用户每日测试使用的成熟度。openEuler 社区各个仓库 maintainers 的响应时间不同、对 RISC-V 的了解程度、支持程度不同，更重要的是目前 RISC-V 生态中的软件支持需要部分临时绕过或临时修复patch，使得回合周期非常长，长到可能会影响到 openEuler RISC-V 的修包速度。通过对其它发行版（debian、fedora）等的观测，都是需要先作为一个 side project / ports 来进行修包和维护，从效率角度出发，先建立一个完整可测试的基本系统。再花长短不一的时间合回发行版的主线。

## 问题 / Issues

1. 目前 openEuler RISC-V 修包速度远远超过 openEuler 社区 review 速度。过去3个月尝试直接将 RISC-V 的 patch 合回 openEuler 主线，但是如背景中所言，以及赶上2203发版，很快就意识到实际操作上变得不可行。
2. openEuler 目前没有 RISC-V 门禁，任何仓库的新的提交都有可能 break 掉 RISC-V 架构。需要有人长期维护。src-oe 就包含了超过8000个仓库，需要一个更大的维护团队和测试团队。

## 提议 / Proposal

1. 逐步建立 repo watcher 角色，本质上属于 RISC-V 架构上的 shadow maintainer。
2. 每个 repo / pkg 设定1-3个 maintainer、1-3个 tester，确保所有的包都得到最低程度的关爱。
3. maintainer/tester 在2022H1由 openEuler RISC-V SIG 成员（张旭舟、席静、王俊强、吕晓倩、吴伟）确定。2022H2开始考虑在SIG下成立更加社区化的一个 RISC-V (shadow) maintainer (steering) committee (RMC) 进行维护者和测试者的增补和替换。
4. 参考 debian 和 fedora 等发行版的管理，将仓库/包进行分组。例如 Rust 语言、Python 语言、Nodejs/npm 都自然形成了不同的组。
5. 相关权责信息在 gitee/openEuler/RISC-V 仓库中进行维护。
6. RMC 的日常会议在2022H1随 openEuler RISC-V SIG 双周会进行

## 时间线 / Timeline

2022Q1: 完成目前正在修复和完成修复的包的维护者选择和机制/流程创建（吴伟）。

2022Q2: 完成所有4k+包的维护者组织，将支持/修复范围对标到 openEuler 所有软件包。

2022Q3: 完成对 openEuler 所有代码仓库的 RISC-V shadow maintain，主动 CI 监测。

## 资源 / Resources

- openEuler RISC-V SIG 负责方向及路线规划、与 openEuler 各 SIG 进行沟通协调。
- 中国科学院软件研究所 Tarsier 团队投入不少于 600 人月及必要的硬件资源。
