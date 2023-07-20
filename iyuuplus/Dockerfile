FROM alpine
ENV APP_ENV=prod \
    LANG=zh_CN.UTF-8 \
    TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=1000\
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
        php81 \
        php81-curl \
        php81-dom \
        php81-json \
        php81-mbstring \
        php81-openssl \
        php81-opcache \
        php81-pdo \
        php81-pdo_sqlite \
        php81-phar \
        php81-pcntl \
        php81-posix \
        php81-simplexml \
        php81-sockets \
        php81-session \
        php81-zip \
        php81-zlib \
        php81-xml \
    && git config --global pull.ff only \
    && git config --global --add safe.directory /IYUU \
    && echo -e "upload_max_filesize=100M\npost_max_size=108M\nmemory_limit=1024M\ndate.timezone=${TZ}" > /etc/php81/conf.d/99-overrides.ini \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && useradd iyuu -u ${PUID} -U -M -d /IYUU -s /sbin/nologin \
    && git clone --depth=1 https://github.com/ledccn/IYUUPlus.git . \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man /usr/share/php81 \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/' /etc/apk/repositories
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
EXPOSE 8787
VOLUME ["/IYUU"]
ENTRYPOINT ["tini", "entrypoint.sh"]
