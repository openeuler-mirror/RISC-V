# ORSP005 openEuler RISC-V 测试规范

## Meta info

提议者：罗云翔，席静

时间：2022-06-16

## 背景 / Background

随着openEuler RISC-V发行版操作系统（以下简称openEuler RISC-V）大量软件包移植的完成，需要测试验证后提供给用户使用。openEuler RISC-V发版流程的确立（ORSP004）保障了缺陷的可追溯和可复现性，为测试和缺陷修复提供了条件。目前急需定义测试规范，解决openEuler RISC-V测什么，谁来测，如何测，何时测和如何管控缺陷修复的问题。

## 问题 / Issues

1. 测什么？openEuler RISC-V 目前已发布开发版本较少，且只面向 QEMU 一个构建对象，缺乏可以实用的系统版本镜像和源。因此当前测试的重点是验证系统镜像和源的基本可用性，即是否可以正常安装必要软件，系统和必要软件基本功能是否正常。如何界定什么是系统基本功能，哪些是必要软件是需要解决的问题。
2. 谁来测？当前openEuler RISC-V专职测试和移植开发人员数目少，社区众测人员能力不一。如何根据实际条件，合理进行任务分配，达到测试目标。
3. 怎么测？合理使用自动化测试工具和openEuler上游社区的测试用例可提高测试效率。
4. 何时测？当前的测试重点是验证openEuler RISC-V系统镜像和源的基本可用性；当此目标达到后，逐步对适合RISC-V环境的openEuler特性软件进行测试；进一步对系统的健壮性、稳定性、效率和安全性进行测试。
5. 如何管控缺陷修复？测试发现的缺陷反馈给开发人员进行修复，如何管控缺陷的修复，需要相关规范。

## 提议 / Proposal

1. openEuler RISC-V SIG 与 TARSIER 团队根据使用需要共同定义openEuler RISC-V的系统镜像和源的基本可用性（包括哪些软件包和功能）
2. 参照openEuler上游社区和其他发行版RISC-V ISA移植测试的实行方式，openEuler RISC-V 界定开发人员、测试人员和社区众测的工作内容，定义入口和出口。
3. 借鉴openEuler上游社区适合实现openEuler RISC-V当前测试目标的自动化测试工具和测试用例，定义不同阶段的测试方法。
4. 定义“何时测”不同阶段的评估标准。
5. 定义缺陷修复的规范。
6. 定义QEMU、Allwinner Nezha/D1、HiFive Unmatched 和 VisionFive V1 四个对象的测试规范

## 时间线 / Timeline

2022-06-20: [定义openEuler RISC-V的系统镜像和源的基本可用性](./ORSP005/openEulerRISC-V的系统镜像和源的基本可用性定义.md)

2022-06-30: [界定开发人员、测试人员和社区众测的工作内容，定义入口和出口](./ORSP005/openEulerRISC-V测试角色.md)

2022-07-10: 定义不同阶段的测试方法，过滤适合openEuler RISC-V当前测试任务的openEuler测试工具和测试用例（文档和相关文件）

2022-07-20: 定义缺陷修复的规范（文档）


## 资源 / Resources

- openEuler RISC-V SIG 负责方向及路线规划、与 openEuler 各 SIG 进行沟通协调。

- 中国科学院软件研究所 Tarsier 团队投入不少于 600 人月及必要的硬件资源。
