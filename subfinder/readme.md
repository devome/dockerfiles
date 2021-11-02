## 简介

中文字幕自动下载，是这个项目的Docker实现：https://github.com/ausaki/subfinder

基于alpine实现，镜像体积小，支持 amd64/arm64/armv7 三大主流架构。

还有另外一个作者的同类项目目前仍在更新：https://github.com/allanpk716/ChineseSubFinder

## 创建

**docker cli**

```
docker run -d \
    --name subfinder \
    --hostname subfiner \
    -v $(pwd)/config:/config  `# 冒号左边请修改为你想在主机上保存配置文件的路径` \
    -v $(pwd)/media:/media    `# 冒号左边请修改为需要下载字幕的媒体目录` \
    -e INTERVAL=2h            `# 每间隔多长时间扫描一次媒体目录，并下载字幕` \
    -e PUID=1000 \
    -e PGID=100 \
    nevinee/subfinder
```

**docker-compose**

新建`docker-compose.yml`文件如下，并以命令`docker-compose up -d`启动。

```
version: "3"
services:
  subfinder:
    image: nevinee/subfinder:latest
    volumes:
      - ./config:/config  # 冒号左边请修改为你想保存配置的路径
      - ./media:/movies   # 冒号左边请修改为你的媒体目录
    environment:
      - PUID=1000
      - PGID=100
      - INTERVAL=2h
    restart: always
    network_mode: bridge
    hostname: subfinder
    container_name: subfinder
```

## 关于环境变量的说明

- 如在使用诸如emby、jellyfin、plex、qbittorrent、transmission、deluge、jackett、sonarr、radarr等等的docker镜像，请务必保证创建本容器时的PUID/PGID和它们一样。

- `INTERVAL`表示检测媒体目录的间隔，可以设置的形式如：`INTERVAL=5h`(每5小时)、`INTERVAL=30m`(每30分钟)、`INTERVAL=1d`(每1天)，默认为：`INTERVAL=2h`。

## 关于配置文件的说明

默认配置如下，如不想使用默认配置，请参考：https://github.com/ausaki/subfinder ，修改`config/subfinder.json`即可。

```json
{
  "exts": ["ass", "srt"],
  "method": ["zimuku", "subhd", "shooter"],
  "video_exts": [".mkv", ".mp4", ".ts", ".iso"],
  "api_urls": {
    "zimuku": "https://www.zimuku.pw/search",
    "subhd": "https://subhd.tv/search",
    "subhd_api_subtitle_download": "/ajax/down_ajax",
    "subhd_api_subtitle_preview": "/ajax/file_ajax"
  }
}
```

## 关于armv7设备的补充说明

armv7设备如若无法使用网络，可能是seccomp问题，详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0#time64_requirements)。

解决办法如下：

- docker cli方式可以在创建命令中增加一行`--security-opt seccomp=unconfined \`。

- docker-compose方式请在`docker-compose.yml`最后增加两行：

    ```
    security_opt:
      - seccomp=unconfined
    ```

## 源码

https://gitee.com/evine/dockerfiles/tree/master/subfinder