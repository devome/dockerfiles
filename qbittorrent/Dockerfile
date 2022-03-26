ARG LIBTORRENT_VERSION
ARG ALPINE_VERSION=latest
FROM nevinee/libtorrent-rasterbar:${LIBTORRENT_VERSION} AS builder
RUN apk add --no-cache \
       boost-dev \
       openssl-dev \
       qt5-qtbase-dev \
       qt5-qttools-dev \
       g++ \
       cmake \
       curl \
       tar \
       samurai \
    && rm -rf /tmp/* /var/cache/apk/*
ARG QBITTORRENT_VERSION
ARG JNPROC=1
RUN mkdir -p /tmp/qbittorrent \
    && cd /tmp/qbittorrent \
    && curl -sSL https://github.com/qbittorrent/qBittorrent/archive/refs/tags/release-${QBITTORRENT_VERSION}.tar.gz | tar xz --strip-components 1 \
    && cmake \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_INTERPROCEDURAL_OPTIMIZATION=ON \
       -DCMAKE_CXX_STANDARD=17 \
       -DWEBUI=ON \
       -DVERBOSE_CONFIGURE=OFF \
       -DSTACKTRACE=OFF \
       -DDBUS=OFF \
       -DGUI=OFF \
       -DQT6=OFF \
       -Brelease \
       -GNinja \
    && cd release \
    && ninja -j${JNPROC} \
    && ninja install \
    && ls -al /usr/local/bin/ \
    && qbittorrent-nox --help
RUN echo "Copy to /out" \
    && strip /usr/local/lib/libtorrent-rasterbar.so.* \
    && strip /usr/local/bin/qbittorrent-nox \
    && mkdir -p /out/usr/lib /out/usr/bin \
    && cp -d /usr/local/lib/libtorrent-rasterbar.so* /out/usr/lib \
    && cp /usr/local/bin/qbittorrent-nox /out/usr/bin

ARG ALPINE_VERSION
FROM alpine:${ALPINE_VERSION}
ENV S6_SERVICES_GRACETIME=30000 \
    S6_KILL_GRACETIME=60000 \
    QBITTORRENT_HOME=/home/qbittorrent \
    TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=100 \
    WEBUI_PORT=8080 \
    BT_PORT=34567 \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ "
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/g' /etc/apk/repositories \
    && apk add --no-cache \
       curl \
       openssl \
       qt5-qtbase \
       shadow \
       tzdata \
       jq \
       bash \
       s6-overlay \
    && rm -rf /tmp/* /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && useradd qbittorrent -u ${PUID} -U -m -d ${QBITTORRENT_HOME} -s /sbin/nologin
COPY --from=builder /out /
COPY s6-overlay /
WORKDIR /data
VOLUME ["/data"]
ENTRYPOINT ["/init"]
