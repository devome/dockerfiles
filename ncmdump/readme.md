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

Dockerfile见：https://gitee.com/evine/dockerfiles/blob/master/ncmdump/Dockerfile