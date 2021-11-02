#!/usr/bin/env bash

## 请不要直接运行本脚本，请通过运行 buildx.sh 脚本来调用本脚本。

set -e

for arch in ${BUILDX_ARCH}; do
    echo "------------------------- 构建目标平台：linux/${arch} -------------------------"
    docker buildx build \
        --tag ${DOCKERHUB_REPOSITORY}:${LIBTORRENT_VERSION}-${arch//\//-} \
        --cache-from "type=local,src=/tmp/.buildx-cache" \
        --cache-to "type=local,dest=/tmp/.buildx-cache" \
        --output "type=docker" \
        --platform linux/${arch} \
        --build-arg "LIBTORRENT_VERSION=${LIBTORRENT_VERSION}" \
        --build-arg "JNPROC=${JNPROC}" \
        --file ${DOCKERFILE_NAME} \
        .
done
