# 常见问题

请先阅读之前的文档。

## gitee

1. **网站gitee.com/openeuler/RISC-V、gitee.com/openeuler-RISC-V和gitee.com/src-openeuler是什么关系？**

    openeuler/RISC-V就是你现在看到的，是openEuler RISC-V SIG网站，主要存放文档工具资料。
  
    src-openeuler是openEuler所有软件包的源码仓库。
  
    openeuler-RISC-V是src-openeuler的fork，也称中间仓，用于临时承载对软件包所做的RISC-V修改适配。未来这些修改适配都要合并到src-openeuler仓库。

2. **怎样fork src-openeuler的软件包？**

   在这个网站，针对[riscv_fork_list.yaml](https://gitee.com/openeuler/RISC-V/blob/master/configuration/riscv_fork_list.yaml)提出PR，增加要fork的软件包名，按字母顺序排序，并简要阐述理由。
  
3. **能不能直接向src-openeuler提交PR？**

   可以。

4. **怎样选择软件包源码分支？**

   软件包的源码分支名字指明了分支对应的发行版版本，可以根据你的目标OBS工程来选择。
   
5. **提交修包PR应注意些什么？**
   
   理由应充分，maintainer不一定熟悉所有包；有成功构建的链接；修改符合[规范](https://gitee.com/openeuler/community/blob/master/zh/contributors/packaging.md)；如果引入了上游或三方补丁，应用`git show`等命令保留原作者信息。
   
##  OBS

6. **https://build.openeuler.openatom.cn和https://build.tarsier-infra.com我应该用哪个？**

    https://build.tarsier-infra.com。

7. **构建日志信息`RPM build errors: bad date in %changelog`是错误吗？**

   不是。构建中提示的一些与RPM有关的宏、.spec书写规范类错误，不影响软件包的正常构建。
  
8. **失败日志最后显示的错误是失败的直接原因吗？**

   一般不是。构建通常并行进行，也有的错误延后传导，因此最后看到的往往不是失败的直接原因。
  
9. **能查看一个软件包前几次的构建日志吗？**

   不能。
  
10. **想查看构建日志但blocked了怎么办？**

    在这个工程里找一个能查看的软件包，比如：https://build.tarsier-infra.com/build/openEuler:22.03/openEuler_2203_self/riscv64/gcc/_log，把软件包名改成你关心的。
  
11. **提示网络访问错误怎么处理？**

    默认OBS上的软件包以qemu-user模式构建（docker下），这时不能访问网络，也不能访问/proc/类的文件。可以调整成qemu-system模式：在软件包增加一个_constraints文件（上传），内容
```
<constraints>
  <sandbox>qemu</sandbox>
</constraints>
```

12. **软件包总是显示blocked构建不了怎么办？**

    编辑这个软件包所在工程的`Meta`标签页，在`repository name=`行，增加`rebuild="local" block="never" linkedbuild="off"`。
  
13. **`Meta`标签页还有啥有用的东西？**

    `<publish> <enable|disable/> </publish>`可以控制软件包是否发布到下载站，`<build> <enable|disable/> </build>`可以控制软件包是否构建。工程的Meta控制的是整个工程的所有软件包，软件包的Meta控制的是这个软件包本身。工程的Meta标签页`repository name=`行下有`path project=`，是工程的依赖，即工程需要的构建依赖包从哪里来。
  
14. **OBS的下载站在哪儿？**

    http://obs-backend.tarsier-infra.com:82/
  
15. **软件包的_link文件是否可以删除？**

    可以。
  
16. **工程的`Project Config`标签有什么用？**

    用处非常大，也是比较高级的应用，等你熟练后可以找一个工程看看，[文档链接](https://openbuildservice.org/help/manuals/obs-user-guide/cha.obs.prjconfig.html)。

  
17. **日志提示`Job seems to be stuck here, killed. (after 28800 seconds of inactivity)`怎么办？**

    构建过程超过28800秒没有任何输出时，OBS会认为软件包已卡死了，然后kill掉构建。如果你认为不是卡死了，而仅仅是慢，可以编辑工程的`Project Config`标签页，增加如下代码解决%build阶段的假死问题，相应的%check阶段用__spec_check_pre：
```
Macros:
%__spec_build_pre	%{___build_pre} \
  case %{name} in \
    软件包名) \
      function keepalive() { while true; do sleep 28000; date; done } \
      keepalive & ;; \
  esac
:Macros
```

18. **构建时下载网络组件总是失败怎么办？**

    手工下载，作为补丁进行修包处理。
  
19. **怎样让自己构建成功的包参与别的包构建？**

    首先，编辑成功包的`Repositories`标签页，勾选`Use for Build Flag`，这是默认设置。然后，将成功包所在的工程，加入到目标工程的依赖里，并放在原有依赖的前面，见上面关于`Meta`标签页的描述；如果成功包和目标包在一个工程里，则不需要这一步。
  
20. **怎样发布自己构建成功的包？**

    编辑软件包的`Repositories`标签页，勾选`Publish Flag`。

## 本地QEMU构建环境

21. **什么是QEMU构建环境？**

    指RISC-V QEMU虚拟机里，另外一个虚拟环境，存放在/var/tmp/build-root/目录下。`osc build`命令初始化这个环境，并在其中构建软件包。
  
22. **怎么查看构建日志？**

    在checkout出的软件包目录下，执行`osc lbl|less`。为防止后续的构建冲掉日志，可以将其另存起来。
  
23. **失败日志最后的`error: Bad exit status from /var/tmp/rpm-tmp.kp0vhP (%build)`指示了什么？**

    指示出在构建环境里，%build阶段，执行/var/tmp/rpm-tmp.kp0vhP脚本出错了。整个构建过程分为%prep、%build、%install、%check等分立的阶段，每个阶段有一个shell脚本，执行这个阶段的所有任务，各个脚本分别对应着软件包spec文件中的有关描述。查看这个脚本可以了解构建设置了什么环境、宏怎么展开的、执行了哪些具体命令。
  
24. **构建过程中要访问网络怎么办？**

    构建前，将/etc/resolv.conf拷贝到构建环境中的/etc目录下。
  
25. **怎么手工进入构建环境？**

    `chroot /var/tmp/build-root/xx工程`
  
26. **构建环境里手动运行java说找不到动态库怎么办？**

    一些程序运行时要访问/proc，可以在手工chroot进构建环境前，执行`mount --bind /proc /var/tmp/build-root/xx工程/proc`。记得退出后，及时umount。
  
27. **在构建环境里怎样重新运行出错命令？**

    方法一：找到并重新执行出错的具体命令。因为环境设置原因，这个命令不一定能正常运行。
  
    方法二：运行对应的/var/tmp/rpm-tmp.xxx脚本。当然你事先可以编辑这个脚本的内容。这是比较可靠的方法。
  
    方法三：用`osc build --stage=xx`重新运行指定的构建阶段，具体请查看osc和rpmbuild的帮助。只运行单独阶段并不一定都可行，如%check，因为可能缺少前面阶段输出的文件。
  
28. **重复构建时能不能跳过依赖包的下载安装？**

    可以，用`osc build --noinit`。
  
29. **多次构建后出现一些莫名其妙的问题咋办？**

    删除构建环境及包缓存试试：`rm -rf /var/tmp/{build-root,osbuild-packagecache}`。
  
30. **怎样在构建环境里安装依赖包？**

    最好在OBS工程上解决好依赖，由osc自动处理依赖包安装。如果确实需要，也可以手工下载rpm包，chroot进构建环境后用`rpm -i`安装。这比较麻烦，且在构建时要加上--noinit参数以防止手工安装的包被自动删除。
  
## 其它

31. **修包一般思路是什么？**

    - 优先选择自己熟悉的编程语言和软件包
    - 分析日志
    - 排除依赖问题
    - 对比x86_64、aarch64的成功日志
    - 查询软件包上游的更新
    - 查看友邻的解决方案
    - 搜索WEB
    - debug源码

32. **超时等环境配置、性能引起的失败怎么处理？**

    不需要修包，通知maintainer即可。

33. **不想修包只想升级可以吗？**

    可以。OBS的Factory:RISC-V...工程专门用于软件包的滚动升级；中间仓的roll分支用于承载升级源码，可在向本仓库提交申请PR时注明升级需求，由maintainer创建roll分支；PR除一般要求外，还要对API接口变更做简要评估，以便maintainer掌握可能的兼容性问题。

34. **可不可以引入新的软件包？**

    可以，需要一点点理由。具体操作可以提issue或咨询SIG。
	
35. **我可不可以象其它发行版那样申请成为maintainer？**

    欢迎！期望你能使申请的包持续保持良好状态。
	
36. **除了修包还有什么参与方式？**

    只要有利于openEuler RISC-V发展的都可以，比如：清理完善文档、系统使用报告、设计应用项目等。
