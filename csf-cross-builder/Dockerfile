FROM alpine
WORKDIR /musl
ARG ARCH="aarch64-linux-musl armv7l-linux-musleabihf i686-linux-musl"
RUN baseurl=https://more.musl.cc/x86_64-linux-musl && \
    apk add --no-cache bash musl-dev gcc g++ go npm tar curl gzip && \
    for target in ${ARCH}; do \
        curl -fsSL ${baseurl}/${target}-cross.tgz -o ${target}-cross.tgz && \
        tar zxf ${target}-cross.tgz; \
    done && \
    rm -rf */usr $(find . -name "ld-musl-*.so.1") *.tgz && \
    chown -R root:root . && \
    ls -l
