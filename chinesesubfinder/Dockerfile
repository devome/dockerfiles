FROM alpine
ENV TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=100 \
    UMASK=022 \
    PS1="\u@\h:\w \$ "
ARG TARGETARCH
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
COPY go/out/${TARGETARCH}/chinesesubfinder /usr/bin/chinesesubfinder
COPY entrypoint.sh /usr/bin/entrypoint.sh
VOLUME ["/config"]
WORKDIR /config
ENTRYPOINT ["tini", "entrypoint.sh"]
