## 简介

这个项目的Docker实现：https://github.com/esnet/iperf ，这是著名的局域网测速工具。

## 运行

```
## 以服务器形式运行，接收其他客户端开展测速，容器会保持一直开启
docker run -p 5201:5201 nevinee/iperf3 -s

## 以客户端形式运行，去连接服务器开展测速，运行完即自动删除容器
docker run --rm nevinee/iperf3 -c <服务器ip>

## 查看帮助
docker run --rm nevinee/iperf3 -h
```