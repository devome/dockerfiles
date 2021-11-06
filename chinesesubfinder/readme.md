## 简介

中文字幕自动下载，是这个项目的Docker实现：https://github.com/allanpk716/ChineseSubFinder

基于alpine实现，比官方镜像体积小、层数少，不使用s6-overlay仅一个进程，日志和设置文件全部和配置文件保存在一起，支持 amd64/arm64/armv7。

**这个项目会修改文件，不建议pt用户使用！！！**

**这个项目会修改文件，不建议pt用户使用！！！**

**这个项目会修改文件，不建议pt用户使用！！！**

pt用户可以使用另一个类似的镜像：https://hub.docker.com/r/nevinee/subfinder

## 创建

**docker cli**

```
docker run -d \
    --name chinesesubfinder \
    --hostname chinesesubfinder \
    -v $(pwd)/config:/config   `# 冒号左边请修改为你想在主机上保存配置、日志等文件的路径` \
    -v $(pwd)/media:/media     `# 冒号左边请修改为需要下载字幕的媒体目录` \
    -e PUID=1000 \
    -e PGID=100 \
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
      - ./media:/media    # 冒号左边请修改为你的媒体目录
    environment:
      - PUID=1000
      - PGID=100
    restart: always
    network_mode: bridge
    hostname: chinesesubfinder
    container_name: chinesesubfinder
```

**如果是首次创建，请在创建后立即关闭容器，并按照[官方配置教程](https://github.com/allanpk716/ChineseSubFinder)配置好`config/config.yaml`后，再启动容器。**

## 关于PUID/PGID的说明

如在使用诸如emby、jellyfin、plex、qbittorrent、transmission、deluge、jackett、sonarr、radarr等等的docker镜像，请在创建本容器时的设置和它们的PUID/PGID和它们一样，如若真的不想设置为一样，至少要保证本容器PUID/PGID所定义的用户拥有你设置的媒体目录（默认是`/media`）的读取和写入权限。

## 源码

https://gitee.com/evine/dockerfiles/tree/master/chinesesubfinder

https://github.com/devome/dockerfiles/tree/master/chinesesubfinder
