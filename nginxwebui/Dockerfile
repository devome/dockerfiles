ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION}
ARG DEBIAN_FRONTEND=noninteractive
ENV LANG=zh_CN.UTF-8 \
    TZ=Asia/Shanghai \
    PS1="\u@\h:\w \$ "
RUN echo "Install some packages..." \
    && sed -i "s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g" /etc/apt/sources.list \
    && sed -i "s@/security.ubuntu.com/@/mirrors.aliyun.com/@g" /etc/apt/sources.list \
    && sed -i "s@/ports.ubuntu.com/@/mirrors.aliyun.com/@g" /etc/apt/sources.list \
    && apt update \
    && apt install -y --no-install-recommends \
       nginx \
       libnginx-mod-stream \
       openjdk-8-jre \
       net-tools \
       curl \
       wget \
       ttf-dejavu \
       fontconfig \
       tzdata \
       tini \
       sqlite3 \
    && fc-cache -f -v \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
COPY src/target/nginxWebUI-*.jar /home/nginxWebUI.jar
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
VOLUME ["/home/nginxWebUI"]
ENTRYPOINT ["tini", "entrypoint.sh"]
