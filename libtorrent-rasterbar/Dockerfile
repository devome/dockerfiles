## 本地构建使用

FROM alpine AS builder
ARG LIBTORRENT_VERSION
COPY libtorrent-${LIBTORRENT_VERSION} /tmp/libtorrent
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache \
       libstdc++ \
    && apk add --no-cache --virtual .build \
       boost-dev \
       build-base \
       openssl-dev \
       cmake \
       ninja \
    && cd /tmp/libtorrent \
    && cmake \
        -DCMAKE_BUILD_TYPE=Release \
        -DCMAKE_CXX_STANDARD=17 \
        -B release \
        -G Ninja \
    && cd release \
    && ninja -j 1 -l 3 \
    && ninja install \
    && ls -al /usr/local/lib \
    && apk del .build \
    && rm -rf /tmp/* /var/cache/apk/*