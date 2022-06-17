#!/usr/bin/env bash

repo="nevinee/chinesesubfinder"
arch="linux/386,linux/amd64,linux/arm64,linux/arm/v7"
ver=$(curl -s https://api.github.com/repos/allanpk716/ChineseSubFinder/tags | jq -r '.[].name' | grep -Evi 'Beta|Docker' | head -1 | sed 's|v||')
alpine_ver=${1:-latest}

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
        --build-arg "ALPINE_VERSION=${alpine_ver}" \
        --tag ${repo}:${ver} \
        --tag ${repo}:latest \
        --push \
        .
    docker pushrm -s "自动下载中文字幕，支持平台：386/amd64/arm64/armv7" $repo  # https://github.com/christian-korneck/docker-pushrm
}

if [[ $ver ]]; then
    [[ ! -d logs ]] && mkdir logs
    [[ -d go/src ]] && rm -rf go/src
    echo "alpine_ver=${1:-latest}"
    docker run --rm \
        --env VERSION=${{ steps.prepare.outputs.version }} \
        --volume $(pwd)/go:/go \
        --volume $(pwd)/init.sh:/init.sh \
        --entrypoint "/init.sh" \
        golang:alpine
    buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${ver}.log
else
    echo "未获取到最新版本号"
fi
