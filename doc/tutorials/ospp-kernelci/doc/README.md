# 板块

## 需要准备的东西 - 所有板块

1. 服务器设备:一台主机，系统为 linux x86 (发行版为 debian 或 ubuntu ，似乎也可以使用 centos。 LAVA官方推荐使用debian)，由于我的条件有限 这里使用的是 windows 11 下的 WSL2-Ubuntu-22.04 测试后也可以正常进行 LAVA 的搭建，不过需要额外注意一些东西，后文会详细说明
2. 被测试的设备:一块开发板 ，这里由于 ospp 的要求，我使用的是 Licheepi 4a 8g-32g , 当然也可以使用其他开发板。
3. 电源控制设备:esp8266 或是其他带有 wifi 模块的开发板 ，不通过网络也可以完成，只不过要挨个管理串口设备，后文会提到
4. 硬件设备:若干杜邦线 ，电源 ，继电器。

# 章节

1. [搭建基础的开发环境](./搭建基础的开发环境.md)
   - 直接使用 ubuntu
   - windows 使用 WSL 2 或 VMware
2. [LAVA-LAB的搭建](./LAVA-LAB的搭建.md)
   - 直接搭建
   - **通过 lava - docker来构建**
3. [已提供的设备类型-qemu](./已提供的设备类型-qemu.md)
   - [lava-docker细节解释 ](./lava-docker细节解释.md)
4. [未提供的设备类型-自定义设备类型-Licheepi 4a](./未提供的设备类型-自定义设备类型-Lip4a.md)
5. [电源控制](./电源控制.md)
   - **使用mqtt + esp8266**
   - 使用其他开发板 + 串口
6. [配置jenkins.md](./配置jenkins.md) 
7. [编写job和testcase](./编写job和testcase.md)

### 可能对你有些帮助

在处理 lava 时可能会需要重复的构建 docker 镜像，手动很麻烦，这里我给出几个简单的清理环境的脚本

导出所有容器

```shell
#!/bin/bash

# 创建一个目录来保存导出的容器
mkdir -p ~/docker_backups

# 获取所有容器的 ID
container_ids=$(docker ps -aq)

# 导出每个容器
for id in $container_ids; do
    container_name=$(docker inspect --format='{{.Name}}' $id | cut -c2-) # 去掉前面的斜杠
    docker export $id -o ~/docker_backups/$container_name.tar
    echo "导出容器 $container_name ($id) 到 ~/docker_backups/$container_name.tar"
done
```

导出所有镜像

```shell
#!/bin/bash

# 创建一个目录来保存导出的镜像
mkdir -p ~/docker_image_backups

# 获取所有镜像的名称
image_names=$(docker images -q)

# 导出每个镜像
for image in $image_names; do
    image_name=$(docker inspect --format='{{.RepoTags}}' $image | tr -d '[],')
    docker save $image -o ~/docker_image_backups/$image_name.tar
    echo "导出镜像 $image_name 到 ~/docker_image_backups/$image_name.tar"
done

```

删除所有 docker 镜像和容器，你可以修改下 改成只删除 lava 相关的，我这里是**全部删除**

```shell
#!/bin/bash

# 停止并删除所有容器
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)

# 删除所有镜像
docker rmi $(docker images -q)

echo "所有容器和镜像已删除。"

```
