FROM alpine:latest
ENV LANG=zh_CN.UTF-8 \
    TZ=Asia/Shanghai \
    WORKDIR=/var/www \
    CRON_TASK="* * * * *" \
    PS1="\u@\h:\w \$ "
RUN apk add --no-cache \
       bash \
       busybox-suid \
       caddy \
       git \
       php8 \
       php8-curl \
       php8-fpm \
       php8-gd \
       php8-json \
       php8-mbstring \
       php8-mysqli \
       php8-session \
       php8-zip \
       s6-overlay \
       shadow \
       tzdata \
    && caddy upgrade \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo -e "${TZ}" > /etc/timezone \
    && echo -e "max_execution_time = 3600\nupload_max_filesize=128M\npost_max_size=128M\nmemory_limit=1024M\ndate.timezone=${TZ}" > /etc/php8/conf.d/99-overrides.ini \
    && echo -e "[global]\nerror_log = /dev/stdout\ndaemonize = no\ninclude=/etc/php8/php-fpm.d/*.conf" > /etc/php8/php-fpm.conf \
    && echo -e "[www]\nuser = caddy\ngroup = caddy\nlisten = 127.0.0.1:9000\nlisten.owner = caddy\nlisten.group = caddy\npm = ondemand\npm.max_children = 75\npm.max_requests = 500\npm.process_idle_timeout = 10s\nchdir = $WORKDIR" > /etc/php8/php-fpm.d/www.conf \
    && echo -e ":8080\nroot * $WORKDIR\nlog {\n    level warn\n}\nphp_fastcgi 127.0.0.1:9000\nfile_server" > /etc/caddy/Caddyfile \
    && rm -rf $WORKDIR/* /var/cache/apk/* /tmp/* \
    && git config --global pull.ff only \
    && git clone --depth=1 -b master https://github.com/MoeNetwork/Tieba-Cloud-Sign $WORKDIR \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/' /etc/apk/repositories
COPY s6-overlay /
WORKDIR $WORKDIR
ENTRYPOINT ["/init"]