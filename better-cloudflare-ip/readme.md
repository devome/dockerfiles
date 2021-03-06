## 简介

这个项目的Docker实现：https://github.com/badafans/better-cloudflare-ip

## 运行

```
docker run -it --rm nevinee/better-cloudflare-ip
```

如需要经常使用，可修改`~/.bashrc`或`~/.zshrc`，在最后添加一行`alias dcf="docker run -it --rm nevinee/better-cloudflare-ip"`，执行`source ~/.你的rc`后可输入`dcf`命令。

*注：网络经常发生变化，如再遇无法连接的情况，可再次运行查找最优IP。*

根据输出的ip修改hosts：

- Windows: C:\Windows\System32\Drivers\etc\hosts

- Linux: /etc/hosts

- Docker: 三种方法

    1. 如果命令行创建容器，添加`--add-host <host>:<ip>`; 

    2. 如果是compose创建，添加`extra_hosts`; 

    3. 也可以直接容器内修改`/etc/hosts`文件，但重启或重建将失效。

## 关于armv7设备的补充说明

armv7设备如若无法使用网络，可能是seccomp问题，详见 [这里](https://wiki.alpinelinux.org/wiki/Release_Notes_for_Alpine_3.13.0)。

解决办法如下：

- docker cli方式可以在创建命令中增加一行`--security-opt seccomp=unconfined \`。

- docker-compose方式请在`docker-compose.yml`最后增加两行：

    ```
    security_opt:
      - seccomp=unconfined
    ```
