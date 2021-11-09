#!/usr/bin/env bash

repo="nevinee/go-webdav"
arch="linux/amd64,linux/arm64,linux/arm/v7"
ver=$(curl -s https://api.github.com/repos/hacdias/webdav/releases/latest | jq -r .tag_name | sed "s/v//")

buildx() {
    docker pull tonistiigi/binfmt
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
    docker buildx inspect --bootstrap
    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --platform "$arch" \
        --build-arg "VERSION=${ver}" \
        --tag ${repo}:${ver} \
        --tag ${repo}:latest \
        --push \
        .
    docker-pushrm -s "go-webdav，支持平台：amd64/arm64/armv7" $repo
}

if [[ $ver ]]; then
    [[ ! -d logs ]] && mkdir logs
    buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${ver}.log
else
    echo "未获取到最新版本号"
fi
