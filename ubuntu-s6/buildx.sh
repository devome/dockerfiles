#!/usr/bin/env bash

repo="nevinee/ubuntu-s6"
arch="linux/amd64,linux/arm64,linux/arm/v7,linux/ppc64le"

docker buildx build \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --build-arg "UBUNTU_VERSION=latest" \
        --platform "$arch" \
        --tag ${repo}:20.04 \
        --tag ${repo}:focal \
        --tag ${repo}:latest \
        --push \
        .

