# GNOME使用手册

## 软件说明

GNOME 是运行在类 Unix 操作系统中最常用桌面环境。是一个功能完善、操作简单，界面友好，集使用和开发为一身的桌面环境，是 GNU 计划的正式桌面。

从用户的角度看，GNOME 是一个集成桌面环境和应用程序的套件。从开发者的角度看，它是一个应用程序开发框架(由数目众多的实用函数库组成)。即使用户不运行 GNOME 桌面环境，用 GNOME 编写的应用程序也可以正常运行。

GNOME 既包含文件管理器，应用商店，文本编辑器等基础软件，也包含系统采样分析，系统日志，软件工程 IDE，web 浏览器，简洁虚拟机监视器，开发者文档浏览器等高级应用和工具。

## 环境配置

- 操作系统版本：openEuler-23.02 v1
- QEMU: 7.2.0
- vcpu: 8
- memory: 16GB

安装方法

## 准备工作

- 安装 QEMU

  从系统软件仓库或自行编译安装支持视频输出的 QEMU

- 准备系统镜像

  本文档使用的系统镜像版本是 [openEuler-23.02-V1-base-qemu-testing.qcow2.zst](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/testing/20230322/v0.1/QEMU/openEuler-23.02-V1-base-qemu-testing.qcow2.zst)，可在[中科院软件所镜像站](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/testing/20230322/v0.1/QEMU/)下载。

  需要用到以下文件

  1. `openEuler-23.02-V1-base-qemu-testing.qcow2.zst` 不带桌面环境的基础系统镜像。
  2. `fw_payload_oe_uboot_2304.bin` 启动用内核
  3. `start_vm.sh` 和 `start_vm_xfce.sh` 启动脚本

## 启动并登入虚拟机

将上述准备文件存放到统一目录，并进入该目录。执行以下命令

```shell
# 解压得到镜像磁盘文件
zstd -d openEuler-23.02-V1-base-qemu-testing.qcow2.zst
# 为启动脚本添加可执行权限
chmod +x start_vm.sh
# 执行启动脚本，启动虚拟机
./start_vm.sh
```

虚拟机启动时检查终端输出，注意是否有错误信息，待系统启动后可以使用以下命令从 ssh 登录虚拟机，具体端口号可参考启动脚本内容或启动时终端输出。

```shell
ssh root@127.0.0.1 -p12055
```

> 默认 `root` 用户密码为 `openEuler12#$`

## 安装 GNOME 并新建非 root 用户

使用 root 用户登入虚拟机后执行以下命令安装 GNOME

```shell
# 更新软件源
dnf update
# 安装字体
dnf install dejavu-fonts liberation-fonts gnu-*-fonts google-*-fonts
# 安装 xorg
dnf install xorg-x11-apps xorg-x11-drivers xorg-x11-drv-ati \
	xorg-x11-drv-dummy xorg-x11-drv-evdev xorg-x11-drv-fbdev \
	xorg-x11-drv-libinput xorg-x11-drv-nouveau xorg-x11-drv-qxl \
	xorg-x11-drv-synaptics-legacy xorg-x11-drv-v4l xorg-x11-server-Xephyr \
	xorg-x11-drv-wacom xorg-x11-fonts xorg-x11-fonts-others \
	xorg-x11-font-utils xorg-x11-server xorg-x11-server-utils \
	xorg-x11-server-Xspice xorg-x11-util-macros xorg-x11-utils xorg-x11-xauth \
	xorg-x11-xbitmaps xorg-x11-xinit xorg-x11-xkb-utils
# 安装 GNOME 和其组件
dnf install adwaita-icon-theme atk atkmm at-spi2-atk at-spi2-core baobab \
	abattis-cantarell-fonts cheese clutter clutter-gst3 clutter-gtk cogl dconf \
	dconf-editor devhelp eog epiphany evince evolution-data-server file-roller folks \
	gcab gcr gdk-pixbuf2 gdm gedit geocode-glib gfbgraph gjs glib2 glibmm24 \
	glib-networking gmime30 gnome-autoar gnome-backgrounds gnome-bluetooth \
	gnome-builder gnome-calculator gnome-calendar gnome-characters \
	gnome-clocks gnome-color-manager gnome-control-center \
	gnome-desktop3 gnome-disk-utility gnome-font-viewer gnome-getting-started-docs \
	gnome-initial-setup gnome-keyring gnome-logs gnome-menus gnome-music \
	gnome-online-accounts gnome-online-miners gnome-photos gnome-remote-desktop \
	gnome-screenshot gnome-session gnome-settings-daemon gnome-shell \
	gnome-shell-extensions gnome-software gnome-system-monitor gnome-terminal \
	gnome-tour gnome-user-docs gnome-user-share gnome-video-effects \
	gnome-weather gobject-introspection gom grilo grilo-plugins \
	gsettings-desktop-schemas gsound gspell gssdp gtk3 gtk4 gtk-doc gtkmm30 \
	gtksourceview4 gtk-vnc2 gupnp gupnp-av gupnp-dlna gvfs json-glib libchamplain \
	libdazzle libgdata libgee libgnomekbd libgsf libgtop2 libgweather libgxps libhandy \
	libmediaart libnma libnotify libpeas librsvg2 libsecret libsigc++20 libsoup \
	mm-common mutter nautilus orca pango pangomm libphodav python3-pyatspi \
	python3-gobject rest rygel simple-scan sushi sysprof totem totem-pl-parser \
	tracker3 tracker3-miners vala vte291 yelp yelp-tools \
	yelp-xsl zenity
```

设置启动时配置

```shell
# 设置 gdm 自启动
systemclt enable gdm
# 设置系统默认以图形界面登录
systemctl set-default graphical.target
```

在关机之前配置可登入 GNOME 的非 root 用户

```shell
# 添加名为 sihuan 的用户，-m 参数为同时创建该用户家目录（/home/sihuan）,-G wheel 为将该用户加入 wheel 组
useradd -m -G wheel sihuan
# 根据交互提示设置新用户密码
passwd sihuan
```

另外由于已知的 6.1.8 版本新内核会造成 `gdm` 启动异常的问题，需要手动降级内核版本到  5.10.0 版本，执行以下步骤：

1. 从[此处](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V2-riscv64/repo/22.03/mainline/riscv64/)下载 5.10.0-10 版本 `kernel`、`kernel-devel`、`kernel-headers` 包。

   > 你可以执行下面三条命令分别下载上述软件包
   >
   > ```shell
   > wget https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V2-riscv64/repo/22.03/mainline/riscv64/kernel-5.10.0-10.oe2203.riscv64.rpm
   > wget https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V2-riscv64/repo/22.03/mainline/riscv64/kernel-devel-5.10.0-10.oe2203.riscv64.rpm
   > wget https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/preview/openEuler-22.03-V2-riscv64/repo/22.03/mainline/riscv64/kernel-headers-5.10.0-10.oe2203.riscv64.rpm
   > 
   > ```

2. 手动安装上述软件包。

   > 确保当前目录下没有其他 `.rpm ` 后缀的文件，以防止以外安装。执行以下命令
   >
   > ```shell
   > rpm -Uv --oldpackage ./*.rpm
   > ```

3. 编辑 `/boot/extlinux/extlinux.conf` 文件，替换其中的 `vmlinuz-openEuler` 为 `Image`。

现在可以关闭虚拟机，可以使用 `shutdown now` 命令。

## 启动 GNOME 桌面环境

使用 `start_vm_xfce.sh` 脚本启动虚拟机，稍作等待就可以看到 gdm 登入界面。

```bash
chmod +x start_vm_xfce.sh
./start_vm_xfce.sh
```

使用之前创建的非 root 用户就可以登入了～