# Cinnamon使用手册

## 软件说明

Cinnamon 是运行在类 Unix 操作系统中最常用的桌面环境，也是一个功能完善、操作简单、界面友好、集使用和开发为一身的桌面环境，还是 GNU 计划的正式桌面。最初是 GNOME Shell 的一个派生版本，由 Linux Mint 开发，提供了相似于 Gnome 2，易于使用的传统用户界面，从 Cinnamon 2.0 开始，成为独立的桌面环境。

官方网站：https://projects.linuxmint.com/cinnamon/

## 环境配置

- 操作系统版本: openEuler 23.03 riscv64
- vcpu: 8
- memory: 8G
- 镜像: https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/testing/20230322/v0.1/QEMU/openEuler-23.02-V1-base-qemu-testing.qcow2.zst

## 安装方法

1. 配置源并更新系统 下载 openEuler ISO镜像并安装系统，更新软件源
```bash
sudo dnf update
```
2. 安装字库
```bash
sudo dnf install dejavu-fonts liberation-fonts gnu-*-fonts google-*-fonts
```
3. 安装必要的xorg相关包。
```bash
sudo dnf install xorg-x11-apps xorg-x11-drivers xorg-x11-drv-ati \
	xorg-x11-drv-dummy xorg-x11-drv-evdev xorg-x11-drv-fbdev xorg-x11-drv-intel \
	xorg-x11-drv-libinput xorg-x11-drv-nouveau xorg-x11-drv-qxl \
	xorg-x11-drv-synaptics-legacy xorg-x11-drv-v4l xorg-x11-drv-vesa \
	xorg-x11-drv-vmware xorg-x11-drv-wacom xorg-x11-fonts xorg-x11-fonts-others \
	xorg-x11-font-utils xorg-x11-server xorg-x11-server-utils xorg-x11-server-Xephyr \
	xorg-x11-server-Xspice xorg-x11-util-macros xorg-x11-utils xorg-x11-xauth \
	xorg-x11-xbitmaps xorg-x11-xinit xorg-x11-xkb-utils
```
这里需要注意的是，在 openEuler 官方安装文档中，有 xorg-x11-drv-intel xorg-x11-drv-vesa xorg-x11-drv-vmware 这三个包，不过我们这里不需要。

4. 安装Cinnamon及组件
```bash
sudo dnf install cinnamon cinnamon-control-center cinnamon-desktop \
	cinnamon-menus cinnamon-screensaver cinnamon-session \
	cinnamon-settings-daemon  cinnamon-themes cjs \
	nemo nemo-extensions  muffin cinnamon-translations inxi \
	perl-XML-Dumper xapps mint-x-icons mint-y-icons mintlocale \
	python3-plum-py caribou mozjs78 python3-pam \
	python3-tinycss2 python3-xapp tint2 gnome-terminal \
	lightdm lightdm-gtk
```
5. 开机自动启动登录管理器
```bash
sudo systemctl enable lightdm
```
6. 设置系统默认以图形界面登录
```bash
sudo systemctl set-default graphical.target
```
7. 重启验证
```bash
sudo reboot
```

## 参考资料
https://projects.linuxmint.com/cinnamon/
https://docs.openeuler.org/zh/docs/22.09/docs/desktop/Install_Cinnamon.html















