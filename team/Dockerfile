FROM node:lts-alpine
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    LANG=zh_CN.UTF-8 \
    SHELL=/bin/bash \
    PS1="\u@\h:\w \$ "
COPY team/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk update -f \
    && apk upgrade \
    && apk --no-cache add -f bash coreutils moreutils git wget nano tzdata perl openssl openssh-client \
    && rm -rf /var/cache/apk/* \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone \
    && echo -e "\n\nHost ${REPO}\nStrictHostKeyChecking no\n" >> /etc/ssh/ssh_config \
    && npm install --registry=https://registry.npm.taobao.org -g pm2 \
    && chmod 777 /usr/local/bin/docker-entrypoint.sh
WORKDIR /root
ENTRYPOINT ["docker-entrypoint.sh"]