如何知道哪些包需要被修复呢？这是一个信息量有点大的工程，对于刚刚入门的小伙伴来说，这里给出一些建议：

1. 在[pkgs_verinfo文档](https://docs.qq.com/sheet/DUGNPekJQY1RLQ3RG?tab=BB08J2 )的`实习生-修包清单整理`页中，找到一个`[状态]` 为“任务待认领”的包，并将 `[状态]` 更新为正确的状态。
   - 为了避免多人同时修复同一个包，请大家及时标记状态。
   - 包的 `[状态]` 可以在各种状态切换。即标记为 “预调阶段” 或“修包阶段”的包，如果发现无法修复，还能重新标记为“任务待认领”；但是你的任何分析过程都有意义，即使最终无法修复，在分析过程中了解的信息都可以备注到各阶段对应的“修包阶段问题与说明”中，供他人参考（注:表格中不容易记录的，可以在RISC-V仓库中创建issue，表格中给出issue链接地址）。


2. 预调阶段：

   正式fork仓库之前的任何个人分析、验证都可视为预调阶段的内容。

   这个阶段的特点是，大家很难知道谁在看哪个包，这里会造成大量的“交叉”，因此建议大家及时的 "占坑"，但是发现“坑自己填不上”的时候，要及时把“坑”让出来。

   在预调阶段，大部分情况，我们需要从obs mainline:RISC-V上将软件包branch到个人obs工程中（obs注册 和 obs使用入门），更新配置并验证构建状态；参考[修包工作流程]( https://gitee.com/openeuler/RISC-V/blob/master/doc/tutorials/workflow-for-build-a-package.md)

   

   

3. 修包阶段：

   操作参考[修包工作流程]( https://gitee.com/openeuler/RISC-V/blob/master/doc/tutorials/workflow-for-build-a-package.md) 文档。

   
   在[pkgs_verinfo](https://docs.qq.com/sheet/DUGNPekJQY1RLQ3RG?tab=BB08J2 )文档其它标签页中，我们提供了更多的信息帮助了解包的情况，可以参考[如何阅读pkgs_verinfo文档](./read-pkgs_verinfo.md)

4. 验证阶段：

   验证即为当gitee仓库的代码更新后，将个人obs工程的软件包版本升级到新版本，然后验证新代码构建状态的过程。

   验证成功的，需要提交submit，将个人工程软件包的信息提交到obs mainline:RISC-V工程。


5. 复盘阶段：

   主要由maintainer完成，对各种问题和信息进行整合，判断。对于在obs mainline:RISC-V工程构建失败的包进行分析和后续安排。