ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION} AS builder
ARG S6_OVERLAY_VERSION
WORKDIR /tmp
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
    && apk add --update --no-cache curl tar gzip \
    && case $(cat /etc/apk/arch) in \
           x86_64) s6_arch=amd64;; \
           armv7) s6_arch=arm;; \
           *) s6_arch=$(cat /etc/apk/arch);; \
       esac \
    && mkdir /out \
    && curl -sSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${s6_arch}.tar.gz -o s6-overlay.tar.gz \
    && tar xzvf s6-overlay.tar.gz -C /out \
    && rm -rf /tmp/*

FROM scratch
COPY --from=builder /out /