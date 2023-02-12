# 使用 LVM 管理硬盘

## LVM 简介

LVM 是逻辑卷管理（Logical Volume Manager）的简称，它是 Linux 环境下对磁盘分区进行管理的一种机制。LVM 通过在硬盘和文件系统之间添加一个逻辑层，来为文件系统屏蔽下层硬盘分区布局，提高硬盘分区管理的灵活性，

使用 LVM 管理硬盘的基本过程如下：

1. 将硬盘创建为物理卷
2. 将多个物理卷组合成卷组
3. 在卷组中创建逻辑卷
4. 在逻辑卷之上创建文件系统

通过 LVM 管理硬盘之后，文件系统不再受限于硬盘的大小，可以分布在多个硬盘上，也可以动态扩容。

### 基本概念

- 物理存储介质（The physical media）：指系统的物理存储设备，如硬盘，系统中为 /dev/hda、/dev/sda 等等，是存储系统最低层的存储单元。

- 物理卷（Physical Volume，PV）：指硬盘分区或从逻辑上与磁盘分区具有同样功能的设备、（如 RAID\)，是 LVM 的基本存储逻辑块。物理卷包括一个特殊的标签，该标签默认存放在第二个 512 字节扇区，但也可以将标签放在最开始的四个扇区之一。该标签包含物理卷的随机唯一识别符（UUID），记录块设备的大小和 LVM 元数据在设备中的存储位置。

- 卷组（Volume Group，VG）：由物理卷组成，屏蔽了底层物理卷细节。可在卷组上创建一个或多个逻辑卷且不用考虑具体的物理卷信息。

- 逻辑卷（Logical Volume，LV）：卷组不能直接用，需要划分成逻辑卷才能使用。逻辑卷可以格式化成不同的文件系统，挂载后直接使用。

- 物理块（Physical Extent，PE）：物理卷以大小相等的“块”为单位存储，块的大小与卷组中逻辑卷块的大小相同。

- 逻辑块（Logical Extent，LE）：逻辑卷以“块”为单位存储，在一卷组中的所有逻辑卷的块大小是相同的。

## 安装

> **说明：**
> openEuler 操作系统默认已安装 LVM。可通过 **rpm -qa | grep lvm2** 命令查询，若打印信息中包含 lvm2 信息，则表示已安装 LVM。

1. 在 root 权限下安装 LVM。

    ```
    # dnf install lvm2
    ```

2. 查看安装后的 rpm 包。

    ```
    $ rpm -qa | grep lvm2
    ```

## 管理物理卷

### 创建物理卷

可在 root 权限下通过 pvcreate 命令创建物理卷。

```
# pvcreate [option] device ...
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -f：强制创建物理卷，不需要用户确认。
  - -u：指定设备的 UUID。
  - -y：所有的问题都回答“yes”。

- device：指定要创建的物理卷对应的设备路径，如果需要批量创建，可以填写多个设备路径，中间以空格间隔。

示例 1：将 dev/sdb、/dev/sdc 创建为物理卷。

```
# pvcreate /dev/sdb /dev/sdc
```

示例 2：将/dev/sdb1、/dev/sdb2 创建为物理卷。

```
# pvcreate /dev/sdb1 /dev/sdb2
```

### 查看物理卷

可在 root 权限通过 pvdisplay 命令查看物理卷的信息，包括：物理卷名称、所属的卷组、物理卷大小、PE 大小、总 PE 数、可用 PE 数、已分配的 PE 数和 UUID。

```
# pvdisplay [option] devname
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -s：以短格式输出。
  - -m：显示 PE 到 LE 的映射。

- devname：指定要查看的物理卷对应的设备路径。如果不指定物理卷路径，则显示所有物理卷的信息。

示例：显示物理卷 /dev/sdb 的基本信息。

```
# pvdisplay /dev/sdb
```

### 修改物理卷属性

可在 root 权限下通过 pvchange 命令修改物理卷的属性。

```
# pvchange [option] pvname ...
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -u：生成新的 UUID。
  - -x：是否允许分配 PE”。

-   pvname：指定要要修改属性的物理卷对应的设备路径，如果需要批量修改，可以填写多个设备路径，中间以空格间隔。

示例：禁止分配 /dev/sdb 物理卷上的 PE。

```
# pvchange -x n /dev/sdb
```

### 删除物理卷

可在 root 权限下通过 pvremove 命令删除物理卷。

```
pvremove [option] pvname ...
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -f：强制删除物理卷，不需要用户确认。
  - -y：所有的问题都回答“yes”。

- pvname：指定要删除的物理卷对应的设备路径，如果需要批量删除，可以填写多个设备路径，中间以空格间隔。

示例：删除物理卷 /dev/sdb

```
# pvremove /dev/sdb
```

## 管理卷组

### 创建卷组

可在 root 权限下通过 vgcreate 命令创建卷组。

```
# vgcreate [option] vgname pvname ...
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -l：卷组上允许创建的最大逻辑卷数。
  - -p：卷组中允许添加的最大物理卷数。
  - -s：卷组上的物理卷的 PE 大小。

- vgname：要创建的卷组名称。
- pvname：要加入到卷组中的物理卷名称。

示例：创建卷组 vg1，并且将物理卷 /dev/sdb 和 /dev/sdc 添加到卷组中。

```
# vgcreate vg1 /dev/sdb /dev/sdc
```

### 查看卷组

可在 root 权限下通过 vgdisplay 命令查看卷组的信息。

```
# vgdisplay [option] [vgname]
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -s：以短格式输出。
  - -A：仅显示活动卷组的属性。

- vgname：指定要查看的卷组名称。如果不指定卷组名称，则显示所有卷组的信息。

示例：显示卷组 vg1 的基本信息。

```
# vgdisplay vg1
```

### 修改卷组属性

可在 root 权限下通过 vgchange 命令修改卷组的属性。

```
# vgchange [option] vgname
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -a：设置卷组的活动状态。

- vgname：指定要修改属性的卷组名称。

示例：将卷组 vg1 状态修改为活动。

```
# vgchange -ay vg1
```

### 扩展卷组

可在 root 权限下通过 vgextend 命令动态扩展卷组。它通过向卷组中添加物理卷来增加卷组的容量。

```
# vgextend [option] vgname pvname ...
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -d：调试模式。
  - -t：仅测试。

- vgname：要扩展容量的卷组名称。
- pvname：要加入到卷组中的物理卷名称。

示例：向卷组 vg1 中添加物理卷 /dev/sdb

```
# vgextend vg1 /dev/sdb
```

### 收缩卷组

可在 root 权限下通过 vgreduce 命令删除卷组中的物理卷来减少卷组容量。不能删除卷组中剩余的最后一个物理卷。

```
# vgreduce [option] vgname pvname ...
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -a：如果命令行中没有指定要删除的物理卷，则删除所有的空物理卷。
  - \-\-removemissing：删除卷组中丢失的物理卷，使卷组恢复正常状态。

- vgname：要收缩容量的卷组名称。
- pvname：要从卷组中删除的物理卷名称。

示例：从卷组 vg1 中移除物理卷 /dev/sdb2

```
# vgreduce vg1 /dev/sdb2
```

### 删除卷组

可在 root 权限下通过 vgremove 命令删除卷组。

```
# vgremove [option] vgname
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -f：强制删除卷组，不需要用户确认。

- vgname：指定要删除的卷组名称。

示例：删除卷组 vg1。

```
# vgremove vg1
```

## 管理逻辑卷

### 创建逻辑卷

可在 root 权限下通过 lvcreate 命令创建逻辑卷。

```
# lvcreate [option] vgname
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -L：指定逻辑卷的大小，单位为“kKmMgGtT”字节。
  - -l：指定逻辑卷的大小（LE 数）。
  - -n：指定要创建的逻辑卷名称。
  - -s：创建快照。

- vgname：要创建逻辑卷的卷组名称。

示例 1：在卷组 vg1 中创建 10G 大小的逻辑卷。

```
# lvcreate -L 10G vg1
```

示例 2：在卷组 vg1 中创建 200M 的逻辑卷，并命名为 lv1。

```
# lvcreate -L 200M -n lv1 vg1
```

### 查看逻辑卷

可在 root 权限下通过 lvdisplay 命令查看逻辑卷的信息，包括逻辑卷空间大小、读写状态和快照信息等属性。

```
lvdisplay [option] [lvname]
```

其中：

- option：命令参数选项。常用的参数选项有：

- -v：显示 LE 到 PE 的映射

- lvname：指定要显示属性的逻辑卷对应的设备文件。如果省略，则显示所有的逻辑卷属性。

    > **说明：**
    >逻辑卷对应的设备文件保存在卷组目录下，例如：在卷组 vg1 上创建一个逻辑卷 lv1，则此逻辑卷对应的设备文件为 /dev/vg1/lv1。

示例：显示逻辑卷 lv1 的基本信息。

```
# lvdisplay /dev/vg1/lv1
```

### 调整逻辑卷大小

可在 root 权限下通过 lvresize 命令调整 LVM 逻辑卷的空间大小，可以增大空间和缩小空间。使用 lvresize 命令调整逻辑卷空间大小和缩小空间时需要谨慎，因为有可能导致数据丢失。

```
# lvresize [option] vgname
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -L：指定逻辑卷的大小，单位为“kKmMgGtT”字节。
  - -l：指定逻辑卷的大小（LE 数）。
  - -f：强制调整逻辑卷大小，不需要用户确认。

- lvname：指定要调整的逻辑卷名称。

示例 1：为逻辑卷 /dev/vg1/lv1 增加 200M 空间。

```
# lvresize -L +200M /dev/vg1/lv1
```

示例 2：为逻辑卷/dev/vg1/lv1 减少 200M 空间。

```
# lvresize -L -200M /dev/vg1/lv1
```

### 扩展逻辑卷

可在 root 权限下通过 lvextend 命令动态在线扩展逻辑卷的空间大小，而不中断应用程序对逻辑卷的访问。

```
# lvextend [option] lvname
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -L：指定逻辑卷的大小，单位为“kKmMgGtT”字节。
  - -l：指定逻辑卷的大小（LE 数）。
  - -f：强制调整逻辑卷大小，不需要用户确认。

- lvname：指定要扩展空间的逻辑卷的设备文件。

示例：为逻辑卷 /dev/vg1/lv1 增加 100M 空间。

```
# lvextend -L +100M /dev/vg1/lv1
```

### 收缩逻辑卷

可在 root 权限下通过 lvreduce 命令减少逻辑卷占用的空间大小。使用 lvreduce 命令收缩逻辑卷的空间大小有可能会删除逻辑卷上已有的数据，所以在操作前必须进行确认。

```
# lvreduce [option] lvname
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -L：指定逻辑卷的大小，单位为“kKmMgGtT”字节。
  - -l：指定逻辑卷的大小（LE 数）。
  - -f：强制调整逻辑卷大小，不需要用户确认。

- lvname：指定要扩展空间的逻辑卷的设备文件。

示例：将逻辑卷/dev/vg1/lv1 的空间减少 100M。

```
# lvreduce -L -100M /dev/vg1/lv1
```

### 删除逻辑卷

可在 root 权限下通过 lvremove 命令删除逻辑卷。如果逻辑卷已经使用 mount 命令挂载，则不能使用 lvremove 命令删除

```
# lvremove [option] vgname
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -f：强制删除逻辑卷，不需要用户确认。

- vgname：指定要删除的逻辑卷。

示例：删除逻辑卷/dev/vg1/lv1。

```
# lvremove /dev/vg1/lv1
```

## 创建并挂载文件系统

在创建完逻辑卷之后，需要在逻辑卷之上创建文件系统并挂载文件系统到相应目录下。

### 创建文件系统

可在 root 权限下通过 mkfs 命令创建文件系统。

```
mkfs [option] lvname
```

其中：

- option：命令参数选项。常用的参数选项有：
  - -t：指定创建的 linux 系统类型，如 ext2，ext3，ext4 等等，默认类型为 ext2。

- lvname：指定要创建的文件系统对应的逻辑卷设备文件名。

示例：在逻辑卷 /dev/vg1/lv1 上创建 ext4 文件系统。

```
# mkfs -t ext4 /dev/vg1/lv1
```

### 手动挂载文件系统

手动挂载的文件系统仅临时有效，操作系统重启则需要重新挂载。

可在 root 权限下通过 mount 命令挂载文件系统。

```
# mount lvname mntpath
```

其中：

- lvname：指定要挂载文件系统的逻辑卷设备文件名。
- mntpath：挂载路径。

示例：将逻辑卷 /dev/vg1/lv1 挂载到 /mnt/data 目录。

```
# mount /dev/vg1/lv1 /mnt/data
```

### 自动挂载文件系统

手动挂载的文件系统在操作系统重启之后需要重新手动挂载文件系统。但若在手动挂载文件系统后在 root 权限下进行如下设置，可以实现操作系统重启后自动挂载文件系统。

1. 执行 blkid 命令查询逻辑卷的 UUID，逻辑卷以 /dev/vg1/lv1 为例。

    ```
    # blkid /dev/vg1/lv1
    ```

    查看打印信息，打印信息中包含如下内容，其中 _uuidnumber_ 是一串 UUID，_fstype_ 为文件系统。

    /dev/vg1/lv1: UUID="_uuidnumber_" TYPE="_fstype_"

2.  编辑 /etc/fstab 文件，并在最后加上如下内容。

    ```
    UUID=uuidnumber  mntpath    fstype    defaults   0 0
    ```

    内容说明如下：

    - 第一列：UUID，此处填写得到的的 _uuidnumber_
    - 第二列：文件系统的挂载目录 _mntpath_
    - 第三列：文件系统的文件格式，此处填写得到的 _fstype_
    - 第四列：挂载选项，此处以"defaults"为例
    - 第五列：备份选项，设置为"1"时，系统自动对该文件系统进行备份；设置为"0"时，不进行备份。此处以"0"为例
    - 第六列：扫描选项，设置为"1"时，系统在启动时自动对该文件系统进行扫描；设置为"0"时，不进行扫描。此处以"0"为例

3. 验证自动挂载功能。
    1. 执行 umount 命令卸载文件系统，逻辑卷以 /dev/vg1/lv1 为例。

        ```
        # umount /dev/vg1/lv1
        ```

    2. 执行如下命令，挂载 /etc/fstab 文件中的设备。

        ```
        # mount -a
        ```

    3. 执行如下命令，查询文件系统挂载信息，挂载目录以 /mnt/data 为例。

        ```
        # mount | grep /mnt/data
        ```

        查看打印信息，若信息中包含如下信息表示自动挂载功能生效。

        /dev/vg1/lv1 on /mnt/data type ext4
