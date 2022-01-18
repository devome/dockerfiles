ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}
ENV APP_ENV=prod \
    LANG=zh_CN.UTF-8 \
    TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=100 \
    PS1="\u@\h:\w \$ "
WORKDIR /IYUU
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
    && apk add --update --no-cache \
        su-exec \
        busybox-suid \
        shadow \
        ca-certificates \
        curl \
        tar \
        libressl \
        openssl  \
        wget \
        zip \
        unzip \
        git \
        tzdata \
        pcre \
        tini \
        composer \
        php7 \
        php7-curl \
        php7-dom \
        php7-json \
        php7-mbstring \
        php7-openssl \
        php7-opcache \
        php7-pdo \
        php7-pdo_sqlite \
        php7-phar \
        php7-pcntl \
        php7-posix \
        php7-simplexml \
        php7-sockets \
        php7-session \
        php7-zip \
        php7-zlib \
        php7-xml \
    && git config --global pull.ff only \
    && echo -e "upload_max_filesize=100M\npost_max_size=108M\nmemory_limit=1024M\ndate.timezone=${TZ}" > /etc/php7/conf.d/99-overrides.ini \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && useradd iyuu -u ${PUID} -U -M -d /IYUU -s /sbin/nologin \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php7
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 8787
VOLUME ["/IYUU"]
ENTRYPOINT ["tini", "entrypoint.sh"]
