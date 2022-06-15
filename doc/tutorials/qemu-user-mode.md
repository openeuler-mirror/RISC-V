# 基于 systemd-nspawn 和 QEMU User Mode 搭建 openEuler RISC-V 软件包的快速开发环境
## 一 准备 osc build 构建环境
### openSUSE
下载 osc 构建工具
```shell
sudo zypper in osc -y
```
### Arch Linux
添加 AUR 源，并且下载 osc 构建工具
```shell
yay -S osc-git obs-build-git
``` 
### 其他发行版
基于 python3 环境的源码构建
#### osc
```shell
git clone https://github.com/openSUSE/osc.git
cd osc
chmod +x setup.py
./setup.py build
sudo ./setup.py install
```
在 `~/.bashrc` 添加一行
```
alias osc="osc-wrapper.py"  
```
#### obs-build
```shell
git clone https://github.com/openSUSE/obs-build.git
cd obs-build
sudo make install
```

> 如何进行基础的 OBS 工程本地构建请参考: 
> - [`~/.oscrc` 配置文件](https://gitee.com/zxs-un/openEuler-port2riscv64/blob/master/doc/build-osc-config-oscrc.md#oscrc%E9%85%8D%E7%BD%AE%E6%96%87%E4%BB%B6)
> - [使用 osc build 在本地构建 openEuler OBS 服务端的内容](https://gitee.com/zxs-un/openEuler-port2riscv64/blob/master/doc/build-osc-obs-service.md)
> - [本地 osc 结合 git 在 openEuler OBS 与 gitee 上进行开发与测试](https://gitee.com/zxs-un/openEuler-port2riscv64/blob/master/doc/build-obs-osc-gitignore.md)

## 二 安装 systemd-nspawn & QEMU User Mode 环境
### 编译 QEMU User Mode
需要先安装好 `glibc-static` `pcre-static` `glib2-static` `zlib-static` 依赖包
```shell
git clone https://github.com/qemu/qemu.git
cd qemu
./configure \
  --static \
  --enable-attr \
  --enable-tcg \
  --enable-linux-user \
  --target-list=riscv64-linux-user \
  --without-default-devices \
  --without-default-features \
  --disable-install-blobs \
  --disable-debug-info \
  --disable-debug-tcg \
  --disable-debug-mutex
make -j$(nproc)
sudo make install
```
### 在 QEMU 源码目录下安装启动 systemd-nspawn
```shell
sudo ./scripts/qemu-binfmt-conf.sh --persistent yes --credential yes --systemd riscv64
sudo systemctl restart systemd-binfmt 
```
### 其他发行版 (Debian/Ubuntu)
```shell
sudo apt install zstd systemd-container
```
## 三 构建 openEuler RISC-V 软件包

`osc build` 命令添加 `–-vm-type=nspawn` 即可
```shell
osc build standard_riscv64 riscv64 --vm-type=nspawn
```
如果如下错误
```shell
[   37s] [1/346] /.build/init_buildsystem: line 1032: perl: command not found
```
在项目 `project config` 中添加对应包即可，如: `Preinstall: perl`
## 参考链接
- https://blog.jiejiss.com/Setup-an-Arch-Linux-RISC-V-Development-Environment/
- https://wiki.archlinux.org/title/Systemd-nspawn
- https://openeuler.riscv.club/wiki/tmp/qemu-static
- https://gitee.com/zxs-un/openEuler-port2riscv64/blob/master/doc/build-osc-config-oscrc.md
- https://gitee.com/openeuler/RISC-V/blob/master/doc/tutorials/workflow-for-build-a-package.md