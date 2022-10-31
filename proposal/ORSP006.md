# ORSP006 为 openEuler RISC-V 增加「准备仓」

## Meta info

提议者：吴伟、王俊强

时间：2022-10-20

## 背景 / Background

随着 openEuler RISC-V 的发展和成熟，除了有大量的补丁需要在 openEuler 上千个仓库中评审合并之外，也逐渐有了更多的包需要被引入到 src-openEuler 中使用。而目前 openEuler RISC-V 的「中间仓」仅能够从 src-openEuler 中fork出来已有的仓库，对于尚未添加的仓库，需要有一个非个人的组织仓库进行存放和协作。

## 问题 / Issues

如上。

## 提议 / Proposal

1. 建立「准备仓」概念，用于指代已经向 src-oe 提交、暂时未被接收的仓库。
2. 由中科院软件所智能软件中心的gitee账号提供准备仓托管服务，目录暂定为「src-oerv」。
3. 准备仓中的仓库被 src-oe 接收之后，进行存档（archive）。
4. openEuler RISC-V maintainers 对准备仓进行创建、合并、升级、存档管理。

## 时间线 / Timeline

202211: 完成准备仓的服务准备。

## 资源 / Resources

- openEuler RISC-V SIG 负责方向及路线规划、与 openEuler 各 SIG 进行沟通协调。
- 中国科学院软件研究所智能软件研究中心提供gitee支持。
