---

## 说明

**因Docker Hub简介有字数限制，详细教程及全部说明请见 [Github](https://github.com/devome/dockerfiles/tree/master/qbittorrent) 或 [Gitee](https://gitee.com/evine/dockerfiles/tree/master/qbittorrent)。**

为保证用户安全，防止用户因使用反代并代理了127.0.0.1这种情况导致安全性降低，从2023年9月5日更新的镜像开始，创建容器需要新增设置两个环境变量：QB_USERNAME（登陆qBittorrent的用户名）和QB_PASSWORD（登陆qBittorrent的密码）。容器将在创建时使用这两个环境变量去设置（如已存在配置文件则是修改）登陆qBittorent的用户名和密码。如未设置这两个环境变量，或者保持为qBittorrent的默认值（默认用户名：admin，默认密码：adminadmin），则本容器附加的所有脚本、定时任务将无法继续使用。[详情](https://github.com/devome/dockerfiles/issues/101)。也因此镜像默认即安装好python，不再需要设置`INSTALL_PYTHON`这个环境变量。

## 声明

本镜像非魔改版、非快验版、非Enhanced增强版，qBittorrent自身的行为/功能全部未做任何改动（也不会考虑添加或修改官方客户端行为/功能的内容），全部属于官方客户端的默认行为/功能，在和PT站Tracker服务器交互时反馈的一切信息均是qBittorrent官方版反馈的信息。本镜像只是基于官方客户端附加了一些实用的脚本，脚本全部是合理合法使用qBittorrent官方API获取信息，脚本全部行为都集中在本地，与任何远端服务器无任何联系。增加的脚本全部代码在 [Github](https://github.com/devome/dockerfiles/tree/master/qbittorrent) 或 [Gitee](https://gitee.com/evine/dockerfiles/tree/master/qbittorrent) 均可查看 。绝对不会因为使用此镜像而导致账号被封。

## 特点

- 自动按`tracker`分类或打标签（**可以选择关闭，可以选择采用qBittorrent中的“分类”还是“标签”**）。

- 下载完成发送通知（**可以选择关闭**），可选途径：钉钉（[效果图](https://gitee.com/evine/dockerfiles/raw/master/qbittorrent/pictures/notify.png)）, Telegram, ServerChan, 爱语飞飞, PUSHPLUS推送加, 企业微信, Gotify；搭配RSS功能（[RSS教程](https://www.jianshu.com/p/54e6137ea4e3)）自动下载效果很好；下载完成后还可以补充运行你的自定义脚本。

- 故障时发送通知，可选途径同上。

- 按设定的cron检查tracker状态，如发现种子的tracker状态有问题，将给该种子添加`TrackerError`的标签，方便筛选；如果tracker出错数量超过设定的阈值，给设定渠道发送通知。

- **一些辅助功能：批量修改tracker；检测指定文件夹下未做种的子文件夹/文件；生成做种文件清单；生成未做种文件清单；配合IYUU自动重新校验和自动恢复做种；指定设备上线时自动限速；多时段限速；分析指定目录的重复做种率（辅种率）等等。**

- **如需要下载完成后自动触发EMBY/JELLYFIN扫描媒体库，触发ChineseSubFinder自动为刚刚下载完成的视频自动下载字幕，请按照 [这里](https://github.com/devome/dockerfiles/tree/master/qbittorrent/diy) 操作。**

- 日志输出到docker控制台，可从portainer查看。

- `python`为可选安装项，设置为`true`就自动安装。

- 体积小，默认中文UI，默认东八区时区。

- `iyuu`标签集成了[IYUUPlus](https://github.com/ledccn/IYUUPlus)，自动设置好下载器，减少IYUUPlus设置复杂程度。

## 效果图

![iyuu-help](https://s3.bmp.ovh/imgs/2023/03/16/d81ef270f591ed4c.gif)

![change-tracker](https://s3.bmp.ovh/imgs/2023/03/16/d0164dc03fa2fcdc.gif)

![change-tracker](https://s3.bmp.ovh/imgs/2023/03/16/c68d896355a22dcf.gif)

![remove-tracker](https://s3.bmp.ovh/imgs/2023/03/16/1cad397ec970f9e3.gif)

![del-unseed-dir](https://s3.bmp.ovh/imgs/2023/03/16/620a163165b3398f.gif)

![report-seed-files](https://s3.bmp.ovh/imgs/2023/03/16/08cd619845b95053.gif)

![report-unseed-files](https://s3.bmp.ovh/imgs/2023/03/16/0d107538303e9ce2.gif)

![gen-dup](https://s3.bmp.ovh/imgs/2023/03/16/cf0b7468ef16760e.gif)

## 源代码、问题反馈、意见建议

如果镜像好用，请点亮star。如有使用上的问题，或者有其他好的功能建议，请在 [Github这里](https://github.com/devome/dockerfiles/issues) 或 [Gitee这里](https://gitee.com/evine/dockerfiles/issues) 提交。

[![Docker Pulls](https://img.shields.io/docker/pulls/nevinee/qbittorrent.svg?style=for-the-badge&label=pulls&logo=docker)](https://hub.docker.com/r/nevinee/qbittorrent) [![Docker Stars](https://img.shields.io/docker/stars/nevinee/qbittorrent.svg?style=for-the-badge&label=stars&logo=docker)](https://hub.docker.com/r/nevinee/qbittorrent) [![GitHub Stars](https://img.shields.io/github/stars/devome/dockerfiles.svg?style=for-the-badge&logo=github)](https://github.com/devome/dockerfiles)