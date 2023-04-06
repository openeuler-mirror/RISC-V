# Kiran使用手册

## 软件说明

kiran桌面是湖南麒麟信安团队以用户和市场需求为导向，研发的一个安全、稳定、高效、易用的桌面环境。kiran可以支持x86和aarch64架构。

正向设计桌面环境，自研包括登录锁屏界面、开始菜单、应用切换、任务栏工作区预览、系统托盘和控制中心等组件，在保证界面风格友好性的情况下更加节省资源；自研深浅色主题，界面功能清晰，呈现模块化的设计风格，通过层次化的方式优化功能布局，交互体验更加友好。

## 环境配置

````
```
Name         : kiran-desktop
Version      : 2.2
Release      : 10.oe2
Architecture : riscv64
Size         : 826
Source       : kiran-desktop-2.2-10.oe2.src.rpm
Repository   : @System
From repo    : epol
Summary      : Kiran desktop environment
License      : Mulan PSL v2
Description  : kiran desktop environment
```
````

## 安装方法

```bash
sudo dnf update
sudo dnf install kiran-desktop
systemctl set-default graphical.target
reboot
```

## 相关issue

https://gitee.com/openeuler/RISC-V/issues/I6OYL4?from=project-issue

https://gitee.com/openeuler/RISC-V/issues/I6OZ5N?from=project-issue
