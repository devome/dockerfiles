ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}
ARG VERSION
RUN apk add --no-cache --virtual .build \
       curl \
       musl-dev \
       make \
       gcc \
       tar \
       gzip \
    && mkdir -p /tmp/build \
    && cd /tmp/build \
    && curl -sSL https://github.com/esnet/iperf/archive/refs/tags/${VERSION}.tar.gz | tar xz --strip-components 1 \
    && ./configure --prefix=/usr --disable-static \
    && make install-strip \
    && apk del --purge .build \
    && apk add libcrypto1.1 \
    && rm -rf /tmp/* /var/cache/apk/*
ENTRYPOINT ["iperf3"]
CMD ["-s"]
