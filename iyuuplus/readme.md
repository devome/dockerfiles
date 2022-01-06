## 简介

https://github.com/ledccn/IYUUPlus ，官方提供了Docker镜像的，建议选择官方的镜像。

本镜像测试通过以后就把代码PR到了官方仓库中。

## 关于armv7设备的补充说明

armv7设备如若无法使用网络，可能是seccomp问题，详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0)。

解决办法如下：

- docker cli方式可以在创建命令中增加一行`--security-opt seccomp=unconfined \`。

- docker-compose方式请在`docker-compose.yml`最后增加两行：

    ```
    security_opt:
      - seccomp=unconfined
    ```