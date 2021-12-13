ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}
ENV LANG=zh_CN.UTF-8 PS1="\u@\h:\w \$ "
WORKDIR /cf
RUN apk add --update --no-cache \
       curl \
       bash \
    && apk add --no-cache --virtual .build \
       musl-dev \
       make \
       gcc \
       tar \
       gzip \
    && mkdir build \
    && cd build \
    && curl -sSL https://github.com/badafans/better-cloudflare-ip/releases/latest/download/linux.tar.gz | tar xz --strip-components 1 \
    && sed -i "s|^int random_data_flag;|extern int random_data_flag;|" src/fping.h \
    && ./configure --prefix=/usr \
    && make \
    && make install \
    && strip $(type fping | awk '{print $3}') \
    && cd .. \
    && sed "s|./fping|fping|" build/src/cf.sh > cf.sh \
    && chmod +x cf.sh \
    && apk del --purge .build \
    && rm -rf build /tmp/* /var/cache/apk/*
CMD ["/cf/cf.sh"]

