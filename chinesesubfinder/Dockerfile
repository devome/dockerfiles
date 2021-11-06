FROM golang:alpine AS builder
ARG VERSION
ENV CGO_ENABLED=1 \
    GO111MODULE=on \
    GOOS=linux \
    GOPROXY=https://goproxy.cn,direct
WORKDIR /build
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --update --no-cache \
       git \
       build-base \
    && git clone -b v${VERSION} https://github.com/allanpk716/ChineseSubFinder . \
    && mkdir -p /out/app \
    && cp config.yaml.sample /out/app/config.yaml.sample \
    && cd cmd/chinesesubfinder \
    && go build -ldflags="-s -w -X main.AppVersion=${VERSION}" -o /out/usr/local/bin/chinesesubfinder
COPY entrypoint.sh /out/usr/local/bin/entrypoint.sh

FROM alpine
ENV TZ=Asia/Shanghai \
    PUID=1026 \
    PGID=100 \
    UMASK=022 \
    PS1="\u@\h:\w \$ "
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --update --no-cache \
       ffmpeg \
       yasm \
       ca-certificates \
       wget \
       shadow \
       tini \
       su-exec \
       tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && useradd csf -u ${PUID} -MU -s /sbin/nologin \
    && rm -rf /tmp/* /var/cache/apk/*
COPY --from=builder /out /
VOLUME ["/config", "/media"]
WORKDIR /config
ENTRYPOINT ["/sbin/tini", "--", "entrypoint.sh"]
