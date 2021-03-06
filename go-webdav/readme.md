## 简介

webdav，是这个项目的Docker实现：https://github.com/hacdias/webdav

基于alpine实现，支持 amd64/arm64/armv7。

**注意：只有webdav协议，没有http文件浏览器功能。**

## 创建

**创建前请在要映射的`config`目录下按[官方教程](https://github.com/hacdias/webdav)建立`config.yml`。**

**docker cli**

```
docker run -d \
    --name go-webdav \
    --network host \
    --restart always \
    -v $(pwd)/config:/etc/webdav     `# 冒号左边请修改为你想在主机上保存配置的路径` \
    -v $(pwd)/file_path:/file_path   `# 你希望加入webdav的路径，冒号两边都由你自己定义，如需多个目录就使用多个映射` \
    nevinee/go-webdav
```

**docker-compose**

新建`docker-compose.yml`文件如下，并以命令`docker-compose up -d`启动。

```
version: "3"
services:
  go-webdav:
    image: nevinee/go-webdav:latest
    volumes:
      - ./config:/etc/webdav     # 冒号左边请修改为你想在主机上保存配置的路径
      - ./file_path:/file_path   # 你希望加入webdav的路径，冒号两边都由你自己定义，如需多个目录就使用多个映射
    restart: always
    network_mode: host
    container_name: go-webdav
```

## 关于armv7设备的补充说明

armv7设备如若无法使用网络，可能是seccomp问题，详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0)。

解决办法如下：

- docker cli方式可以在创建命令中增加一行`--security-opt seccomp=unconfined \`。

- docker-compose方式请在`docker-compose.yml`最后增加两行：

    ```
    security_opt:
      - seccomp=unconfined
    ```

## 配置文件示例

```
address: 0.0.0.0
port: 2021
auth: true
tls: false
prefix: /

scope: .
modify: true
rules: []

users:
  - username: "USERNAME"
    password: "PASSWORD"
    scope: /media
```

## 源码

https://gitee.com/evine/dockerfiles/tree/master/go-webdav

https://github.com/devome/dockerfiles/tree/master/go-webdav
