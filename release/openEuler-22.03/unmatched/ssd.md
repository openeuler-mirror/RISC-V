# 从NVMe驱动器启动openEuler-22.03-V1 

## 1. 启动的制作 

使用NVMe驱动器来启动Unmatched会在性能与可用性方面有很大的提升，所以强烈推荐，尽可能的使用它。

**前提条件：SSD应先完成格式化，如SSD已有其它操作系统，请参考以下文档4.1.1 启动模式选择DIP开关解决 **

[HiFive Unmatched入门指南](./hifive-unmatched-gsg-v1p4_ZH.pdf)

- 从SD卡启动
- 将openEuler RISC-V镜像复制或下载到SD卡上
- 将其解压。为了方便输入其名称，请将其改名为易于输入的名称。例如，可以将其改名为`openEuler.img`
- 通过执行以下指令，保证设备有NVMe驱动。

```bash
ls -l /dev/nvme*
```

- 执行完这个代码以后，有可能会出现`/dev/nvme0n1`这样一个NVMe驱动器。这样，通过执行以下指令，就可以将镜像烧录到这个NVMe中。

注：此步拷贝时间较长，如你有SSD外接硬盘盒，建议直接使用电脑外接SSD硬盘盒，执行以下步骤，以节省时间。

```bash
sudo dd if=./openEuler-22.03-V1-riscv64-unmatched-xfce.img of=/dev/nvme0n1 bs=1M status=progress
```

- 然后将NVMe驱动器中的根分区挂载到/mnt然后chroot进这个环境。在这种情况下，rootfs往往会在第三分区，也就是`/dev/nvme0n1p3`

```bash
sudo mount /dev/nvme0n1p3 /mnt
sudo chroot /mnt
```

- 使用你最喜欢用的文本编辑器(可以使用vim和nano)去编辑`vim /boot/extlinux/extlinux.conf`这个文件，在SD卡上改变根分区，即

```bash
root=/dev/mmcblk0p3
```

将其改为NVMe上的根分区，即

```bash
root=/dev/nvme0n1p3
```

- `exit`退出chroot环境，然后以同样的方法来编辑 `vim /boot/extlinux/extlinux.conf`文件。

- 重启系统后，它将从NVMe驱动器启动。

## 2. SSD下存储扩容方法

当我们使用`dd`来烧录镜像时，储存设备中总会在末尾留一部分空余空间，这是因为镜像大小会小于储存空间大小。对 openEuler RISC-V的镜像，根分区会在第一次从SD卡启动后会被自动调整大小以使有足够的可利用空间。这个工作是由 `/usr/lib/oE-script/resize-rootfs`脚本来做的，然而，这个脚本有一些硬编码变量，所以只适用于SD卡。

用户可以用以下指令来使它适用于NVMe驱动器。比如，假设NVMe驱动器是`/dev/nvme0n1`：

```bash
sed -i 's#/dev/mmcblk0#/dev/nvme0n1#g' /usr/lib/oE-script/resize-rootfs
```

并在 NVMe 驱动器上的根分区上为脚本设置一个配置项：

```bash
touch /.resize-rootfs
```

**Reference**

- [How to install Ubuntu on RISC-V HiFive boards（如何在RISC-V HiFive开发版中安装Ubuntu）](https://ubuntu.com/tutorials/how-to-install-ubuntu-on-risc-v-hifive-boards)

- [Installing Debian On SiFive HiFive Unmatched（在SiFive HiFive Unmatched中安装Debian）](https://wiki.debian.org/InstallingDebianOn/SiFive/HiFiveUnmatched)
