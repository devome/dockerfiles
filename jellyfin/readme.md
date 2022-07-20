## 简介

Jellyfin AMD显卡版本，集成了AMD显卡的OpenCL，预装了`fonts-noto-cjk`字体，支持中日韩文。只要显卡支持，就可以硬解4K x265，并且还可以开启色调映射。

未集成Intel相关驱动，非AMD显卡请勿使用本镜像。主要是自己用，所以镜像简单粗暴，和官方镜像构建方式不一样，所以可能有没发现的问题存在。

## 创建：

1. 请确认宿主机`/dev/dri`目录下存在`renderD128`（双显卡可能还会有`renderD129`，注意自行区分是哪个，并在Jellyfin选择正确的硬解显卡），有关硬解这里不多说，详细介绍请见[官方教程](https://jellyfin.org/docs/general/administration/hardware-acceleration.html)。

2. 请在宿主机上运行`awk -F: '/^render/{print $3}' /etc/group`，会输出一个数字，用这个数字代替下面的`render_id`。可以直接从官方镜像切换，数据不会丢失。

compose.yml

```yaml
version: "3.8"
services:
  jellyfin:
    image: nevinee/jellyfin:latest
    container_name: jellyfin
    restart: always
    hostname: jellyfin
    privileged: true
    environment:
      - TZ=Asia/Shanghai        # 时区
    group_add:
      - "render_id"             # 保留引号，引号内应该是上面命令输出的数字，没有其他字符
    volumes:
      - ./config:/config
      - ./cache:/cache
      - <媒体目录>:<媒体目录>
      - <媒体目录>:<媒体目录>
    network_mode: host
    devices:
      - /dev/dri:/dev/dri
```

docker cli

```shell
docker run -d \
  --volume /path/to/config:/config \
  --volume /path/to/cache:/cache \
  --volume /path/to/media:/media \
  --env TZ=Asia/Shanghai \
  --privileged \
  --group-add="122" `# 需要替换为上面获取的render_id的数字` \
  --net=host \
  --restart=always \
  --device /dev/dri:/dev/dri \
  nevinee/jellyfin
```

## 说明

经我测试，在AMD 5700G上使用本镜像在`硬件加速`驱动选择`Video Acceleration API (VAAPI)`时，可以完美开启硬解4K x265视频，并可以开启`控制台 -> 播放 -> 启用色调映射`（注意不是`启用 VPP 色调映射`，VPP是Intel的），将HDR转成的SDR，在非电视类设备上色彩更鲜亮不灰暗。

如想使用`AMD AMF`驱动来硬解，请参考下面的几个链接在容器内进行设置：

- https://amdgpu-install.readthedocs.io/en/latest/
- https://jellyfin.org/docs/general/administration/hardware-acceleration.html#amd-amf-encoding-on-ubuntu-1804-or-2004-lts

下图是硬解4K x265的结果：

![4K](https://raw.githubusercontent.com/devome/dockerfiles/master/jellyfin/4K-x265.png)

如想知道你的核显到底可以硬解什么编码，可以运行下面命令，运行后可以在`控制台 -> 播放 -> 启用硬件解码`下面勾选支持的编码格式。

```shell
docker exec jellyfin /usr/lib/jellyfin-ffmpeg/vainfo
```

## Dockerfile

见：https://github.com/devome/dockerfiles/tree/master/jellyfin

