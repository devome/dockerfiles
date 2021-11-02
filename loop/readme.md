这个项目 https://github.com/Miserlou/Loop 的Docker实现，支持 amd64/arm64/armv7 三大主流平台，镜像中仅有 `/usr/local/bin/loop` 这一个文件，如需使用，需要在Dokerfile中编写如下语句：

```
COPY --from=nevinee/loop / /
```

loop的详细用法见：https://github.com/Miserlou/Loop

一些使用案例：

1. https://gitee.com/evine/dockerfiles/blob/master/subfinder/s6-overlay/etc/services.d/subfinder/run

2. https://gitee.com/evine/dockerfiles/blob/master/nodejs/s6-overlay/etc/services.d/refresh-cron/run

Dockerfile见：

https://gitee.com/evine/dockerfiles/tree/master/loop