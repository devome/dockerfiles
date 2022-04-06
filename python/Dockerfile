FROM nevinee/alpine-s6
LABEL maintainer="Evine Deng <evinedeng@foxmail.com>"
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    HOME=/root \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ "
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update -f \
    && apk --no-cache add -f \
       python3-dev \
       py3-pip \
       bash \
       openssl \
       coreutils \
       moreutils \
       git \
       wget \
       curl \
       nano \
       tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && ln -s /usr/bin/python3 /usr/bin/python \
    && python -m pip install --upgrade pip \
    && rm -rf \
       /tmp/* \
       /root/.cache
COPY --from=nevinee/loop:latest / /
COPY s6-overlay /
WORKDIR /root
ENTRYPOINT ["/init"]