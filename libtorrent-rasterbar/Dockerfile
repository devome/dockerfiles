ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}
ARG LIBTORRENT_VERSION
ARG JNPROC=1
RUN apk add --no-cache --virtual .build \
       boost-dev \
       openssl-dev \
       cmake \
       g++ \
       samurai \
       curl \
       tar \
    && mkdir -p /tmp/libtorrent-rasterbar \
    && cd /tmp/libtorrent-rasterbar \
    && curl -sSL https://github.com/arvidn/libtorrent/releases/download/v${LIBTORRENT_VERSION}/libtorrent-rasterbar-${LIBTORRENT_VERSION}.tar.gz | tar xz --strip-components 1 \
    && cmake \
       -DCMAKE_BUILD_TYPE=Release \
       -DCMAKE_CXX_STANDARD=17 \
       -DBUILD_SHARED_LIBS=ON \
       -Brelease \
       -GNinja \
    && cd release \
    && ninja -j${JNPROC} \
    && ninja install \
    && ls -al /usr/local/lib \
    && apk del --purge .build \
    && apk add libcrypto1.1 libgcc libssl1.1 libstdc++ \
    && rm -rf /tmp/* /var/cache/apk/*