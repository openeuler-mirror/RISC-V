### 脚本使用说明

#### 1. 功能

自动生成 openEuler RISC-V QEMU 镜像

#### 2. 文件说明

`oe-rv.repo`: yum 源配置文件。每次脚本执行，都会自动从 Gitee 上获取该文件，将其作为新镜像的 yum 源

`pkg.list`: 新镜像预安装的包。每次脚本执行，都会自动从 Gitee 上获取该文件，并根据文件中列出的包进行安装

`make_rootfs_oe.sh`: 在 openEuler RISC-V QEMU 中自动生成镜像的脚本

`make_rootfs_oe_docker.sh`: 在 openEuler RISC-V docker container 中自动生成镜像的脚本

#### 2. 使用方法

##### 2.1 make_rootfs_oe.sh 使用方法

1）启动 openEuler RISC-V QEMU 镜像，在当前目录下 (`/root`) 执行脚本。脚本执行完成后会在脚本同一目录下生成。

2）脚本执行完成后，会在脚本同一目录下生成新镜像 (`oe-rv.raw`)，文件系统压缩包 (`oe-rv.tar.gz`) 和包安装过程的 log (`pkginstall_log.txt`)

3）所生成镜像登录的用户名/密码：`root`/`openEuler12#$`

##### 2.2 make_rootfs_oe_docker.sh 使用方法

1）如若在 x86 宿主机上运行 openEuler RISC-V 的 docker container，需要先执行以下步骤：

```bash
sudo apt install --no-install-recommends qemu-user-static binfmt-support

update-binfmts --enable qemu-riscv64

update-binfmts --display qemu-riscv64

sudo chmod a+x /usr/bin/qemu-*
```

2）执行 `docker run -itd --privileged --name oe-rv geasscore/openeuler-riscv64:20.03 /bin/bash` 启动 openEuler RISC-V docker container

3）脚本执行完成后，会在脚本同一目录下生成新镜像 (`oe-rv.raw`)，新镜像的压缩包 (`oe-rv.raw.tar.zst`)，文件系统压缩包 (`oe-rv.tar.gz`)，kernel 镜像 (`boot` 目录) 和包安装过程的 log (`pkginstall_log.txt`)

4）所生成镜像登录的用户名/密码：`root`/`openEuler12#$`
