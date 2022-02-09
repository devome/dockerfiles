ARG ALPINE_VERSION=latest
FROM golang:alpine AS builder
ARG VERSION
ENV CGO_ENABLED=1 \
    GO111MODULE=on \
    GOOS=linux \
    GOPROXY=https://goproxy.cn,direct
WORKDIR /build
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache \
       build-base \
       curl \
       tar \
       nodejs \
       npm \
    && curl -sSL https://github.com/allanpk716/ChineseSubFinder/archive/refs/tags/v${VERSION}.tar.gz | tar xvz --strip-components 1 \
    && npm --prefix frontend install \
    && npm --prefix frontend run build \
    && go build -ldflags="-s -w --extldflags '-static -fpic' -X main.AppVersion=${VERSION}" -o /out/usr/local/bin/chinesesubfinder ./cmd/chinesesubfinder
COPY entrypoint.sh /out/usr/local/bin/entrypoint.sh

ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}
ENV TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=100 \
    UMASK=022 \
    PS1="\u@\h:\w \$ "
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --no-cache \
       ffmpeg \
       ca-certificates \
       tini \
       su-exec \
       tzdata \
    #  chromium \
    #  font-bitstream-100dpi \
    #  font-bitstream-75dpi \
    #  font-noto-emoji \
    #  font-noto-cjk \
    #  font-screen-cyrillic \
    #  imagemagick \
    #  xorg-server \
    #  xvfb \
    #  yasm \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && rm -rf /tmp/* /var/cache/apk/*
COPY --from=builder /out /
VOLUME ["/config"]
WORKDIR /config
ENTRYPOINT ["tini", "entrypoint.sh"]
