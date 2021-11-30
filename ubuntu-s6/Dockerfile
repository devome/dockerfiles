ARG UBUNTU_VERSION=latest
FROM ubuntu:${UBUNTU_VERSION}
COPY --from=nevinee/s6-overlay:bin-is-softlink / /
ENTRYPOINT ["/init"]
