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

armv7设备如若无法使用网络，可能是seccomp问题，详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0)。

解决办法如下：

- docker cli方式可以在创建命令中增加一行`--security-opt seccomp=unconfined \`。

- docker-compose方式请在`docker-compose.yml`最后增加两行：

    ```
    security_opt:
      - seccomp=unconfined
    ```

[![dockeri.co](http://dockeri.co/image/nevinee/python)](https://hub.docker.com/r/nevinee/python/)