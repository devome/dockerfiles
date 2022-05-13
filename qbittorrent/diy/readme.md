## 脚本作用

用于qBittorrent下载完成后实现以下内容：

1. 自动向EMBY/JELLYFIN触发扫描媒体库；

2. 自动向[ChineseSubFinder](https://github.com/allanpk716/ChineseSubFinder)触发为刚刚下载完成的视频下载中文字幕。

## [nevinee/qbittorrent](https://hub.docker.com/r/nevinee/qbittorrent) 镜像使用本脚本的方法

下载 [diy.sh](https://raw.githubusercontent.com/devome/dockerfiles/master/qbittorrent/diy/diy.sh) 放在容器内的`/data/diy/diy.sh`，然后按照该文件注释编辑即可。

如果你本来存在`/data/diy/diy.sh`，可以将 [diy.sh](https://raw.githubusercontent.com/devome/dockerfiles/master/qbittorrent/diy/diy.sh) 内容放在你现有的`diy.sh`之后。

## 其他 qBittorrent 客户端使用本脚本的方法

1. 自行根据你qBittorrent所处的环境确保这几个命令可用：`bash curl find grep jq`；

2. 下载 [diy.sh](https://raw.githubusercontent.com/devome/dockerfiles/master/qbittorrent/diy/diy.sh)，**增加可执行权限，并按照注释编辑**；

3. 在脚本配置区域增加一个变量`qb_url`，qBittorrent的本地地址，形如：`qb_url="https://127.0.0.1:8080"`，其中`127.0.0.1`不要改；

4. qBittorrent设置中勾选`对本地主机上的客户端跳过身份验证`；

5. qBittorrent设置中勾选`Torrent 完成时运行外部程序`，并填入`/<你的存放路径>/diy.sh "%I"`，如果qBittorrent版本`>=4.4.0`，并且会有`v2 torrent`，则设置为`/<你的存放路径>/diy.sh "%K"`。

## 说明

如有关对API的疑问请自行前往以下链接查阅。触发ChineseSubFinder后并不是马上就能保证下载好字幕，相关逻辑也请自行查阅ChineseSubFinder文档。

1. [ChineseSubFinder API](https://github.com/allanpk716/ChineseSubFinder/blob/docs/DesignFile/Web%E7%95%8C%E9%9D%A2%E8%AE%BE%E8%AE%A1/api%20%E6%8E%A5%E5%8F%A3%E8%AE%BE%E8%AE%A1.md), [ChineseSubFinder APIKEY](https://github.com/allanpk716/ChineseSubFinder/blob/docs/DesignFile/ApiKey%E8%AE%BE%E8%AE%A1/ApiKey%E8%AE%BE%E8%AE%A1.md)

2. [Jellyfin API](https://api.jellyfin.org/)

3. [Emby API](http://swagger.emby.media/?staticview=true)

