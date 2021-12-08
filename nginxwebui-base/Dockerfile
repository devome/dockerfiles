FROM debian
ARG DEBIAN_FRONTEND=noninteractive
RUN echo "Install some packages..." \
    && sed -i "s@/deb.debian.org/@/mirrors.aliyun.com/@g" /etc/apt/sources.list \
    && sed -i "s@/security.debian.org/@/mirrors.aliyun.com/@g" /etc/apt/sources.list \
    && apt update \
    && apt install -y --no-install-recommends \
       nginx \
       libnginx-mod-stream \
       openjdk-11-jre \
       net-tools \
       curl \
       wget \
       fonts-dejavu \
       fontconfig \
       tzdata \
       tini \
       sqlite3 \
    && fc-cache -f -v \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && echo "${TZ}" > /etc/timezone \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
