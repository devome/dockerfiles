FROM alpine
ENV LANG=zh_CN.UTF-8 \
    TZ=Asia/Shanghai \
    PUID=1000 \
    PGID=1000 \
    PS1="\u@\h:\w \$ "
RUN apk add --no-cache \
       acme.sh \
       curl \
       fontconfig \
       net-tools \
       nginx \
       nginx-mod-stream \
       nginx-mod-http-headers-more \
       nginx-mod-http-lua \
       openjdk8-jre \
       shadow \
       su-exec \
       tini \
       ttf-dejavu \
       tzdata \
       wget \
    && fc-cache -f -v \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && rm -rf /var/cache/apk/* /tmp/* \
    && sed -i 's/dl-cdn.alpinelinux.org/mirrors.bfsu.edu.cn/g' /etc/apk/repositories
COPY src/target/nginxWebUI-*.jar /home/nginxWebUI.jar
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh
VOLUME ["/home/nginxWebUI"]
ENTRYPOINT ["tini", "entrypoint.sh"]
