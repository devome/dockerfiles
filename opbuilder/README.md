用来编译 openwrt / lede 的容器，容器中已含有全部编译的依赖项，创建的配置如下：

```yaml
version: "3.8"
services:
  opbuilder:
    image: nevinee/opbuilder
    container_name: opbuilder
    restart: unless-stopped
    network_mode: host
    hostname: opbuilder
    volumes:
      - .:/home/evine
    init: true
    environment:
      PUID: 1000           # 默认1000，如果需要使用其他uid的用户来编译，请修改为对应用户的uid
      PGID: 1000           # 默认1000，如果需要使用其他gid的用户来编译，请修改为对应用户的gid
      ENABLE_CHOWN: true   # 默认false，不重新设置文件所有者，如遇文件权限问题，请设置为true，将在创建后重新设置映射文件夹的权限
```

也可以按需修改下列命令中`$(pwd)` `PUID` `PGID` `ENABLE_CHOWN`来创建：

```shell
docker run -d \
  --volume $(pwd):/home/evine \
  --env PUID=1000 `# 默认1000，如果需要使用其他uid的用户来编译，请修改为对应用户的uid` \
  --env PGID=1000 `# 默认1000，如果需要使用其他gid的用户来编译，请修改为对应用户的gid` \
  --env ENABLE_CHOWN=true `# 默认false，不重新设置文件所有者，如遇文件权限问题，请设置为true，将在创建后重新设置映射文件夹的权限` \
  --restart unless-stopped \
  --hostname opbuilder \
  --name opbuilder \
  --init \
  nevinee/opbuilder
```

已安装zsh，以`docker exec -it opbuilder zsh`进入容器后即可编译openwrt。**注：在容器内可以免密执行sudo命令。**

如果不想输入上面这么长的命令，可以在宿主机上这样操作（如果使用的是zsh可以把`.bashrc`换成`.zshrc`），然后你就可以直接输入`dto`就进入容器了：

```shell
echo "alias dto='docker exec -it opbuilder zsh'" >> ~/.bashrc
source ~/.bashrc
```

建议首次创建时，进入容器后运行一次以下命令以安装`oh-my-zsh`：

```shell
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
cd ~/.oh-my-zsh/custom/plugins
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions.git
git clone --depth 1 https://github.com/zsh-users/zsh-syntax-highlighting.git
```

提供一个容器内的`/home/evine/.zshrc`文件作参考：

```shell
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="agnoster"
plugins=(git extract sudo z zsh-autosuggestions zsh-syntax-highlighting zsh-interactive-cd) # z也可以用autojump代替
source $ZSH/oh-my-zsh.sh
```

`.zshrc`中和plugin如何使用请见：https://github.com/ohmyzsh/ohmyzsh/wiki/Plugins

本容器亦支持运行一次编译脚本后直接删除容器，创建时只要增加command即可：

```shell
docker run -d \
  --rm \
  --volume $(pwd):/home/evine \
  --env PUID=1000 `# 默认1000，如果保持默认可以不要本行` \
  --env PGID=1000 `# 默认1000，如果保持默认可以不要本行` \
  --env ENABLE_CHOWN=true `# 默认false，不重新设置文件所有者，如果保持默认可以不要本行` \
  nevinee/opbuilder \
  bash /home/evine/your_script.sh  #只要带上command即可，运行完你的脚本后会直接删除容器
```

Dockerfile见：https://github.com/devome/dockerfiles/tree/master/opbuilder
