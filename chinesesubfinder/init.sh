#!/bin/sh

export CGO_ENABLED=1
export GO111MODULE=on
export GOOS=linux

if [ ! -d /go/src ]; then
    mkdir -p /go/src
fi
if [ ! -d /go/bin ]; then
    mkdir -p /go/bin
fi

cd /go/src
apk add --no-cache curl npm tar
curl -sSL https://github.com/allanpk716/ChineseSubFinder/archive/refs/tags/v${VERSION}.tar.gz | tar xvz --strip-components 1
npm --prefix frontend ci
npm --prefix frontend run build
go mod tidy
go mod download
exit 0
