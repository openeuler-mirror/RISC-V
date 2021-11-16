# Version Info
继openEuler之前所发布的RISC-V preview版镜像之后，openEuler 22.03 LTS RISC-V 是openEuler 基于5.10内核的首个长周期LTS版本（参见[版本生命周期](https://www.openeuler.org/zh/other/lifecycle/)）。

计划在本版本中，面向RISC-V的商用场景和广大社区使用者，提供标准镜像，精简镜像和容器镜像等，并且支持界面，容器，BishengJDK，安全等功能。

现启动版本需求收集，欢迎各sig maintainer和社区开发者们积极反馈和交流。<br />
<br />
需求反馈基本流程： <br />
1、在issue板块发布issue，描述需求详细信息，主要包括场景，内容，交付件，目标，验证方式等内容。<br />
2、在本贴的Feature表格中按照格式要求，写入22.03-LTS RISC-V的需求/特性，并关联相关的需求issue，此时状态为*Discussion*。 <br />
3、在RISC-V SIG的双周例会上评审需求，若同意接受，则状态改为*Developing*。<br />
4、开发、验证完成之后，状态改为*Accepted*，作为版本特性，跟随openEuler 22.03 LTS RISC-V 共同发布。<br />

# Release Plan


| Stage  name          | Begin time | End time   | Days | Note                                      |
| -------------------- | ---------- | ---------- | ---- | ----------------------------------------- |
| Collect key features | 2021/11/1  | 2021/12/30 | 60   | 版本需求收集                              |
| Develop              | 2021/11/8  | 2022/2/7   | 90   | 特性完成开发和自验证，代码提交合入Master    |
| Kernel freezing      | 2022/1/25  | 2022/1/30  | 5    | 内核冻结                                  |
| Branch               | 2022/2/7   | 2022/2/7   | 1    | 拉版本分支：Master -> 22.03 LTS-Next -> 22.03 LTS |
| Build & Alpha        | 2022/2/7   | 2022/2/11  | 5    | 版本DailyBuild  & 开发自验证              |
| Test round 1         | 2022/2/14 | 2022/2/18 | 5    | 版本启动测试                              |
| Beta Version release | 2022/2/21 | 2022/2/23 | 3    | Beta版本发布                              |
| Test round 2         | 2022/2/22 | 2022/2/25 | 5    |                                           |
| Test round 3         | 2022/2/28 | 2022/3/4  | 5    |                                           |
| Test round 4         | 2022/3/7  | 2022/3/11 | 5    |                                           |
| Test round 5         | 2022/3/15 | 2022/3/17 | 3    |                                           |
| Release              | 2022/3/30 | 2022/3/30 | 1    |                                           |


# Feature list
#### 状态说明：
- Discussion(方案讨论，需求未接受)
- Developing(开发中)
- Testing(测试中)
- Accepted(已验收)

|no|feature|status|sig|owner|
|:----|:---|:---|:--|:----|
|[I40OKN](https://gitee.com/openeuler/RISC-V/issues/I40OKN)|镜像支持硬件平台部署|Developing|RISC-V|[@xuzhou zhang](https://gitee.com/whoisxxx), [@xijing](https://gitee.com/xijing666)|


