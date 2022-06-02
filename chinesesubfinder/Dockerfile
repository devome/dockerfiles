ARG ALPINE_VERSION=latest
FROM golang:alpine AS builder
ARG VERSION
ENV CGO_ENABLED=1 \
    GO111MODULE=on \
    GOOS=linux
COPY go /go
WORKDIR /go/src
RUN apk add --no-cache gcc g++ musl-dev && \
    go build -ldflags="-s -w --extldflags '-static -fpic' -X main.AppVersion=v${VERSION}" -o /out/usr/local/bin/chinesesubfinder ./cmd/chinesesubfinder
COPY entrypoint.sh /out/usr/local/bin/entrypoint.sh

ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}
ENV TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=100 \
    UMASK=022 \
    PS1="\u@\h:\w \$ "
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache \
       ffmpeg \
       ca-certificates \
       tini \
       su-exec \
       tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && rm -rf /tmp/* /var/cache/apk/*
COPY --from=builder /out /
VOLUME ["/config"]
WORKDIR /config
ENTRYPOINT ["tini", "entrypoint.sh"]
