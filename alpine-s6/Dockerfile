ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}
RUN apk add --no-cache s6-overlay
ENV PS1="\u@\h:\w \$ "
ENTRYPOINT ["/init"]
