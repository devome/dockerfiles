#!/usr/bin/env bash

set -o pipefail

repo="nevinee/nginxwebui-base"
arch_ubuntu="linux/amd64,linux/arm64,linux/arm/v7"
arch_debian="linux/386,linux/amd64,linux/arm64,linux/arm/v7,linux/mips64le"

buildx() {
    docker pull tonistiigi/binfmt
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
    docker buildx inspect --bootstrap
    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --platform "$arch_ubuntu" \
        --tag ${repo}:latest \
        --push \
        .
    
    docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --platform "$arch_debian" \
        --tag ${repo}:latest-debian \
        --push \
        --file Dockerfile.debian
        .
}

buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]"
