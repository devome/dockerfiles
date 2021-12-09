#!/usr/bin/env bash

set -o pipefail

repo="nevinee/nginxwebui"
arch_ubuntu="linux/amd64,linux/arm64,linux/arm/v7"
arch_debian="linux/386,linux/amd64,linux/arm64,linux/arm/v7,linux/mips64le"

buildx() {
    cd src
    mvn clean package
    cd ..
    docker pull tonistiigi/binfmt
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
    docker buildx inspect --bootstrap    
    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --build-arg "BASE_TAG=latest-debian" \
        --platform "$arch_debian" \
        --tag ${repo}:${ver}-debian \
        --tag ${repo}:latest-debian \
        --push \
        .

    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --build-arg "BASE_TAG=latest" \
        --platform "$arch_ubuntu" \
        --tag ${repo}:${ver} \
        --tag ${repo}:latest \
        --push \
        .
}

git -C src pull
ver=$(cat src/pom.xml | grep -A1 nginxWebUI | grep version | perl -pe "s|.*((\d+\.?){3,}).*|\1|")
if [[ $ver != $(cat version 2>/dev/null) ]]; then
    echo "构建镜像：$repo"
    echo "构建平台：$arch"
    echo "构建版本：$ver"
    echo "3秒后开始编译jar并构建镜像..."
    sleep 3
    [[ ! -d logs ]] && mkdir logs
    buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${ver}.log
    [[ $? -eq 0 ]] && {
        echo $ver > version
        docker pushrm -s "可视化配置nginx，支持386/amd64/arm64/armv7/mips64le" $repo  # https://github.com/christian-korneck/docker-pushrm
    }
else
    echo "当前已经是最新版本：$ver"
fi
