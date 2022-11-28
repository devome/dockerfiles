## 特点

- 自动按`tracker`分类或打标签（**可以选择关闭，可以选择采用qBittorrent中的“分类”还是“标签”**）。

- 下载完成发送通知（**可以选择关闭**），可选途径：钉钉（[效果图](https://gitee.com/evine/dockerfiles/raw/master/qbittorrent/pictures/notify.png)）, Telegram, ServerChan, 爱语飞飞, PUSHPLUS推送加；搭配RSS功能（[RSS教程](https://www.jianshu.com/p/54e6137ea4e3)）自动下载效果很好；下载完成后还可以补充运行你的自定义脚本。

- 故障时发送通知，可选途径同上。

- 按设定的cron检查tracker状态，如发现种子的tracker状态有问题，将给该种子添加`TrackerError`的标签，方便筛选；如果tracker出错数量超过设定的阈值，给设定渠道发送通知。

- **一些辅助功能：批量修改tracker；检测指定文件夹下未做种的子文件夹/文件；生成做种文件清单；生成未做种文件清单；配合IYUU自动重新校验和自动恢复做种；指定设备上线时自动限速；多时段限速等等。**

- **如需要下载完成后自动触发EMBY/JELLYFIN扫描媒体库，触发ChineseSubFinder自动为刚刚下载完成的视频自动下载字幕，请按照 [这里](https://github.com/devome/dockerfiles/tree/master/qbittorrent/diy) 操作。**

- 日志输出到docker控制台，可从portainer查看。

- `python`为可选安装项，设置为`true`就自动安装。

- 体积小，默认中文UI，默认东八区时区。

- `iyuu`标签集成了[IYUUPlus](https://github.com/ledccn/IYUUPlus)，自动设置好下载器，减少IYUUPlus设置复杂程度。

## 标签

1. **`4.x.x` , `latest`**: 标签以纯数字版本号命名，这是qBittorrent正式发布的稳定版，其中最新的版本额外增加`latest`标签。`Qt: 5.15.6` `Libtorrent: 2.0.8` `Boost: 1.80.0` `OpenSSL:3.0.7` `zlib: 1.2.13`。
  
2. **`4.x.x-iyuu` , `latest-iyuu` , `iyuu`**: 标签中带有`iyuu`字样，基于qBittorrent稳定版集成了[IYUUPlus](https://github.com/ledccn/IYUUPlus)，其中最新的版本额外增加`latest-iyuu`和`iyuu`标签，自动安装好[IYUUPlus](https://github.com/ledccn/IYUUPlus)，自动设置好下载器，主要针对不会设置下载器的用户。

3. **`4.x.xbetax` , `4.x.xrcx` , `unstable`**: 标签中带有`beta`或`rc`字样，这是qBittorrent发布的测试版，其中最新的测试版额外增加`unstable` 标签。此标签仅供测试使用及向qBittorrent官方反馈bug使用。

4. **`edge`**: 基于`alpine:edge`制作的镜像，体积最小，所依赖的组件版本最新，会提供`riscv64`版本镜像。**所有新功能或者BUG修复，或者有任何变化时，都会第一时间更新到此标签。**`Qt: 6.4.1` `Libtorrent: 2.0.8` `Boost: 1.80.0` `OpenSSL: 3.0.7` `zlib: 1.2.13`。

## 更新日志（仅列出稳定版）

| Date     | qBittorrent | libtorrent | alpine | 备注 |
| :-:      | :-:         | :-:        | :-:    | -    |
| 20210608 | 4.3.5       | 1.2.13     | 3.13.5 |      |
| 20210617 | 4.3.5       | 1.2.14     | 3.14.0 | 默认不再安装python，需要开关打开才安装 |
| 20210628 | 4.3.6       | 1.2.14     | 3.14.0 | 优化自动分类和tracker错误检查时的资源占用 |
| 20210804 | 4.3.7       | 1.2.14     | 3.14.0 | 1. 增加5个环境变量控制开关，详见[环境变量清单](#环境变量清单)；<br>2. 增加批量修改 tracker的功能，详见[命令](#命令)；<br>3. 增加在运行`dl-finish %I`时运行自定义脚本的功能，详见[相关问题](#相关问题)。 |
| 20210830 | 4.3.8       | 1.2.14     | 3.14.2 | 1. 增加3个环境变量控制开关，详见[环境变量清单](#环境变量清单)；<br>2. 增加检测指定目录未做种的子文件夹/文件功能，详见[命令](#命令)。 |
| 20211101 | 4.3.9       | 1.2.14     | 3.14.2 | 修复通知内容中含有字符"&"时无法正常发送的bug。 |
| 20220107 | 4.4.0       | 2.0.5      | 3.14.3 | 1. 增加环境变量`EXTRA_PACKAGES`，详见[环境变量清单](#环境变量清单)；<br>2. 默认运行自动分类程序时仅对未分类的种子进行分类，如需要强制对所有种子进行分类，请参考[命令](#命令)；<br>3. 增加两个需要手动运行的脚本`report-seed-files`(导出所有做种文件清单)和`report-unseed-files`(导出指定文件夹下未做种文件清单)，详见[命令](#命令)。 |
| 20220216 | 4.4.1       | 2.0.5      | 3.14.3 |      |
| 20220325 | 4.4.2       | 2.0.5      | 3.14.4 |      |
| 20220524 | 4.4.3       | 2.0.6      | 3.16.0 | 1. 修复存在多个标签时无法移除`TrackerError`标签的bug；</br>2. 增加企业微信群机器人的通知渠道。</br>3. 升级openssl到1.1.1o，boost到1.78，alpine到3.16.0，升级iyuu镜像中的php7为php8。 |
| 20220526 | 4.4.3.1     | 2.0.6      | 3.16.0 |      |
| 20220824 | 4.4.4       | 2.0.7      | 3.16.2 | 1. 增加`remove-track`脚本，详见[命令](#命令)；</br>2. 优化`del-unseed-dir`脚本，现还可以一次性检测多个目录了；</br>3. 增加Gotity通知环境变量`GOTIFY_URL` `GOTIFY_APP_TOKEN` `GOTIFY_PRIORITY`，详见[环境变量清单](#环境变量清单)。 |
| 20220831 | 4.4.5       | 2.0.7      | 3.16.2 |       |
| 20221024 | 4.4.5       | 2.0.8      | 3.16.2 | libtorrent-rasterbar v2.0.8 修复了内存溢出的问题，因此更新一下qbittorrent。 |
| 20221109 | 4.3.9       | 1.2.18     | 3.16.2 | 添加`CATEGORY_OR_TAG`环境变量，详见环境变量清单；考虑到4.3.9将是许多人的使用版本，将全部新功能重新应用到4.3.9版本中。 |
| 20221126 | 4.3.9</br>4.5.0 | 1.2.18</br>2.0.8 | 3.17.0 | alpine升级至3.17.0，升级依赖版本为：boost 1.80.0, openssl 3.0.7, qt 5.16.6, zlib 1.2.13 |

## 环境变量清单

在下一节的创建命令中，包括已经提及的变量在内，总共以下环境变量，请根据需要参考创建命令中`WEBUI_PORT` `BT_PORT`的形式自行补充添加到创建命令中。

*注1：默认值的含义是，你不设置这个环境变量为其他值，那么程序就自动使用默认值。*

*注2：所有定时任务cron类的环境变量（以`CRON`这四个字母开头的）在docker cli中请用一对双引号引起来，在docker-compose中不要增加引号。*

*注3：**所有环境变量你都可以不设置，并不影响qbittorrent的使用**，但如果你想用得更爽，你就根据你的需要设置。*

<details>

<summary markdown="span"><b><h3> ▶▶▶ 点击这里展开环境变量列表 ◀◀◀ </h></b></summary>

**以下是所有标签均可用的环境变量：**

| 序号 | 变量名                   | 默认值         | 说明 |
| :-: | :-:                     | :-:           | -    |
|  1  | S6_SERVICES_GRACETIME   | 3000(qb<=4.3.9)<br>30000(qb>=4.4.0) | 在关闭/重启/重建容器时，关闭容器内程序（主要就是qbittorrent程序）前的**最长等待时间（单位：毫秒）**。具体见 [相关问题](#相关问题) 问题16。建议4.3.9及以下版本设置为`30000`。 |
|  2  | PUID                    | 1000          | 用户的uid，输入命令`id -u`可以查到，以该用户运行qbittorrent-nox，群晖用户必须改。 |
|  3  | PGID                    | 100          | 用户的gid，输入命令`id -g`可以查到，以该用户运行qbittorrent-nox，群晖用户必须改。 |
|  4  | WEBUI_PORT              | 8080          | WebUI访问端口，建议自定义，如需公网访问，需要将qBittorrent和公网之间所有网关设备上都设置端口转发。 |
|  5  | BT_PORT                 | 34567         | BT监听端口，建议自定义，如需达到`可连接`状态，需要将qBittorrent和公网之间所有网关设备上都设置端口转发。 |
|  6  | TZ                      | Asia/Shanghai | 时区，可填内容详见：https://meetingplanner.io/zh-cn/timezone/cities |
|  7  | INSTALL_PYTHON          | false         | 默认不安装python，如需要python（qBittorrent的搜索功能必须安装python），请设置为`true`，设置后将在首次启动容器时自动安装好。 |
|  8  | ENABLE_AUTO_CATEGORY    | true          | 4.3.7+可用。是否自动按tracker进行分类，默认为`true`开启，如需关闭，请设置为`false`。 |
|  9  | CATEGORY_OR_TAG         | category      | 4.3.9及4.5.0+可用，当`ENABLE_AUTO_CATEGORY=true`时，控制自动分类是qBittorrent中的“分类”还是“标签”。设置为`category`（默认值）为“分类”，设置为`tag`为“标签”。当设置为`tag`时，由于标签不是唯一的，无法筛选出没有打上tracker标签的种子，所以运行`auto-cat -a`和`auto-cat -A`都将对全部种子按tracker打标签，种子多时比较耗时；而当设置为`category`时，运行`auto-cat -a`就只对未分类种子进行分类。 |
|  10 | DL_FINISH_NOTIFY        | true          | 默认会在下载完成时向设定的通知渠道发送种子下载完成的通知消息，如不想收此类通知，则设置为`false`。 |
|  11 | TRACKER_ERROR_COUNT_MIN | 3             | 4.3.7+可用。可以设置的值：正整数。在检测到tracker出错的种子数量超过这个阈值时，给设置的通知渠道发送通知。 |
|  12 | UMASK_SET               | 000           | 权限掩码`umask`，指定qBittorrent在建立文件时预设的权限掩码，可以设置为`022`。 |
|  13 | TG_USER_ID              |               | 通知渠道telegram，如需使用需要和 TG_BOT_TOKEN 同时赋值，私聊 @getuseridbot 获取。 |
|  14 | TG_BOT_TOKEN            |               | 通知渠道telegram，如需使用需要和 TG_USER_ID 同时赋值，私聊 @BotFather 获取。 |
|  15 | TG_PROXY_ADDRESS        |               | 4.3.7+可用。给TG机器人发送消息的代理地址，当设置了`TG_USER_ID`和`TG_BOT_TOKEN`后可以设置此值，形如：`http://192.168.1.1:7890`，也可以不设置。 |
|  16 | TG_PROXY_USER           |               | 4.3.7+可用。给TG机器人发送消息的代理的用户名和密码，当设置了`TG_PROXY_ADDRESS`后可以设置此值，格式为：`<用户名>:<密码>`，形如：`admin:password`，如没有可不设置。 |
|  17 | DD_BOT_TOKEN            |               | 通知渠道钉钉，如需使用需要和 DD_BOT_SECRET 同时赋值，机器人设置中webhook链接`access_token=`后面的字符串（不含`=`以及`=`之前的字符）。 |
|  18 | DD_BOT_SECRET           |               | 通知渠道钉钉，如需使用需要和 DD_BOT_TOKEN 同时赋值，机器人设置中**只启用**`加签`，加签的秘钥，形如：`SEC1234567890abcdefg`。 |
|  19 | IYUU_TOKEN              |               | 通知渠道爱语飞飞，通过 [这里](http://iyuu.cn) 获取，爱语飞飞的TOKEN。 |
|  20 | SCKEY                   |               | 通知渠道ServerChan，通过 [这里](http://sc.ftqq.com/3.version) 获取。 |
|  21 | PUSHPLUS_TOKEN          |               | 4.3.7+可用。通知渠道PUSH PLUS，填入其token，详见 [这里](http://www.pushplus.plus)。 |
|  22 | WORK_WECHAT_BOT_KEY     |               | 4.3.9及4.4.3+可用。通知渠道企业微信群机器人，填入机器人设置webhook链接中`key=`后面的字符串，不含`key=`。 |
|  23 | GOTIFY_URL              |               | 4.3.9及4.4.4+可用。通知渠道Gotify，填入其通知网址，需要和`GOTIFY_APP_TOKEN`同时赋值。 |
|  24 | GOTIFY_APP_TOKEN        |               | 4.3.9及4.4.4+可用。通知渠道Gotify，填入其TOKEN，需要和`GOTIFY_URL`同时赋值。 |
|  25 | GOTIFY_PRIORITY         | 5             | 4.3.9及4.4.4+可用。通知渠道Gotify，发送消息的优先级。 |
|  26 | CRON_HEALTH_CHECK       | 12 * * * *    | 宕机检查的cron，在设定的cron运行时如发现qbittorrent-nox宕机了，则向设置的通知渠道发送通知。 |
|  27 | CRON_AUTO_CATEGORY      | 32 */2 * * *  | 自动分类的cron，在设定的cron运行`auto-cat -a`命令，将所有**未分类**种子按tracker分类（当`CATEGORY_OR_TAG=category`时），或将所有种子按tracker打标签（当`CATEGORY_OR_TAG=tag`时）。对于种子很多的大户人家，建议把cron频率修改低一些，一天一次即可。此cron可以由`ENABLE_AUTO_CATEGORY`关闭，关闭后不生效。虽然本变量是全版本有效，但控制采用“分类”还是“标签”的变量`CATEGORY_OR_TAG`仅4.3.9和4.5.0+有效。 |
|  28 | CRON_TRACKER_ERROR      | 52 */4 * * *  | 检查tracker状态是否健康的cron，在设定的cron将检查所有种子的tracker状态，如果有问题就打上`TrackerError`的标签。对于种子很多的大户人家，建议把cron频率修改低一些，一天一次即可。 |
|  29 | MONITOR_IP              |               | 4.3.8+可用。可设置为局域网设备的ip，多个ip以半角空格分隔，形如：`192.168.1.5 192.168.1.9 192.168.1.20`。本变量作用：当检测到这些设置的ip中有任何一个ip在线时（检测频率为每分钟），自动启用qbittorent客户端的“备用速度限制”，如果都不在线就关闭“备用速度限制”。“备用速度限制”需要事先设置好限制速率，建议在路由器上给需要设置的设备固定ip。在docker cli中请使用一对双引号引起来，在docker-compose中不要使用引用。 |
|  30 | CRON_ALTER_LIMITS       |               | 4.3.8+可用。启动和关闭“备用速度限制“的cron，主要针对多时段限速场景，当设置了`MONITOR_IP`时本变量的cron不生效（因为会冲突）。详见 [相关问题](#相关问题) 问题13。 |
|  31 | CRON_IYUU_HELP          |               | 4.3.8+可用。IYUUPlus辅助任务的cron，自动重校验、自动恢复做种，详见 [相关问题](#相关问题) 问题14。 |
|  32 | EXTRA_PACKAGES          |               | 4.3.9+可用。你需要安装的其他软件包，形如`htop nano nodejs`，多个软件包用半角空格分开，在docker cli中请用一对双引号引起来，在docker-compose中不要增加引号。 |

**以下是仅`iyuu`标签额外可用的环境变量：**

| 序号 | 变量名                   | 默认值         | 说明 |
| :-: | :-:                     | :-:                                    | -    |
|  1  | IYUU_REPO_URL           | `https://gitee.com/ledc/iyuuplus.git` | 指定从哪里获取IYUUPlus的代码，默认从gitee更新，如果你想从github更新，可以设置为：`https://github.com/ledccn/IYUUPlus.git` |

</details>

## 创建（点击每种部署方式展开详情）

<details>

<summary markdown="span"><b><h3> ▶ 1. 群晖  </h></b></summary>

请见 [这里](https://gitee.com/evine/dockerfiles/blob/master/qbittorrent/dsm.md)。安装后访问`http://ip:8080`。如想使用集成了IYUUPlus的qBittorrent（自动设置好IYUUPlus中的下载器），请使用docker cli以命令行方式部署。

</details>

<details>

<summary markdown="span"><b><h3> ▶ 2. 命令行docker cli </h></b></summary>

- 除`WEBUI_PORT` `BT_PORT` `PUID` `PGID`这几个环境变量外，如果你还需要使用其他环境变量，请根据[环境变量清单](#环境变量清单)按照`-e 变量名="变量值" \`的形式自行添加在创建命令中。

- armv7设备如若无法使用网络，可能是seccomp问题，详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0#time64_requirements)。可以在创建命令中增加一行`--security-opt seccomp=unconfined \` 来解决。

- 创建完成后请访问`http://<IP>:<WEBUI_PORT>`（如未修改，对安装机默认是`http://127.0.0.1:8080`）来对qbittorrent作进一步设置，初始用户名密码：`admin/adminadmin`。如要在公网访问，请务必修改用户名和密码。

- 针对`iyuu`标签，创建后可访问`http://<IP>:8787`进行IYUUPlus设置。

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
  --tmpfs /tmp \
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
  --tmpfs /tmp \
  --restart always \
  --name qbittorrent \
  --hostname qbittorrent \
  nevinee/qbittorrent:iyuu
```

</details>

<details>

<summary markdown="span"><b><h3> ▶ 3. docker compose </h></b></summary>

新建`compose.yml`文件如下（[docker compose安装方法](https://docs.docker.com/compose/cli-command/)），创建好后以`docker-compose up -d`(旧版)或`docker compose up -d`(新版)命令启动即可。

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
    tmpfs:
      - /tmp
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
    tmpfs:
      - /tmp
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

由于 dockerhub 简介的字数上限，相关问题请到 [Github](https://github.com/devome/dockerfiles/blob/master/qbittorrent/qa.md) 或 [Gitee](https://gitee.com/evine/dockerfiles/blob/master/qbittorrent/qa.md) 进行查看。

## 命令（点击每一类命令展开详情）

<details>

<summary markdown="span"><b> ▶ 1. 自动运行的命令（所有标签可用，由设置的cron或在下载完成时自动运行，当然也可以手动运行）</b></summary>

```
# 发送通知
docker exec qbittorrent notify "测试消息标题" "测试消息通知内容"

# 将种子按tracker进行分类，由CRON_AUTO_CATEGOR设置的cron来调用
docker exec qbittorrent auto-cat -a  # 由程序自动调用，也可手动运行。当CATEGORY_OR_TAG=category时，将所有未分类的种子按tracker分类；当CATEGORY_OR_TAG=tag时，对所有种子按tracker打标签
docker exec qbittorrent auto-cat -A  # 需要手动运行。当CATEGORY_OR_TAG=category时，将所有种子按tracker分类；当CATEGORY_OR_TAG=tag时，对所有种子按tracker打标签

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

<summary markdown="span"><b> ▼ 2. 需要手动运行的命令（所有标签可用）</b></summary>

```
# 查看qbittorrent日志，也可以直接在portainer控制台中看到
docker logs -f qbittorrent

# 批量修改tracker，详见下面效果图，4.3.7+可用，有两种使用方式，请运行下面命令查看两种方式
docker exec -it qbittorrent change-tracker -h

# 批量删除tracker，4.4.4+可用，有两种使用方式，请运行下面命令查看两种方式
docker exec -it qbittorrent remove-tracker -h

# 检测指定文件夹下没有在qbittorrent客户端中做种或下载的子文件夹/子文件，由用户确认是否删除，详见下面效果图，4.3.8+可用
# 从4.4.4起，更改成可以一次性检测多个目录
docker exec -it qbittorrent del-unseed-dir

# 当CATEGORY_OR_TAG=category时，将所有种子按tracker分类；当CATEGORY_OR_TAG=tag时，对所有种子按tracker打标签。4.3.9+可用
docker exec qbittorrent auto-cat -A

# 生成本qBittorrent客户端中所有做种文件清单，4.3.9+可用
docker exec -it qbittorrent report-seed-files

# 生成指定路径下没有在本qBittorrent客户端做种的文件清单，4.3.9+可用
docker exec -it qbittorrent report-unseed-files
```

</details>

<details>

<summary markdown="span"><b> ▶ 3. 仅“iyuu”标签可用的命令</b></summary>

```
# 更新IYUUPlus脚本
docker exec -it qbittorrent git -C /iyuu pull

# 重启IYUUPlus
docker exec -it qbittorrent php /iyuu/start.php restart -d 
```

</details>

## 效果图

![notify](https://raw.githubusercontent.com/devome/dockerfiles/master/qbittorrent/pictures/notify.png)

![iyuu-help](https://raw.githubusercontent.com/devome/dockerfiles/master/qbittorrent/pictures/iyuu-help.png)

![change-tracker](https://raw.githubusercontent.com/devome/dockerfiles/master/qbittorrent/pictures/change-tracker.png)

![del-unseed-dir](https://raw.githubusercontent.com/devome/dockerfiles/master/qbittorrent/pictures/del-unseed-dir.png)


## 参考

- [crazymax/qbittorrent](https://hub.docker.com/r/crazymax/qbittorrent) , 参考了Dockerfile; 
  
- [80x86/qbittorrent](https://hub.docker.com/r/80x86/qbittorrent), 借鉴了标签和分类的理念。

## 源代码、问题反馈、意见建议

旧的Github账号已经删除了，抱歉。如果镜像好用，请点亮star。

全套代码见 [Github](https://github.com/devome/dockerfiles/tree/master/qbittorrent) 或 [Gitee](https://gitee.com/evine/dockerfiles/tree/master/qbittorrent)。

如有使用上的问题，或者有其他好的功能建议，请在 [Github这里](https://github.com/devome/dockerfiles/issues) 或 [Gitee这里](https://gitee.com/evine/dockerfiles/issues) 提交。

[![Docker Pulls](https://img.shields.io/docker/pulls/nevinee/qbittorrent.svg?style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/nevinee/qbittorrent) [![Docker Stars](https://img.shields.io/docker/stars/nevinee/qbittorrent.svg?style=for-the-badge&label=stars&logo=docker)](https://hub.docker.com/r/nevinee/qbittorrent) [![GitHub Stars](https://img.shields.io/github/stars/devome/dockerfiles.svg?style=for-the-badge&logo=github)](https://github.com/devome/dockerfiles)
