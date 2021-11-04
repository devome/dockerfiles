## Instruction/说明

Even if there are no other services, this container will remain open after it is created. /即使没有任何服务，本容器创建以后也会保持开启状态。

## Create/创建

```
docker run -d \
  --name alpine \
  nevinee/alpine-s6
```
Then enter the container,  you can do anything you want to do. /然后进入容器，你可以做任何你想做的事情。
```
docker exec -it alpine bash
```

## Dockerfile

https://gitee.com/evine/dockerfiles/tree/master/alpine-s6

https://github.com/devome/dockerfiles/tree/master/alpine-s6