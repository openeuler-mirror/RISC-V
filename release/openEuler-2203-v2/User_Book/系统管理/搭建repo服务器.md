# 搭建 repo 服务器

> **说明：**
> openEuler 提供了多种 repo 源 供用户在线使用，各 repo 源含义可参考 [系统安装](./../Releasenotes/系统安装。md)。若用户无法在线获取 openEuler repo 源，则可使用 openEuler 提供的 ISO 发布包创建为本地 openEuler repo 源。本章节中以 openEuler-22.03-LTS-aarch64-dvd.iso 发布包为例，请根据实际需要的 ISO 发布包进行修改。

## 概述

将 openEuler 提供的 ISO 发布包 openEuler-22.03-LTS-aarch64-dvd.iso 创建为 repo 源，如下以使用 nginx 进行 repo 源部署，提供 http 服务为例进行说明。

## 创建/更新本地 repo 源

使用 mount 挂载，将 openEuler 的 ISO 发布包 openEuler-22.03-LTS-aarch64-dvd.iso 创建为 repo 源，并能够对 repo 源进行更新。

### 获取 ISO 发布包

请从如下网址获取 openEuler 的 ISO 发布包：

[https://repo.openeuler.org/openEuler-22.03-LTS/ISO/](https://repo.openeuler.org/openEuler-22.03-LTS/ISO/)

### 挂载 ISO 创建 repo 源

在 root 权限下使用 mount 命令挂载 ISO 发布包。

示例如下：

```
# mount /home/openeuler/openEuler-22.03-LTS-aarch64-dvd.iso /mnt/
```

挂载好的 mnt 目录如下：

```
.
│── boot.catalog
│── docs
│── EFI
│── images
│── Packages
│── repodata
│── TRANS.TBL
└── RPM-GPG-KEY-openEuler
```

其中，Packages 为 rpm 包所在的目录，repodata 为 repo 源元数据所在的目录，RPM-GPG-KEY-openEuler 为 openEuler 的签名公钥。

### 使用 bsdtar 解压 ISO 文件

```
$ bsdtar xp -C /home/openeuler/iso -f /home/openeuler/openEuler-22.03-LTS-aarch64-dvd.iso
```

### 创建本地 repo 源

可以拷贝 ISO 发布包中相关文件至本地目录以创建本地 repo 源，示例如下：

```
$ mkdir -p ~/srv/repo/
$ cp -r /mnt/Packages ~/srv/repo/
$ cp -r /mnt/repodata ~/srv/repo/
$ cp -r /mnt/RPM-GPG-KEY-openEuler ~/srv/repo/
```

从而本地 repo 目录如下：

```
.
│── Packages
│── repodata
└── RPM-GPG-KEY-openEuler
```

Packages 为 rpm 包所在的目录，repodata 为 repo 源元数据所在的目录，RPM-GPG-KEY-openEuler 为 openEuler 的签名公钥。

### 更新 repo 源

更新 repo 源有两种方式：

- 通过新版本的 ISO 更新已有的 repo 源，与创建 repo 源的方式相同，即挂载 ISO 发布包或重新拷贝 ISO 发布包至本地目录。

- 在 repo 源的 Packages 目录下添加 rpm 包，然后通过 createrepo 命令更新 repo 源

    ```
    $ createrepo --update --workers=16 ~/srv/repo
    ```

    其中，\-\-update 表示更新，\-\-workers 表示线程数，可自定义。

    > **说明：**
    >若命令打印信息为createrepo: command not found，则表示未安装 createrepo 软件，可在 root 权限下执行 **dnf install createrepo** 进行安装。

## 部署远端 repo 源

在 openEuler 上通过 nginx 部署 repo 源。

### nginx 安装与配置

1. 使用 dnf 安装 nginx 软件

    ```
    # dnf install nginx
    ```

2. 安装 nginx 之后，在 root 权限下配置 /etc/nginx/nginx.conf 文件，示例如下：

    > **说明：**
    >文档中的配置内容仅供参考，请用户根据实际情况（例如安全加固需要）进行配置。

    ```
    user  nginx;
    worker_processes  auto;
    error_log  /var/log/nginx/error.log  warn;
    pid        /var/run/nginx.pid;

    events {
        worker_connections  1024;
    }

    http {
        include       /etc/nginx/mime.types;
        default_type  application/octet-stream;

        log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                          '$status $body_bytes_sent "$http_referer" '
                          '"$http_user_agent" "$http_x_forwarded_for"';

        access_log  /var/log/nginx/access.log  main;
        sendfile        on;
        keepalive_timeout  65;

        server {
            listen       80;
            server_name  localhost;
            client_max_body_size 4G;
            root         /srv/repo;

            location / {
                autoindex            on;
                autoindex_exact_size on;
                autoindex_localtime  on;
            }

        }

    }
    ```

### 启动 nginx 服务

1. 在 root 权限下通过 systemd 启动 nginx 服务：

    ```
    # systemctl start nginx
    ```

2. nginx 服务状态可通过下面命令查看：

    ```
    $ systemctl status nginx
    ```

    若服务状态为 active (running)，则表示 nginx 服务启动成功。

    - 若 nginx 服务启动失败，查看错误信息：

    ```
    $ systemctl status nginx.service --full
    ```

### repo 源部署

1. 在 root 权限下修改目录/srv/repo 的权限：

    ```
    # chmod -R 755 /srv/repo
    ```

2. 重新启动 nginx 服务：

    ```
    # systemctl restart nginx
    ```

## 使用 repo 源

创建好的 repo 可配置为 yum 源

### repo 配置为 yum 源（软件源）

构建好的 repo 可以配置为 yum 源使用，在/etc/yum.repos.d/目录下使用 root 权限创建 .repo 的配置文件（必须以 repo 为扩展名），分为本地文件源和 http 服务器源两种方式：

- 配置本地 yum 源

    在/etc/yum.repos.d 目录下创建 openEuler.repo 文件，使用构建的本地 repo 源作为 yum 源，openEuler.repo 的内容如下：

    ```
    [base]
    name=base
    baseurl=file:///srv/repo
    enabled=1
    gpgcheck=1
    gpgkey=file:///srv/repo/RPM-GPG-KEY-openEuler
    ```

    > **说明：**
    > \[*repoid*\] 中的 repoid 为软件仓库（repository）的 ID 号，所有。repo 配置文件中的各 repoid 不能重复，必须唯一。示例中 repoid 设置为 **base**。
    > name 为软件仓库描述的字符串。
    > baseurl 为软件仓库的地址。
    > enabled 为是否启用该软件源仓库，可选值为 1 和 0。默认值为 1，表示启用该软件源仓库。
    > gpgcheck 可设置为 1 或 0，1 表示进行 gpg（GNU Private Guard）校验，0 表示不进行 gpg 校验，gpgcheck 可以确定 rpm 包的来源是有效和安全的。
    > gpgkey 为验证签名用的公钥。

- 配置 http 服务器 yum 源

    在/etc/yum.repos.d 目录下创建 openEuler.repo 文件。

  - 若使用用户部署的 http 服务端的 repo 源作为 yum 源，openEuler.repo 的内容如下：

        ```
        [base]
        name=base
        baseurl=http://192.168.139.209/
        enabled=1
        gpgcheck=1
        gpgkey=http://192.168.139.209/RPM-GPG-KEY-openEuler
        ```

        > **说明：**
        > "192.168.139.209"为示例地址，请用户根据实际情况进行配置。

  - 若使用 openEuler 提供的 openEuler repo 源作为 yum 源，以 aarch64 架构的 OS repo 源为例，openEuler.repo 的内容如下：

        ```
        [base]
        name=base
        baseurl=http://repo.openeuler.org/openEuler-22.03-LTS/OS/aarch64/
        enabled=1
        gpgcheck=1
        gpgkey=http://repo.openeuler.org/openEuler-22.03-LTS/OS/aarch64/RPM-GPG-KEY-openEuler
        ```

### repo 优先级

当有多个 repo 源时，可通过在。repo 文件的 priority 参数设置 repo 的优先级（如果不设置，默认优先级是 99，当相同优先级的源中存在相同 rpm 包时，会安装最新的版本）。其中，1 为最高优先级，99 为最低优先级，如给 openEuler.repo 配置优先级为 2：

```
[base]
name=base
baseurl=http://192.168.139.209/
enabled=1
priority=2
gpgcheck=1
gpgkey=http://192.168.139.209/RPM-GPG-KEY-openEuler
```

### dnf 相关命令

dnf 命令在安装升级时能够自动解析包的依赖关系，一般的使用方式如下：

```
dnf <command> <packages name>
```

常用的命令如下：

- 安装，需要在 root 权限下执行。

    ```
    # dnf install <packages name>
    ```

- 升级，需要在 root 权限下执行。

    ```
    # dnf update <packages name>
    ```

- 检查更新

    ```
    $ dnf check-update
    ```

- 卸载，需要在 root 权限下执行。

    ```
    # dnf remove <packages name>
    ```

- 查询

    ```
    $ dnf search <packages name>
    ```

- 本地安装，需要在 root 权限下执行。

    ```
    # dnf localinstall <rpm_package_path>
    ```

- 查看历史记录

    ```
    $ dnf history
    ```

- 清除缓存目录

    ```
    $ dnf clean all
    ```

- 更新缓存

    ```
    $ dnf makecache
    ```
