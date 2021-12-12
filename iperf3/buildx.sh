#!/usr/bin/env bash

repo="nevinee/iperf3"
arch="linux/386,linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6,linux/ppc64le,linux/s390x"
ver=$(curl -s https://api.github.com/repos/esnet/iperf/tags | jq -r .[].name | grep -m1 -P "(\d+\.){2}\d+")
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
        --build-arg "VERSION=$ver" \
        --platform "$arch" \
        --tag ${repo}:${ver} \
        --tag ${repo}:latest \
        --push \
        .
    docker pushrm -s "局域网测速工具iperf3" $repo  # https://github.com/christian-korneck/docker-pushrm
}

if [[ $ver ]]; then
    [[ ! -d logs ]] && mkdir logs
    echo "alpine_ver=${1:-latest}"
    buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${ver}.log
else
    echo "未获取到最新版本号"
fi
