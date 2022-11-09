## 相关问题，点击每个问题可展开答案

<details>

<summary markdown="span"><b>01. 使用此镜像会导致封号吗</b></summary>

此镜像未修改qbittorrent客户端官方任何信息，在和pt站tracker服务器交互时反馈的一切信息均是qbittorrent官方原版反馈的信息，此镜像只是基于qbittorrent额外增加了一些脚本而已。增加的脚本全部代码在 [这里](https://github.com/devome/dockerfiles/tree/master/qbittorrent) 可以查看，不会因为使用此镜像导致pt账号被封。

</details>

<details>

<summary markdown="span"><b>02. 如何在运行 dl-finish "%I" 时调用自定义脚本</b></summary>

- 此功能可用版本：4.3.7+；

- 只要你将名为`diy.sh`的shell脚本放在映射目录下的`diy`文件夹下即可，容器内路径为`/data/diy/diy.sh`（hash已存储在名为torrent_hash的变量中，可通过此值获取其他信息）。

- 如想传入除“%I”种子hash之外的其他参数，可以在 设置->下载->Torrent 完成时运行外部程序 下填入这种形式：`dl-finish "%I" "%N" "%L" "%F"`，必须保证"%I"是第一个参数，后面的参数根据你自己需要调整。在`diy.sh`中，`"%N" "%L" "%F"`分别通过`$2 $3 $4`调用。如：`cmd "$2" "$3 "$4"`。$2, $3, $4分别指传入的第2, 第3, 第4个参数，分别对应`"%N" "%L" "%F"`。

- 假如你要调用其他语言的脚本，比如python，可以在`diy.sh`中写上`python3 /data/diy/your_python_scripts.py $torrent_hash`即可。如需要传入更多参数，请参考上一条在“Torrent 完成时运行外部程序”填入形如`dl-finish "%I" "%N" "%L" "%F"`的形式，然后在`diy.sh`中写上`python3 /data/diy/your_python_scripts.py "$2" "$3" "$4"`。

- 如需要下载完成后自动触发EMBY/JELLYFIN扫描媒体库，触发ChineseSubFinder自动为刚刚下载完成的视频自动下载字幕，请按照 [这里](https://github.com/devome/dockerfiles/tree/master/qbittorrent/diy) 操作。

</details>

<details>

<summary markdown="span"><b>03. 如何优雅的关闭qbittorrent容器</b></summary>

- 暴力强制关闭qbittorrent容器自然是容易丢失任务的，所以在关闭前应当先将所有种子暂停，过一会再关闭容器。这时，所有的配置文件和torrent恢复文件也都是暂停后的状态，然后再新建容器或重新部署，启动后再开始所有任务。

- 还有一点要注意，千万不要在有下载任务时关闭或重启qbittorrent容器。

</details>

<details>

<summary markdown="span"><b>04. 如何从其他作者的镜像/套件版转移至本镜像</b></summary>

-  **如果启用了ssl/https，请先在原qbittorrent的webui中禁用，或者将`qBittorrent.conf`中`WebUI\HTTPS\Enabled=true`改为`WebUI\HTTPS\Enabled=false`。**

- 请注意要优雅的关闭旧容器后再处理配置文件。

- 进入原来容器的映射目录（或原套件版配置文件保存目录，可能是隐藏的）下，在config下分别找到`qBittorrent.conf` `qBittorrent-data.conf` `rss`，在data下找到`BT_backup`，然后将其参考上面的目录树放在新容器的映射目录下，然后在创建容器时，保证新容器中的下载文件的保存路径和旧容器一致，并新建容器即可。

- 举例说明如何保证新容器中的下载文件的保存路径和旧容器一致，比如旧容器中下载了一个 `xxx.2020.BluRay.1080p.x264.DTS-XXX`，保存路径为`/movies`（宿主机上的真实路径为`/volume1/home/id/movies`），那么在新建新容器时，给新容器增加一个路径映射：`/volume1/home/id/movies:/movies`　即可。

- 注意新容器的PUID/PGID和要旧容器保持一致。

- 注意在 `设置` -> `下载` 中勾选 `Torrent 完成时运行外部程序` 并填入 `dl-finish "%I"`，如需要https要重新设置证书路径。

</details>

<details>

<summary markdown="span"><b>05. 可不可以不使用默认下载目录</b></summary>

默认下载目录是`/data/downloads`，如不想使用默认下载目录，可以额外映射其他路径，比如映射`/volume1/media:/media`，然后在qbittorrent中设置默认下载目录为`/media`，也可以在每次下载时自己输入下载目录为`/media`。

</details>

<details>

<summary markdown="span"><b>06. 遗忘登陆密码如何重置</b></summary>

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

<summary markdown="span"><b>07. 如何与emby, jellyfin, plex等等配合使用</b></summary>

将需要配合使用的容器的环境变量PUID/PGID设置为一样的即可。

</details>

<details>

<summary markdown="span"><b>08. 启用了其他非官方webui，导致webui打不开，如何关闭</b></summary>

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

<summary markdown="span"><b>09. 如何自动更新容器</b></summary>

安装watchtower即可，详见 [这里](https://hub.docker.com/r/containrrr/watchtower)

</details>

<details>

<summary markdown="span"><b>10. 安装了watchtower，如何让qbittorrent不被watchtower自动更新</b></summary>

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

<summary markdown="span"><b>11. 为何建议将qbittorrent安装在macvlan网络上</b></summary>

- 可以在网关上给qbittorrent所在ip独立设置限速; 

- 如果有用openwrt时，可以让qbittorrent所在ip跳过代理。

</details>

<details>

<summary markdown="span"><b>12. 将qbittorrent安装在macvlan网络上时，如何使用IYUUAutoReseed自动辅种</b></summary>

将两个容器都安装在同一个macvlan网络上即可，或者直接安装`nevinee/qbittorrent:iyuu`标签。

</details>

<details>

<summary markdown="span"><b>13. 如何使用 CRON_ALTER_LIMITS 这个环境变量</b></summary>

- 4.3.8+可用。

- 该功能主要提供给多时段限速场景使用，请在qbittorrent客户端中先设置好”备用速度限制“的限制速率。

- 当设置了有效的`MONITOR_IP`时，`CRON_ALTER_LIMITS`的cron不生效（因为会冲突）。

- 设置形式如：`0 5 * * *:0 18 * * *|0 8 * * *:0 22 * * *`，`|`前面的cron是启用“备用速度限制”的时间点，`|`后面的cron是关闭“备用速度限制”的时间点。需要在一天中多次启用“备用速度限制”的，以`:`分隔每个cron，可以任意个cron，需要多次关闭“备用速度限制”的同样以`:`分隔每个cron。

- 比如需要在周一至周五的5:00-8:00、17:30-23:30，以及周六、周日的9:00-23:30进行限速，那么可以设置`CRON_ALTER_LIMITS`为`0 5 * * 1-5:30 17 * * 1-5:0 9 * * 0,6|0 8 * * 1-5:30 23 * * *`。

- 比如需要在周一至周五的17:30-22:00，以及周六、周日的8:30-23:00进行限速，那么可以设置`CRON_ALTER_LIMITS`为`30 17 * * 1-5:30 8 * * 0,6|0 22 * * 1-5:0 23 * * 0,6`。

- 在docker cli中请使用一对双引号引起来，在docker-compose.yml中请勿增加引号。

</details>

<details>

<summary markdown="span"><b>14. 如何使用 CRON_IYUU_HELP 这个环境变量</b></summary>

- 4.3.8+可用。

- 在设置的时间点执行`iyuu-help`命令，实现以下功能：

  1. 检查下载清单（就是qbittorrent筛选“下载”的清单），检测该清单中处于暂停状态、并且下载完成率为0%（辅种的种子在校验前也是0%）的种子，将这些种子请求重新校验。**已经请求过校验并且完成率大于0%的种子不会再次校验。**
  2. 检查暂停清单（就是qbittorrent筛选“暂停”的清单），检测该清单中100%下载完成/100%校验通过的种子，将这些种子恢复做种。**校验未通过不达100%完成率的种子不会启动，仍然保持暂停状态。**

- 配合IYUUAutoReseed，将CRON_IYUU_HELP设置在IYUUAutoReseed自动辅种任务的cron以后，并运行若干次即可（因为校验比较费时，所以要多次运行）。

- 比如你IYUUAutoReseed辅种任务的cron是`22 7 * * *`，你想从辅种任务3分钟后，每10分钟运行一次，共运行4次，那么可以设置CRON_IYUU_HELP为：`25-55/10 7 * * *`。

- 在docker cli中请使用一对双引号引起来，在docker-compose.yml中请勿增加引号。

</details>

<details>

<summary markdown="span"><b>15. 为什么没法使用搜索功能</b></summary>

搜索功能依赖于python，请在创建容器时添加环境变量`INSTALL_PYTHON`，并将值设置为`true`。

</details>

<details>

<summary markdown="span"><b>16. 环境变量S6_SERVICES_GRACETIME的含义</b></summary>

- 本镜像使用了s6-overlay程序，在关闭/重启/重建容器时，s6-overlay程序会在关闭容器内程序前等待一定的时间。s6-overlay程序可以设置两个等待的最大时长，一个是`S6_SERVICES_GRACETIME`，一个是`S6_KILL_GRACETIME`，其含义详见[这里](https://github.com/just-containers/s6-overlay#customizing-s6-behaviour)。嫌太长可以直接看本文下面的说明。

- qBittorrent程序在下线时，会尝试保存`qBittorrent.conf`, `qBittorrent-data.conf`, `BT_bacup`下的种子做种状态数据以及其他文件。尤其是`BT_bacup`文件夹的数据，对保留做种状态是极其重要的。在qBittorrent做种数量大时，保存这些数据可能需要花费较长的时间，所以我们需要尽量将`S6_SERVICES_GRACETIME`设置大一些。设置大了也不要紧，这只是等待的最长时间，实际使用时大部分都不会等待这么久。

- 我们为了**温和（不要暴力）的关闭**qBittorrent程序，需要尽可能的等待qBittorrent程序自行下线，也就是加大`S6_SERVICES_GRACETIME`的值。

- 但在4.3.9版本及以前，本镜像没有重设`S6_SERVICES_GRACETIME`的值，所以采用了s6-overlay程序默认的`3000`毫秒，这对qBittorrent程序来说，不是一个合适的值，因此建议4.3.9版本及以前的在创建容器时，手动指定一个更大的值，个人认为`30000`毫秒是一个不错的选择。

- 如果你发现容器在关闭/重启/重建时所花费的时间已经比较接近，甚至是超过`S6_SERVICES_GRACETIME`所设置的时间时，就建议将`S6_SERVICES_GRACETIME`设置得再大一些，大到远远超过关闭/重启/重建时所花费的时间。

- 在4.4.0及以后，本镜像将重设`S6_SERVICES_GRACETIME`的值为`30000`毫秒，但仍然可以由用户指定其他值。

</details>

<details>

<summary markdown="span"><b>17. qBittorrent使用https的webui时，iyuu如何连接</b></summary>

- 当qBittorrent使用https的webui时，iyuu连接qBittorrent需要使用`https://<域名>:<端口>`的形式，不能使用`https://<IP>:<端口>`，所以需要在创建iyuu容器（使用nevinee/qbittorrent:iyuu时同样也需要）指定域名和ip的对应关系。

- 命令行创建iyuu容器时时，增加`--add-host <域名>:<qBittorrent容器的IP>`，其中域名是你在公网上访问qBittorrent的webui的域名，如果直接使用的`nevinee/qbittorrent:iyuu`标签，就是`--add-host <域名>:127.0.0.1`。

- docker compose创建时，增加以下内容：

    ```
        extra_hosts:
          - "<域名>:<qBittorrent容器的IP>"  ## 如果直接使用的`nevinee/qbittorrent:iyuu`标签，IP就是127.0.0.1
    ```

</details>

<details>

<summary markdown="span"><b>18. qBittorrent占用了巨大的内存，如何调整</b></summary>

你所见到的占用巨大的内存并不是真的占用了，使用`docker stats qbittorrent`输出的内存占用更准确一点，其他方式输出的内存占用会非常的大。因为libtorrent-rasterbar v2.x把内存使用交给内核来处理，内核会自己根据内存大小和读取频次来自动决定怎么去缓存，所以不要被看起来庞大的内存占用给吓着了。详见libtorrent-rasterbar作者的[原话](https://github.com/arvidn/libtorrent/issues/6667#issuecomment-1040874903)。

谷歌翻译如下：

> 总结一下，libtorrent2.0使用内存映射文件。在除windows之外的所有现代操作系统上，在块设备级别使用统一的页面缓存，其中匿名内存（由swapfile支持）和内存映射文件（包括共享库，运行可执行文件）都是同一缓存的一部分。Linux可能是决定如何在物理RAM中平衡这些页面的最复杂的工具。

> 使用内存映射文件的好处主要有：

> 内核（它知道机器有多少物理RAM可用）最了解何时以及以何种顺序刷新缓存。也许更重要的是，决定保留读缓存的数量和时间。

> 某些类型的存储可以由CPU直接寻址，就像它是RAM一样，绕过了许多内核基础设施，并提供了非常高的性能。（linux称此DAX）

> 此外，当报告libtorrent（特别是mmap磁盘后端）中的问题时，仅仅指出vmstats数字表明内核决定使用大量物理内存进行磁盘缓存是不够的。这是内存映射磁盘后端的一个特性。

</details>