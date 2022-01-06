## 简介

这个项目的Docker实现：https://github.com/esnet/iperf ，这是著名的局域网测速工具。

Docker的网络结构会对速度有影响，因此非必要情况下，不建议使用Docker版。

## 运行

```
## 以服务器形式运行，接收其他客户端开展测速
docker run -it --rm -p 5201:5201 nevinee/iperf3 -s   # 前台
docker run -itd -p 5201:5201 nevinee/iperf3 -s       # 后台

## 以客户端形式运行，去连接服务器开展测速，运行完即自动删除容器
docker run --rm -it nevinee/iperf3 -c <服务器ip>

## 查看帮助
docker run --rm nevinee/iperf3 -h
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