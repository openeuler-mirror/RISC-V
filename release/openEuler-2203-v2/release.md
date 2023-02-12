# openEuler 22.03 RISC-V V2 版本验收测试报告

修订记录

| 日期      | 修订版本 | 修改章节 |
| --------- | -------- | -------- |
| 2023/1/16 | 1.0.0    | 初始     |

## 摘要

本文主要描述openEuler 22.03 RISC-V V2版本的整体测试过程，详细叙述测试覆盖情况，并通过问题分析对版本整体质量进行评估和总结。

## 概述

openEuler 是一款开源操作系统。当前 openEuler 内核源于 Linux，支持 RISC-V 处理器，能够充分释放计算芯片的潜能，是由全球开源贡献者构建的高效、稳定、安全的开源操作系统。

本文主要汇总 openEuler 22.03-V2 RISC-V 版本的总体测试活动，按照社区开发模式进行运作，结合社区 Tarsier 团队制定的版本计划规划相应的测试计划及活动。测试报告覆盖新需求、继承需求的测试执行情况和评估，并结合各类专项测试活动和版本问题单总体情况进行整体的说明和质量评估。

## 测试版本说明

本文档测试对象是 openEuler 22.03 RISC-V 2022年12月11日和 openEuler 22.03-V2 RISC-V（20221228）发布版本，发布范围相较 22.03 LTS RISC-V 版本主要变动：

- 软件包选型升级
- 软件：Xfce 桌面（预装），Chromium 浏览器（预装），Firefox 浏览器（预装），Libreoffice 办公套件（预装），Tunderbird 电子邮件客户端（预装），GIMP 图片编辑工具（预装）, DDE, MySQL
- 全栈支持 Unmatched 开发板，全栈支持 VisionFive 开发板，部分支持 D1 开发板, 部分支持 Licheerv 开发板
- 修复 Bug

## 测试环境

### 环境和测试结果

| 硬件/QEMU | 硬件配置信息 | 测试结果 |
| ----------------------------------- | ------------------------------------------------------------ | ------------------------- |
| HiFive Unmatched | CPU: SiFive Freedom U740 SoC <br/>内存：16GB DDR4<br/>存储设备：SanDisk Ultra 32GB micro SD | 通过 |
| VisionFive | CPU: JH7100 <br />内存：8GB DDR4<br />存储设备：SanDisk Ultra 32GB micro SD | 通过 |
| D1 | CPU: C906 <br />内存：2GB DDR4<br />存储设备：SanDisk Ultra 32GB micro SD | 基本通过，存在部分缺陷 |
| Qemu 7.2 | CPU: 8<br />内存：8GB <br />存储设备：文件 | 通过 |
| Licheerv | CPU： 全志 D1 阿里平头哥 玄铁 C906 内核<br />内存： 16bit 512MB DDR3<br />存储设备：SanDisk Ultra 32GB micro SD | 基本通过，存在部分缺陷 |

### 系统安装

- [x] [使用QEMU安装RISC-V openEuler](./Installation_Book/QEMU/README.md)
- [x] [使用Unmatched开发板安装RISC-V openEuler](./Installation_Book/Unmatched/README.md)
- [x] [使用Visionfive开发板安装RISC-V openEuler](./Installation_Book/Visionfive/README.md)
- [x] [使用D1开发板安装RISC-V openEuler](./Installation_Book/D1_and_Licheerv/README.md)
- [x] [使用Licheerv开发板安装RISC-V openEuler](./Installation_Book/D1_and_Licheerv/README.md)

openEuler 22.03-V2 RISC-V QEMU和Unmatched，Visionfive、D1、Licheerv版本通过或基本通过测试发布。

## 用户手册

### 系统管理

- [基础配置](./User_Book/系统管理/基础配置.md)
- [查看系统信息](./User_Book/系统管理/查看系统信息.md)
- [管理用户和用户组](./User_Book/系统管理/管理用户和用户组.md)
- [配置网络](./User_Book/系统管理/配置网络.md)
- [使用DNF管理软件包](./User_Book/系统管理/使用DNF管理软件包.md)
- [使用LVM管理硬盘](./User_Book/系统管理/使用LVM管理硬盘.md)
- [管理进程](./User_Book/系统管理/管理进程.md)
- [管理服务](./User_Book/系统管理/管理服务.md)
- [搭建FTP服务器](./User_Book/系统管理/搭建FTP服务器.md)
- [搭建repo服务器](./User_Book/系统管理/搭建repo服务器.md)
- [搭建web服务器](./User_Book/系统管理/搭建web服务器.md)
- [搭建数据库服务器](./User_Book/系统管理/搭建数据库服务器.md)

### 应用软件

- [XFCE使用手册](./User_Book/XFCE使用手册)
- [DDE使用手册](./User_Book/DDE使用手册)
- [Chromium使用手册](./User_Book/Chromium使用手册)
- [Firefox使用手册](./User_Book/Firefox使用手册)
- [Libreoffice使用手册](./User_Book/Libreoffice使用手册)
  - [Libreoffice Base使用手册](./User_Book/Libreoffice使用手册/Base_userguide.md)
  - [Libreoffice Writer使用手册](./User_Book/Libreoffice使用手册/Writer_userguide.md)
  - [Libreoffice Calc使用手册](./User_Book/Libreoffice使用手册/Calc_userguide.md)
  - [Libreoffice Draw使用手册](./User_Book/Libreoffice使用手册/Draw_userguide.md)
  - [Libreoffice Impress使用手册](./User_Book/Libreoffice使用手册/Impress_userguide.md)
  - [Libreoffice Math使用手册](./User_Book/Libreoffice使用手册/Math_userguide.md)
- [GIMP使用手册](./User_Book/GIMP使用手册)
- [Thunderbird使用手册](./User_Book/Thunderbird使用手册)
- [MySQL使用手册](./User_Book/MySQL使用手册)

## 版本测试活动策略

**openEuler 22.03-V2 RISC-V（20221228）版本**

| 需求                        | 测试分层策略                                             |
| ------------------------------- | ------------------------------------------------------------ |
| 支持HiFive Unmatched | 对HiFive Unmatched进行安装、基本功能、兼容性及稳定性的测试 |
| 支持VisionFive | 对VisionFive进行安装、基本功能、兼容性及稳定性的测试通过 |
| 支持D1 |对D1进行安装、部分基本功能、兼容性及稳定性的测试通过， 主要缺陷：WiFi 功能不可用，LibreOffice 启动闪退，修改屏幕分辨率后 Xfce 显示可能出现问题 |
| 支持Licheerv |对Licheerv进行安装、部分基本功能、兼容性及稳定性的测试通过， 主要缺陷：LibreOffice 启动闪退，修改屏幕分辨率后 Xfce 显示可能出现问题 |
| 支持常用软件和系统设置功能软件 | 验证常用软件和系统设置功能软件在openEuler RISC-V版本上的可安装和基本功能 |
| 支持Xfce桌面 | 验证Xfce桌面系统在openEuler RISC-V版本上的可安装和基本功能 |
| 支持Chromium软件 | 验证Chromium软件的安装和软件的基本功能 |
| 支持Firefox软件 | 验证Firefox软件的安装和软件的基本功能，D1启动缓慢，bilibili.com视频无法打开 |
| 支持Libreoffice软件 | 验证Libreoffice软件的安装和软件的基本功能，D1和Licheerv启动闪退 |
| 支持Tunderbird软件 | 验证Tunderbird软件的安装和软件的基本功能 |
| 支持Eclipse软件 | 验证Eclipse软件的安装和软件的基本功能 |
| 支持MySQL软件 | 验证MySQL的安装和软件的基本功能 |
| 支持GIMP软件 | 验证GIMP软件的安装和软件的基本功能 |

本次版本测试快照构建规则：[ORSP004](https://gitee.com/openeuler/RISC-V/blob/master/proposal/ORSP004.md)

本次版本测试快照责任人：周嘉诚

## 缺陷分级定义

- P1 / blocking 指阻塞性bug修复之前什么都不能干。例如用户数据丢失可能列为P1
- P2 / important 指用户几乎总会遇到并影响使用，例如常用用例中程序崩溃、关键功能无法使用等
- P3 / normal 指用户经常遇到并且影响使用体验的bug
- P4 / improvement 不紧急的bug
- P5 / wishlist 期望实现的功能等

## 测试结论

openEuler 22.03-V2 RISC-V 版本整体测试按照Tarsier团队的计划，共完成了一轮重点特性测试+一轮自动化测试（常用软件和系统设置功能）+一轮回归测试；其中第一轮测试聚焦在新移植软件的安装和基础功能测试；一轮自动化测试验证交付版本的常用软件和系统设置功能；一轮回归测通过测试第一轮报告的缺陷，验证缺陷的修复和影响程度；版本发布验收测试是在版本正式发布至官网后开展的轻量化验证活动，旨在保证发布件和测试验证过程交付件的一致性。

openEuler 22.03-V2 RISC-V 版本系统主要组件共发现缺陷  个，P1 0 个，P2  1 个，P3 3 个，P4 81 个，P5 0 个，其中openEuler 22.03-V1 RISC-V 版本中部分问题已修复，回归测试结果正常，版本整体质量较好。自动化测试共1426个测试用例，通过测试用例 1006 个，未通过测试用例 420 个，软件源包依赖缺陷 90 个。

### 重点组件测试

对产品所有继承特性进行评价，用表格形式评价，包括特性列表（与特性清单保持一致），验证质量评估，**测试报告见组件名称的链接**。

| 序号 | 组件/特性名称 | 测试用例数目 | 通过用例 | 问题数目 | 特性质量评估 | 备注 |
| ---- | ----------------------------------------- | :-------------------------: | ---------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| 1 | [支持HiFive Unmatched](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/Unmatched) | 15 | [14](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/Unmatched/succeeded_case) | [1](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/Unmatched/failed_case) | <font color=green>█</font> | 全栈支持Unmatched开发板，Firefox启动50%左右失败 |
| 2 | [支持VisionFive](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/Visionfive) | 16 | [14](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/Visionfive/succeeded_case) | [2](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/Visionfive/failed_case) | <font color=green>█</font> | 全栈支持VisionFive开发板 |
| 3 | [支持D1](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/D1) | 14 | [9](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/D1/succeeded_case) | [5](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/D1/failed_case) | <font color=green>▲</font> | 部分支持D1开发板, 缺陷：WiFi 和蓝牙功能不可用，LibreOffice 启动闪退，修改屏幕分辨率后 Xfce 显示可能出现问题，HDMI 接口热插拔可能不可用, Firefox启动缓慢（3分钟以上），Firefox无法浏览bilibili.com视频。 |
| 4 | [支持Licheerv](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/LicheeRV) | 17 | [10](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/LicheeRV/succeeded_case)  | [7](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Hardware_Test/LicheeRV/failed_case)  | <font color=green>█</font> | 部分支持Licheerv开发板，缺陷：LibreOffice 启动闪退，修改屏幕分辨率后 Xfce 显示可能出现问题，HDMI 接口热插拔可能不可用，Firefox浏览bilibili.com视频50%左右失败网页报错， Thunderbird无法关闭。 |
| 5 | [支持Xfce桌面](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/XFCE) | 57 | [51](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/XFCE/succeeded_case) | [6](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/XFCE/failed_case)  | <font color=green>█</font> | 安装和卸载正常，整体核心功能(重要组件和系统插件)稳定正常，整体质量良好。 |
| 6 | [支持DDE](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/DDE) | 70 | [61](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/DDE/succeeded_case) | [9](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/DDE/failed_case) | <font color=green>█</font> | 安装和卸载正常，整体核心功能(重要组件和系统插件)稳定正常，整体质量良好。 |
| 7 | [支持Chromium浏览器](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/Chromium) | 124 | [100](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/Chromium/succeeded_case)  | [24](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/Chromium/failed_case)  | <font color=green>█</font> | 安装和卸载正常，整体核心功能(重要组件和系统插件)稳定正常，整体质量良好。 |
| 8 | [支持Firefox浏览器](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/Firefox) | 75 | [71](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/Firefox/succeeded_case) | [4](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/Firefox/failed_case) | <font color=green>█</font> | 安装和卸载正常，整体核心功能(重要组件和系统插件)稳定正常，整体质量良好。 |
| 9 | [支持Libreoffice](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/LibreOffice) | 245 | [225](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/LibreOffice/succeeded_case) | [20](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/LibreOffice/failed_case) | <font color=green>█</font> | 安装正常，卸载失败，整体核心功能(重要组件和系统插件)稳定正常，整体质量良好。 |
| 10 | [支持Tunderbird](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/Thunderbird) | 22 | [20](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/Thunderbird/succeeded_case) | [2](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/Thunderbird/failed_case) | <font color=green>█</font> | 安装和卸载正常，整体核心功能(重要组件和系统插件)稳定正常，整体质量良好，可以收发邮件。 |
| 11 | [支持MYSQL](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/MYSQL) | 48 | [48](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/MYSQL/succeeded_case) | 0 | <font color=green>█</font> | 安装和卸载正常，整体核心功能(重要组件和系统插件)稳定正常，整体质量良好。 |
| 12 | [支持GIMP](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/GIMP) | 33 | [28](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/GIMP/succeeded_case) | [5](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/Manual_Testing/tree/master/GIMP/failed_case) | <font color=green>█</font> | 安装和卸载正常，整体核心功能(重要组件和系统插件)稳定正常，整体质量良好。 |

- <font color=red>●</font>： 表示特性不稳定，风险高
- <font color=blue>▲</font>： 表示特性基本可用，遗留少量问题
- <font color=green>█</font>： 表示特性质量良好

### 常见软件和系统功能自动化测试

- 测试范围：共329个测试套(327个软件包+systemd+os-basic)，1426个测试用例
- 测试框架：mugen-riscv（由第三测试小队开发维护的mugen分支，新增了测试环境自动复原、多线程测试和测试结果自动分析等功能）[仓库链接](https://github.com/brsf11/mugen-riscv)
- 测试方式：测试环境自动复原，测试套间隔离以及自动分配硬盘外设资源的自动化测试
    使用qemu_test.py，利用qemu qcow2快照实现在测试每个测试套时单独建立qemu虚拟机进行测试，保证了测试套间不会相互干扰。测试程序运行时会根据测试套文件中"add disk"字段的信息，自动创建硬盘资源并分配给对应的虚拟机。
- [详细测试结果](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Auto_Testing/openEuler-RISC-V-22.03-Preview-V2)
- 测试结论：本次自动化测试共1426个测试用例，通过测试用例 1006 个，未通过测试用例 420 个，以下为 [详细测试报告](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Auto_Testing/openEuler-RISC-V-22.03-Preview-V2/logs/logs.md) 与 [未通过测试分析](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Auto_Testing/openEuler-RISC-V-22.03-Preview-V2/logs_failed/logs_failed.md)。

### V1缺陷修复状态

以下为2203-V1版本中失败的测试用例现状，修复了 13 个，排除了 12 个，余下 45 个正在修复中。

| 序号 | 测试套             | 测试用例                                                     | 状态   |
| ---- | ------------------ | ------------------------------------------------------------ | ------ |
| 1    | Java—1.8.0-openjdk | oe_test_openjdk_rmic_rmid                                    | 已排除 |
| 2    | Java—1.8.0-openjdk | oe_test_openjdk_appletviewer_clhsdb                          | 未修复 |
| 3    | Java—1.8.0-openjdk | oe_test_openjdk_jdb_jdep                                     | 未修复 |
| 4    | easymock           | oe_test_easymock_junit4                                      | 已排除 |
| 5    | easymock           | oe_test_easymock_junit5                                      | 已排除 |
| 6    | easymock           | oe_test_easymock_spring                                      | 未修复 |
| 7    | pcp                | oe_test_pmdumplog_02                                         | 已排除 |
| 8    | pcp                | oe_test_pmevent_01                                           | 已排除 |
| 9    | pcp                | oe_test_pmlogconf_pmlogsize                                  | 已排除 |
| 10   | pcp                | oe_test_pmpython_mkaf_pcp-python                             | 已排除 |
| 11   | pcp                | oe_test_pmval_01                                             | 已排除 |
| 12   | djvulibre          | oe_test_djvulibre_01                                         | 已排除 |
| 13   | rabbitmq-server    | oe_test_rabbitmq-server                                      | 已排除 |
| 14   | clamav             | oe_test_clamav_clamav-milter                                 | 已排除 |
| 15   | clamav             | oe_test_clamav_sigtool_2                                     | 已排除 |
| 16   | clamav             | oe_test_clamav_clamdtop                                      | 未修复 |
| 17   | clamav             | oe_test_clamav_clamonacc                                     | 未修复 |
| 18   | clamav             | oe_test_clamav_clamscan_1                                    | 未修复 |
| 19   | clamav             | oe_test_clamav_clamscan_2                                    | 未修复 |
| 20   | clamav             | oe_test_clamav_clamscan_3                                    | 未修复 |
| 21   | clamav             | oe_test_clamav_clamsubmit                                    | 未修复 |
| 22   | clamav             | oe_test_service_clamav-clamonacc                             | 未修复 |
| 23   | freeradius         | oe_test_freeradius_freeradius-utils_radclient2oe_test_freeradius_freeradius_raddebugAndCheckrad | 已修复 |
| 24   | freeradius         | oe_test_freeradius_freeradius-utils_rad_counter              | 已修复 |
| 25   | freeradius         | oe_test_freeradius_freeradius-utils_radclient                | 已修复 |
| 26   | freeradius         | oe_test_freeradius_freeradius-utils_radcryptAndRadeapclient  | 已修复 |
| 27   | freeradius         | oe_test_freeradius_freeradius-utils_radlastAndRadsniff       | 已修复 |
| 28   | freeradius         | oe_test_freeradius_freeradius-utils_radsqlrelay              | 已修复 |
| 29   | freeradius         | oe_test_freeradius_freeradius-utils_radclient2               | 未修复 |
| 30   | freeradius         | oe_test_freeradius_freeradius-utils_radeapclient             | 未修复 |
| 31   | freeradius         | oe_test_freeradius_freeradius-utils_radlast                  | 未修复 |
| 32   | freeradius         | oe_test_freeradius_freeradius-utils_radsniff                 | 未修复 |
| 33   | freeradius         | oe_test_freeradius_freeradius-utils_radsniff2                | 未修复 |
| 34   | freeradius         | oe_test_freeradius_freeradius-utils_radtestAndRadwho         | 未修复 |
| 35   | freeradius         | oe_test_freeradius_freeradius-utils_radwho                   | 未修复 |
| 36   | freeradius         | oe_test_freeradius_freeradius-utils_radzap                   | 未修复 |
| 37   | freeradius         | oe_test_freeradius_freeradius-utils_rlm_ippool_toolAndSmbencrypt | 未修复 |
| 38   | freeradius         | oe_test_service_radiusd                                      | 未修复 |
| 39   | atune              | oe_test_service_atune-engine                                 | 已修复 |
| 40   | atune              | oe_test_service_atuned                                       | 未修复 |
| 41   | p7zip              | oe_test_p7zip_7za_001                                        | 已修复 |
| 42   | p7zip              | oe_test_p7zip_7za_002                                        | 已修复 |
| 43   | p7zip              | oe_test_p7zip_7za_003                                        | 已修复 |
| 44   | p7zip              | oe_test_p7zip_7za_004                                        | 已修复 |
| 45   | p7zip              | oe_test_p7zip_7za_005                                        | 已修复 |
| 46   | kubernetes         | oe_test_service_kube-controller-manager                      | 已修复 |
| 47   | kubernetes         | oe_test_service_kube-scheduler                               | 已修复 |
| 48   | kubernetes         | oe_test_service_kube-proxy                                   | 未修复 |
| 49   | os-basic           | oe_test_awk                                                  | 未修复 |
| 50   | os-basic           | oe_test_disk_graphics_card                                   | 未修复 |
| 51   | os-basic           | oe_test_disk_schedule_specific                               | 未修复 |
| 52   | os-basic           | oe_test_disk_schedule_udev                                   | 未修复 |
| 53   | os-basic           | oe_test_IOaccess_1Gfile                                      | 未修复 |
| 54   | os-basic           | oe_test_kernel_kdump                                         | 未修复 |
| 55   | os-basic           | oe_test_kernel_module_operation                              | 未修复 |
| 56   | os-basic           | oe_test_nmcli_set_bond                                       | 未修复 |
| 57   | os-basic           | oe_test_nmcli_set_team                                       | 未修复 |
| 58   | os-basic           | oe_test_power_measurement_internal                           | 未修复 |
| 59   | os-basic           | oe_test_power_powertop_powerup                               | 未修复 |
| 60   | os-basic           | oe_test_power_powertop2tuned_optimize                        | 未修复 |
| 61   | os-basic           | oe_test_server_httpd_checkfirewall                           | 未修复 |
| 62   | os-basic           | oe_test_server_httpd_restart                                 | 未修复 |
| 63   | os-basic           | oe_test_server_httpd_tls                                     | 未修复 |
| 64   | os-basic           | oe_test_server_openssh_secure                                | 未修复 |
| 65   | os-basic           | oe_test_server_openssh_verifykey                             | 未修复 |
| 66   | os-basic           | oe_test_server_squid_blacklist                               | 未修复 |
| 67   | os-basic           | oe_test_server_squid_ip                                      | 未修复 |
| 68   | os-basic           | oe_test_server_squid_proxy                                   | 未修复 |
| 69   | os-basic           | oe_test_system_monitor_share_total                           | 未修复 |
| 70   | os-basic           | oe_test_who                                                  | 未修复 |

### 软件源包依赖测试

测试环境：

- OpenEuler 22.03 V2 riscv64 preview 安装镜像
- OpenEuler 22.03 V2 riscv64 软件源

测试结论：

- 发现出问题的软件包往往彼此关联，如`libreoffice`的众多语言包、`texlive`的若干插件、`vdsm`的一些钩子等等

- 依赖树顶端的软件包出问题时，整个依赖树都无法正常运转。如大量软件包依赖于`vdsm`，当它无法正常安装时，那些依赖它的软件包也会无法正常安装

- 部分软件包出现同名多版本共存的现象，导致包管理器无法选择哪一种进行安装

- 大多数依赖问题源于所依赖的软件包版本号不满足条件或无法提供相关功能，或在软件源中找不到所对应的依赖的软件包

- 测试软件包总数22534个，发现缺陷90个。

[测试报告](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Manual_Testing/System_Dependency/)

| 序号 | 包名                                       | 描述                                                         |
| ---- | ------------------------------------------ | ------------------------------------------------------------ |
| 1    | vdo                                        | - nothing provides kmod-kvdo >= 6.2 needed by vdo-6.2.0.298-14.oe2203.riscv64 |
| 2    | texlive-biblatex-apa                       | - nothing provides biber needed by texlive-biblatex-apa-8:svn47268-24.oe2203.noarch |
| 3    | texlive-ctanupload                         | - nothing provides perl(HTML::FormatText) needed by texlive-ctanupload-7:20180414-35.oe2203.noarch<br />- nothing provides perl(HTML::TreeBuilder) needed by texlive-ctanupload-7:20180414-35.oe2203.noarch<br />- nothing provides perl(WWW::Mechanize) needed by texlive-ctanupload-7:20180414-35.oe2203.noarch |
| 4    | texlive-exceltex                           | - nothing provides perl(Spreadsheet::ParseExcel) needed by texlive-exceltex-7:20180414-35.oe2203.noarch |
| 5    | texlive-includernw                         | - nothing provides R-knitr needed by texlive-includernw-8:svn47557-24.oe2203.noarch |
| 6    | texlive-latexindent                        | - nothing provides perl(Log::Dispatch::File) needed by texlive-latexindent-7:20180414-35.oe2203.noarch<br />- nothing provides perl(Log::Log4perl) needed by texlive-latexindent-7:20180414-35.oe2203.noarch<br />- nothing provides perl(Log::Log4perl::Appender::Screen) needed by texlive-latexindent-7:20180414-35.oe2203.noarch |
| 7    | fence-agents-sbd                           | - nothing provides sbd needed by fence-agents-sbd-4.2.1-32.oe2203.noarch |
| 8    | nvwa                                       | - nothing provides criu needed by nvwa-0.2-1.oe2203.riscv64  |
| 9    | lirc-tools-gui                             | - nothing provides xorg-x11-fonts-core needed by lirc-tools-gui-0.10.1-1.oe2203.riscv64 |
| 10   | python3-keras-rl2                          | - nothing provides python3.9dist(tensorflow) >= 2.1 needed by python3-keras-rl2-1.0.4-1.oe2203.noarch |
| 11   | python3-nni                                | - nothing provides python3.9dist(websockets) needed by python3-nni-1.8-2.oe2203.riscv64<br />- nothing provides python3.9dist(hyperopt) = 0.1.2 needed by python3-nni-1.8-2.oe2203.riscv64 |
| 12   | python3-spec                               | - nothing provides python3.9dist(nose) >= 1.3 needed by python3-spec-1.4.1-1.oe2203.noarch<br />- nothing provides python3.9dist(nose) < 2 needed by python3-spec-1.4.1-1.oe2203.noarch |
| 13   | texlive-oldstandard                        | - nothing provides oldstandard-sfd-fonts needed by texlive-oldstandard-8:svn41735-24.oe2203.noarch |
| 14   | vdsm                                       | - nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 15   | gnome-builder                              | - nothing provides devhelp-libs(riscv-64) >= 3.25.1 needed by gnome-builder-3.40.0-1.oe2203.riscv64 |
| 16   | ovirt-engine-dwh-grafana-integration-setup | - nothing provides ovirt-engine-setup-plugin-ovirt-engine-common >= 4.4.0 needed by ovirt-engine-dwh-grafana-integration-setup-4.4.4.1-2.oe2203.noarch |
| 17   | ovirt-engine-dwh-setup                     | - nothing provides ovirt-engine-setup-plugin-ovirt-engine-common >= 4.4.0 needed by ovirt-engine-dwh-setup-4.4.4.1-2.oe2203.noarch |
| 18   | perl-Any-URI-Escape                        | - nothing provides perl(:MODULE_COMPAT_5.28.0) needed by perl-Any-URI-Escape-0.01-1.oe2203.noarch |
| 19   | A-FOT                                      | - nothing provides llvm-bolt needed by A-FOT-v1.0-0.oe2.riscv64 |
| 20   | dirac                                      | - nothing provides libcppunit-1.14.so.0()(64bit) needed by dirac-1.0.2-33.4.oe2.riscv64 |
| 21   | permissions-config                         | - nothing provides group(trusted) needed by permissions-config-20220419-33.1.oe2.riscv64 |
| 22   | libreoffice-langpack-af                    | - nothing provides hunspell-af needed by libreoffice-langpack-af-1:7.3.5.2-2.oe2203.riscv64<br />- nothing provides hyphen-af needed by libreoffice-langpack-af-1:7.3.5.2-2.oe2203.riscv64 |
| 23   | libreoffice-langpack-bg                    | - nothing provides mythes-bg needed by libreoffice-langpack-bg-1:7.3.5.2-2.oe2203.riscv64 |
| 24   | libreoffice-langpack-ca                    | - nothing provides mythes-ca needed by libreoffice-langpack-ca-1:7.3.5.2-2.oe2203.riscv64 |
| 25   | libreoffice-langpack-cs                    | - nothing provides mythes-cs needed by libreoffice-langpack-cs-1:7.3.5.2-2.oe2203.riscv64 |
| 26   | libreoffice-langpack-da                    | - nothing provides mythes-da needed by libreoffice-langpack-da-1:7.3.5.2-2.oe2203.riscv64 |
| 27   | libreoffice-langpack-de                    | - nothing provides mythes-de needed by libreoffice-langpack-de-1:7.3.5.2-2.oe2203.riscv64 |
| 28   | libreoffice-langpack-el                    | - nothing provides mythes-el needed by libreoffice-langpack-el-1:7.3.5.2-2.oe2203.riscv64 |
| 29   | libreoffice-langpack-eo                    | - nothing provides mythes-eo needed by libreoffice-langpack-eo-1:7.3.5.2-2.oe2203.riscv64 |
| 30   | libreoffice-langpack-es                    | - nothing provides mythes-es needed by libreoffice-langpack-es-1:7.3.5.2-2.oe2203.riscv64 |
| 31   | libreoffice-langpack-fi                    | - nothing provides libreoffice-voikko needed by libreoffice-langpack-fi-1:7.3.5.2-2.oe2203.riscv64 |
| 32   | libreoffice-langpack-fr                    | - nothing provides mythes-fr needed by libreoffice-langpack-fr-1:7.3.5.2-2.oe2203.riscv64 |
| 33   | libreoffice-langpack-ga                    | - nothing provides mythes-ga needed by libreoffice-langpack-ga-1:7.3.5.2-2.oe2203.riscv64 |
| 34   | libreoffice-langpack-hi                    | - nothing provides hunspell-hi needed by libreoffice-langpack-hi-1:7.3.5.2-2.oe2203.riscv64 |
| 35   | libreoffice-langpack-hu                    | - nothing provides hyphen-hu needed by libreoffice-langpack-hu-1:7.3.5.2-2.oe2203.riscv64<br />- nothing provides mythes-hu needed by libreoffice-langpack-hu-1:7.3.5.2-2.oe2203.riscv64 |
| 36   | libreoffice-langpack-it                    | - nothing provides mythes-it needed by libreoffice-langpack-it-1:7.3.5.2-2.oe2203.riscv64 |
| 37   | libreoffice-langpack-nl                    | - nothing provides mythes-nl needed by libreoffice-langpack-nl-1:7.3.5.2-2.oe2203.riscv64 |
| 38   | libreoffice-langpack-pl                    | - nothing provides mythes-pl needed by libreoffice-langpack-pl-1:7.3.5.2-2.oe2203.riscv64 |
| 39   | libreoffice-langpack-pt-BR                 | - nothing provides mythes-pt needed by libreoffice-langpack-pt-BR-1:7.3.5.2-2.oe2203.riscv64 |
| 40   | libreoffice-langpack-pt-PT                 | - nothing provides mythes-pt needed by libreoffice-langpack-pt-PT-1:7.3.5.2-2.oe2203.riscv64 |
| 41   | libreoffice-langpack-ro                    | - nothing provides mythes-ro needed by libreoffice-langpack-ro-1:7.3.5.2-2.oe2203.riscv64 |
| 42   | libreoffice-langpack-ru                    | - nothing provides mythes-ru needed by libreoffice-langpack-ru-1:7.3.5.2-2.oe2203.riscv64 |
| 43   | libreoffice-langpack-si                    | - nothing provides hunspell-si needed by libreoffice-langpack-si-1:7.3.5.2-2.oe2203.riscv64 |
| 44   | libreoffice-langpack-sk                    | - nothing provides mythes-sk needed by libreoffice-langpack-sk-1:7.3.5.2-2.oe2203.riscv64 |
| 45   | libreoffice-langpack-sl                    | - nothing provides mythes-sl needed by libreoffice-langpack-sl-1:7.3.5.2-2.oe2203.riscv64 |
| 46   | libreoffice-langpack-sv                    | - nothing provides mythes-sv needed by libreoffice-langpack-sv-1:7.3.5.2-2.oe2203.riscv64 |
| 47   | libreoffice-langpack-ta                    | - nothing provides hunspell-ta needed by libreoffice-langpack-ta-1:7.3.5.2-2.oe2203.riscv64 |
| 48   | libreoffice-langpack-uk                    | - nothing provides mythes-uk needed by libreoffice-langpack-uk-1:7.3.5.2-2.oe2203.riscv64 |
| 49   | libreoffice-langpack-zu                    | - nothing provides hyphen-zu needed by libreoffice-langpack-zu-1:7.3.5.2-2.oe2203.riscv64 |
| 50   | permissions-zypp-plugin                    | - nothing provides python3-zypp-plugin needed by permissions-zypp-plugin-20220419.-33.1.oe2.noarch<br />- nothing provides libzypp(plugin:commit) = 1 needed by permissions-zypp-plugin-20220419.-33.1.oe2.noarch |
| 51   | firefox                                    | Problem: cannot install the best candidate for the job<br />- nothing provides libicudata.so.71()(64bit) needed by firefox-100.0.2-1.oe2203.riscv64- nothing provides libicui18n.so.71()(64bit) needed by firefox-100.0.2-1.oe2203.riscv64<br />- nothing provides libicuuc.so.71()(64bit) needed by firefox-100.0.2-1.oe2203.riscv64 |
| 52   | texlive-collection-fontutils               | Problem: cannot install the best candidate for the job<br />- nothing provides t1utils needed by texlive-collection-fontutils-8:svn37105.0-27.oe2203.noarch |
| 53   | texlive-collection-binextra                | Problem: cannot install the best candidate for the job<br />- nothing provides asymptote needed by texlive-collection-binextra-8:svn47945-27.oe2203.noarch<br />- nothing provides latexmk needed by texlive-collection-binextra-8:svn47945-27.oe2203.noarch |
| 54   | gnome-boxes                                | Problem: cannot install the best candidate for the job<br />- nothing provides libvirt-daemon-kvm needed by gnome-boxes-3.38.2-4.oe2203.riscv64 |
| 55   | permissions                                | Problem: package permissions-20220419.-33.1.oe2.riscv64 requires permissions-config, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides group(trusted) needed by permissions-config-20220419-33.1.oe2.riscv64 |
| 56   | firefox-devel                              | Problem: package firefox-devel-100.0.2-1.oe2203.riscv64 requires firefox = 100.0.2, but none of the providers can be installed<br />- cannot install the best candidate for the job<br />- nothing provides libicudata.so.71()(64bit) needed by firefox-100.0.2-1.oe2203.riscv64<br />- nothing provides libicui18n.so.71()(64bit) needed by firefox-100.0.2-1.oe2203.riscv64<br />- nothing provides libicuuc.so.71()(64bit) needed by firefox-100.0.2-1.oe2203.riscv64 |
| 57   | vdsm-hook-vmfex-dev                        | Problem: package vdsm-hook-vmfex-dev-4.40.60.7-5.oe2203.noarch requires vdsm = 4.40.60.7-5.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 58   | vdsm-hook-qemucmdline                      | Problem: package vdsm-hook-qemucmdline-4.40.60.7-5.oe2203.noarch requires vdsm, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 59   | vdsm-hook-macbind                          | Problem: package vdsm-hook-macbind-4.40.60.7-5.oe2203.noarch requires vdsm >= 4.14, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 60   | vdsm-hook-localdisk                        | Problem: package vdsm-hook-localdisk-4.40.60.7-5.oe2203.noarch requires vdsm = 4.40.60.7, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 61   | vdsm-hook-fcoe                             | Problem: package vdsm-hook-fcoe-4.40.60.7-5.oe2203.noarch requires vdsm = 4.40.60.7-5.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 62   | vdsm-hook-faqemu                           | Problem: package vdsm-hook-faqemu-4.40.60.7-5.oe2203.noarch requires vdsm, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 63   | vdsm-hook-fakevmstats                      | Problem: package vdsm-hook-fakevmstats-4.40.60.7-5.oe2203.noarch requires vdsm, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 64   | vdsm-hook-extne                            | Problem: package vdsm-hook-extnet-4.40.60.7-5.oe2203.noarch requires vdsm = 4.40.60.7-5.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 65   | vdsm-hook-ethtool-options                  | Problem: package vdsm-hook-ethtool-options-4.40.60.7-5.oe2203.noarch requires vdsm = 4.40.60.7-5.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 66   | vdsm-hook-checkips                         | Problem: package vdsm-hook-checkips-4.40.60.7-5.oe2203.riscv64 requires vdsm = 4.40.60.7-5.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 67   | vdsm-hook-checkimages                      | Problem: package vdsm-hook-checkimages-4.40.60.7-5.oe2203.noarch requires vdsm, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 68   | vdsm-hook-boot_hostdev                     | Problem: package vdsm-hook-boot_hostdev-4.40.60.7-5.oe2203.noarch requires vdsm, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 69   | vdsm-hook-allocate_net                     | Problem: package vdsm-hook-allocate_net-4.40.60.7-5.oe2203.noarch requires vdsm, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 70   | vdsm-gluster                               | Problem: package vdsm-gluster-4.40.60.7-5.oe2203.riscv64 requires vdsm = 4.40.60.7-5.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 6.1.0 needed by vdsm-4.40.60.7-5.oe2203.riscv64 |
| 71   | ovirt-engine-dwh                           | Problem: package ovirt-engine-dwh-4.4.4.1-2.oe2203.noarch requires ovirt-engine-dwh-setup >= 4.4.4.1-2.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides ovirt-engine-setup-plugin-ovirt-engine-common >= 4.4.0 needed by ovirt-engine-dwh-setup-4.4.4.1-2.oe2203.noarch |
| 72   | gnome-builder-devel                        | Problem: package gnome-builder-devel-3.40.0-1.oe2203.riscv64 requires gnome-builder(riscv-64) = 3.40.0-1.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides devhelp-libs(riscv-64) >= 3.25.1 needed by gnome-builder-3.40.0-1.oe2203.riscv64 |
| 73   | texlive-collection-mathscience             | Problem: package texlive-collection-mathscience-8:svn48252-27.oe2203.noarch requires texlive-includernw, but none of the providers can be installed<br />- cannot install the best candidate for the job<br />- nothing provides R-knitr needed by texlive-includernw-8:svn47557-24.oe2203.noarch |
| 74   | texlive-collection-latexextra              | Problem: package texlive-collection-latexextra-8:svn48313-27.oe2203.noarch requires texlive-exceltex, but none of the providers can be installed<br />- cannot install the best candidate for the job<br />- nothing provides perl(Spreadsheet::ParseExcel) needed by texlive-exceltex-7:20180414-35.oe2203.noarch |
| 75   | texlive-scheme-medium                      | Problem: package texlive-scheme-medium-8:svn44177-27.oe2203.noarch requires texlive-collection-fontutils, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides t1utils needed by texlive-collection-fontutils-8:svn37105.0-26.oe2203.noarch<br />- nothing provides t1utils needed by texlive-collection-fontutils-8:svn37105.0-27.oe2203.noarch |
| 76   | texlive-scheme-gust                        | Problem: package texlive-scheme-gust-8:svn44177-27.oe2203.noarch requires texlive-collection-fontutils, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides t1utils needed by texlive-collection-fontutils-8:svn37105.0-26.oe2203.noarch<br />- nothing provides t1utils needed by texlive-collection-fontutils-8:svn37105.0-27.oe2203.noarch |
| 77   | exlive-collection-bibtexextra              | Problem: package texlive-collection-bibtexextra-8:svn47839-27.oe2203.noarch requires texlive-biblatex-apa, but none of the providers can be installed<br />- cannot install the best candidate for the job<br />- nothing provides biber needed by texlive-biblatex-apa-8:svn47268-24.oe2203.noarch |
| 78   | ruby-libguestfs                            | Problem: package ruby-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs.so.0()(64bit), but none of the providers can be installed<br />- package ruby-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |
| 79   | python3-libguestfs                         | Problem: package python3-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs.so.0()(64bit), but none of the providers can be installed<br />- package python3-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |
| 80   | php-libguestfs                             | Problem: package php-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs.so.0()(64bit), but none of the providers can be installed<br />- package php-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |
| 81   | perl-Sys-Guestfs                           | Problem: package perl-Sys-Guestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs.so.0()(64bit), but none of the providers can be installed<br />- package perl-Sys-Guestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |
| 82   | ocaml-libguestfs                           | Problem: package ocaml-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs.so.0()(64bit), but none of the providers can be installed<br />- package ocaml-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |
| 83   | nbdkit-guestfs-plugin                      | Problem: package nbdkit-guestfs-plugin-1.29.11-1.oe2203.riscv64 requires libguestfs.so.0()(64bit), but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |
| 84   | lua-guestfs                                | Problem: package lua-guestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs.so.0()(64bit), but none of the providers can be installed<br />- package lua-guestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |
| 85   | libguestfs-gobject                         | Problem: package libguestfs-gobject-1:1.40.2-17.oe2203.riscv64 requires libguestfs.so.0()(64bit), but none of the providers can be installed<br />- package libguestfs-gobject-1:1.40.2-17.oe2203.riscv64 requires libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |
| 86   | libguestfs-devel                           | Problem: package libguestfs-devel-1:1.40.2-17.oe2203.riscv64 requires libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |
| 87   | fence-agents-all                           | Problem: package fence-agents-all-4.2.1-32.oe2203.riscv64 requires fence-agents-sbd >= 4.2.1, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides sbd needed by fence-agents-sbd-4.2.1-32.oe2203.noarch |
| 88   | libguestfs-gobject-devel                   | Problem: package libguestfs-gobject-devel-1:1.40.2-17.oe2203.riscv64 requires pkgconfig(libguestfs), but none of the providers can be installed<br />- package libguestfs-devel-1:1.40.2-17.oe2203.riscv64 requires libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |
| 89   | ocaml-libguestfs-devel                     | Problem: package ocaml-libguestfs-devel-1:1.40.2-17.oe2203.riscv64 requires ocaml-libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- package ocaml-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs.so.0()(64bit), but none of the providers can be installed<br />- package ocaml-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |
| 90   | vdsm-hook-fileinject                       | Problem: package vdsm-hook-fileinject-4.40.60.7-5.oe2203.noarch requires python3-libguestfs, but none of the providers can be installed<br />- package python3-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs.so.0()(64bit), but none of the providers can be installed<br />- package python3-libguestfs-1:1.40.2-17.oe2203.riscv64 requires libguestfs(riscv-64) = 1:1.40.2-17.oe2203, but none of the providers can be installed<br />- conflicting requests<br />- nothing provides libvirt-daemon-kvm >= 0.10.2-3 needed by libguestfs-1:1.40.2-17.oe2203.riscv64 |

### 用户反馈开发需求

| **序号** | **特性名称** | 等级 |
| -------- | ---------------------------- | ------------------------------------------------------------ |
| 1 | 镜像预装中文输入法                                           | P3 |

## 附件

1. [RISC-V openEuler 22.03 1211版本自动化测试报告](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Auto_Testing/1211-22.03testing)
2. [RISC-V openEuler 22.03 preview V2 自动化测试报告](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/tree/master/Auto_Testing/openEuler-RISC-V-22.03-Preview-V2)
3. [RISC-V openEuler 22.03 1211版本自动化测试说明](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/blob/master/Auto_Testing/1211-22.03testing/README.md)
4. [RISC-V openEuler 22.03 preview V2 自动化测试说明](https://gitee.com/yunxiangluo/openeuler-riscv-2203-v2-test/blob/master/Auto_Testing/openEuler-RISC-V-22.03-Preview-V2/README.md)
