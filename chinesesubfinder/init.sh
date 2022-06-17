#!/bin/sh

set -e

export CGO_ENABLED=1
export GO111MODULE=on
export GOOS=linux
export MUSL=/musl

## 准备必要的环境
if [ ! -d ~/go/src ]; then
    mkdir -p ~/go/src
fi
if [ ! -d ~/go/bin ]; then
    mkdir -p ~/go/bin
fi

## 下载源码并下载go mod
cd ~/go/src
curl -sSL https://github.com/allanpk716/ChineseSubFinder/archive/refs/tags/v${VERSION}.tar.gz | tar xvz --strip-components 1
npm --prefix frontend ci
npm --prefix frontend run build
go mod tidy

## 编译共用函数
cross_make() {
    if [ -n ${CROSS_NAME} ]; then
        export GPP_VERSION=$(${MUSL}/${CROSS_NAME}/bin/g++ --version | grep -oE '\d+\.\d+\.\d+' | head -1)
        export PATH=${MUSL}/${CROSS_NAME}-cross/bin:${MUSL}/${CROSS_NAME}-cross/${CROSS_NAME}/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
        export C_INCLUDE_PATH=${MUSL}/${CROSS_NAME}-cross/${CROSS_NAME}/include
        export CPLUS_INCLUDE_PATH=${MUSL}/${CROSS_NAME}-cross/${CROSS_NAME}/include/c++/${GPP_VERSION}
        export LIBRARY_PATH=${MUSL}/${CROSS_NAME}-cross/${CROSS_NAME}/lib
        export CC=${CROSS_NAME}-gcc
        export CXX=${CROSS_NAME}-g++
        export AR=${CROSS_NAME}-ar
    fi
    echo "[$(date +'%H:%M:%S')] 开始编译 ${GOARCH} 平台..."
    go build \
        -ldflags="-s -w --extldflags '-static -fpic' -X main.AppVersion=v${VERSION}" \
        -o ~/go/out/${GOARCH}/chinesesubfinder \
        ./cmd/chinesesubfinder
}

## 编译amd64平台
export GOARCH=amd64
export GOAMD64=v1
cross_make
unset -v GOARCH
unset -v GOAMD64

## 编译386平台
export CROSS_NAME=i686-linux-musl
export GOARCH=386
cross_make
unset -v CROSS_NAME
unset -v GOARCH

## 编译arm64平台
export CROSS_NAME=aarch64-linux-musl
export GOARCH=arm64
cross_make
unset -v CROSS_NAME
unset -v GOARCH

## 编译arm/v7平台
export CROSS_NAME=armv7l-linux-musleabihf
export GOARCH=arm
export GOARM=7
cross_make
unset -v CROSS_NAME
unset -v GOARCH
unset -v GOARM

## 列出文件
ls -lR ~/go/out
exit 0
