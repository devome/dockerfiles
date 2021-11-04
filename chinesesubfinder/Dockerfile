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
    && go build -ldflags="-s -w -X main.AppVersion=${VERSION}" -o /out/app/chinesesubfinder
COPY s6-overlay /out

FROM alpine
ENV TZ=Asia/Shanghai \
    PUID=1026 \
    PGID=100 \
    UMASK=022 \
    PS1="\u@\h:\w \$ "
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --update --no-cache \
       chromium \
       ffmpeg \
       yasm \
       ca-certificates \
       wget \
       shadow \
       s6-overlay \
       tzdata \
    && ln -sf /usr/bin/chromium-browser /usr/bin/chrome \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && useradd csf -u ${PUID} -U -m -s /sbin/nologin \
    && rm -rf /tmp/* /var/cache/apk/*
COPY --from=builder /out /
WORKDIR /app
VOLUME ["/config", "/media"]
ENTRYPOINT ["/init"]

