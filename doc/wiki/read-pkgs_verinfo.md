## 软件包工具-版本和构建状态获取

为了更好的了解源代码版本（master、openEuler-22.03-LTS、openEuler-22.03-LTS-Next）、obs构建工程（引用的源代码分支、版本、包构建状态、是否曾经构建成功生成了二进制rpm包、包release版本）信息，帮助梳理清楚哪些包需要被修复，PLCT开发了工具：https://github.com/isrc-cas/tarsier-oerv/tree/main/scripts/src-openEuler_VerInfo 来梳理以上信息, 其结果可在[网站](https://mirror.iscas.ac.cn/openeuler-sig-riscv/forobs/)被找到。



### 工具开发的背景

在openeuler 2203发行版的时间背景下，上游openeuler 2203诸多软件包版本是在不停更新的，但是这个更新信息并未主动（或者比较方便）的让riscv sig同步了解。obs工程引用的源代码版本是应该不断更新的，为了更好的了解源码仓src-openeuler中软件包版本更新情况，引导riscv更有针对性的修包，因此开发了脚本工具来获取信息。

### 获取结果文件

使用工具的方法详见[工具使用指南](https://github.com/isrc-cas/tarsier-oerv/blob/main/scripts/src-openEuler_VerInfo/README.md) 

由于数据量较大，脚本运行一次时间可能超过4小时，我们会定期运行，并将运行结果放到[网站](https://mirror.iscas.ac.cn/openeuler-sig-riscv/forobs/) ，因此不需要大家去运行工具。



### 如何阅读统计结果文件

- No. : 序号

- Package: 包名（obs工程中的包名）

- obs_repository: obs service文件中的gitee address

- obs_commit_id: obs service文件中的gitee commit id；**Lastest Update字段中对应值0。**

- obs_status: 包在库中的当前状态

- gitee_master: 源码仓src-openeuler中master分支最新的commit id；**Lastest Update字段中对应值1。**

- gitee_openEuler-22.03-LTS: 源码仓src-openeuler中openEuler-22.03-LTS分支最新的commit id；**Lastest Update字段中对应值2。**

- gitee_openEuler-22.03-LTS-Next: 源码仓src-openeuler中openEuler-22.03-LTS-Next分支最新的commit id；**Lastest Update字段中对应值3。**

- Lastest Update: 在obs和源码仓src-openeuler的3个分支（master、openEuler-22.03-LTS、openEuler-22.03-LTS-Next）中时间最新的commit（按照commitid对应的时间判定）

  - 0：代表obs最新；
  - 1：代表源码仓src-openeuler中master分支最新；
  - 2：代表源码仓src-openeuler中openEuler-22.03-LTS分支最新；
  - 3：代表源码仓src-openeuler中openEuler-22.03-LTS-Next分支最新；

- Upgrade Priority: obs和源码仓src-openeuler的3个分支最新的不重复的commit id的个数。
  
  - 4：表示上述4个commitid均不一致。这种情况需要对obs工程软件包版本进行分析和梳理。
  
    - 为什么obs版本没有使用gitee3个版本中的任何一个？是否代码使用的openeuler-risc-v中间仓？
  
    - 升级到什么版本？
  
      > 为了2203发版，我们采用near 2203::LTS 的版本（长远来说用最新代码）；
      >
      > 
      >
      > 按照master——>21.09——>2203:LTS:Next——>2203:LTS的拉取顺序，原则上2203:LTS版本较新。master作为开发分支，一直合入所有创新版本的更新；详见[openEuler版本分支维护规范](https://gitee.com/openeuler/release-management/blob/master/openEuler%E7%89%88%E6%9C%AC%E5%88%86%E6%94%AF%E7%BB%B4%E6%8A%A4%E8%A7%84%E8%8C%83.md)
      >
      > 
      >
      > **注意：Lastest Update的最新commit分支只是从时间上判定的，但是不同的分支代码可以是分别更新的，需要开发者去了解下每个分支的变化差异**
  
    - 为什么修包优先级高？
  
      > 4表示4个版本信息都不一致，说明版本更新的频率快。一般重要的包，基础的包维护活跃度高；
  
  - 2和3：表示上述4个commitid版本存在不一致。**需要去对照每个分支的commitid进行对比哪几个不同**，然后分析：
  
    - obs版本是否需要升级？
  
    - 升级到什么版本？
  
      > 为了2203发版，我们采用near 2203::LTS 的版本（长远来说用最新代码）；
  
  - 1：表示上述4个commitid版本全部一致。gitee3个分支代码一样，obs工程使用的是gitee最新的源码；obs工程软件包版本无需升级；
  
- has rpm history: 在库中是否有曾经编译成功的rpm包

- rpm version: 在库中编译成功的源码包名


