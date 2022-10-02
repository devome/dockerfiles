ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}
ENV APP_ENV=prod \
    LANG=zh_CN.UTF-8 \
    TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=100 \
    PS1="\u@\h:\w \$ "
WORKDIR /IYUU
RUN apk add --no-cache \
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
        php8 \
        php8-curl \
        php8-dom \
        php8-json \
        php8-mbstring \
        php8-openssl \
        php8-opcache \
        php8-pdo \
        php8-pdo_sqlite \
        php8-phar \
        php8-pcntl \
        php8-posix \
        php8-simplexml \
        php8-sockets \
        php8-session \
        php8-zip \
        php8-zlib \
        php8-xml \
    && git config --global pull.ff only \
    && git config --global --add safe.directory /IYUU \
    && echo -e "upload_max_filesize=100M\npost_max_size=108M\nmemory_limit=1024M\ndate.timezone=${TZ}" > /etc/php8/conf.d/99-overrides.ini \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && useradd iyuu -u ${PUID} -U -M -d /IYUU -s /sbin/nologin \
    && git clone https://github.com/ledccn/IYUUPlus.git . \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php8 \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/' /etc/apk/repositories
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 8787
VOLUME ["/IYUU"]
ENTRYPOINT ["tini", "entrypoint.sh"]
