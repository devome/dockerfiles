ARG ALPINE_VERSION=latest
FROM alpine:${ALPINE_VERSION}
RUN apk add --no-cache git openssh-client
ADD *.sh /
ENTRYPOINT ["/entrypoint.sh"]