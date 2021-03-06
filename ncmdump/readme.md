转换网易云的ncm格式为mp3/flac等其他格式。这个项目（ https://github.com/nondanee/ncmdump ，已被屏蔽）的Docker实现，支持 amd64/arm64/armv7 三大主流平台。

查看具体用法

```
docker run --rm nevinee/ncmdump -h
```

如

```
docker run --rm -v $(pwd):/music nevinee/ncmdump /music
docker run --rm -v $(pwd):/music nevinee/ncmdump /music/xxx.ncm
docker run --rm -v $(pwd):/music nevinee/ncmdump -r /music/xxx.ncm
```
armv7设备如若无法使用网络，可能是seccomp问题，详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0)。

解决办法如下：

- docker cli方式可以在创建命令中增加一行`--security-opt seccomp=unconfined \`。

- docker-compose方式请在`docker-compose.yml`最后增加两行：

    ```
    security_opt:
      - seccomp=unconfined
    ```


源码：

https://gitee.com/evine/dockerfiles/blob/master/ncmdump/Dockerfile

https://github.com/devome/dockerfiles/blob/master/ncmdump/Dockerfile