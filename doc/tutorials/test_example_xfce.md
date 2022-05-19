# Xfce 测试指引

> 版本: v0.0.1
>
> 更新时间: 2022-05-18

## 测试材料

### 安装测试与功能测试

> **注意不要下错文件!**
>
> 仅参与功能测试的朋友请跳到下一节
>
> 参与安装测试和功能测试的朋友请看本节

#### QEMU

  > TODO: Some qemu setup guide here

#### 镜像

- 在此次测试中我们选取 20220518 生成的 v0.1 版 QEMU 镜像进行测试。
- 请到镜像源下载 `fw_payload_oe_qemuvirt.elf`，`openeuler-qemu.raw.tar.zst` 与 `start_vm.sh` 三个文件，并将其放置在同一个文件夹内，保证目录中没有中文。
- [点此直达下载文件夹](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/compose/20220518/v0.1/QEMU/)

### 仅功能测试

> **注意不要下错文件!**
>
> 参与安装测试和功能测试的朋友请回到上一节
>
> 仅参与功能测试的朋友请看本节

#### QEMU

  > TODO: Some qemu setup guide here

#### 镜像

- 在此次测试中我们选取 20220518 生成的 v0.1 版 QEMU 镜像进行测试。
- 请到镜像源下载 `fw_payload_oe_qemuvirt.elf`，`openeuler-qemu-xfce.raw.tar.zst` 与 `start_vm_xfce.sh` 三个文件，并将其放置在同一个文件夹内，保证目录中没有中文。
- [点此直达下载文件夹](https://mirror.iscas.ac.cn/openeuler-sig-riscv/openEuler-RISC-V/compose/20220518/v0.1/QEMU/)

-----

## 操作指引

### 安装测试与功能测试

> 仅参与功能测试的朋友请跳到下一节
>
> 参与安装测试和功能测试的朋友请看本节

#### 设置环境与登录

- 解压 tar.zst 格式的镜像文件

  ```bash
  tar -I `zstdmt` -xvf ./openeuler-qemu.raw.tar.zst
  ```

- 执行 `ps -p $$`，确认 CMD 栏下方对应着 `bash`, `zsh` 或其他 bash 兼容 shell
- 执行 `bash start_vm.sh`，并查看 `ssh port` 的返回结果
- 执行 `ssh -p {insert your ssh port here} root@localhost`，如 `ssh -p 10255 root@localhost`
- 输入密码完成登录，默认的用户名和密码为 `root` 和 `openEuler1234`

#### 安装 `xfce4`

- 执行下列指令

```bash
yum install xorg-x11-xinit xorg-x11-server libxfce4util xfconf libxfce4ui exo garcon thunar thunar-volman tumbler xfce4-appfinder xfce4-panel xfce4-power-manager xfce4-settings xfdesktop xfwm4 xfce4-session xfce4-terminal -y
```

- 安装过程中，有些包可能会已经以依赖的形式被安装了，没关系直接跳过。


#### 启动 `xfce`

- 在视频输出窗口中输入 `startxfce4` 启动 xfce4。

```bash
startxfce4
```

- 显示效果如下图

> TODO: add image

#### 执行功能测试内容

> TODO: add functional test content

### 仅功能测试

> 参与安装测试和功能测试的朋友请回到上一节
>
> 仅参与功能测试的朋友请看本节

#### 设置环境与登录

- 解压 tar.zst 格式的镜像文件

  ```bash
  tar -I `zstdmt` -xvf ./openeuler-qemu-xfce.raw.tar.zst
  ```

- 执行 `ps -p $$`，确认 CMD 栏下方对应着 `bash`,`zsh` 或其他 bash 兼容 shell
- 执行 `bash start_vm_xfce.sh`
- 确认一个标题为 QEMU 的 GTK 窗口出现。如果没有，请查看文档的`已知问题`一节
- 等待数分钟直到图形界面出现
- 在 `lightdm` 的登录界面输入用户名和密码。默认的用户名和密码为 `root` 和 `openEuler1234` 完成登录

#### 执行功能测试内容

> TODO: add functional test content
