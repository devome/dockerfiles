#!/usr/bin/env bash

repo="nevinee/python"
arch="linux/amd64,linux/arm64,linux/arm/v7"

buildx() {
    docker pull tonistiigi/binfmt
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
    docker buildx inspect --bootstrap
    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --platform "$arch" \
        --tag ${repo}:latest \
        --push \
        .
    docker pushrm $repo  # https://github.com/christian-korneck/docker-pushrm
}

[[ ! -d logs ]] && mkdir logs
buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${ver}.log
