### 脚本使用说明

#### 1. 功能

自动生成openEuler RISC-V QEMU镜像

#### 2. 文件说明

oe-rv.repo: yum源配置文件。每次脚本执行，都会自动从gitee上获取该文件，将其作为新镜像的yum源

pkg.list: 新镜像预安装的包。每次脚本执行，都会自动从gitee上获取该文件，并根据文件中列出的包进行安装

make_rootfs_oe.sh: 自动生成镜像的脚本

#### 2. 使用方法

1）启动openEuler RISC-V QEMU镜像，在当前目录下(/root)执行脚本。脚本执行完成后会在脚本同一目录下生成。

2）脚本执行完成后，会在脚本同一目录下生成新镜像(oe-rv.raw)和安装包过程的log(pkginstall_log.txt)

