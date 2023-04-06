# 搭建 web 服务器

## Apache 服务器

### 概述

Web（World Wide Web）是目前最常用的 Internet 协议之一。目前在 Unix-Like 系统中的 web 服务器主要通过 Apache 服务器软件实现。为了实现运营动态网站，产生了 LAMP（Linux + Apache + MySQL + PHP）。web 服务可以结合文字、图形、影像以及声音等多媒体，并支持超链接（Hyperlink）的方式传输信息。

### 安装

要安装 Apache HTTP 服务器，在 root 权限下执行以下命令：

```
# dnf install httpd
```

### 管理 httpd

#### 概述

通过 systemctl 工具，可以对 httpd 服务进行管理，包括启动、停止、重启服务，以及查看服务状态等。本章介绍 Apache HTTP 服务的管理操作，以指导用户使用。

#### 启动服务

- 启动并运行 httpd 服务，命令如下：

    ```
    # systemctl start httpd
    ```

- 假如希望在系统启动时，httpd 服务自动启动，则命令和回显如下：

    ```
    # systemctl enable httpd
    Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
    ```

#### 停止服务

- 停止运行的 httpd 服务，命令如下：

    ```
    # systemctl stop httpd
    ```

- 如果不希望服务在系统开机阶段自动开启，命令和回显如下：

    ```
    # systemctl disable httpd
    Removed /etc/systemd/system/multi-user.target.wants/httpd.service.
    ```

#### 重启服务

重启服务有三种方式：

- 完全重启服务

    ```
    # systemctl restart httpd
    ```

    该命令会停止运行 httpd 服务并且立即重新启动。一般在服务安装以后或者去除一个动态加载的模块（例如 PHP）时使用这个命令。

- 重新加载配置

    ```
    # systemctl reload httpd
    ```

    该命令会使运行的 httpd 服务重新加载它的配置文件。任何当前正在处理的请求将会被中断，从而造成客户端浏览器显示一个错误消息或者重新渲染部分页面。

- 重新加载配置而不影响激活的请求

    ```
    # apachectl graceful
    ```

    该命令会使运行的 httpd 服务重新加载它的配置文件。任何当前正在处理的请求将会继续使用旧的配置文件。

#### 验证服务状态

验证 httpd 服务是否正在运行

```
$ systemctl is-active httpd
```

回显为"active"说明服务处于运行状态。

### 配置文件说明

当 httpd 服启动后，默认情况下它会读取如表 1所示的配置文件。

**表 1**  配置文件说明

| 配置文件 | 说明 |
| ------- | ---- |
| /etc/httpd/conf/httpd.conf | httpd 服务的主配置文件 |
| /etc/httpd/conf.d/*.conf | httpd 服务的附加配置文件 |

虽然默认配置可以适用于多数情况，但是用户至少需要熟悉里面的一些重要配置项。配置文件修改完成后，可使用如下命令检查配置文件可能出现的语法错误。

```
$ apachectl configtest
```

如果回显如下，说明配置文件语法正确。

```
Syntax OK
```

> **说明：**
> - 在修改配置文件之前，请先备份原始文件，以便出现问题时能够快速恢复配置文件。
> - 需要重启 web 服务，才能使修改后的配置文件生效。

### 管理模块和 SSL

#### 概述

httpd 服务是一个模块化的应用，它和许多动态共享对象 DSO（Dynamic Shared Objects）一起分发。动态共享对象 DSO，在必要情况下，可以在运行时被动态加载或卸载。服务器操作系统中这些模块位于 /usr/lib64/httpd/modules/ 目录下。本节介绍如何加载模块。

#### 加载模块

为了加载一个特殊的 DSO 模块，在配置文件中使用加载模块指示。独立软件包提供的模块一般在 /etc/httpd/conf.modules.d 目录下有自己的配置文件。

例如，加载 asis DSO 模块的操作步骤如下：

1. 在 /etc/httpd/conf.modules.d/00-optional.conf 文件中，取消注释如下配置行。

    ```
    LoadModule asis_module modules/mod_asis.so
    ```

2. 重启 httpd 服务加载模块

    ```
    # systemctl restart httpd
    ```

3. 加载完成后，在 root 权限下使用 httpd -M 的命令查看是否已经加载了 asis DSO 模块。

    ```
    # httpd -M | grep asis
    ```

    回显如下，说明 asis DSO 模块加载成功。

    ```
    asis_module (shared)
    ```

> **说明：**
> **httpd 的常用命令**
>
> - httpd -v : 查看 httpd 的版本号。
> - httpd -l：查看编译进 httpd 程序的静态模块。
> - httpd -M：查看编译进 httpd 程序的静态模块和已经加载的动态模块。

#### SSL 介绍

安全套接层 SSL（Secure Sockets Layer）是一个允许服务端和客户端之间进行安全通信的加密协议。其中，传输层安全性协议 TLS（Transport Layer Security）为网络通信提供了安全性和数据完整性保障。openEuler 支持 Mozilla NSS（Network Security Services）作为安全性协议 TLS 进行配置。加载 SSL 的操作步骤如下：

1. 在 root 权限下安装 mod\_ssl 的 rpm 包。

    ```
    # dnf install mod_ssl
    ```

2. 安装完成后，请在 root 权限下重启 httpd 服务以便于重新加载配置文件。

    ```
    # systemctl restart httpd
    ```

3. 加载完成后，在 root 权限下使用 httpd -M 的命令查看是否已经加载了 SSL。

    ```
    # httpd -M | grep ssl
    ```

    回显如下，说明 SSL 已加载成功。

    ```
    ssl_module (shared)
    ```

### 验证 web 服务是否搭建成功

Web 服务器搭建完成后，可以通过如下方式验证是否搭建成功。

1. 在 root 权限下查看服务器的 IP 地址，命令如下：

    ```
    # ifconfig
    ```

    回显信息如下，说明服务器 IP 为 10.0.2.15

    ```
    eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
            inet6 fe80::755d:9093:521d:a487  prefixlen 64  scopeid 0x20<link>
            inet6 fec0::8ff1:c51d:49c4:66b8  prefixlen 64  scopeid 0x40<site>
            ether 52:54:00:12:34:56  txqueuelen 1000  (Ethernet)
            RX packets 42029  bytes 59363087 (56.6 MiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 3743  bytes 384835 (375.8 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 127.0.0.1  netmask 255.0.0.0
            inet6 ::1  prefixlen 128  scopeid 0x10<host>
            loop  txqueuelen 1000  (Local Loopback)
            RX packets 90  bytes 10747 (10.4 KiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 90  bytes 10747 (10.4 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
    ```

2. 验证 web 服务器是否搭建成功，用户可选择 Linux 或 Windows 系统进行验证。
    - 使用 Linux 系统验证

        执行如下命令，查看是否可以访问网页信息，服务搭建成功时，该网页可以正常访问。

        ```
        $ curl http://10.0.2.15
        ```

    - 使用 Windows 系统验证

        打开浏览器，在地址栏输入如下地址，如果能正常访问网页，说明 httpd 服务器搭建成功。

        http://10.0.2.15

## Nginx 服务器

### 概述

Nginx 是一款轻量级的 Web 服务器/反向代理服务器及电子邮件（IMAP/POP3）代理服务器，其特点是占有内存少，并发能力强，支持 FastCGI、SSL、Virtual Host、URL Rewrite、Gzip 等功能，并且支持很多第三方的模块扩展。

### 安装

要安装 Nginx 服务器，在 root 权限下执行以下命令：

```
# dnf install nginx
```

### 管理 nginx

#### 概述

通过 systemctl 工具，可以对 nginx 服务进行管理，包括启动、停止、重启服务，以及查看服务状态等。本章介绍 nginx 服务的管理操作，以指导用户使用。

#### 启动服务

- 启动并运行 nginx 服务，命令如下：

    ```
    # systemctl start nginx
    ```

- 假如希望在系统启动时，nginx 服务自动启动，则命令和回显如下：

    ```
    # systemctl enable nginx
    Created symlink /etc/systemd/system/multi-user.target.wants/nginx.service → /usr/lib/systemd/system/nginx.service.
    ```

#### 停止服务

- 停止运行的 nginx 服务，命令如下：

    ```
    # systemctl stop nginx
    ```

- 如果不希望服务在系统开机阶段自动开启，命令和回显如下：

    ```
    # systemctl disable nginx
    Removed /etc/systemd/system/multi-user.target.wants/nginx.service.
    ```

#### 重启服务

重启服务有三种方式：

- 完全重启服务

    ```
    # systemctl restart nginx
    ```

    该命令会停止运行的 nginx 服务并且立即重新启动它。一般在服务安装以后或者去除一个动态加载的模块（例如 PHP）时使用这个命令。

- 重新加载配置

    ```
    # systemctl reload nginx
    ```

    该命令会使运行的 nginx 服务重新加载它的配置文件。任何当前正在处理的请求将会被中断，从而造成客户端浏览器显示一个错误消息或者重新渲染部分页面。

- 平滑重启 nginx

    ```
    # nginx -s reload
    ```

    该命令会使运行的 nginx 服务重新加载它的配置文件。任何当前正在处理的请求将会继续使用旧的配置文件。

#### 验证服务状态

验证 nginx 服务是否正在运行

```
$ systemctl is-active nginx
```

回显为"active"说明服务处于运行状态。

### 配置文件说明

当 nginx 服启动后，默认情况下它会读取如表 2 所示的配置文件。

**表 2**  配置文件说明

| 配置文件 | 说明 |
| -------- | ---- |
| /etc/nginx/nginx.conf | 主配置文件 |
| /etc/nginx/conf.d/*.conf | 附加配置文件 |

虽然默认配置可以适用于多数情况，但是用户至少需要熟悉里面的一些重要配置项。配置文件修改完成后，可以在 root 权限下使用如下命令检查配置文件可能出现的语法错误。

```
# nginx -t
```

如果回显信息中有"syntax is ok"，说明配置文件语法正确。

> **说明：**
> - 在修改配置文件之前，请先备份原始文件，以便出现问题时能够快速恢复配置文件。
> - 需要重启 web 服务，才能使修改后的配置文件生效。

### 管理模块

#### 概述

nginx 服务是一个模块化的应用，它和许多动态共享对象 DSO（Dynamic Shared Objects）一起分发。动态共享对象 DSO，在必要情况下，可以在运行时被动态加载或卸载。服务器操作系统中这些模块位于 /usr/lib64/nginx/modules/ 目录下。本节介绍如何加载和写入模块。

#### 加载模块

为了加载一个特殊的 DSO 模块，在配置文件中使用加载模块指示。独立软件包提供的模块一般在 /usr/share/nginx/modules 目录下有自己的配置文件。

### 验证 web 服务是否搭建成功

Web 服务器搭建完成后，可以通过如下方式验证是否搭建成功。

1. 在 root 权限下查看服务器的 IP 地址，命令如下：

    ```
    # ifconfig
    ```

    回显信息如下，说明服务器 IP 为 10.0.2.15

    ```
    eth0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
            inet 10.0.2.15  netmask 255.255.255.0  broadcast 10.0.2.255
            inet6 fe80::755d:9093:521d:a487  prefixlen 64  scopeid 0x20<link>
            inet6 fec0::8ff1:c51d:49c4:66b8  prefixlen 64  scopeid 0x40<site>
            ether 52:54:00:12:34:56  txqueuelen 1000  (Ethernet)
            RX packets 42029  bytes 59363087 (56.6 MiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 3743  bytes 384835 (375.8 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

    lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
            inet 127.0.0.1  netmask 255.0.0.0
            inet6 ::1  prefixlen 128  scopeid 0x10<host>
            loop  txqueuelen 1000  (Local Loopback)
            RX packets 90  bytes 10747 (10.4 KiB)
            RX errors 0  dropped 0  overruns 0  frame 0
            TX packets 90  bytes 10747 (10.4 KiB)
            TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
    ```

2. 验证 web 服务器是否搭建成功，用户可选择 Linux 或 Windows 系统进行验证。
    - 使用 Linux 系统验证

        执行如下命令，查看是否可以访问网页信息，服务搭建成功时，该网页可以正常访问。

        ```
        $ curl http://10.0.2.15
        ```

    - 使用 Windows 系统验证

        打开浏览器，在地址栏输入如下地址，如果能正常访问网页，说明 httpd 服务器搭建成功。

        http://10.0.2.15
