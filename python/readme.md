基于python官方版本docker集成了`bash openssl coreutils moreutils git wget curl nano tzdata perl`，默认时区`Asia/Shanghai`。

创建：

```shell
docker run -dit \
  -v /宿主机上的目录/:/root \
  --name python \
  --hostname python \
  nevinee/python
```

然后进入容器，你想干啥就干啥：

```shell
docker exec -it python bash
```

如果映射目录下存在`crontab.list`，将在创建后以它作为容器的定时任务。修改`crontab.list`两秒后会自动更新容器的cron。

[![dockeri.co](http://dockeri.co/image/nevinee/python)](https://hub.docker.com/r/nevinee/python/)