### 中间仓管理方法及工具

为理顺中间仓PR管理，解决中间仓未合入src-openEuler前，PR与src-openEuler升级之间的冲突问题，可采取如下方法管理中间仓。

#### 1. 中间仓版本分支与OBS工程尽量一一对应

比如，OBS openEuler:2203工程，对应openEuler-22.03-LTS分支。

#### 2. 中间仓版本分支不存在时

新fork产生的中间仓必然含有当前OBS工程对应的版本分支，因此这种情况针对的是中间仓fork上游时间较早的情况。

由maintainer通过WEB或CLI方式，手动增加中间仓分支。CLI方式可参考如下脚本：
```
#!/bin/bash

if [ $# != 2 ]; then
    echo "Usage: $0 package-name branch-name"
    exit 1
fi

git clone git@gitee.com:openeuler-risc-v/$1.git
cd $1
git fetch git@gitee.com:src-openeuler/$1 $2:$2
git checkout $2
git push --set-upstream origin $2
```

#### 3. 中间仓版本分支已存在且已有合入的针对RISC-V的PR时

当不需要同步src-openEuler新的提交时，按正常PR流程处理。

否则，需要maintainer进行手动干预。这种情况一般出现于src-openEuler的版本分支进行了代码升级，以解决构建或运行问题。手动干预的原则是，确保针对RISC-V的补丁位于commit序列的最后，以保证源码演进的正确性，有利于将来中间仓合入src-openEuler。操作方法只能通过CLI方式本地处理，可参考如下脚本：
```
#!/bin/bash

if [ $# != 2 ]; then
    echo "Usage: $0 package-name branch-name"
    exit 1
fi

git clone git@gitee.com:openeuler-risc-v/$1.git -b $2
cd $1

# 备份原有分支
git branch -c deprecated-by-rebase-`date +%Y%m%d-%H%M%S`

# 去除最后一个合入的PR，该PR即已有的针对RISC-V的补丁。如果不去除，同步
# src-openEuler新的提交后，它将位于源码演进的中间，破坏了源码的正确性。
# 此类PR有多个时，需调整命令的参数
git reset --hard HEAD^

# 同步src-openEuler相应分支的最新提交
git pull git@gitee.com:src-openeuler/$1 $2

# 强制同步中间仓
git push --force
```
这样操作后，中间仓相应分支rebase为“干净的”、最新的src-openEuler代码。因此，需协调committer在此分支基础上，重新应用原有补丁，并增加新的PR内容。

#### 4. 版本滚动更新

这里版本滚动更新是指超越src-openEuler的版本进行的更新升级，不包含为解决RISC-V上构建问题而进行的版本升级。

由maintainer根据合适的代码分支，创建roll分支，专门承载滚动更新代码。
