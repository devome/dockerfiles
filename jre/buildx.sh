#!/usr/bin/env bash

set -o pipefail

repo="nevinee/jre"
arches="386 amd64 arm64 arm/v7"
ver=8u311
tags="$ver latest"

buildx() {
    docker pull tonistiigi/binfmt
    docker run --privileged --rm tonistiigi/binfmt --install all
    docker buildx create --name builder --use 2>/dev/null || docker buildx use builder
    docker buildx inspect --bootstrap
    for arch in $arches; do
        docker buildx build \
            --cache-from "type=local,src=/tmp/.buildx-cache" \
            --cache-to "type=local,dest=/tmp/.buildx-cache" \
            --build-arg "JRE_VERSION=$ver" \
            --build-arg "ARCH=${arch//\//-}" \
            --platform "linux/$arch" \
            --tag ${repo}:${ver}-${arch//\//-} \
            --output "type=docker" \
            .
    done
    
    for arch in $arches; do
        docker push ${repo}:${ver}-${arch//\//-}
    done

    images=()
    for arch in $arches; do
        images+=( "${repo}:${ver}-${arch//\//-}" )
    done

    for tag in $tags; do
        docker manifest create "${repo}:${tag}" "${images[@]}"
        docker manifest push --purge "${repo}:${tag}"
    done

    for image in ${images[@]}; do
        hub-tool tag rm --verbose -f $image
    done
}

if [[ $ver ]]; then
    [[ ! -d logs ]] && mkdir logs
    buildx 2>&1 | ts "[%Y-%m-%d %H:%M:%.S]" | tee -a logs/${ver}.log
else
    echo "当前版本：$ver"
fi
