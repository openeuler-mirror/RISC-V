全流程参考文档：[https://gitee.com/openeuler/RISC-V/blob/master/documents/Installing.md](https://gitee.com/openeuler/RISC-V/blob/master/documents/Installing.md)



# 宿主机：在win10上安装ubuntu20.04 双系统

ubuntu镜像：ubuntu官网下载的20.04 LTS版本




# 模拟器：qemu-riscv64安装
参考文档：[https://wiki.qemu.org/Documentation/Platforms/RISCV](https://wiki.qemu.org/Documentation/Platforms/RISCV)


查看apt-get源上是否有qemu-rv64的二进制安装包：
```
$ sudo apt-get update
$ sudo apt-cache search all | grep qemu
oem-qemu-meta - Meta package for QEMU
qemu - fast processor emulator, dummy package
qemu-system - QEMU full system emulation binaries
aqemu - QEMU 和 KVM 的 Qt5 前端
grub-firmware-qemu - GRUB firmware image for QEMU
nova-compute-qemu - OpenStack Compute - compute node (QEmu)
qemu-guest-agent - Guest-side qemu-system agent
qemu-system-x86-xen - QEMU full system emulation binaries (x86)
qemu-user - QEMU user mode emulation binaries
qemu-user-binfmt - QEMU user mode binfmt registration for qemu-user
qemu-user-static - QEMU user mode emulation binaries (static version)
qemubuilder - pbuilder using QEMU as backend
```

没有，通过下载源代码自己构建的方式安装：
软件下载：[https://download.qemu.org/](https://download.qemu.org/)
按照要求，qemu版本要求是4.0.0~5.0.0之间的；我选择了5.0.0：[https://download.qemu.org/qemu-5.0.0.tar.xz](https://download.qemu.org/qemu-5.0.0.tar.xz)  

1、下载qemu源代码并构建（在构建之前ubuntu上需要安装gcc）

```
$ wget https://download.qemu.org/qemu-5.0.0.tar.xz
$ tar xvJf qemu-5.0.0.tar.xz
$ cd qemu-5.0.0
#$ ./configure --target-list=riscv64-softmmu && make
#riscv-64-linux-user为用户模式，可以运行基于riscv指令集编译的程序文件,softmmu为镜像模拟器，可以运行基于riscv指令集编译的linux镜像，为了测试方便，可以两个都安装
./configure --target-list=riscv64-softmmu,riscv64-linux-user --prefix=/home/xx/program/riscv64-qemu
$ make
$ make install  #若--prefix为根目录下的目录，就需要加sudo
```
2、配置环境变量
```
$ vim ~/.bashrc 
在文末添加：将QEMU_HOME路径替换为--prefix定义的路径
export QEMU_HOME=/home/xx/program/riscv64-qemu
export PATH=$QEMU_HOME/bin:$PATH

$ source ~/.bashrc 
$ echo $PATH
```
3、验证安装是否正确
```
$ qemu-system-riscv64 --version 

#出现类似如下输出表示 qemu 工作正常
QEMU emulator version 5.0.0
Copyright (c) 2003-2020 Fabrice Bellard and the QEMU Project developers
```



# 下载openEuler RISC-V系统镜像

由于我们的目标是运行最新版的openEuler riscv os，我们采用最新的发布版21.03：
下载oE：[https://repo.openeuler.org/openEuler-preview/RISC-V/Image/](https://repo.openeuler.org/openEuler-preview/RISC-V/Image/)
![image.png](https://cdn.nlark.com/yuque/0/2021/png/12590933/1627377517238-78ff64df-4328-46db-8a25-b611a03eaccb.png#align=left&display=inline&height=285&id=oWpqj&margin=%5Bobject%20Object%5D&name=image.png&originHeight=285&originWidth=1120&size=48561&status=done&style=none&width=1120)
将上图中的3个文件全部下载下来。




# 通过QEMU启动一个openEuler RISC-V
## 启动


使用 qemu 启动 linux： (在elf、qcow2文件所在的路径下执行)
```
$ qemu-system-riscv64 \
  -nographic -machine virt \
  -smp 8 -m 2G \
  -kernel fw_payload_oe.elf \
  -drive file=openEuler-preview.riscv64.qcow2,format=qcow2,id=hd0 \
  -object rng-random,filename=/dev/urandom,id=rng0 \
  -device virtio-rng-device,rng=rng0 \
  -device virtio-blk-device,drive=hd0 \
  -device virtio-net-device,netdev=usernet \
  -netdev user,id=usernet,hostfwd=tcp::12055-:22 \
  -append 'root=/dev/vda1 rw console=ttyS0 systemd.default_timeout_start_sec=600 selinux=0 highres=off mem=4096M earlycon'
  
  启动命令可做成Shell脚本，其中fw_payload_oe.elf与openEuler-preview.riscv64.qcow2需修改为实际下载的文件名， 并注意相对和绝对路径，如做成启动脚本则可与脚本放在同一目录下。 为ssh转发的12055端口也可改为自己需要的端口号，但截至本文撰写，ssh登录出现挂起现象，暂未解决。
```
执行情况：

```
qemu-system-riscv64: warning: No -bios option specified. Not loading a firmware.
qemu-system-riscv64: warning: This default will change in a future QEMU release. Please use the -bios option to avoid breakages when this happens.
qemu-system-riscv64: warning: See QEMU's deprecation documentation for details.

OpenSBI v0.6
   ____                    _____ ____ _____
  / __ \                  / ____|  _ \_   _|
 | |  | |_ __   ___ _ __ | (___ | |_) || |
 | |  | | '_ \ / _ \ '_ \ \___ \|  _ < | |
 | |__| | |_) |  __/ | | |____) | |_) || |_
  \____/| .__/ \___|_| |_|_____/|____/_____|
        | |
        |_|

Platform Name          : QEMU Virt Machine
Platform HART Features : RV64ACDFIMSU
Platform Max HARTs     : 8
Current Hart           : 0
Firmware Base          : 0x80000000
Firmware Size          : 120 KB
Runtime SBI Version    : 0.2

MIDELEG : 0x0000000000000222
MEDELEG : 0x000000000000b109
PMP0    : 0x0000000080000000-0x000000008001ffff (A)
PMP1    : 0x0000000000000000-0xffffffffffffffff (A,R,W,X)
[    0.000000] OF: fdt: Ignoring memory range 0x80000000 - 0x80200000
[    0.000000] Linux version 5.5.19 (abuild@oe-RISCV-worker24) (gcc version 9.3.1 (GCC)) #1 SMP Mon Nov 9 11:39:23 UTC 2020
[    0.000000] earlycon: ns16550a0 at MMIO 0x0000000010000000 (options '')
[    0.000000] printk: bootconsole [ns16550a0] enabled
[    0.000000] initrd not found or empty - disabling initrd
[    0.000000] Zone ranges:
[    0.000000]   DMA32    [mem 0x0000000080200000-0x00000000ffffffff]
[    0.000000]   Normal   empty
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000080200000-0x00000000ffffffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000080200000-0x00000000ffffffff]
[    0.000000] software IO TLB: mapped [mem 0xfa3f6000-0xfe3f6000] (64MB)
[    0.000000] SBI specification v0.2 detected
[    0.000000] SBI implementation ID=0x1 Version=0x6
[    0.000000] SBI v0.2 TIME extension detected
[    0.000000] SBI v0.2 IPI extension detected
[    0.000000] SBI v0.2 RFENCE extension detected
[    0.000000] riscv: ISA extensions acdfimsu
[    0.000000] riscv: ELF capabilities acdfim
[    0.000000] percpu: Embedded 17 pages/cpu s31256 r8192 d30184 u69632
[    0.000000] Built 1 zonelists, mobility grouping on.  Total pages: 516615
[    0.000000] Kernel command line: root=/dev/vda1 rw console=ttyS0 systemd.default_timeout_start_sec=600 selinux=0 highres=off mem=4096M earlycon
[    0.000000] Dentry cache hash table entries: 262144 (order: 9, 2097152 bytes, linear)
[    0.000000] Inode-cache hash table entries: 131072 (order: 8, 1048576 bytes, linear)
[    0.000000] Sorting __ex_table...
[    0.000000] mem auto-init: stack:off, heap alloc:off, heap free:off
[    0.000000] Memory: 1987436K/2095104K available (6331K kernel code, 403K rwdata, 2122K rodata, 222K init, 308K bss, 107668K reserved, 0K cma-reserved)
[    0.000000] SLUB: HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.
[    0.000000] NR_IRQS: 0, nr_irqs: 0, preallocated irqs: 0
[    0.000000] plic: mapped 53 interrupts with 8 handlers for 16 contexts.
[    0.000000] riscv_timer_init_dt: Registering clocksource cpuid [0] hartid [0]
[    0.000000] clocksource: riscv_clocksource: mask: 0xffffffffffffffff max_cycles: 0x24e6a1710, max_idle_ns: 440795202120 ns
[    0.000286] sched_clock: 64 bits at 10MHz, resolution 100ns, wraps every 4398046511100ns
[    0.005678] Console: colour dummy device 80x25
[    0.020790] Calibrating delay loop (skipped), value calculated using timer frequency.. 20.00 BogoMIPS (lpj=40000)
[    0.022082] pid_max: default: 32768 minimum: 301
[    0.025004] Mount-cache hash table entries: 4096 (order: 3, 32768 bytes, linear)
[    0.026058] Mountpoint-cache hash table entries: 4096 (order: 3, 32768 bytes, linear)
[    0.083507] rcu: Hierarchical SRCU implementation.
[    0.089866] smp: Bringing up secondary CPUs ...
[    0.111352] smp: Brought up 1 node, 8 CPUs
[    0.121755] devtmpfs: initialized
[    0.132616] random: get_random_u32 called from bucket_table_alloc.isra.0+0x4e/0x154 with crng_init=0
[    0.135542] clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 7645041785100000 ns
[    0.136118] futex hash table entries: 2048 (order: 5, 131072 bytes, linear)
[    0.143951] NET: Registered protocol family 16
[    0.175382] HugeTLB registered 2.00 MiB page size, pre-allocated 0 pages
[    0.191590] vgaarb: loaded
[    0.193585] SCSI subsystem initialized
[    0.196538] usbcore: registered new interface driver usbfs
[    0.197142] usbcore: registered new interface driver hub
[    0.197694] usbcore: registered new device driver usb
[    0.216605] clocksource: Switched to clocksource riscv_clocksource
[    0.237965] NET: Registered protocol family 2
[    0.242173] tcp_listen_portaddr_hash hash table entries: 1024 (order: 2, 16384 bytes, linear)
[    0.242954] TCP established hash table entries: 16384 (order: 5, 131072 bytes, linear)
[    0.243720] TCP bind hash table entries: 16384 (order: 6, 262144 bytes, linear)
[    0.246543] TCP: Hash tables configured (established 16384 bind 16384)
[    0.248811] UDP hash table entries: 1024 (order: 3, 32768 bytes, linear)
[    0.249503] UDP-Lite hash table entries: 1024 (order: 3, 32768 bytes, linear)
[    0.251593] NET: Registered protocol family 1
[    0.255169] RPC: Registered named UNIX socket transport module.
[    0.255648] RPC: Registered udp transport module.
[    0.255942] RPC: Registered tcp transport module.
[    0.256236] RPC: Registered tcp NFSv4.1 backchannel transport module.
[    0.256757] PCI: CLS 0 bytes, default 64
[    0.261791] kvm [1]: hypervisor extension not available
[    0.267861] workingset: timestamp_bits=62 max_order=19 bucket_order=0
[    0.280420] NFS: Registering the id_resolver key type
[    0.281901] Key type id_resolver registered
[    0.282238] Key type id_legacy registered
[    0.282838] nfs4filelayout_init: NFSv4 File Layout Driver Registering...
[    0.284017] 9p: Installing v9fs 9p2000 file system support
[    0.285532] NET: Registered protocol family 38
[    0.286077] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.286830] io scheduler mq-deadline registered
[    0.287213] io scheduler kyber registered
[    0.290971] pci-host-generic 30000000.pci: host bridge /soc/pci@30000000 ranges:
[    0.291956] pci-host-generic 30000000.pci:       IO 0x0003000000..0x000300ffff -> 0x0000000000
[    0.292724] pci-host-generic 30000000.pci:      MEM 0x0040000000..0x007fffffff -> 0x0040000000
[    0.300129] pci-host-generic 30000000.pci: ECAM at [mem 0x30000000-0x3fffffff] for [bus 00-ff]
[    0.301513] pci-host-generic 30000000.pci: PCI host bridge to bus 0000:00
[    0.302053] pci_bus 0000:00: root bus resource [bus 00-ff]
[    0.302417] pci_bus 0000:00: root bus resource [io  0x0000-0xffff]
[    0.302830] pci_bus 0000:00: root bus resource [mem 0x40000000-0x7fffffff]
[    0.303943] pci 0000:00:00.0: [1b36:0008] type 00 class 0x060000
[    0.418509] Serial: 8250/16550 driver, 4 ports, IRQ sharing disabled
[    0.425084] printk: console [ttyS0] disabled
[    0.426000] 10000000.uart: ttyS0 at MMIO 0x10000000 (irq = 10, base_baud = 230400) is a 16550A
[    0.427259] printk: console [ttyS0] enabled
[    0.427259] printk: console [ttyS0] enabled
[    0.427742] printk: bootconsole [ns16550a0] disabled
[    0.427742] printk: bootconsole [ns16550a0] disabled
[    0.434630] random: fast init done
[    0.434748] [drm] radeon kernel modesetting enabled.
[    0.435645] random: crng init done
[    0.457905] loop: module loaded
[    0.471927] virtio_blk virtio1: [vda] 20971520 512-byte logical blocks (10.7 GB/10.0 GiB)
[    0.489879]  vda: vda1
[    0.497305] libphy: Fixed MDIO Bus: probed
[    0.502030] e1000e: Intel(R) PRO/1000 Network Driver - 3.2.6-k
[    0.502259] e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
[    0.502962] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    0.503247] ehci-pci: EHCI PCI platform driver
[    0.503601] ehci-platform: EHCI generic platform driver
[    0.503933] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    0.504241] ohci-pci: OHCI PCI platform driver
[    0.504597] ohci-platform: OHCI generic platform driver
[    0.505340] usbcore: registered new interface driver uas
[    0.505679] usbcore: registered new interface driver usb-storage
[    0.506931] mousedev: PS/2 mouse device common for all mice
[    0.508630] usbcore: registered new interface driver usbhid
[    0.509024] usbhid: USB HID core driver
[    0.511972] NET: Registered protocol family 10
[    0.520430] Segment Routing with IPv6
[    0.520970] sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
[    0.523626] NET: Registered protocol family 17
[    0.525365] 9pnet: Installing 9P2000 support
[    0.525903] Key type dns_resolver registered
[    0.582390] EXT4-fs (vda1): recovery complete
[    0.583938] EXT4-fs (vda1): mounted filesystem with ordered data mode. Opts: (null)
[    0.584683] VFS: Mounted root (ext4 filesystem) on device 254:1.
[    0.589019] devtmpfs: mounted
[    0.608908] Freeing unused kernel memory: 220K
[    0.609190] This architecture does not have kernel memory protection.
[    0.609623] Run /sbin/init as init process
[    1.144325] systemd[1]: System time before build time, advancing clock.
[    1.347623] systemd[1]: systemd v243-22.oe1 running in system mode. (+PAM +AUDIT +SELINUX +IMA -APPARMOR +SMACK +SYSVINIT +UTMP +LIBCRYPTSETUP +GCRYPT +GNUTLS +ACL +XZ +LZ4 +SECCOMP +BLKID +ELFUTILS +KMOD +IDN2 -IDN +PCRE2 default-hierarchy=legacy)
[    1.349978] systemd[1]: Detected architecture riscv64.

Welcome to openEuler 20.03 (LTS)!

[    1.409563] systemd[1]: Set hostname to <openEuler-RISCV-rare>.
[    1.873384] systemd-rc-local-generator[97]: /etc/rc.d/rc.local is not marked executable, skipping.
[    2.078717] systemd[1]: /usr/lib/systemd/system/auditd.service:13: PIDFile= references a path below legacy directory /var/run/, updating /var/run/auditd.pid → /run/auditd.pid; please update the unit file accordingly.
[    2.259040] systemd[1]: /usr/lib/systemd/system/dbus.socket:5: ListenStream= references a path below legacy directory /var/run/, updating /var/run/dbus/system_bus_socket → /run/dbus/system_bus_socket; please update the unit file accordingly.
[    2.633558] systemd[1]: system-getty.slice: unit configures an IP firewall, but the local system does not support BPF/cgroup firewalling.
[    2.634166] systemd[1]: (This warning is only shown for the first unit using IP firewalling.)
[    2.640696] systemd[1]: Created slice system-getty.slice.
[  OK  ] Created slice system-getty.slice.
[    2.647478] systemd[1]: Created slice system-serial\x2dgetty.slice.
[  OK  ] Created slice system-serial\x2dgetty.slice.
[    2.651635] systemd[1]: Created slice system-sshd\x2dkeygen.slice.
[  OK  ] Created slice system-sshd\x2dkeygen.slice.
[  OK  ] Created slice User and Session Slice.
[  OK  ] Started Dispatch Password …ts to Console Directory Watch.
[  OK  ] Started Forward Password R…uests to Wall Directory Watch.
[  OK  ] Reached target Local Encrypted Volumes.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Remote File Systems.
[  OK  ] Reached target Slices.
[  OK  ] Reached target Swap.
[  OK  ] Listening on Process Core Dump Socket.
[  OK  ] Listening on initctl Compatibility Named Pipe.
[  OK  ] Listening on Journal Socket (/dev/log).
[  OK  ] Listening on Journal Socket.
[  OK  ] Listening on Network Service Netlink Socket.
[  OK  ] Listening on udev Control Socket.
[  OK  ] Listening on udev Kernel Socket.
         Mounting Huge Pages File System...
         Mounting POSIX Message Queue File System...
         Mounting Kernel Debug File System...
         Mounting Temporary Directory (/tmp)...
         Starting Journal Service...
         Starting Remount Root and Kernel File Systems...
         Starting Apply Kernel Variables...
         Starting udev Coldplug all Devices...
[  OK  ] Mounted Huge Pages File System.
[  OK  ] Mounted POSIX Message Queue File System.
[  OK  ] Mounted Kernel Debug File System.
[  OK  ] Mounted Temporary Directory (/tmp).
[  OK  ] Started Remount Root and Kernel File Systems.
[  OK  ] Started Apply Kernel Variables.
         Starting Load/Save Random Seed...
         Starting Create Static Device Nodes in /dev...
[  OK  ] Started Journal Service.
         Starting Flush Journal to Persistent Storage...
[  OK  ] Started Load/Save Random Seed.
[  OK  ] Started Create Static Device Nodes in /dev.
[  OK  ] Reached target Local File Systems (Pre).
[  OK  ] Reached target Local File Systems.
         Starting udev Kernel Device Manager...
[    3.826326] systemd-journald[110]: Received client request to flush runtime journal.
[    3.833705] systemd-journald[110]: File /var/log/journal/5752e0903cf6471ba6b18338c39992db/system.journal corrupted or uncleanly shut down, renaming and replacing.
[  OK  ] Started udev Kernel Device Manager.
         Starting Network Service...
[  OK  ] Started Flush Journal to Persistent Storage.
         Starting Create Volatile Files and Directories...
[  OK  ] Started Create Volatile Files and Directories.
         Starting Security Auditing Service...
         Starting Network Time Synchronization...
[  OK  ] Started Network Service.
         Starting Wait for Network to be Configured...
[FAILED] Failed to start Security Auditing Service.
See 'systemctl status auditd.service' for details.
         Starting Update UTMP about System Boot/Shutdown...
[  OK  ] Started Update UTMP about System Boot/Shutdown.
[  OK  ] Started Network Time Synchronization.
[  OK  ] Reached target System Time Set.
[  OK  ] Reached target System Time Synchronized.
[  OK  ] Found device /dev/ttyS0.
[  OK  ] Started udev Coldplug all Devices.
[  OK  ] Found device /dev/hvc0.
[  OK  ] Reached target System Initialization.
[  OK  ] Started dnf makecache --timer.
[  OK  ] Started Daily Cleanup of Temporary Directories.
[  OK  ] Reached target Timers.
[  OK  ] Listening on D-Bus System Message Bus Socket.
[  OK  ] Reached target Sockets.
[  OK  ] Reached target Basic System.
[  OK  ] Started D-Bus System Message Bus.
         Starting Network Manager...
         Starting Update RTC With System Clock...
[  OK  ] Reached target sshd-keygen.target.
         Starting Login Service...
[  OK  ] Started Update RTC With System Clock.
[  OK  ] Started Login Service.
[  OK  ] Started Network Manager.
[  OK  ] Reached target Network.
         Starting Network Manager Wait Online...
         Starting OpenSSH server daemon...
         Starting Permit User Sessions...
[  OK  ] Started Permit User Sessions.
[  OK  ] Started Getty on tty1.
[  OK  ] Started Serial Getty on hvc0.
[  OK  ] Started Serial Getty on ttyS0.
[  OK  ] Reached target Login Prompts.
         Starting Hostname Service...
[  OK  ] Started OpenSSH server daemon.
[  OK  ] Reached target Multi-User System.
[  OK  ] Reached target Graphical Interface.
         Starting Update UTMP about System Runlevel Changes...
[  OK  ] Started Update UTMP about System Runlevel Changes.
[  OK  ] Started Hostname Service.
         Starting Network Manager Script Dispatcher Service...
[  OK  ] Started Network Manager Script Dispatcher Service.
[  OK  ] Started Wait for Network to be Configured.
[  OK  ] Started Network Manager Wait Online.
[  OK  ] Reached target Network is Online.

openEuler 20.0
openEuler 20.303 (LTS)
Kernel 5.5.19 on an riscv64

 (LTS)
Kernel 5.5.19 on an riscv64

openEuler-RISCV-rare openEuler-RISCV-rarelogin:  login:
```

- 登录：root 
- 密码：openEuler12#$



登陆成功之后，可以看到如下的信息：
```
openEuler-RISCV-rare login: root
Password: 
Last login: Tue Sep  3 14:07:05 from 172.18.12.1


Welcome to 5.5.19

System information as of time: 	Tue Sep  3 09:32:35 UTC 2019

System load: 	0.15
Processes: 	107
Memory used: 	2.7%
Swap used: 	0.0%
Usage On: 	11%
Users online: 	1


[root@openEuler-RISCV-rare ~]# 
```

