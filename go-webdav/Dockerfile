FROM golang:alpine as builder
ARG VERSION
ARG GOPROXY=https://goproxy.cn,https://mirrors.aliyun.com/goproxy/,https://goproxy.io,direct
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --update --no-cache git \
    && git clone -b v${VERSION} https://github.com/hacdias/webdav /build \
    && cd /build \
    && ls -lh \
    && mkdir -p /out/usr/local/bin \
    && mkdir -p /out/etc/ssl/certs \
    && go mod tidy \
    && go build -ldflags="-s -w" -o /out/usr/local/bin/webdav \
    && cp /etc/ssl/certs/ca-certificates.crt /out/etc/ssl/certs/ca-certificates.crt

ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}
COPY --from=builder /out /
VOLUME ["/etc/webdav"]
ENTRYPOINT ["webdav"]
