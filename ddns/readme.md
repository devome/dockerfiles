基于 https://hub.docker.com/r/newfuture/ddns 调整了一点点自己想用的内容而已，也可以使用官方原版。

本镜像和原版的一点点区别：
- 原版直接映射一个config.json文件，本镜像映射一个文件夹config，这个文件夹下除了要放config.json，还可以放一些其他的辅助脚本；
- 原版的cron无法自定义，本镜像可以；
- 把时区调整为北京时间；
- 增加了bash, curl包，方便自己写获取ip的shell脚本。

docker-compose.yml如下：
```
version: "2.0"
services:
  ddns:
    image: nevinee/ddns
    container_name: ddns
    restart: always
    network_mode: host
    hostname: ddns
    volumes:
      - ./:/config   #文件夹下必须存在按官方教程配置好的config.json
    environment:
      - CRON=3-53/5 * * * *    # 可以自定义
```

Dockerfile见：https://gitee.com/evine/dockerfiles/tree/master/ddns