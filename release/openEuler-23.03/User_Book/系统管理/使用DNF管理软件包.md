# 使用 DNF 管理软件包

DNF 是一款 Linux 软件包管理工具，用于管理 RPM 软件包。DNF 可以查询软件包信息，从指定软件库获取软件包，自动处理依赖关系以安装或卸载软件包，以及更新系统到最新可用版本。

> **说明：**
> DNF 与 YUM 完全兼容，提供了与 YUM 兼容的命令行以及为扩展和插件提供的 API。

## 配置 DNF

### DNF 配置文件

DNF 的主要配置文件是 /etc/dnf/dnf.conf，该文件的 main 部分为 DNF 的全局设置。

另外，在 /etc/yum.repos.d 目录中保存着一个或多个 repo 源相关文件，它们也可以定义不同的 repository 。

所以 openEuler 软件源的配置一般有两种方式，一种是编辑 /etc/dnf/dnf.conf 文件，另外一种是修改或新增 /etc/yum.repos.d 目录的 .repo 文件。

#### 配置 main 部分

/etc/dnf/dnf.conf 文件包含的 main 部分，配置示例如下：

```
[main]
gpgcheck=1
installonly_limit=3
clean_requirements_on_remove=True
best=True
```

常用选项说明：

**表 1**  main 参数说明

| 参数 | 说明 |
| ---- | ---- |
| cachedir | 缓存目录，该目录用于存储 RPM 包和数据库文件。默认为 /var/cache/dnf |
| keepcache | 是否保留缓存，表示是否要缓存已安装成功的那些 RPM 包及头文件，默认值为 False，即不缓存。 |
| debuglevel | 设置 DNF 生成的 debug 信息。取值范围：\[0-10\]，数值越大会输出越详细的 debug 信息。默认值为 2，设置为 0 表示不输出 debug 信息。 |
| clean_requirements_on_remove | 删除在 dnf remove 期间不再使用的依赖项，如果软件包是通过 DNF 安装的，而不是通过显式用户请求安装的，则只能通过 clean_requirements_on_remove 删除软件包，即它是作为依赖项引入的。 默认值为 True。 |
| best | 升级包时，总是尝试安装其最高版本，如果最高版本无法安装，则提示无法安装的原因并停止安装。默认值为 True。 |
| obsoletes | 可选值 1 和 0，设置是否允许更新陈旧的 RPM 包。默认值为 1，表示允许更新。 |
| gpgcheck | 可选值 1 和 0，设置是否进行 GPG 校验。默认值为 1，表示需要进行校验。 |
| plugins | 可选值 1 和 0，表示启用或禁用 DNF 插件。默认值为 1，表示启用 DNF 插件。 |
| installonly_limit | 设置可以同时安装 installonlypkgs 指令列出包的数量。默认值为 3，不建议降低此值。 |

#### 配置 repository 部分

repository 部分允许您定义定制化的 openEuler 软件源仓库，各个仓库的名称不能相同，否则会引起冲突。配置 repository 部分有两种方式，一种是直接配置 /etc/dnf/dnf.conf 文件中的 repository 部分，另外一种是修改或新增 /etc/yum.repos.d 目录的 .repo 文件。

- 直接配置 /etc/dnf/dnf.conf 文件中的 repository 部分

    下面是 [repository] 部分的一个最小配置示例：

    ```
    [repository]
    name=repository_name
    baseurl=repository_url
    ```

    > **说明：**
    >openEuler 提供在线的镜像源，地址：[https://repo.openeuler.org/](https://repo.openeuler.org/)。以 openEuler 21.03 的 aarch64 版本为例，baseurl 为 [https://repo.openeuler.org/openEuler-21.03/OS/aarch64/](https://repo.openeuler.org/openEuler-21.03/OS/aarch64/)。

    选项说明：

    **表 2**  repository 参数说明
    | 参数 | 说明 |
    | ---- | ---- |
    | name | 仓库名称，不能重复。 |
    | baseurl | 仓库地址，可以是本地目录或者远程仓库地址。 |

- 配置 /etc/yum.repos.d 目录下的 .repo 文件

    openEuler 提供了多种 repo 源供用户在线使用。使用 root 权限添加 openEuler repo 源，示例如下：

    ```
    # vi /etc/yum.repos.d/openEuler.repo
    ```

    ```
    [OS]
    name=openEuler-$releasever-OS
    baseurl=https://repo.openeuler.org/openEuler-21.03/OS/$basearch/
    enabled=1
    gpgcheck=1
    gpgkey=https://repo.openeuler.org/openEuler-21.03/OS/$basearch/RPM-GPG-KEY-openEuler
    ```

    > **说明：**
    > - enabled 设置是否启用该软件源仓库，可选值为 1 和 0。默认值为 1，表示启用该软件源仓库。
	> - gpgkey 为验证软件包签名的公钥。

#### 显示当前配置

- 要显示当前的配置信息：

    ```
    $ dnf config-manager --dump
    ```

- 要显示相应软件源的配置，首先查询 repo id：

    ```
    $ dnf repolist
    ```

    然后执行如下命令，显示对应 id 的软件源配置，其中 _repository_ 为 repo id：

    ```
    $ dnf config-manager --dump repository
    ```

### 创建本地软件源仓库

要建立一个本地软件源仓库，请按照下列步骤操作。

1. 安装 createrepo 软件包。在 root 权限下执行如下命令：

    ```
    # dnf install createrepo
    ```

2. 将 RPM 软件包复制到一个目录下，如 /mnt/local_repo
3. 创建软件源，执行以下命令：

    ```
    createrepo /mnt/local_repo
    ```

### 添加、启用和禁用软件源

本节将介绍如何通过 dnf config-manager 命令添加、启用和禁用软件源仓库。

#### 添加软件源

要定义一个新的软件源仓库，您可以在 /etc/dnf/dnf.conf 文件中添加 "repository" 部分，或者在 /etc/yum.repos.d/ 目录下添加 .repo 文件。建议您通过添加 .repo 文件的方式，每个软件源都有自己对应的 .repo 文件，以下介绍该方式的操作方法。

要在您的系统中添加源，请在 root 权限下执行如下命令，执行完成之后会在 /etc/yum.repos.d/ 目录下生成对应的 repo 文件。其中 _repository\_url_ 为 repo 源地址。

```
# dnf config-manager --add-repo repository_url
```

#### 启用软件源

要启用软件源，请在 root 权限下执行如下命令，其中 _repository_ 为 repo id（可通过 dnf repolist 命令查询）：

```
# dnf config-manager --set-enable repository
```

#### 禁用软件源

要禁用软件源，请在 root 权限下执行如下命令：

```
# dnf config-manager --set-disable repository
```

## 管理软件包

dnf 能够让您方便的进行查询、安装、删除软件包等操作。

### 搜索软件包

您可以使用 RPM 包名称、缩写或者描述搜索需要的 RPM 包，使用命令如下：

```
$ dnf search term
```

示例如下：

```
$ dnf search httpd
========================================== N/S matched: httpd ==========================================
httpd.aarch64 : Apache HTTP Server
httpd-devel.aarch64 : Development interfaces for the Apache HTTP server
httpd-manual.noarch : Documentation for the Apache HTTP server
httpd-tools.aarch64  : Tools for use with the Apache HTTP Server
libmicrohttpd.aarch64  : Lightweight library for embedding a webserver in applications
mod_auth_mellon.aarch64  : A SAML 2.0 authentication module for the Apache Httpd Server
mod_dav_svn.aarch64  : Apache httpd module for Subversion server
```

### 列出软件包清单

要列出系统中所有已安装的以及可用的 RPM 包信息，使用命令如下：

```
$ dnf list all
```

要列出系统中特定的 RPM 包信息，使用命令如下：

```
$ dnf list package_name
```

示例如下：

```
$ dnf list httpd
Available Packages
httpd.aarch64              2.4.34-8.h5.oe1           Local
```

### 显示 RPM 包信息

要显示一个或者多个 RPM 包信息，使用命令如下：

```
$ dnf info package_name...
```

例如搜索，命令如下：

```
$ dnf info httpd
Available Packages
Name        : httpd
Version     : 2.4.34
Release     : 8.h5.oe1
Arch        : aarch64
Size        : 1.2 M
Repo        : Local
Summary     : Apache HTTP Server
URL         : http://httpd.apache.org/
License     : ASL 2.0
Description : The Apache HTTP Server is a powerful, efficient, and extensible
            : web server.
```

### 安装 RPM 包

要安装一个软件包及其所有未安装的依赖，请在 root 权限下执行如下命令：

```
# dnf install package_name
```

您也可以通过添加软件包名字同时安装多个软件包。

```
# dnf install package_name1 package_name2
```

示例如下：

```
# dnf install httpd mod_ssl
```


### 下载软件包

使用 dnf 下载软件包，输入如下命令：

```
$ dnf download package_name
```

如果需要同时下载依赖，则加上参数 \-\-resolve，使用命令如下：

```
$ dnf download --resolve package_name
```

示例如下：

```
$ dnf download --resolve httpd
```

### 删除软件包

要卸载软件包以及相关的依赖软件包，请在 root 权限下执行如下命令：

```
# dnf remove package_name
```

示例如下：

```
# dnf remove totem
```

## 管理软件包组

软件包集合是服务于一个共同目的的一组软件包，例如系统工具集等。使用 dnf 可以对软件包组进行安装/删除等操作，使相关操作更高效。

### 列出软件包组清单

使用 summary 参数，可以列出系统中所有已安装软件包组、可用的组，可用的环境组的数量，命令如下：

```
$ dnf groups summary
```

使用示例如下：

```
$ dnf groups summary
Available Groups: 9
```

要列出所有软件包组和它们的组 ID ，命令如下：

```
$ dnf group list --ids
```

使用示例如下：

```
$ dnf group list --ids
Last metadata expiration check: 0:06:03 ago on Fri Dec 23 13:14:01 2022.
Available Environment Groups:
   Minimal Install (minimal-environment)
   Server (server-product-environment)
   Virtualization Host (virtualization-host-environment)
Available Groups:
   Container Management (container-management)
   Development Tools (development)
   Headless Management (headless-management)
   Legacy UNIX Compatibility (legacy-unix)
   Network Servers (network-server)
   Scientific Support (scientific)
   Security Tools (security-tools)
   System Tools (system-tools)
   Smart Card Support (smart-card)
```

### 显示软件包组信息

要列出包含在一个软件包组中必须安装的包和可选包，使用命令如下：

```
$ dnf group info group_name
```

例如显示 Development Tools 包组信息，示例如下：

```
$ dnf group info "Development Tools"
Last metadata expiration check: 0:14:54 ago on Wed 05 Jun 2019 08:38:02 PM CST.

Group: Development Tools
 Description: A basic development environment.
 Mandatory Packages:
   binutils
   glibc-devel
   make
   pkgconf
   pkgconf-m4
   pkgconf-pkg-config
   rpm-sign
 Optional Packages:
   expect
```

### 安装软件包组

每一个软件包组都有自己的名称以及相应的 ID(groupid)，您可以使用软件包组名称或它的 ID 进行安装。

要安装一个软件包组，请在 root 权限下执行如下命令：

```
# dnf group install group_name
```

```
# dnf group install groupid
```

例如安装 Development Tools 软件包组，命令如下：

```
# dnf group install "Development Tools"
```

```
# dnf group install development
```

### 删除软件包组

要卸载软件包组，您可以使用软件包组名称或它的 ID，在 root 权限下执行如下命令：

```
# dnf group remove group_name
```

```
# dnf group remove groupid
```

例如删除 Development Tools 软件包组，命令如下：

```
# dnf group remove "Development Tools"
```

```
# dnf group remove development
```

## 检查并更新

dnf 可以检查您的系统中是否有软件包需要更新。您可以通过 dnf 列出需要更新的软件包，并可以选择一次性全部更新或者只对指定包进行更新。

### 检查更新

如果您需要显示当前系统可用的更新，使用命令如下：

```
dnf check-update
```

使用示例如下：

```
# dnf check-update
Last metadata expiration check: 0:02:10 ago on Sun 01 Sep 2019 11:28:07 PM  CST.

anaconda-core.aarch64       19.31.123-1.14             updates
anaconda-gui.aarch64        19.31.123-1.14             updates
anaconda-tui.aarch64        19.31.123-1.14             updates
anaconda-user-help.aarch64  19.31.123-1.14             updates
anaconda-widgets.aarch64    19.31.123-1.14             updates
bind-libs.aarch64           32:9.9.4-29.3              updates
bind-libs-lite.aarch64      32:9.9.4-29.3              updates
bind-license.noarch         32:9.9.4-29.3              updates
bind-utils.aarch64          32:9.9.4-29.3              updates
...
```

### 升级

如果您需要升级单个软件包，在 root 权限下执行如下命令：

```
# dnf update package_name
```

例如升级 anaconda-gui.aarch64 包，示例如下：

```
# dnf update anaconda-gui.aarch64
Last metadata expiration check: 0:02:10 ago on Sun 01 Sep 2019 11:30:27 PM  CST.
Dependencies Resolved
================================================================================
 Package                  Arch         Version              Repository     Size
================================================================================
Updating:
 anaconda-gui             aarch64      19.31.123-1.14       updates       461 k
 anaconda-core            aarch64      19.31.123-1.14       updates       1.4 M
 anaconda-tui             aarch64      19.31.123-1.14       updates       274 k
 anaconda-user-help       aarch64      19.31.123-1.14       updates       315 k
 anaconda-widgets         aarch64      19.31.123-1.14       updates       748 k

Transaction Summary
================================================================================
Upgrade  5 Package

Total download size: 3.1 M
Is this ok [y/N]:
```

类似地，如果您需要升级软件包组，在 root 权限下执行如下命令：

```
# dnf group update group_name
```

### 更新所有的包和它们的依赖

要更新所有的包和它们的依赖，在 root 权限下执行如下命令：

```
# dnf update
```
