## 特点

- 自动按`tracker`分类（**可以选择关闭**）。
- 下载完成发送通知（**可以选择关闭**），可选途径：钉钉（[效果图](https://gitee.com/evine/dockerfiles/raw/master/qbittorrent/pictures/notify.png)）, Telegram, ServerChan, 爱语飞飞, PUSHPLUS推送加；搭配RSS功能（[RSS教程](https://www.jianshu.com/p/54e6137ea4e3)）自动下载效果很好；下载完成后还可以补充运行你的自定义脚本。
- 故障时发送通知，可选途径同上。
- 按设定的cron检查tracker状态，如发现种子的tracker状态有问题，将给该种子添加`TrackerError`的标签，方便筛选；如果tracker出错数量超过设定的阈值，给设定渠道发送通知。
- **一些辅助功能：批量修改tracker；检测指定文件夹下未做种的子文件夹/文件；配合IYUU自动重新校验和自动恢复做种；指定设备上线时自动限速；多时段限速等等。**
- 日志输出到docker控制台，可从portainer查看。
- `python`为可选安装项，设置为`true`就自动安装。
- 体积小，默认中文UI，默认东八区时区。
- `iyuu`标签集成了[IYUUPlus](https://github.com/ledccn/IYUUPlus)，自动设置好下载器，减少IYUUPlus设置复杂程度。

## 标签


所有标签可用平台：`amd64` `386` `arm/v6` `arm/v7` `arm64` `ppc64le` `s390x`。

| 标签  | 备注 |
| :-:  | -   |
| `4.x.x` `latest`        | 标签以纯数字版本号命名，这是qBittorrent正式发布的稳定版，其中最新的版本额外增加`latest`标签。 |
| `4.x.x-iyuu` `iyuu`     | 标签中带有`iyuu`字样，基于qBittorrent稳定版集成了[IYUUPlus](https://github.com/ledccn/IYUUPlus)，其中最新的版本额外增加`iyuu`标签，自动设置好下载器。 |
| `4.x.xbetax` `4.x.xrcx` `unstable` | 标签中带有`beta`或`rc`字样，这是qBittorrent发布的测试版，其中最新的测试版额外增加`unstable` 标签。 |

## 更新日志(仅列出稳定版)

| Date     | qBittorrent | libtorrent | alpine | 备注 |
| :-:      | :-:         | :-:        | :-:    | -    |
| 20210608 | 4.3.5       | 1.2.13     | 3.13.5 |      |
| 20210617 | 4.3.5       | 1.2.14     | 3.14.0 | 默认不再安装python，需要开关打开才安装 |
| 20210628 | 4.3.6       | 1.2.14     | 3.14.0 | 优化自动分类和tracker错误检查时的资源占用 |
| 20210804 | 4.3.7       | 1.2.14     | 3.14.0 | 1. 增加5个环境变量控制开关，详见[环境变量清单](#环境变量清单)；<br>2. 增加批量修改 tracker的功能，详见[命令](#命令)；<br>3. 增加在运行`dl-finish %I`时运行自定义脚本的功能，详见[相关问题](#相关问题)。 |
| 20210830 | 4.3.8       | 1.2.14     | 3.14.2 | 1. 增加3个环境变量控制开关，详见[环境变量清单](#环境变量清单)；<br>2. 增加检测指定目录未做种的子文件夹/文件功能，详见[命令](#命令)。 |
| 20211101 | 4.3.9       | 1.2.14     | 3.14.2 | 修复通知内容中含有字符"&"时无法正常发送的bug。 |

## 环境变量清单

在下一节的创建命令中，包括已经提及的变量在内，总共以下环境变量，请根据需要参考创建命令中`WEBUI_PORT` `BT_PORT`的形式自行补充添加到创建命令中。

*注1：默认值的含义是，你不设置这个环境变量为其他值，那么程序就自动使用默认值。*

*注2：所有定时任务cron类的环境变量（以`CRON`这四个字母开头的）在docker cli中请用一对双引号引起来，在docker-compose中不要增加引号。*

*注3：**所有环境变量你都可以不设置，并不影响qbittorrent的使用**，但如果你想用得更爽，你就根据你的需要设置。*

<details>

<summary markdown="span"><b>点击这里展开环境变量列表</b></summary>

**以下是所有标签均可用的环境变量：**

| 序号 | 变量名                   | 默认值         | 说明 |
| :-: | :-:                     | :-:           | -    |
|  1  | PUID                    | 1000          | 用户的uid，输入命令`id -u`可以查到，以该用户运行qbittorrent-nox，群晖用户必须改。 |
|  2  | PGID                    | 100          | 用户的gid，输入命令`id -g`可以查到，以该用户运行qbittorrent-nox，群晖用户必须改。 |
|  3  | WEBUI_PORT              | 8080          | WebUI访问端口，建议自定义，如需公网访问，需要将qBittorrent和公网之间所有网关设备上都设置端口转发。 |
|  4  | BT_PORT                 | 34567         | BT监听端口，建议自定义，如需达到`可连接`状态，需要将qBittorrent和公网之间所有网关设备上都设置端口转发。 |
|  5  | TZ                      | Asia/Shanghai | 时区，可填内容详见：https://meetingplanner.io/zh-cn/timezone/cities |
|  6  | INSTALL_PYTHON          | false         | 默认不安装python，如需要python（qBittorrent的搜索功能必须安装python），请设置为`true`，设置后将在首次启动容器时自动安装好。 |
|  7  | ENABLE_AUTO_CATEGORY    | true          | 是否自动分类，默认自动分类，如不想自动分类，请设置为`false`。4.3.7+可用。 |
|  8  | DL_FINISH_NOTIFY        | true          | 默认会在下载完成时向设定的通知渠道发送种子下载完成的通知消息，如不想收此类通知，则设置为`false`。 |
|  9  | TRACKER_ERROR_COUNT_MIN | 3             | 可以设置的值：正整数。在检测到tracker出错的种子数量超过这个阈值时，给设置的通知渠道发送通知。4.3.7+可用。 |
|  10 | UMASK_SET               | 000           | 权限掩码`umask`，指定qBittorrent在建立文件时预设的权限掩码，可以设置为`022`。 |
|  11 | TG_USER_ID              |               | 通知渠道telegram，如需使用需要和 TG_BOT_TOKEN 同时赋值，私聊 @getuseridbot 获取。 |
|  12 | TG_BOT_TOKEN            |               | 通知渠道telegram，如需使用需要和 TG_USER_ID 同时赋值，私聊 @BotFather 获取。 |
|  13 | TG_PROXY_ADDRESS        |               | 给TG机器人发送消息的代理地址，当设置了`TG_USER_ID`和`TG_BOT_TOKEN`后可以设置此值，形如：`http://192.168.1.1:7890`，也可以不设置。4.3.7+可用。 |
|  14 | TG_PROXY_USER           |               | 给TG机器人发送消息的代理的用户名和密码，当设置了`TG_PROXY_ADDRESS`后可以设置此值，格式为：`<用户名>:<密码>`，形如：`admin:password`，如没有可不设置。4.3.7+可用。 |
|  15 | DD_BOT_TOKEN            |               | 通知渠道钉钉，如需使用需要和 DD_BOT_SECRET 同时赋值，机器人设置中webhook链接`access_token=`后面的字符串（不含`=`以及`=`之前的字符）。 |
|  16 | DD_BOT_SECRET           |               | 通知渠道钉钉，如需使用需要和 DD_BOT_TOKEN 同时赋值，机器人设置中**只启用**`加签`，加签的秘钥，形如：`SEC1234567890abcdefg`。 |
|  17 | IYUU_TOKEN              |               | 通知渠道爱语飞飞，通过 [这里](http://iyuu.cn) 获取，爱语飞飞的TOKEN。 |
|  18 | SCKEY                   |               | 通知渠道ServerChan，通过 [这里](http://sc.ftqq.com/3.version) 获取。 |
|  19 | PUSHPLUS_TOKEN          |               | 通知渠道PUSH PLUS，填入其token，详见 [这里](http://www.pushplus.plus)，4.3.7+可用。 |
|  20 | CRON_HEALTH_CHECK       | 12 * * * *    | 宕机检查的cron，在设定的cron运行时如发现qbittorrent-nox宕机了，则向设置的通知渠道发送通知。 |
|  21 | CRON_AUTO_CATEGORY      | 32 */2 * * *  | 自动分类的cron，在设定的cron将所有种子按tracker分类。对于种子很多的大户人家，建议把cron频率修改低一些，一天一次即可。此cron可以由`ENABLE_AUTO_CATEGORY`关闭，关闭后不生效。 |
|  22 | CRON_TRACKER_ERROR      | 52 */4 * * *  | 检查tracker状态是否健康的cron，在设定的cron将检查所有种子的tracker状态，如果有问题就打上`TrackerError`的标签。对于种子很多的大户人家，建议把cron频率修改低一些，一天一次即可。 |
|  23 | MONITOR_IP              |               | 可设置为局域网设备的ip，多个ip以半角空格分隔，形如：`192.168.1.5 192.168.1.9 192.168.1.20`。本变量作用：当检测到这些设置的ip中有任何一个ip在线时（检测频率为每分钟），自动启用qbittorent客户端的“备用速度限制”，如果都不在线就关闭“备用速度限制”。“备用速度限制”需要事先设置好限制速率，建议在路由器上给需要设置的设备固定ip。在docker cli中请使用一对双引号引起来，在docker-compose中不要使用引用。4.3.8+可用。 |
|  24 | CRON_ALTER_LIMITS       |               | 启动和关闭“备用速度限制“的cron，主要针对多时段限速场景，当设置了`MONITOR_IP`时本变量的cron不生效（因为会冲突）。详见 [相关问题](#相关问题) 一节“如何使用 CRON_ALTER_LIMITS 这个环境变量”。4.3.8+可用。 |
|  25 | CRON_IYUU_HELP          |               | IYUUPlus辅助任务的cron，自动重校验、自动恢复做种，详见 [相关问题](#相关问题) 一节“如何使用 CRON_IYUU_HELP 这个环境变量”。4.3.8+可用。 |

**以下是仅`iyuu`标签额外可用的环境变量：**

| 序号 | 变量名                   | 默认值         | 说明 |
| :-: | :-:                     | :-:                                    | -    |
|  1  | IYUU_REPO_URL           | `https://gitee.com/ledc/iyuuplus.git` | 指定从哪里获取IYUUPlus的代码，默认从gitee更新，如果你想从github更新，可以设置为：`https://github.com/ledccn/IYUUPlus.git` |

</details>

## 创建

**点击下列每种部署方式可展开详情。**

<details>

<summary markdown="span"><b>群晖</b></summary>

请见 [这里](https://gitee.com/evine/dockerfiles/blob/master/qbittorrent/dsm.md)。安装后访问`http://ip:8080`。如想使用集成了IYUUPlus的qBittorrent（自动设置好IYUUPlus中的下载器），请使用docker cli以命令行方式部署。

</details>

<details>

<summary markdown="span"><b>docker cli</b></summary>

```
## latest标签或unstable标签
docker run -dit \
  -v $PWD/qbittorrent:/data `# 冒号左边请修改为你想在本地保存的路径，这个路径用来保存你个人的配置文件` \
  -e PUID="1000"        `# 输入id -u可查询，群晖必须改` \
  -e PGID="100"         `# 输入id -g可查询，群晖必须改` \
  -e WEBUI_PORT="8080"  `# WEBUI控制端口，可自定义` \
  -e BT_PORT="34567"    `# BT监听端口，可自定义` \
  -p 8080:8080          `# 冒号左右一样，要和WEBUI_PORT一致，命令中的3个8080要改一起改` \
  -p 34567:34567/tcp    `# 冒号左右一样，要和BT_PORT一致，命令中的5个34567要改一起改` \
  -p 34567:34567/udp    `# 冒号左右一样，要和BT_PORT一致，命令中的5个34567要改一起改` \
  --restart always \
  --name qbittorrent \
  --hostname qbittorrent \
  nevinee/qbittorrent   `# 如想参与qbittorrent测试工作，可以指定测试标签nevinee/qbittorrent:unstable`

## iyuu标签
docker run -dit \
  -v $PWD/qbittorrent:/data `# 冒号左边请修改为你想在本地保存的路径，这个路径用来保存你个人的配置文件` \
  -e PUID="1000"        `# 输入id -u可查询，群晖必须改` \
  -e PGID="100"         `# 输入id -g可查询，群晖必须改` \
  -e WEBUI_PORT="8080"  `# WEBUI控制端口，可自定义` \
  -e BT_PORT="34567"    `# BT监听端口，可自定义` \
  -p 8080:8080          `# 冒号左右一样，要和WEBUI_PORT一致，命令中的3个8080要改一起改` \
  -p 34567:34567/tcp    `# 冒号左右一样，要和BT_PORT一致，命令中的5个34567要改一起改` \
  -p 34567:34567/udp    `# 冒号左右一样，要和BT_PORT一致，命令中的5个34567要改一起改` \
  -p 8787:8787          `# IYUUPlus的WebUI控制端口` \
  --restart always \
  --name qbittorrent \
  --hostname qbittorrent \
  nevinee/qbittorrent:iyuu
```

- 除`WEBUI_PORT` `BT_PORT` `PUID` `PGID`这几个环境变量外，如果你还需要使用其他环境变量，请根据[环境变量清单](#环境变量清单)按照`-e 变量名="变量值" \`的形式自行添加在创建命令中。

- armv7设备如若无法使用网络，可能是seccomp问题，详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0#time64_requirements)。可以在创建命令中增加一行`--security-opt seccomp=unconfined \` 来解决。

- 创建完成后请访问`http://<IP>:<WEBUI_PORT>`（如未修改，对安装机默认是`http://127.0.0.1:8080`）来对qbittorrent作进一步设置，初始用户名密码：`admin/adminadmin`。如要在公网访问，请务必修改用户名和密码。

- 针对`iyuu`标签，创建后可访问`http://<IP>:8787`进行IYUUPlus设置。

</details>

<details>

<summary markdown="span"><b>docker-compose</b></summary>

新建`docker-compose.yml`文件如下（[点我查看arm设备如何安装docker-compose](https://www.jianshu.com/p/1beecfed17bc)），创建好后以`docker-compose up -d`命令启动即可。

```
version: "2.0"
services:
  qbittorrent:
    image: nevinee/qbittorrent  # 如想参与测试工作可以指定nevinee/qbittorrent:unstable，如想使用集成了iyuu的版本请指定nevinee/qbittorrent:iyuu
    container_name: qbittorrent
    restart: always
    tty: true
    network_mode: bridge
    hostname: qbitorrent
    volumes:
      - ./data:/data      # 配置保存目录
    environment:          # 下面未列出的其他环境变量请根据环境变量清单自行添加
      - WEBUI_PORT=8080   # WEBUI控制端口，可自定义
      - BT_PORT=34567     # BT监听端口，可自定义
      - PUID=1000         # 输入id -u可查询，群晖必须改
      - PGID=100          # 输入id -g可查询，群晖必须改
    ports:
      - 8080:8080        # 冒号左右一致，必须同WEBUI_PORT一样，本文件中的3个8080要改一起改
      - 34567:34567      # 冒号左右一致，必须同BT_PORT一样，本文件中的5个34567要改一起改
      - 34567:34567/udp  # 冒号左右一致，必须同BT_PORT一样，本文件中的5个34567要改一起改
      #- 8787:8787       # 如使用的是nevinee/qbittorrent:iyuu标签，请解除本行注释
    #security_opt:       # armv7设备请解除本行和下一行的注释
      #- seccomp=unconfined
```

如若想将qbittorrent建立在已经创建好的macvlan网络上，可以按如下方式创建：

```
version: "2.0"
services:
  qbittorrent:
    image: nevinee/qbittorrent # 如想参与测试工作可以指定nevinee/qbittorrent:unstable，如想使用集成了iyuu的版本，请指定nevinee/qbittorrent:iyuu
    container_name: qbittorrent
    restart: always
    tty: true
    networks: 
      <你的macvlan网络名称>:
        ipv4_address: <你想设置的ip>
        aliases:
          - qbittorrent
    dns:   # docker是无法为macvlan网络提供dns解析服务的，要想正常在macvlan网络上发通知，请给容器添加dns服务器，你也可以直接使用你的网关ip作为dns服务器
      - 223.5.5.5
      - 114.114.114.114
      - 1.2.4.8
    hostname: qbitorrent
    volumes:
      - ./data:/data
    environment:          # 下面未列出的其他环境变量请根据环境变量清单自行添加
      - WEBUI_PORT=8080   # WEBUI控制端口，可自定义
      - BT_PORT=34567     # BT监听端口，可自定义
      - PUID=1000         # 输入id -u可查询，群晖必须改
      - PGID=100          # 输入id -g可查询，群晖必须改
    #security_opt:        # armv7设备请解除本行和下一行的注释
      #- seccomp=unconfined

networks: 
  <你的macvlan网络名称>:
    external: true
```

- 创建完成后请访问`http://<IP>:<WEBUI_PORT>`（如未修改，对安装机默认是`http://127.0.0.1:8080`）来对qbittorrent作进一步设置，初始用户名密码：`admin/adminadmin`。如要在公网访问，请务必修改用户名和密码。

- 针对`iyuu`标签，创建后可访问`http://<IP>:8787`进行IYUUPlus设置。

</details>

## 目录说明

如果按照上述任何一种部署方式，在映射的目录下会有以下文件夹：

```
/data                         # 基础路径在容器内为/data，下面所有文件夹均处于/data的下一层，基础路径在宿主机上为你创建容器时映射的
├── cache                     # qbittorrent的缓存目录
├── certs                     # 用来存放ssl证书，默认是空的，可另外使用acme.sh来申请ssl证书
├── config                    # 所有的配置文件保存目录
│   ├── qBittorrent.conf      # **配置文件，很重要，如需恢复配置此文件必须保留**
│   ├── qBittorrent-data.conf # **上传下载数据统计文件，如需恢复配置此文件必须保留**
│   └── rss                   # **rss的配置文件保存目录，如需恢复配置此目录必须保留**
├── data                      # 所有的数据文件保存目录
│   ├── BT_backup             # **torrent的快速恢复文件保存目录，如需恢复做种数据此目录必须保留**
│   ├── GeoDB                 # IP数据保存目录
│   ├── logs                  # 日志文件保存目录
│   ├── nova3                 # 启用qBittorrent搜索功能后相关文件保存目录
│   └── rss                   # rss订阅下载文件保存目录
├── diy                       # 存放你自己编写的脚本的目录，diy.sh需要存放在此
├── downloads                 # 默认下载目录
├── iyuu_db                   # 仅iyuu标签有此目录，用来保存IYUUPlus的配置文件，IYUUPlus用户须保留此文件夹
├── logs -> data/logs         # 只是个软连接，连接到容器内的/data/data/logs
├── temp                      # 下载文件临时存放目录，默认在配置中未启用
├── torrents                  # 保存种子文件目录，默认在配置中未启用
├── watch                     # 监控目录，监控这个目录下的.torrent文件并自动下载，默认在配置中未启用
└── webui                     # 存放其他webui文件的目录，需要自己存放，默认在配置中未启用
```

*有两个星号标记的文件或目录是重要目录，恢复数据必须要有这几个。*

*在这里可以查阅所有可用的非官方webui：https://github.com/qbittorrent/qBittorrent/wiki/List-of-known-alternate-WebUIs*

## 相关问题

**点击每个问题可展开答案。**

<details>

<summary markdown="span"><b>使用此镜像会导致封号吗</b></summary>

此镜像未修改qbittorrent客户端官方任何信息，在和pt站tracker服务器交互时反馈的一切信息均是qbittorrent官方原版反馈的信息，此镜像只是基于qbittorrent额外增加了一些脚本而已。增加的脚本全部代码在 [这里](https://github.com/devome/dockerfiles/tree/master/qbittorrent) 可以查看，不会因为使用此镜像导致pt账号被封。

</details>

<details>

<summary markdown="span"><b>如何在运行 dl-finish "%I" 时调用自定义脚本</b></summary>

- 此功能可用版本：4.3.7+；

- 只要你将名为`diy.sh`的shell脚本放在映射目录下的`diy`文件夹下即可，容器内路径为`/data/diy/diy.sh`（hash已存储在名为torrent_hash的变量中，可通过此值获取其他信息）。

- 如想传入除“%I”种子hash之外的其他参数，可以在 设置->下载->Torrent 完成时运行外部程序 下填入这种形式：`dl-finish "%I" "%N" "%L" "%F"`，必须保证"%I"是第一个参数，后面的参数根据你自己需要调整。在`diy.sh`中，`"%N" "%L" "%F"`分别通过`$2 $3 $4`调用。如：`cmd "$2" "$3 "$4"`。$2, $3, $4分别指传入的第2, 第3, 第4个参数，分别对应`"%N" "%L" "%F"`。

- 假如你要调用其他语言的脚本，比如python，可以在`diy.sh`中写上`python3 /data/diy/your_python_scripts.py $torrent_hash`即可。如需要传入更多参数，请参考上一条在“Torrent 完成时运行外部程序”填入形如`dl-finish "%I" "%N" "%L" "%F"`的形式，然后在`diy.sh`中写上`python3 /data/diy/your_python_scripts.py "$2" "$3" "$4"`。

</details>

<details>

<summary markdown="span"><b>如何优雅的关闭qbittorrent容器</b></summary>

- 暴力强制关闭qbittorrent容器自然是容易丢失任务的，所以在关闭前应当先将所有种子暂停，过一会再关闭容器。这时，所有的配置文件和torrent恢复文件也都是暂停后的状态，然后再新建容器或重新部署，启动后再开始所有任务。

- 还有一点要注意，千万不要在有下载任务时关闭或重启qbittorrent容器。

</details>

<details>

<summary markdown="span"><b>如何从其他作者的镜像/套件版转移至本镜像</b></summary>

-  **如果启用了ssl/https，请先在原qbittorrent的webui中禁用，或者将`qBittorrent.conf`中`WebUI\HTTPS\Enabled=true`改为`WebUI\HTTPS\Enabled=false`。**

- 请注意要优雅的关闭旧容器后再处理配置文件。

- 进入原来容器的映射目录（或原套件版配置文件保存目录，可能是隐藏的）下，在config下分别找到`qBittorrent.conf` `qBittorrent-data.conf` `rss`，在data下找到`BT_backup`，然后将其参考上面的目录树放在新容器的映射目录下，然后在创建容器时，保证新容器中的下载文件的保存路径和旧容器一致，并新建容器即可。

- 举例说明如何保证新容器中的下载文件的保存路径和旧容器一致，比如旧容器中下载了一个 `xxx.2020.BluRay.1080p.x264.DTS-XXX`，保存路径为`/movies`（宿主机上的真实路径为`/volume1/home/id/movies`），那么在新建新容器时，给新容器增加一个路径映射：`/volume1/home/id/movies:/movies`　即可。

- 注意新容器的PUID/PGID和要旧容器保持一致。

- 注意在 `设置` -> `下载` 中勾选 `Torrent 完成时运行外部程序` 并填入 `dl-finish "%I"`，如需要https要重新设置证书路径。

</details>

<details>

<summary markdown="span"><b>可不可以不使用默认下载目录</b></summary>

如不想使用默认下载目录，可以额外映射其他路径，比如映射`/volume1/movies:/movies`，然后在qbittorrent中设置默认下载目录为`/movies`，也可以在每次下载时自己输入下载目录为`/movies`。

</details>

<details>

<summary markdown="span"><b>遗忘登陆密码如何重置</b></summary>

```
# 进入容器
docker exec -it qbittorrent bash

# 如果启用了ssl
curl -k -X POST -d 'json={"web_ui_username":"新的用户名","web_ui_password":"新的密码"}' https://127.0.0.1:${WEBUI_PORT}/api/v2/app/setPreferences

# 如果未启用ssl
curl -X POST -d 'json={"web_ui_username":"新的用户名","web_ui_password":"新的密码"}' http://127.0.0.1:${WEBUI_PORT}/api/v2/app/setPreferences
```

</details>

<details>

<summary markdown="span"><b>如何与emby, jellyfin, plex等等配合使用</b></summary>

将需要配合使用的容器的环境变量PUID/PGID设置为一样的即可。

</details>

<details>

<summary markdown="span"><b>启用了其他非官方webui，导致webui打不开，如何关闭</b></summary>

```
# 进入容器
docker exec -it qbittorrent bash

# 如果启用了ssl
curl -k -X POST -d 'json={"alternative_webui_enabled":false}' https://127.0.0.1:${WEBUI_PORT}/api/v2/app/setPreferences

# 如果未启用ssl
curl -X POST -d 'json={"alternative_webui_enabled":false}' http://127.0.0.1:${WEBUI_PORT}/api/v2/app/setPreferences
```

</details>

<details>

<summary markdown="span"><b>如何自动更新容器</b></summary>

安装watchtower即可，详见 [这里](https://hub.docker.com/r/containrrr/watchtower)

</details>

<details>

<summary markdown="span"><b>安装了watchtower，如何让qbittorrent不被watchtower自动更新</b></summary>

- 方法1：部署qbittorrent容器时，直接指定标签，如`nevinee/qbittorrent:4.3.7`；

- 方法2（推荐）：在部署时在命令中添加一个label：`com.centurylinklabs.watchtower.enable=false`：

    docker cli：
    ```
    --label com.centurylinklabs.watchtower.enable=false \
    ```

    docker-compose:
    ```
        labels:
          com.centurylinklabs.watchtower.enable: false
    ```

</details>

<details>

<summary markdown="span"><b>为何建议将qbittorrent安装在macvlan网络上</b></summary>

- 可以在网关上给qbittorrent所在ip独立设置限速; 

- 如果有用openwrt时，可以让qbittorrent所在ip跳过代理。

</details>

<details>

<summary markdown="span"><b>将qbittorrent安装在macvlan网络上时，如何使用IYUUAutoReseed自动辅种</b></summary>

将两个容器都安装在同一个macvlan网络上即可，或者直接安装`nevinee/qbittorrent:iyuu`标签。

</details>

<details>

<summary markdown="span"><b>如何使用 CRON_ALTER_LIMITS 这个环境变量</b></summary>

- 4.3.8+可用。

- 该功能主要提供给多时段限速场景使用，请在qbittorrent客户端中先设置好”备用速度限制“的限制速率。

- 当设置了有效的`MONITOR_IP`时，`CRON_ALTER_LIMITS`的cron不生效（因为会冲突）。

- 设置形式如：`0 5 * * *:0 18 * * *|0 8 * * *:0 22 * * *`，`|`前面的cron是启用“备用速度限制”的时间点，`|`后面的cron是关闭“备用速度限制”的时间点。需要在一天中多次启用“备用速度限制”的，以`:`分隔每个cron，可以任意个cron，需要多次关闭“备用速度限制”的同样以`:`分隔每个cron。

- 比如需要在周一至周五的5:00-8:00、17:30-23:30，以及周六、周日的9:00-23:30进行限速，那么可以设置`CRON_ALTER_LIMITS`为`0 5 * * 1-5:30 17 * * 1-5:0 9 * * 0,6|0 8 * * 1-5:30 23 * * *`。

- 比如需要在周一至周五的17:30-22:00，以及周六、周日的8:30-23:00进行限速，那么可以设置`CRON_ALTER_LIMITS`为`30 17 * * 1-5:30 8 * * 0,6|0 22 * * 1-5:0 23 * * 0,6`。

- 在docker cli中请使用一对双引号引起来，在docker-compose.yml中请勿增加引号。

</details>

<details>

<summary markdown="span"><b>如何使用 CRON_IYUU_HELP 这个环境变量</b></summary>

- 4.3.8+可用。

- 在设置的时间点执行`iyuu-help`命令，实现以下功能：

  1. 检查下载清单（就是qbittorrent筛选“下载”的清单），检测该清单中处于暂停状态、并且下载完成率为0%（辅种的种子在校验前也是0%）的种子，将这些种子请求重新校验。**已经请求过校验并且完成率大于0%的种子不会再次校验。**
  2. 检查暂停清单（就是qbittorrent筛选“暂停”的清单），检测该清单中100%下载完成/100%校验通过的种子，将这些种子恢复做种。**校验未通过不达100%完成率的种子不会启动，仍然保持暂停状态。**

- 配合IYUUAutoReseed，将CRON_IYUU_HELP设置在IYUUAutoReseed自动辅种任务的cron以后，并运行若干次即可（因为校验比较费时，所以要多次运行）。

- 比如你IYUUAutoReseed辅种任务的cron是`22 7 * * *`，你想从辅种任务3分钟后，每10分钟运行一次，共运行4次，那么可以设置CRON_IYUU_HELP为：`25-55/10 7 * * *`。

- 在docker cli中请使用一对双引号引起来，在docker-compose.yml中请勿增加引号。

</details>

<details>

<summary markdown="span"><b>为什么没法使用搜索功能</b></summary>

搜索功能依赖于python，请在创建容器时添加环境变量`INSTALL_PYTHON`，并将值设置为`true`。

</details>

## 命令

<details>

<summary markdown="span"><b>1. 由设置的cron或在下载完成时自动运行的命令（所有标签可用），点击本文字可展开详情</b></summary>

```
# 发送通知
docker exec qbittorrent notify "测试消息标题" "测试消息通知内容"

# 将所有种子按tracker进行分类，由CRON_AUTO_CATEGOR设置的cron来调用
docker exec qbittorrent auto-cat -a

# 将指定种子按tracker进行分类，会自动在下载完成时运行一次（由 dl-finish <hash> 命令调用）
docker exec qbittorrent auto-cat -i <hash>   # hash可以在种子详情中的"普通"标签页上查看到

# 下载完成时将种子分类，并发送通知，已经在配置文件中填好了
docker exec qbittorrent dl-finish <hash>     # hash可以在种子详情中的"普通"标签页上查看到

# 检查qbittorrent是否宕机，如宕机则发送通知，由CRON_HEALTH_CHECK设置的cron来调用
docker exec qbittorrent health-check

# 检查所有种子的tracker状态是否有问题，如有问题，给该种子添加一个 TrackerError 的标签，由CRON_TRACKER_ERROR设置的cron来调用
docker exec qbittorrent tracker-error

# 每分钟检测MONITOR_IP设置的ip是否在线，如有任何一个ip在线，则启用“备用速度限制”，4.3.8+可用。
docker exec qbittorrent detect-ip

## 启用可关闭“备用速度限制”，4.3.8+可用，由CRON_ALTER_LIMITS设置的cron来调用
docker exec qbittorrent alter-limits on    # 启用“备用速度限制”
docker exec qbittorrent alter-limits off   # 关闭“备用速度限制”

## IYUUAutoReseed辅助任务，自动重校验、自动恢复做种，4.3.8+可用，由CRON_IYUU_HELP设置的cron来调用
docker exec qbittorrent iyuu-help
```

</details>

<details open>

<summary markdown="span"><b>2. 需要手动运行的命令（所有标签可用）</b></summary>

```
# 查看qbittorrent日志，也可以直接在portainer控制台中看到
docker logs -f qbittorrent

# 批量修改tracker，4.3.7+可用
docker exec -it qbittorrent change-tracker

# 检测指定文件夹下没有在qbittorrent客户端中做种或下载的子文件夹/子文件，由用户确认是否删除，4.3.8+可用
docker exec -it qbittorrent del-unseed-dir
```

</details>

<details>

<summary markdown="span"><b>3. 仅“iyuu”标签可用的命令，点击展开</b></summary>

```
# 更新IYUUPlus脚本
docker exec -it qbittorrent git -C /iyuu pull

# 重启IYUUPlus
docker exec -it qbittorrent php /iyuu/start.php restart -d 
```

</details>

## 效果图

![notify](https://gitee.com/evine/dockerfiles/raw/master/qbittorrent/pictures/notify.png)

![iyuu-help](https://gitee.com/evine/dockerfiles/raw/master/qbittorrent/pictures/iyuu-help.png)

![change-tracker](https://gitee.com/evine/dockerfiles/raw/master/qbittorrent/pictures/change-tracker.png)

![del-unseed-dir](https://gitee.com/evine/dockerfiles/raw/master/qbittorrent/pictures/del-unseed-dir.png)


## 参考

- [crazymax/qbittorrent](https://hub.docker.com/r/crazymax/qbittorrent) , 参考了Dockerfile; 
  
- [80x86/qbittorrent](https://hub.docker.com/r/80x86/qbittorrent), 借鉴了标签和分类的理念，正因为此镜像源码未公开，且长期不更新，这才催生我重写代码；

- [arpaulnet/s6-overlay-stage](https://hub.docker.com/r/arpaulnet/s6-overlay-stage), 学习了多平台镜像制作方法。

## 源代码、问题反馈、意见建议

旧的Github账号已经删除了，抱歉。

全套代码见 [Github](https://github.com/devome/dockerfiles/tree/master/qbittorrent) 或 [Gitee](https://gitee.com/evine/dockerfiles/tree/master/qbittorrent)。

如有使用上的问题，或者有其他好的功能建议，请在 [Github这里](https://github.com/devome/dockerfiles/issues) 或 [Gitee这里](https://gitee.com/evine/dockerfiles/issues) 提交。

[![dockeri.co](http://dockeri.co/image/nevinee/qbittorrent)](https://hub.docker.com/r/nevinee/qbittorrent/)
