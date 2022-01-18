## 简介

https://github.com/ledccn/IYUUPlus ，官方提供了Docker镜像的，建议选择官方的镜像。

本镜像测试通过以后就把代码PR到了官方仓库中。**但2022年1月18日，本镜像增加了一项功能：允许用户以非root用户权限运行iyuuplus，修改PUID，PGID两个环境变量即可。未推送到官方。**

## 创建

### docker compose
```
version: "3.8"
services:
  iyuuplus:
    image: nevinee/iyuuplus
    container_name: iyuuplus
    restart: always
    network_mode: bridge
    hostname: iyuuplus
    volumes:
      - ./IYUU:/IYUU
      - /qb种子路径/:/BT_backup
      - /tr种子路径/:/torrent
    environment:
      - PUID=1000  # 以什么用记运行iyuuplus，该用户的uid
      - PGID=100   # 以什么用记运行iyuuplus，该用户的gid
```

### docker cli
```
docker run -d \
  --name iyuuplus \
  --hostname iyuuplus \
  --restart always \
  --network bridge \
  --volume $(pwd)/IYUU:/IYUU \
  --volume /qb种子路径/:/BT_backup \
  --volume /tr种子路径/:/torrent \
  --env PUID=1000 `# 以什么用记运行iyuuplus，该用户的uid` \
  --env PGID=100  `# 以什么用记运行iyuuplus，该用户的gid` \
  nevinee/iyuuplus
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