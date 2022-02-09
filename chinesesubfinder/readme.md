## 简介

中文字幕自动下载，是这个项目的Docker实现：https://github.com/allanpk716/ChineseSubFinder

基于alpine实现，比官方镜像体积小、层数少，日志和设置文件全部和配置文件保存在一起，支持 386/amd64/arm64/armv7。

**注意：本镜像未安装chromium，可能无法从subhd下载字幕，如有此需要，请使用官方原版镜像allanpk716/chinesesubfinder。**

## 创建

**注：从0.20.0起，需要从webui来设置参数，因此需要额外映射端口出来。并且从该版本起，可以设置多个媒体目录。**

**docker cli**

```
docker run -d \
    -v $(pwd)/config:/config   `# 冒号左边请修改为你想在主机上保存配置、日志等文件的路径` \
    -v $(pwd)/media:/media     `# 请修改为需要下载字幕的媒体目录，冒号右边可以改成你方便记忆的目录，多个媒体目录需要添加多个-v映射` \
    -e PUID=1000 \
    -e PGID=100 \
    -p 19035:19035 `# 从0.20.0版本开始，通过webui来设置` \
    --name chinesesubfinder \
    --hostname chinesesubfinder \
    --log-driver "json-file" \
    --log-opt "max-size=100m" `# 限制日志大小，可自行调整` \
    nevinee/chinesesubfinder
```

**docker-compose**

新建`docker-compose.yml`文件如下，并以命令`docker-compose up -d`启动。

```
version: "3"
services:
  chinesesubfinder:
    image: nevinee/chinesesubfinder:latest
    volumes:
      - ./config:/config  # 冒号左边请修改为你想在主机上保存配置、日志等文件的路径
      - ./media:/media    # 请修改为你的媒体目录，冒号右边可以改成你方便记忆的目录，多个媒体目录需要分别映射进来
    environment:
      - PUID=1000
      - PGID=100
    restart: always
    network_mode: bridge
    hostname: chinesesubfinder
    container_name: chinesesubfinder
    ports:
      - 19035:19035  # 从0.20.0版本开始，通过webui来设置
    logging:
        driver: "json-file"
        options:
          max-size: "100m" # 限制日志大小，可自行调整
```

**如果是首次创建，请在创建后立即关闭容器，并按照[官方配置教程](https://github.com/allanpk716/ChineseSubFinder)配置好`config/config.yaml`后，再启动容器。**

## 关于PUID/PGID的说明

如在使用诸如emby、jellyfin、plex、qbittorrent、transmission、deluge、jackett、sonarr、radarr等等的docker镜像，请在创建本容器时的设置和它们的PUID/PGID和它们一样，如若真的不想设置为一样，至少要保证本容器PUID/PGID所定义的用户拥有你设置的媒体目录（示例中是`/media`）的读取和写入权限。

## 关于armv7设备的补充说明

armv7设备如若无法使用网络，可能是seccomp问题，详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0)。

解决办法如下：

- docker cli方式可以在创建命令中增加一行`--security-opt seccomp=unconfined \`。

- docker-compose方式请在`docker-compose.yml`最后增加两行：

    ```
    security_opt:
      - seccomp=unconfined
    ```

## 源码

https://gitee.com/evine/dockerfiles/tree/master/chinesesubfinder

https://github.com/devome/dockerfiles/tree/master/chinesesubfinder
