## 简介

将这个项目 https://github.com/just-containers/s6-overlay 转换成docker镜像，镜像中只有`s6-overlay`这套程序，以方便的在构建容器时直接复制。

本来`alpine`3.13和3.14版本都已经在repositories软件仓库中都集成了`s6-overlay`，这两个版本的`alpine`可以直接使用`apk add s6-overlay`方便的添加。在`s6`(`s6-overlay`的依赖项)升级以后，`s6-overlay`目前还没有很好的适配，所以在`alpine`3.15中又去掉了这个`s6-overlay`的包。但又需要用到它，怎么办呢，只好把它和它旧的依赖整个制作成镜像了，这样在`alpine`什么版本都能用。

其他系统，如debian等等，在仓库中是没有`s6-overlay`的，要用到的话请按如下用法进行使用。

可用平台：`linux/386` `linux/amd64` `linux/arm64` `linux/arm/v7` `linux/arm/v6` `linux/ppc64le`

**本镜像只含多平台的s6-overlay全套程序，没有其他任何文件。**

## 用法

在你的Dockerfile中增加如下语句即可：

### 如果系统的`/bin`是个目录，如alpine、debian等

```
...
COPY --from=nevinee/s6-overlay / /
...
...
ENTRYPOINT ["/init"]
...
```

### 如果系统的`/bin`是个软连接，如ubuntu，centos等

```
...
COPY --from=nevinee/s6-overlay:bin-is-softlink / /
...
...
ENTRYPOINT ["/init"]
...
```

*注：`s6-overlay`的具体使用方法请见：https://github.com/just-containers/s6-overlay*

## Dockerfile

https://gitee.com/evine/dockerfiles/tree/master/s6-overlay

https://github.com/devome/dockerfiles/tree/master/tieba-cloud-sign