# 配置 jenkins

首先要安装 jenkins ，查看官方文档吧！[Jenkins 用户手册](https://www.jenkins.io/zh/doc/) 

安装 jenkins 有多种方式，按照你的需求来 我这边直接使用 jar 包

在 Jenkins.war 同级目录下使用 ` java -jar jenkins.war --httpPort=8080` 即可

## jenkins 安装插件

这里演示如何安装插件 **HTTP Request Plugin**

![jenkins1](img/jenkins/jenkins1.png)

![jenkins2](img/jenkins/jenkins2.png)

进入界面后点击**Available plugins** ，搜索 **HTTP Request Plugin** 点击安装

## jenkins 配置 Credentials

为了便于管理密钥，也为了安全考虑 ，这里要配置 Credentials

![jenkins1](img/jenkins/jenkins1.png)

![jenkinsnew1](img/jenkins/jenkinsnew1.png)

![jenkins5](img/jenkins/jenkins5.png)

可以看到,有很多种形式,后面我们会配置 Secret text 和 SSH Username with private key

![jenkins6](img/jenkins/jenkins6.png)

## jenkins 触发 lava job

### REST API

这里使用 REST API 做例子,在主机中输入

```shell
curl -d '{"username":"admin", "password":"v"}' -H "Content-Type: application/json" -X POST "http://localhost:8000/api/v0.2/token/"
#可以得到如下结果
{"token":"adminlavatoken"}
```

其实就是使用 curl 向 LAVA API 发送 POST 请求

如果你对之前的章节还有印象会发现这个 token 正是 **boards.yaml** 中设置的

此外你还可以重新提交一个 job，这里是 job 15，他便会按照 job 15 的定义 重新提交一遍 

```shell
curl -X POST \
     "http://localhost:8000/api/v0.2/jobs/15/resubmit/" \
     -H "Authorization: Token adminlavatoken"
```

他将会返回一串报文

```shell
{"message":"job(s) successfully submitted","job_ids":[33]}
```

表明 job 的提交情况和重新提交的 job id

也可以直接提交一个新的 job

```shell
curl -x "" -v -H "Authorization: Token adminlavatoken" \
     -d '{
           "definition": "{\"device_type\":\"qemu\",\"job_name\":\"your-testjob-name\",\"timeouts\":{\"job\":{\"minutes\":30},\"action\":{\"minutes\":20},\"connection\":{\"minutes\":5}},\"priority\":\"medium\",\"visibility\":\"public\",\"context\":{\"arch\":\"riscv64\",\"machine\":\"virt\",\"guestfs_interface\":\"virtio\",\"extra_options\":[\"-nographic\",\"-smp 4\",\"-m 8G\"]},\"metadata\":{\"format\":\"Lava-Test Test Definition 1.0\",\"name\":\"your-testjob-name\",\"description\":\"Description of the test job\",\"version\":\"1.0\"},\"actions\":[{\"deploy\":{\"timeout\":{\"minutes\":20},\"to\":\"tmpfs\",\"images\":{\"kernel_1\":{\"image_arg\":\"-blockdev node-name=pflash0,driver=file,read-only=on,filename={kernel_1}\",\"url\":\"file:///path/to/kernel1\"}}}}]}"
         }' \
     -H "Content-Type: application/json" \
     -X POST "http://127.0.0.1:8000/api/v0.2/jobs/"
```

这是它返回的报文

```shell
*   Trying 127.0.0.1:8000...
* Connected to 127.0.0.1 (127.0.0.1) port 8000 (#0)
> POST /api/v0.2/jobs/ HTTP/1.1
> Host: 127.0.0.1:8000
> User-Agent: curl/7.81.0
> Accept: */*
> Authorization: Token adminlavatoken
> Content-Type: application/json
> Content-Length: 784
>
* Mark bundle as not supporting multiuse
< HTTP/1.1 201 Created
< Date: Mon, 14 Oct 2024 09:50:19 GMT
< Server: gunicorn
< Content-Type: application/json
< Vary: Accept,Cookie
< Allow: GET, POST, HEAD, OPTIONS
< X-Frame-Options: DENY
< Content-Length: 58
< X-Content-Type-Options: nosniff
< X-XSS-Protection: 1; mode=block
< Referrer-Policy: same-origin
<
* Connection #0 to host 127.0.0.1 left intact
{"message":"job(s) successfully submitted","job_ids":[34]}
```

这里你就完成了通过 REST API 查看 job 和 重新提交 job 的工作,当然他做更多是 详细可以查看 https://docs.lavasoftware.org/lava/data-export.html 

### pipeline

这里给出一个简单的 pipeline

```
pipeline {
    agent any

    stages {
        stage('Fetch Job Status') {
            steps {
                script {
                    def jobId = "2" // 替换为实际的 Job ID
                    def response = httpRequest(
                        url: "http://127.0.0.1:8000/api/v0.2/jobs/${jobId}", // 获取作业状态
                        httpMode: 'GET',
                        authentication: 'lava-api-token'
                    )
                    echo "Job Status: ${response.content}"
                }
            }
        }
    }
}
```

从描述可以看出 这是一个获取 lava job status 的 pipeline

其中 `authentication: 'lava-api-token'` 是 jenkins 中的 Credentials 配置

这是根据 REST API 编写的，当然你也可以选择直接在 pipeline 中执行 `sh "curl -d '{"username":"admin", "password":"v"}' -H "Content-Type: application/json" -X POST "http://localhost:8000/api/v0.2/token/" "`

这是一个触发已有任务的 pipeline

```
pipeline {
    agent any

    stages {
        stage('Resubmit Job') {
            steps {
                script {
                    def jobId = "4" // 替换为实际的 Job ID
                    def token = "adminlavatoken" // 替换为你的 API token

                    def response = httpRequest(
                        url: "http://localhost:8000/api/v0.2/jobs/${jobId}/resubmit/",
                        httpMode: 'POST',
                        customHeaders: [[name: 'Authorization', value: "Token ${token}"]]
                    )
                    echo "Response: ${response.content}"
                }
            }
        }
    }
}
```

可以注意到这里拿 token 直接放在了 pipeline 里，显然是不安全的 后面会解决这个问题

可以参考官方文档 [创建您的第一个Pipeline (jenkins.io)](https://www.jenkins.io/zh/doc/pipeline/tour/hello-world/) 来了解如何创建一个 pipeline

至此，完成了 lava 与 jenkins 使用 pipeline 交互的部分

## kernel 源码 与 jenkins

目前有两种完成 jenkins 的思路，都是使用了 **webhook** 

插件上可以采用 **gitee** 或 **Generic Webhook Trigger** ，安装方式上面有提到，都是类似的。

选择 item 方面也可以采用 **自由软件风格项目** 和 **pipeline 项目**两种形式

所以这样子搭配 至少有了四种可实现的方法

这里会简单阐述方法 先采用 **自由软件风格项目** 和 **gitee** 插件 来做演示

### gitee  +自由软件风格项目

#### gitee 插件

安装方面与上面的其他插件方法一致。

可以参考 gitee 的官方文档 [Jenkins 插件 - Gitee.com](https://gitee.com/help/articles/4193) ，按着其指示配置 Webhook ，此时点击项目 WebHooks 中的 **测试**

![jenkins7](img/jenkins/jenkins7.png)

会有相应的结果，但我这里显示超时，这其实是 gitee 这边测试的 bug ，似乎已经很长时间了，正常你触发的时候是没问题的

![jenkins8](img/jenkins/jenkins8.png)



正常 push 代码时是会正常触发的，可以查看 jenkins system log

(我这里单独把 gitee 的 log 拎了出来)

![jenkins9](img/jenkins/jenkins9.png)

可以看到是有正常的信息的

到这里你完成了 使用 gitee 插件 捕获 webhook 传来的信息

#### 自由软件风格项目

**Build Steps** 这部分选择使用 Execute shell ，来让 jenkins 可以直接使用部署其服务的主机的环境。

由于之前的工作 ( gitee 插件会根据你的需求,自动更新你所跟踪的 gitee 仓库的状态,我们不用手动拉取)，我们已经将 远程仓库的最新状态拉取到本地，由于这种情况下 jenkins 和 lava 位于同一台机器内,可以在编译 Image 后直接使用 REST API，使用 crul 来触发实现准备好的 lava job

![jenkins11](D:\study\gitee_repositories\RISC-V\doc\tutorials\ospp-kernelci\doc\img\jenkins\jenkins11.png)



### Generic Webhook Trigger + pipeline

这里我再详细的写出 Generic Webhook Trigger + pipeline 的形式的完整流程 

#### Generic Webhook 插件

首先安装 **Generic Webhook Trigger** 插件

![jenkins12](img/jenkins/jenkins12.png)

#### pipeline 项目

创建一个 pipeline 工程

![jenkins13](img/jenkins/jenkins13.png)

在 **Build Triggers** 点击 Generic Webhook Trigger

![jenkins10](img/jenkins/jenkins10.png)

只需要设置 token 即可

![jenkins14](img/jenkins/jenkins14.png)

然后配置 对应仓库的 webhook 我这里我给我的 gitee 仓库配置

![jenkins15](img/jenkins/jenkins15.png)

可以手动触发试试 浏览器输入 `你的jenkis地址/generic-webhook-trigger/invoke?token=你的token`

![jenkins16](img/jenkins/jenkins16.png)



这里是 获取源码 构建 和 触发 lava lab 的 pipeline ，实际上，获取 webhook 这一环境也可使用 pipeline，有兴趣可以自行尝试

```pipeline
pipeline {
    agent any
    environment {
        PATH = "/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin"
    }
    stages {
        stage('Prepare') {
            steps {
                script {
                    // 检查 riscv-kernel 目录是否存在
                    if (fileExists('riscv-kernel')) {
                        echo 'riscv-kernel directory exists in OLK. Checking branch...'
                        dir('riscv-kernel') {
                            // 获取当前分支
                            def currentBranch = sh(script: 'git rev-parse --abbrev-ref HEAD', returnStdout: true).trim()
                            echo "Current branch is: ${currentBranch}"

                            // 检查当前分支是否为 OLK-6.6
                            if (currentBranch == 'OLK-6.6') {
                                echo 'Already on OLK-6.6 branch. Pulling latest changes...'
                                sh 'git pull'
                            } else {
                                echo "Not on OLK-6.6 branch, switching..."
                                sh "git checkout OLK-6.6"
                                sh 'git pull'
                            }
                        }
                    } else {
                        echo 'riscv-kernel directory does not exist. Cloning OLK-6.6 branch...'
                        // 直接拉取指定分支的代码
                        git url: 'https://gitee.com/feifei-fertilizer/riscv-kernel.git', branch: 'OLK-6.6'
                        }
                    }
                }
            }
        stage('Build') {
            steps {
                sh "ls"
                dir('riscv-kernel') {
                    sh "ls"
                                // 检查 .config 文件是否存在
                    script {
                        if (fileExists('.config')) {
                            sh "rm .config"
                        } else {
                            echo '.config file does not exist, skipping removal.'
                        }
                    }
                    sh "cp arch/riscv/configs/openeuler_defconfig .config"
                    sh "make "
                    sh "make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- Image"
                    sh "cp arch/riscv/boot/Image ~/ospp/2024-large-files/"
                }
            }
        }
        stage('Resubmit Job') {
            steps {
                script {
                    def jobId = "15" // 替换为实际的 Job ID
                    def token = "adminlavatoken" // 替换为你的 API token

                    def response = httpRequest(
                        url: "http://localhost:8000/api/v0.2/jobs/${jobId}/resubmit/",
                        httpMode: 'POST',
                        customHeaders: [[name: 'Authorization', value: "Token ${token}"]]
                    )
                    echo "Response: ${response.content}"
                }
            }
        }
    }
}
```

如果想像这里一样 使用 pipeline 触发则需要额外安装 **HTTP Request Plugin** 插件

到这里就可以完成 gitee 源码 push , 自动触发 jenkins 构建 kernel 源码, jenkins 再触发 lavajob , 恭喜你。

![jenkins20](img/jenkins/jenkins20.png)

构建过程图

![jenkins17](img/jenkins/jenkins17.png)

![jenkins18](img/jenkins/jenkins18.png)

## 目前存在的问题

可以看到 jenkins 的构建流程，我们已经打通了最基础的 kernel ci 流程，但是仍有许多不完善的地方

1. 搭建 kernel ci 会将 jenkins 和 LAVA 部署在多台机器上
2. 不能把 token 等需要保护的信息暴露在 pipeline 里
3. 触发 job 举的例子是触发 LAVA 中已存在的 job，但既然是 CI 要考虑初次触发job的情况 

# 更完善的解决方案

## 解决 token 暴露的问题

配置 Credentials，上面有介绍过这部分内容

![jenkinsnew2](img/jenkins/jenkinsnew2.png)

![jenkinsnew3](img/jenkins/jenkinsnew3.png)



这里要注意的是不要配置成 Admin credentials 这是管理员的凭据 ，而要配置 **Manage Jenkins 中的 credentials**。

此时你就可以把 pipeline 修改为

```pipeline
pipeline {
    agent any
    stages {
        stage('Resubmit Job') {
            steps {
                script {
                    def jobId = "4" // 替换为实际的 Job ID
                    
                    // 使用 withCredentials 确保凭据被正确加载
                    withCredentials([string(credentialsId: 'lava-api-token', variable: 'TOKEN')]) {
                        def response = httpRequest(
                            url: "http://localhost:8000/api/v0.2/jobs/${jobId}/resubmit/",
                            httpMode: 'POST',
                            customHeaders: [[name: 'Authorization', value: "Token ${TOKEN}"]]
                        )
                        echo "Response: ${response.content}"
                    }
                }
            }
        }
    }
}
```

[string(credentialsId: 'lava-api-token', variable: 'TOKEN')] 是 Jenkins Pipeline 的一个参数列表 

string(...)：指定凭据的类型为字符串

lava-api-token 对应的是上面配置的 secret text 的 credentials id ,

variable:'TOKEN'：定义了在 Pipeline 中使用该凭据时的环境变量名称，凭据的值将被赋给这个变量。



此时 jenkins log 中 便不会显示 token 的明文信息

![jenkinsnew4](img/jenkins/jenkinsnew4.png)

## 解决 image 构建问题

先罗列需要做的事

1. 搭建 jenkins 的机器（机器A） 得到 webhook 信息
2. 传递该信息，使负责编译源码的机器（机器B）更新代码并完成编译
3. 机器B 将编译好的内容传递给 lava 宿主机（机器C）
4. 机器C 完成 lava 测试

我们之前 A B C 均为同一台机器，不用考虑网络，权限等问题

这里我考虑三台机器的关系如下

1. A -> B -> C
2. A <-> B and B -> C

第一种适合简单的情况，第二种则适用于复杂的场景.

下面给出怎么做

### 安装 SSH Agent 插件

然后配置 **ssh credentials** 

这里给出示意图

![jenkinsnew5](img/jenkins/jenkinsnew5.png)

在 ssh 连接的服务器上配置好你的公钥即可,下面是一个 使用 ssh credentials pipeline 的基础模板

```pipeline
pipeline {
    agent any

    stages {
        stage('Connect to Remote Machine') {
            steps {
                script {
                    sshagent(['my-ssh-credentials']) { // 替换为你的凭据 ID
                        sh 'ssh username@ip "command"'
                    }
                }
            }
        }
    }
}
```

这里给出一部分 ssh 连接后的指令，这里涉及到的是源码的更新

```pipeline
pipeline {
    agent any

    stages {
        stage('CHECK KERNEL EXIST') {
            steps {
                script {
                    sshagent(['my-ssh-credentials']) { // 替换为你的凭据 ID
                        def command = '''
                        if ls ~/build | grep -q 'riscv-kernel'; then
                            echo "Found 'riscv-kernel' in ~/build."
                        else
                            echo "'riscv-kernel' not found in ~/build. Cloning repository..."
                            git clone https://gitee.com/feifei-fertilizer/riscv-kernel.git ~/build
                        fi
                        
                        cd ~/build/riscv-kernel
                            
                        # 检查当前分支
                        current_branch=$(git rev-parse --abbrev-ref HEAD)
                        if [ "$current_branch" = "OLK-6.6" ]; then
                            echo "Currently on branch 'OLK-6.6'."
                            # 在这里添加处理分支在该分支上的代码
                        else
                            echo "Not on branch 'OLK-6.6', currently on branch '$current_branch'. Switching to 'OLK-6.6'..."
                            git checkout OLK-6.6
                        fi
                        git pull
                        '''
                        // 使用单个 SSH 连接执行全部命令
                        sh "ssh feifei@192.168.0.149 '${command}'"
                    }
                }
            }
        }
    }
}
```

开始构建 ,  这里 ssh 连接到远程构建的机器 使用其环境开始构建，我选择把 更新源码 和 编译 kernel 分为两个 stage ，这样哪一环出了问题可以更好的定位。这里检测了 config 文件是否存在 以及使用什么工具链。

```pipeline
pipeline {
    agent any

    stages {
        stage('COMPILE THE KERNEL') {
            steps {
                script {
                    sshagent(['my-ssh-credentials']) { // 替换为你的凭据 ID
                        def command = '''
                        cd ~/build/riscv-kernel
                        if [ -f ~/build/riscv-kernel/.config ]; then
                            echo ".config file exists."
                            rm ~/build/riscv-kernel/.config
                        else
                            echo ".config file does not exist."
                        fi
                        cp ~/build/riscv-kernel/arch/riscv/configs/openeuler_defconfig ~/build/riscv-kernel/.config
                        make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- Image
                        '''
                        // 使用单个 SSH 连接执行全部命令
                        sh "ssh feifei@192.168.0.149 '${command}'"
                    }
                }
            }
        }
    }
}
```

文件传输 ，有几种思路，我这里使用了 scp，毕竟之前我们一直在使用 ssh ,你也可以把文件传输到服务器上，或 git 仓库，总之 lava 服务器能得到就行

```pipeline
pipeline {
    agent any

    stages {
        stage('COMPILE THE KERNEL') {
            steps {
                script {
                    sshagent(['my-ssh-credentials']) { // 替换为你的凭据 ID
                        def command = '''l
                        if [ -f ~/build/riscv-kernel/arch/riscv/boot/Image ]; then
                            echo "Image file exists."
                        else
                            echo ".config file does not exist."
                        fi
                        scp ~/build/riscv-kernel/arch/riscv/boot/Image feifei@192.168.0.149:~/ospp/2024ospp-large-files/new
                        '''
                        // 使用单个 SSH 连接执行全部命令
                        sh "ssh feifei@192.168.0.149 '${command}'"
                    }
                }
            }
        }
    }
}
```

## 解决首次触发问题

我们之前的 ci 方案是重新提交了已有的 job，无法解决首次触发的问题

lava 官方提供了三种触发方式 分别是 XML-RPC  , Web , 命令行使用 lavacli 命令 (其实还有 REST API)

可以查看 [提交您的第一份工作 — LAVA 2024.09 文档 --- Submitting your first job — LAVA 2024.09 documentation (lavasoftware.org)](https://docs.lavasoftware.org/lava/first-job.html#index-2)

之前我们的方案就是采用了 REST API ,上面也提过可以做到,但我们接下来的方案使用的是 lavacli 原因有一下几点

1. lavacli 提供的是 yaml 文件,可以拿着 job 模板直接提交,服务端也可以比较方便管理 job
2. 使用 REST API 提交 ,lava 会进行很严格的格式检测 ,这让我们提供的测试定义被压缩在一行,可读性极差,而且本人在提交时经常因为格式问题不成功

下面的 pipeline 实现了 判断有没有 同名的 job ,有的话就重新提交该 job,没有的话就通过 lavacli 提交定义

```pipeline
pipeline {
    agent any

    stages {
        stage('COMPILE THE KERNEL') {
            steps {
                script {
                    sshagent(['my-ssh-credentials']) {
                        withCredentials([string(credentialsId: 'lava-api-token', variable: 'TOKEN')]) {
                            def LAVA_URI = "http://admin:${TOKEN}@192.168.0.149:8000/RPC2/"
                            def JOB_NAME = "qemu-oerv-24.03-smoke-test"
                            def JOB_Path = "~/ospp/example/job/qemu/qemu-oerv-24.03-smoke-test.yaml"
                            def command = """
                            # 列出作业并检查
                            JOB_INFO=\$(lavacli --uri "$LAVA_URI" jobs list | grep "$JOB_NAME")
                            JOB_ID=\$(echo "\$JOB_INFO" | awk "{print \\\$2}" | cut -d':' -f1 | head -n 1)
                            if [ -n "\$JOB_ID" ]; then
                                echo "Lately Job ID: \$JOB_ID."
                            curl -X POST \
                            "http://192.168.0.149:8000/api/v0.2/jobs/\$JOB_ID/resubmit/" \
                            -H "Authorization: Token ${TOKEN}"    
                            else
                                echo "Job '$JOB_NAME' does not exist."
                                lavacli --uri "$LAVA_URI"  jobs submit  $JOB_Path
                            fi
                            
                            """
                            // 使用单个 SSH 连接执行全部命令
                            sh "ssh feifei@192.168.0.149 ${command}"
                        }
                    }
                }
            }
        }
    }
}
```

当然 这个解决方法目前也存在一些问题 

这个查看的只是最近作业中有没有重名 job ,考虑到大型的 lava 项目 job id 会以万为单位计算,这显然不是特别好的解决方案, 而且当 job 名称(取决于 job 中的 job name 字段 ) 与提供的 yaml 文件名称不完全一致,也无法检测出

不过好在检测不出也能提供定义,进而进行测试

我认为用 lavacli 的方式来管理每一个 job 会比较好，这样每个 job 在服务器中都有一个对应的 yaml 文件.

## 解决问题并压缩到一个 pipeline 中

```pipeline
pipeline {
    agent any

    stages {
        stage('CHECK KERNEL EXIST') {
            steps {
                script {
                    sshagent(['my-ssh-credentials']) { // 替换为你的凭据 ID
                        def command = '''
                        if ls ~/build | grep -q 'riscv-kernel'; then
                            echo "Found 'riscv-kernel' in ~/build."
                        else
                            echo "'riscv-kernel' not found in ~/build. Cloning repository..."
                            git clone https://gitee.com/feifei-fertilizer/riscv-kernel.git ~/build
                        fi
                        
                        cd ~/build/riscv-kernel
                            
                        # 检查当前分支
                        current_branch=$(git rev-parse --abbrev-ref HEAD)
                        if [ "$current_branch" = "OLK-6.6" ]; then
                            echo "Currently on branch 'OLK-6.6'."
                            # 在这里添加处理分支在该分支上的代码
                        else
                            echo "Not on branch 'OLK-6.6', currently on branch '$current_branch'. Switching to 'OLK-6.6'..."
                            git checkout OLK-6.6
                        fi
                        git pull
                        '''
                        // 使用单个 SSH 连接执行全部命令
                        sh "ssh feifei@192.168.0.149 '${command}'"
                    }
                }
            }
        }
        stage('COMPILE THE KERNEL') {
            steps {
                script {
                    sshagent(['my-ssh-credentials']) { // 替换为你的凭据 ID
                        def command = '''
                        cd ~/build/riscv-kernel
                        if [ -f ~/build/riscv-kernel/.config ]; then
                            echo ".config file exists."
                            rm ~/build/riscv-kernel/.config
                        else
                            echo ".config file does not exist."
                        fi
                        cp ~/build/riscv-kernel/arch/riscv/configs/openeuler_defconfig ~/build/riscv-kernel/.config
                        make ARCH=riscv CROSS_COMPILE=riscv64-linux-gnu- Image
                        '''
                        // 使用单个 SSH 连接执行全部命令
                        sh "ssh feifei@192.168.0.149 '${command}'"
                    }
                }
            }
        }
        stage('TRANSFER THE KERNEL') {
            steps {
                script {
                    sshagent(['my-ssh-credentials']) { // 替换为你的凭据 ID
                        def command = '''
                        if [ -f ~/build/riscv-kernel/arch/riscv/boot/Image ]; then
                            echo "Image file exists."
                        else
                            echo "Image does not exist."
                        fi
                        scp ~/build/riscv-kernel/arch/riscv/boot/Image feifei@192.168.0.149:~/ospp/2024ospp-large-files/new
                        '''
                        // 使用单个 SSH 连接执行全部命令
                        sh "ssh feifei@192.168.0.149 '${command}'"
                    }
                }
            }
        }
        stage('TRIGGER LAVA JOB') {
            steps {
                script {
                    sshagent(['my-ssh-credentials']) {
                        withCredentials([string(credentialsId: 'lava-api-token', variable: 'TOKEN')]) {
                            def LAVA_URI = "http://admin:${TOKEN}@192.168.0.149:8000/RPC2/"
                            def JOB_NAME = "qemu-oerv-24.03-smoke-test"
                            def JOB_Path = "~/ospp/example/job/qemu/qemu-oerv-24.03-smoke-test.yaml"
                            def command = """
                            # 列出作业并检查
                            JOB_INFO=\$(lavacli --uri "$LAVA_URI" jobs list | grep "$JOB_NAME")
                            JOB_ID=\$(echo "\$JOB_INFO" | awk "{print \\\$2}" | cut -d':' -f1 | head -n 1)
                            if [ -n "\$JOB_ID" ]; then
                                echo "Lately Job ID: \$JOB_ID."
                            curl -X POST \
                            "http://192.168.0.149:8000/api/v0.2/jobs/15/resubmit/" \
                            -H "Authorization: Token ${TOKEN}"    
                            else
                                echo "Job '$JOB_NAME' does not exist."
                                lavacli --uri "$LAVA_URI"  jobs submit  $JOB_Path
                            fi
                            
                            """
                            // 使用单个 SSH 连接执行全部命令
                            sh "ssh feifei@192.168.0.149 ${command}"
                        }
                    }
                }
            }
        }
    }
}
```

**查看结果**

完成 kernel 编译 并发送

![jenkinsnew6](img/jenkins/jenkinsnew6.png)

触发 job 

![jenkinsnew7](img/jenkins/jenkinsnew7.png)

lava 测试结果

![jenkinsnew8](img/jenkins/jenkinsnew8.png)

![jenkinsnew9](img/jenkins/jenkinsnew9.png)

在 jenkins 端查看结果

![jenkinsnew10](img/jenkins/jenkinsnew10.png)

完成

## 使用 jenkins nodes

经过老师的指导，了解到 jenkins 可以添加多个 node ，实在是很方便

还是那几台机器 但是不用 在每个 stage 里手动连接， 只需要使用 `node('name') `即可使用配置好的机器

下面展示如何配置 node 

![jenkinsnew11](img/jenkins/jenkinsnew11.png)

按照下面的方式填写

启动方式选择 Launch agents via SSH ，credentials 选择 feifei ,这个是前面提过的配置的 ssh credentials 

![jenkinsnew12](img/jenkins/jenkinsnew12.png)

可以看到我们 nodes 列表 ，目前节点的状态

注意使用 node 管理的机器需要安装有 java 17，否则会报错 ，这是之前直接使用 ssh 连接所不需要的

![jenkinsnew13](img/jenkins/jenkinsnew13.png)

下面是使用 node 的版本 ，可以更直观的看出都用了哪个节点

```pipeline
pipeline {
    agent none // 不在整个 pipeline 级别上指定 agent
    stages {
        stage('CHECK KERNEL EXIST') {
            steps {
                script {
                    node('kernel') { // 指定使用标签为 'kernel' 的节点
                    sh '''
                        if ls ~/build | grep -q 'riscv-kernel'; then
                            echo "Found 'riscv-kernel' in ~/build."
                        else
                            echo "'riscv-kernel' not found in ~/build. Cloning repository..."
                            git clone https://gitee.com/feifei-fertilizer/riscv-kernel.git ~/build
                        fi
                        
                        cd ~/build/riscv-kernel
                            
                        # 检查当前分支
                        current_branch=$(git rev-parse --abbrev-ref HEAD)
                        if [ "$current_branch" = "OLK-6.6" ]; then
                            echo "Currently on branch 'OLK-6.6'."
                            # 在这里添加处理分支在该分支上的代码
                        else
                            echo "Not on branch 'OLK-6.6', currently on branch '$current_branch'. Switching to 'OLK-6.6'..."
                            git checkout OLK-6.6
                        fi
                        git pull
                        '''
                    }
                }
            }
        }
        stage('COMPILE THE KERNEL') {
            steps {
                script {
                    node('kernel') { // 使用标签为 'kernel' 的节点
                        sh '''
                        cd riscv-kernel
                        if [ -f ~.config ]; then
                            echo ".config file exists."
                            rm .config
                        else
                            echo ".config file does not exist."
                        fi
                        cp ./arch/riscv/configs/openeuler_defconfig .config
                        '''
                    }
                }
            }
        }
        stage('TRANSFER THE KERNEL') {
            steps {
                script {
                    node('kernel') { // 再次使用标签 'kernel'
                        sh '''
                        if [ -d ./oerv-24.03-kernel-image  ]; then
                            echo "oerv-24.03-kernel-image exists."
                        else
                            echo "oerv-24.03-kernel-image does not exist."
                            git clone git@gitee.com:feifei-fertilizer/oerv-24.03-kernel-image.git
                        fi
                        cp ./riscv-kernel/arch/riscv/boot/Image ./oerv-24.03-kernel-image                        					cd oerv-24.03-kernel-image
                        git commit -m "$(date +"%Y-%m-%d %H:%M:%S")"
                        git push
                        '''
                    }
                }
            }
        }
        stage('TRIGGER LAVA JOB') {
            steps {
                script {
                    node('lava') { // 使用标签 'lava'
                            withCredentials([string(credentialsId: 'lava-api-token', variable: 'TOKEN')]) {
                            def LAVA_URI = "http://admin:${TOKEN}@192.168.0.149:8000/RPC2/"
                            def JOB_NAME = "qemu-oerv-24.03-smoke-test"
                            def JOB_Path = "~/ospp/example/job/qemu/qemu-oerv-24.03-smoke-test.yaml"
                            sh  """
                            # 列出作业并检查
                            if [ -d ./oerv-24.03-kernel-image  ]; then
                                echo "oerv-24.03-kernel-image exists."
                            else
                                echo "oerv-24.03-kernel-image does not exist."
                                git clone git@gitee.com:feifei-fertilizer/oerv-24.03-kernel-image.git
                            fi
                            JOB_INFO=\$(lavacli --uri "$LAVA_URI" jobs list | grep "$JOB_NAME")
                            JOB_ID=\$(echo "\$JOB_INFO" | awk "{print \\\$2}" | cut -d':' -f1 | head -n 1)
                            if [ -n "\$JOB_ID" ]; then
                                echo "Lately Job ID: \$JOB_ID."
                            curl -X POST \
                            "http://192.168.0.149:8000/api/v0.2/jobs/15/resubmit/" \
                            -H "Authorization: Token ${TOKEN}"    
                            else
                                echo "Job '$JOB_NAME' does not exist."
                                lavacli --uri "$LAVA_URI"  jobs submit  $JOB_Path
                            fi
                            """
                        }
                    }
                }
            }        
        }
    }
}
```

这次没有再用 scp 传文件，而是在编译完 Image 后上传到远程仓库中，再让 `lava` 更新远程仓库内容到本地，以此获得 Image

这里套用了之前的命令行 ，看着很臃肿，你也可以用 try catch 等方式来优化一些细节

结果如下

![jenkinsnew15](img/jenkins/jenkinsnew15.png)![jenkinsnew14](img/jenkins/jenkinsnew14.png)
