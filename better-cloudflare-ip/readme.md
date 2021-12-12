## 简介

这个项目的Docker实现：https://github.com/badafans/better-cloudflare-ip

## 运行

```
docker run --rm nevinee/better-cloudflare-ip
```

*注：网络经常发生变化，如再遇无法连接的情况，可再次运行查找最优IP。*

根据输出的ip修改hosts：

- Windows: C:\Windows\System32\Drivers\etc\hosts

- Linux: /etc/hosts

- Docker: 三种方法

    1. 如果命令行创建容器，添加`--add-host <host>:<ip>`; 

    2. 如果是compose创建，添加`extra_hosts`; 

    3. 也可以直接容器内修改`/etc/hosts`文件，但重启或重建将失效。
