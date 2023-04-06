# 搭建 FTP 服务器

## 总体介绍

### FTP 简介

FTP（File Transfer Protocol）即文件传输协议，是互联网最早的传输协议之一，其最主要的功能是服务器和客户端之间的文件传输。FTP 使用户可以通过一套标准的命令访问远程系统上的文件，而不需要直接登录远程系统。另外，FTP 服务器还提供了如下主要功能：

- 用户分类
    默认情况下，FTP 服务器依据登录情况，将用户分为实体用户（real user）、访客（guest）、匿名用户（anonymous）三类。三类用户对系统的访问权限差异较大，实体用户具有较完整的访问权限，匿名用户仅有下载资源的权限。

- 命令记录和日志文件记录
    FTP 可以利用系统的 syslogd 记录数据，这些数据包括用户历史使用命令与用户传输数据（传输时间、文件大小等），用户可以在 /var/log/ 中获得各项日志信息。

- 限制用户的访问范围
    FTP 可以将用户的工作范围限定在用户主目录。用户通过 FTP 登录后系统显示的根目录就是用户主目录，这种环境被称为 change root，简称 chroot。这种方式可以限制用户只能访问主目录，而不允许访问 /etc、/home、/usr/local 等系统的重要目录，从而保护系统，使系统更安全。

### FTP 使用到的端口

FTP 的正常工作需要使用到多个网络端口，服务器端会使用到的端口主要有：

- 命令通道，默认端口为 21
- 数据通道，默认端口为 20

两者的连接发起端不同，端口 21 接收来自客户端的连接，端口 20 则是 FTP 服务器主动连接至客户端。

### vsftpd 简介

由于 FTP 历史悠久，它采用未加密的传输方式，所以被认为是一种不安全的协议。为了更安全地使用 FTP，这里介绍 FTP 较为安全的守护进程 vsftpd（Very Secure FTP Daemon）。

之所以说 vsftpd 安全，是因为它最初的发展理念就是构建一个以安全为中心的 FTP 服务器。它具有如下特点：

- vsftpd 服务的启动身份为一般用户，具有较低的系统权限。此外，vsftpd 使用 chroot 改变根目录，不会误用系统工具。
- 任何需要较高执行权限的 vsftpd 命令均由一个特殊的上层程序控制，该上层程序的权限较低，以不影响系统本身为准。
- vsftpd 整合了大部分 FTP 会使用到的额外命令（例如 dir、ls、cd 等），一般不需要系统提供额外命令，对系统来说比较安全。

## 使用 vsftpd

### 安装 vsftpd

使用 vsftpd 需要安装 vsftpd 软件，在已经配置 yum 源的情况下，通过 root 权限执行如下命令，即可完成 vsftpd 的安装。

```
# dnf install vsftpd
```

### 管理 vsftpd 服务

启动、停止和重启 vsftpd 服务，请在 root 权限下执行对应命令。

- 启动 vsftpd 服务

    ```
    # systemctl start vsftpd
    ```

    可以通过 netstat 命令查看通信端口 21 是否开启，如下显示说明 vsftpd 已经启动。

    ```
    # netstat -tulnp | grep 21
    tcp6       0      0 :::21                   :::*                    LISTEN      19716/vsftpd
    ```

- 停止 vsftpd 服务

    ```
    # systemctl stop vsftpd
    ```

- 重启 vsftpd 服务

    ```
    # systemctl restart vsftpd
    ```

## 配置 vsftpd

### vsftpd 配置文件介绍

用户可以通过修改 vsftpd 的配置文件，控制用户权限等。vsftpd 的主要配置文件和含义如表 1所示，用户可以根据需求修改配置文件的内容。

**表 1** vsftpd 配置文件介绍
| 配置文件 | 含义 |
| -------- | ---- |
| /etc/vsftpd/vsftpd.conf | vsftpd 的主要配置文件 |
| /etc/pam.d/vsftpd | vsftpd 的 PAM 配置文件 |
| /etc/vsftpd/ftpusers | 禁止访问 vsftpd 的用户列表 |
| /etc/vsftpd/user_list | 禁止或允许访问 vsftpd 的用户列表，取决于主配置文件 vsftpd.conf 的参数 |

### 默认配置说明

openEuler 系统中 ，vsftpd 默认不开放匿名用户，查看主配置文件 /etc/vsftpd/vsftpd.conf，其内容如下：

```
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
```

### 配置本地时间

#### 概述

openEuler 系统中，vsftpd 默认使用 GMT 时间（格林尼治时间），可能和本地时间不一致，例如 GMT 时间比北京时间晚 8 小时，请用户改为本地时间，否则服务器和客户端时间不一致，在上传下载文件时可能引起错误。

#### 设置方法

在 root 权限下设置 vsftpd 时间为本地时间的操作步骤如下：

1. 编辑配置文件 /etc/vsftpd/vsftpd.conf，将参数 use\_localtime 的参数值改为 YES

    需要加入的配置行如下：

    ```
    use_localtime=YES
    ```

2. 重启 vsftpd 服务。

    ```
    # systemctl restart vsftpd
    ```

### 配置欢迎信息

在 root 权限下设置 vsftp 的欢迎信息 welcome.txt 文件的操作步骤如下：

1. 编辑配置文件 /etc/vsftpd/vsftpd.conf，加入欢迎信息文件配置内容。

    需要加入的配置行如下：

    ```
    banner_file=/etc/vsftpd/welcome.txt
    ```

2. 建立欢迎信息。即编辑 /etc/vsftpd/welcome.txt 文件，写入欢迎信息。

    ```
    # vim /etc/vsftpd/welcome.txt
    ```

    欢迎信息举例如下：

    ```
    Welcome to this FTP server!
    ```

### 配置系统帐号登录权限

一般情况下，用户需要限制部分帐号的登录权限。用户可根据需要进行配置。

限制系统帐号登录的文件有两个，默认如下：

- /etc/vsftpd/ftpusers：受 /etc/pam.d/vsftpd 文件的设置影响，由 PAM 模块掌管。
- /etc/vsftpd/user\_list：由 vsftpd.conf 的 userlist\_file 设置，由 vsftpd 主动提供。


打开 user\_list 可以查看当前文件中包含的帐号信息，命令和回显如下：

```
$ vim /etc/vsftpd/user_list
root
bin
daemon
adm
lp
sync
shutdown
halt
mail
news
uucp
operator
games
nobody
```

## 验证 FTP 服务是否搭建成功

可以使用 openEuler repo 提供的 FTP 客户端进行验证。命令和回显如下，根据提示输入用户名（用户为系统中存在的用户）和密码。如果显示 Login successful，即说明 FTP 服务器搭建成功。

```
$ ftp localhost
Trying 127.0.0.1...
Connected to localhost (127.0.0.1).
220-Welcome to this FTP server!
220
Name (localhost:root): USERNAME
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> bye
221 Goodbye.
```

> **说明：**
> 如果没有 **ftp** 命令，可以在 root 权限下执行 **dnf install ftp** 命令安装后再使用 **ftp** 命令。

## 传输文件

### 概述

这里给出 vsftpd 服务启动后，如何进行文件传输的指导。

### 连接服务器

**命令格式**

```
$ ftp [ hostname | ip-address ]
```

其中 _hostname_ 为服务器名称，_ip-address_ 为服务器 IP 地址。

**操作说明**

在 openEuler 系统的命令行终端，执行如下命令：

```
$ ftp ip-address
```

根据提示输入用户名和密码，认证通过后显示如下，说明 ftp 连接成功，此时进入了连接到的服务器目录。

```
ftp>
```

在该提示符下，可以输入不同的命令进行相关操作：

- 显示服务器当前路径

    ```
    ftp> pwd
    ```

- 显示本地路径，用户可以将该路径下的文件上传到 FTP 服务器对应位置

    ```
    ftp> lcd
    ```

- 退出当前窗口，返回本地 Linux 终端

    ```
    ftp>！
    ```

### 下载文件

通常使用 get 或 mget 命令下载文件。

**get 使用方法**

- 功能说明：将文件从远端主机中传送至本地主机中
- 命令格式

    ```
    get  remote-file local-file
    ```

    其中 _remote-file_  为远程文件，_local-file_  为本地文件

- 示例：获取远程服务器上的/home/openEuler/openEuler.htm 文件到本地/home/myopenEuler/，并改名为 myopenEuler.htm，命令如下：

    ```
    ftp> get /home/openEuler/openEuler.htm /home/myopenEuler/myopenEuler.htm
    ```

**mget 使用方法**

- 功能说明：从远端主机接收一批文件至本地文件
- 命令格式

    ````
    mget  remote-file
    ````

    其中 _remote-file_  为远程文件

- 示例：获取服务器上 /home/openEuler/ 目录下的所有文件，命令如下：

    ```
    ftp> cd /home/openEuler/
    ftp> mget *.*
    ```

    > **说明：**
    >- 此时每下载一个文件，都会有提示信息。如果要屏蔽提示信息，则在 **mget \*.\*** 命令前先执行 **prompt off**
    >- 文件都被下载到当前目录下。比如，在  /home/myopenEuler/ 下运行的 ftp 命令，则文件都下载到 /home/myopenEuler/ 下。

### 上传文件

通常使用 put 或 mput 命令上传文件。

**put 使用方法**

- 功能说明：将本地的一个文件传送到远端主机中
- 命令格式

    ````
    put  local-file remote-file
    ````

    其中 _remote-file_ 为远程文件，_local-file_ 为本地文件

- 示例：将本地的 myopenEuler.htm 传送到远端主机/home/openEuler/，并改名为 openEuler.htm，命令如下：

    ```
    ftp> put myopenEuler.htm /home/openEuler/openEuler.htm
    ```

**mput 使用方法**

- 功能说明：将本地主机中一批文件传送至远端主机
- 命令格式：

    ```
    mput local-file
    ```

    其中 _local-file_  为本地文件

- 示例：将本地当前目录下所有 htm 文件上传到服务器/home/openEuler/下，命令如下：

    ```
    ftp> cd /home/openEuler/
    ftp> mput *.htm
    ```

### 删除文件

通常使用 delete 或 mdelete 命令删除文件。

**delete 使用方法**

- 功能说明：删除远程服务器上的一个或多个文件
- 命令格式

    ```
    delete remote-file
    ```

    其中 _remote-file_  为远程文件

- 示例：删除远程服务器上/home/openEuler/下的 openEuler.htm 文件，命令如下：

    ```
    ftp> cd /home/openEuler/
    ftp> delete openEuler.htm
    ```

**mdelete 使用方法**

- 功能说明：删除远程服务器上的文件，常用于批量删除
- 命令格式：

    ```
    mdelete remote-file
    ```

    其中 _remote-file_  为远程文件

- 示例：删除远程服务器上/home/openEuler/下所有 a 开头的文件，命令如下：

    ```
    ftp> cd /home/openEuler/
    ftp> mdelete a*
    ```

### 断开服务器

断开与服务器的连接，使用 bye 命令，如下：

```
ftp> bye
```
