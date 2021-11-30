#!/usr/bin/env bash

repo="nevinee/ddns"
arch="linux/amd64,linux/arm64,linux/arm/v7"
ver=$(curl -s https://api.github.com/repos/NewFuture/DDNS/releases/latest | jq -r .tag_name | sed "s/v//")
alpine_ver=${1:-latest}

buildx() {
    docker pull tonistiigi/binfmt
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
    docker buildx inspect --bootstrap
    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --build-arg "ALPINE_VERSION=$alpine_ver" \
        --platform "$arch" \
        --tag ${repo}:${ver} \
        --tag ${repo}:latest \
        --push \
        .
    docker pushrm $repo  # https://github.com/christian-korneck/docker-pushrm
}

if [[ $ver ]]; then
    [[ ! -d logs ]] && mkdir logs
    echo "alpine_ver=${1:-latest}"
    buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${ver}.log
else
    echo "未获取到最新版本号"
fi
