FROM alpine:3.15.3
ENV LANG=zh_CN.UTF-8 \
    PS1="\u@\h:\w \$ "
RUN apk add --update --no-cache \
       python3 \
       py3-pip \
    && apk add --no-cache --virtual .build \
       git \
       gcc \
       musl-dev \
    && ln /usr/bin/python3 /usr/bin/python \
    && pip install pycryptodome mutagen \
    && pip install git+https://github.com/nondanee/ncmdump.git \
    && apk del .build \
    && rm -rf /tmp/* /root/.cache
ENTRYPOINT ["/usr/bin/ncmdump"]
