# openEuler-22.03-V1版本release报告

修订记录

| 日期       | 修订版本 | 修改章节           |
| ---------- | -------- | ------------------ |
| 2022/10/8 | 1.0.0    | 初始   |

**摘要**

文本主要描述openEuler-22.03-V1版本的release过程，详细叙述版本主要变动，并通过问题分析对版本整体质量进行评估和总结。


# 1   概述

openEuler是一款开源操作系统。当前openEuler内核源于Linux，支持RISC-V处理器，能够充分释放计算芯片的潜能，是由全球开源贡献者构建的高效、稳定、安全的开源操作系统。


# 2   版本说明

本release对象是openEuler-22.03-V1，2022年10月8日发布版本，发布范围相较22.03 LTS RISC-V版本主要变动：

1. 软件包选型升级
2. 新增软件：Xfce桌面，Chromium浏览器，Firefox浏览器，Libreoffice办公套件，Tunderbird电子邮件客户端，Eclipse，VLC视频播放工具，GIMP图片编辑工具
3. 新增全栈支持Unmatched，VisionFive开发板
4. 修复bug和cve

支持环境如下：

| 硬件/QEMU | 硬件配置信息 | 测试结果 |
| ----------------------------------- | ------------------------------------------------------------ | ------------------------- |
| HiFive Unmatched | CPU: SiFive Freedom U740 SoC <br />内存：16GB DDR4<br />存储设备：SanDisk Ultra 32GB micro SD | 通过 |
| VisionFive | CPU: JH7100 <br />内存：8GB DDR4<br />存储设备：SanDisk Ultra 32GB micro SD | 通过 |
| Qemu 6.2/7.0 | CPU: 8<br />内存：8GB <br />存储设备：文件 | 通过 |

| 主要变动                    |
| ------------------------------- |
| 支持HiFive Unmatched |
| 支持VisionFive|
| 支持常用软件和系统设置功能软件 |
| 支持Xfce桌面 |
| 支持Chromium软件 |
| 支持Firefox软件 |
| 支持Libreoffice软件 |
| 支持Tunderbird软件 |
| 支持Eclipse软件 |
| 支持VLC软件 |
| 支持GIMP软件 |

# 3 环境安装

- [使用QEMU安装openEuler-22.03-V1](./qemu/README.md)
- [使用Unmatched开发板安装openEuler-22.03-V1](./unmatched/README.md)
- [使用VisionFive开发板安装openEuler-22.03-V1](./visionfive/README.md)
- [使用D1开发板安装openEuler-22.03-V1](./d1/README.md)
