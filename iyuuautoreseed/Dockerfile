## 修改自：https://github.com/ledccn/IYUUAutoReseed

FROM alpine
ENV APP_ENV=prod \
    LANG=zh_CN.UTF-8 \
    TZ=Asia/Shanghai \
    PS1="\u@\h:\w \$ "
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories \
    && apk add --no-cache --update \
       bash \
       git \
       tzdata \
       php7 \
       php7-curl \
       php7-dom \
       php7-json \
       php7-mbstring \
       php7-simplexml \
       php7-zip \
       php7-xml \
    && echo -e "upload_max_filesize=100M\npost_max_size=108M\nmemory_limit=1024M\ndate.timezone=${TZ}" > /etc/php7/conf.d/99-overrides.ini \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && rm -rf \
       /var/cache/apk/* \
       /tmp/* \
       /usr/share/man \
       /usr/share/php7
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
WORKDIR /iyuu
VOLUME ["/iyuu"]
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]