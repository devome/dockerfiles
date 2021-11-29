FROM alpine:3.14
ARG LIBTORRENT_VERSION
ARG JNPROC=1
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache libstdc++ \
    && apk add --no-cache --virtual .build \
       boost-dev \
       build-base \
       openssl-dev \
       cmake \
       curl \
       tar \
       samurai \
    && mkdir -p /tmp/libtorrent-rasterbar \
    && cd /tmp/libtorrent-rasterbar \
    && curl -sSL https://github.com/arvidn/libtorrent/releases/download/v${LIBTORRENT_VERSION}/libtorrent-rasterbar-${LIBTORRENT_VERSION}.tar.gz | tar xvz --strip-components 1 \
    && cmake \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_CXX_STANDARD=17 \
       -Brelease \
       -GNinja \
    && cd release \
    && ninja -j${JNPROC} \
    && ninja install \
    && ls -al /usr/local/lib \
    && apk del --purge .build \
    && rm -rf /tmp/* /var/cache/apk/*