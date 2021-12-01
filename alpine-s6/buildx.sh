#!/usr/bin/env bash

repo="nevinee/alpine-s6"
arch="linux/386,linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6,linux/ppc64le"
s6_ver=$(curl -s https://api.github.com/repos/just-containers/s6-overlay/releases/latest | jq -r .tag_name | sed "s/v//")
ver="$1"

buildx() {
    docker pull tonistiigi/binfmt
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
    docker buildx inspect --bootstrap
    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --build-arg "ALPINE_VERSION=${ver}" \
        --build-arg "S6_OVERLAY_VERSION=$s6_ver" \
        --platform "$arch" \
        --tag ${repo}:${ver} \
        --tag ${repo}:latest \
        --push \
        .
    docker pushrm $repo  # https://github.com/christian-korneck/docker-pushrm
}

if [[ $ver ]]; then
    [[ ! -d logs ]] && mkdir logs
    [[ -z $s6_ver ]] && echo "未获取到s6-overlay版本" && exit 1
    buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${ver}.log
else
    echo "未输入最新版本号"
fi
