#!/usr/bin/env bash

set -o pipefail

repo="nevinee/nginxwebui"
arch="linux/amd64,linux/arm64"

buildx() {
    docker pull tonistiigi/binfmt
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
    docker buildx inspect --bootstrap
    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --platform "$arch" \
        --tag ${repo}:${ver} \
        --tag ${repo}:latest \
        --push \
        .
}

git -C src pull
ver=$(cat src/pom.xml | grep -A1 nginxWebUI | grep version | perl -pe "s|.*((\d+\.?){3,}).*|\1|")
if [[ $ver != $(cat version 2>/dev/null) ]]; then
    [[ ! -d logs ]] && mkdir logs
    buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${ver}.log
    [[ $? -eq 0 ]] && {
        echo $ver > version
        docker pushrm -s "可视化配置nginx，减小体积，支持amd64/arm64" $repo  # https://github.com/christian-korneck/docker-pushrm
    }
else
    echo "当前版本：$ver"
fi
