## 简介

https://github.com/ledccn/IYUUAutoReseed ，官方提供了Docker镜像的，建议选择官方的镜像。本镜像主要是为了本人使用方便。

## 本镜像创建

```
version: "2.0"
services:
  iyuuautoreseed:
    image: nevinee/iyuuautoreseed
    container_name: iyuuautoreseed
    restart: always
    network_mode: bridge
    hostname: iyuuautoreseed
    volumes:
      - ./iyuu:/iyuu  # 首次启动前映射的iyuu文件夹必须是空的
    environment:
      - CRON_GIT_PULL=23 7,19 * * *    # 更新脚本的cron
      - CRON_IYUU=51 7,19 * * *        # 辅种程序的cron
```

创建好后编辑`./iyuu/config/config.php`即可，不负责解释一切疑问。

## 关于armv7设备的补充说明

armv7设备如若无法使用网络，可能是seccomp问题，详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0)。

解决办法如下：

- docker cli方式可以在创建命令中增加一行`--security-opt seccomp=unconfined \`。

- docker-compose方式请在`docker-compose.yml`最后增加两行：

    ```
    security_opt:
      - seccomp=unconfined
    ```
