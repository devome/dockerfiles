FROM alpine:latest
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk --no-cache --update add -f bash s6-overlay \
    && rm -rf /var/cache/apk/*
ENV SHELL=/bin/bash \
    PS1="\u@\h:\w \$ "
ENTRYPOINT ["/init"]
