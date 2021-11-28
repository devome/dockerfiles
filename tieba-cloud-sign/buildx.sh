#!/usr/bin/env bash

repo="nevinee/tieba-cloud-sign"
arch="linux/386,linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6,linux/ppc64le,linux/s390x"
[[ $1 ]] && {
    ver=$1
    cmd_tag="--tag ${repo}:${ver} --tag ${repo}:latest"
} || cmd_tag="--tag ${repo}:latest"

buildx() {
    docker pull tonistiigi/binfmt
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
    docker buildx inspect --bootstrap
    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --platform "$arch" \
        --push \
        $cmd_tag \
        .
    docker pushrm $repo  # https://github.com/christian-korneck/docker-pushrm
}

[[ ! -d logs ]] && mkdir logs
buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${ver}.log
