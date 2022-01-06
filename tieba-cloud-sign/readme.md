## 说明

官方镜像也是本人维护的，现在可以直接使用官方镜像。https://hub.docker.com/r/moenetwork/tieba-cloud-sign

2021-11-28，本镜像增加了一个小功能：每天会自动更新一下源代码。

## 创建

`docker-compose.yml`文件如下，**除了镜像名称不同外，其余同 [官方教程](https://github.com/MoeNetwork/Tieba-Cloud-Sign) 一致。**

创建好后访问`http://<ip>:8080`进行下一步操作。

```
version: "2.0"
services:
  web:
    image: nevinee/tieba-cloud-sign  # 本镜像名称
    container_name: tieba
    restart: always
    hostname: tieba
    environment:
      - PUID=1000  # 可修改为你想以什么用户运行caddy，该用户的UID
      - PGID=1000  # 可修改为你想以什么用户运行caddy，该用户的UID
      - DB_HOST=db:3306
      - DB_USER=root
      - DB_PASSWD=janejane123456  # 数据库密码
      - DB_NAME=tiebacloud        # 数据库名
      - CSRF=true
      - CRON_TASK=* * * * *       # 执行do.php的cron，默认每分钟执行，明白这是何含义的可以自己改
    volumes:
      - ./www:/var/www
    ports:
      - 8080:8080
    links:
      - db
    depends_on:
      - db
    #security_opt:  # armv7设备请解除这两行注释
      #- seccomp=unconfined

  db:
    image: agrozyme/mariadb  #如若此镜像在你的平台上不可用，可以自行在docker hub上搜索你平台可用的mariadb镜像
    environment:
      - MYSQL_DATABASE=tiebacloud
      - MYSQL_ROOT_PASSWORD=janejane123456
    volumes:
      - ./mysql:/var/lib/mysql
```
    
[mysql官方镜像](https://hub.docker.com/_/mysql) 可用平台：`amd64`。

[mariadb官方镜像](https://hub.docker.com/_/mariadb) 可用平台：`amd64` `arm64` `ppc64le`。

[agrozyme/mariadb镜像](https://hub.docker.com/r/agrozyme/mariadb) 可用平台：`amd64` `386` `arm64` `arm/v7` `arm/v6` `ppc64le` `s390x`。

## 关于armv7设备的补充说明

armv7设备如若无法使用网络，可能是seccomp问题，详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0)。

解决办法如下：

- docker cli方式可以在创建命令中增加一行`--security-opt seccomp=unconfined \`。

- docker-compose方式请在`docker-compose.yml`最后增加两行：

    ```
    security_opt:
      - seccomp=unconfined
    ```

## Dockerfile

https://gitee.com/evine/dockerfiles/tree/master/tieba-cloud-sign

https://github.com/devome/dockerfiles/tree/master/tieba-cloud-sign

[![dockeri.co](http://dockeri.co/image/nevinee/tieba-cloud-sign)](https://hub.docker.com/r/nevinee/tieba-cloud-sign/)