#!/usr/bin/env bash

repo="nevinee/s6-overlay"
arch="linux/386,linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6,linux/ppc64le"
ver=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest | jq -r .tag_name | sed "s/v//")
alpine_ver=${1:-latest}

buildx() {
    docker pull tonistiigi/binfmt
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
    docker buildx inspect --bootstrap

    ## 构建/bin是个软链接的版本
    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --build-arg "ALPINE_VERSION=$alpine_ver" \
        --build-arg "S6_OVERLAY_VERSION=$ver" \
        --platform "$arch" \
        --tag ${repo}:${ver}-bin-is-softlink \
        --tag ${repo}:bin-is-softlink \
        --file Dockerfile.bin_is_softlink \
        --push \
        .
    
    ## 构建/bin是个目录的版本
    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --build-arg "ALPINE_VERSION=$alpine_ver" \
        --build-arg "S6_OVERLAY_VERSION=$ver" \
        --platform "$arch" \
        --tag ${repo}:${ver} \
        --tag ${repo}:latest \
        --file Dockerfile \
        --push \
        .

    docker pushrm -s "方便简单的直接COPY s6-overlay" $repo  # https://github.com/christian-korneck/docker-pushrm
}

if [[ $ver ]]; then
    [[ ! -d logs ]] && mkdir logs
    echo "alpine_ver=${1:-latest}"
    echo "ver=$ver"
    buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${ver}.log
else
    echo "未获取到最新版本号"
fi
