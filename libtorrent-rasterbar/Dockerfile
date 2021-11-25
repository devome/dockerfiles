FROM alpine
ARG LIBTORRENT_VERSION
ARG JNPROC=1
ARG URL=https://github.com/arvidn/libtorrent
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update \
    && apk add --no-cache libstdc++ \
    && apk add --no-cache --virtual .build \
       boost-dev \
       build-base \
       openssl-dev \
       cmake \
       samurai \
       git \
    && git clone --branch v${LIBTORRENT_VERSION} --recurse-submodules ${URL} /tmp/libtorrent \
    && cd /tmp/libtorrent \
    && cmake \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_CXX_STANDARD=17 \
       -Brelease \
       -GNinja \
    && cd release \
    && ninja -j${JNPROC} -l3 \
    && ninja install \
    && ls -al /usr/local/lib \
    && apk del --purge .build \
    && rm -rf /tmp/* /var/cache/apk/*