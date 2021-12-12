#!/usr/bin/env bash

repo="nevinee/better-cloudflare-ip"
arch="linux/386,linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6,linux/ppc64le,linux/s390x"
alpine_ver=${1:-latest}

docker pull tonistiigi/binfmt
docker run --privileged --rm tonistiigi/binfmt --install all
docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
docker buildx inspect --bootstrap
docker buildx build \
    --cache-from "type=local,src=/tmp/.buildx-cache" \
    --cache-to "type=local,dest=/tmp/.buildx-cache" \
    --build-arg "ALPINE_VERSION=$alpine_ver" \
    --platform "$arch" \
    --tag ${repo}:latest \
    --push \
    .
docker pushrm -s "寻找CloudFlare最优IP" $repo  # https://github.com/christian-korneck/docker-pushrm
