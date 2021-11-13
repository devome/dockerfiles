## 简介

这个项目的docker实现：https://github.com/cym1102/nginxWebUI

本镜像经过测试以后，已经将相关构建代码推送到官方仓库。

## 创建

**除了镜像名称不一样，其实创建命令和官方是一样的，参见：https://github.com/cym1102/nginxWebUI**

**docker-cli**

```
docker run -d \
  --name=nginxwebui \
  --privileged=true \
  --net=host \
  -v $(pwd)/nginxwebui:/home/nginxwebui `# 冒号左边请替换为你想保存配置的路径` \
  -e BOOT_OPTIONS="--server.port=8080"  `# 默认端口为8080` \
  nevinee/nginxwebui
```

**docker-compose**

新建`compose.yml`如下，请以命令`docker compose up -d`或`docker-compose up -d`启动。

```
version: "3"
services:
  nginxWebUi-server:
    image: nevinee/nginxwebui
    volumes:
      - type: bind
        source: "/home/nginxWebUI"       # 可以自定义
        target: "/home/nginxWebUI"
    environment:
      BOOT_OPTIONS: "--server.port=8080" # 默认监听8080端口
    privileged: true
    network_mode: host
```

创建完成后访问`http://<IP>:8080`即可开始可视化配置nginx。

## 源码

https://gitee.com/evine/dockerfiles/tree/master/nginxwebui

https://github.com/devome/dockerfiles/blob/master/nginxwebui
