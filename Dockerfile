# syntax=docker/dockerfile:1

FROM alpine:3.24

ARG QUASSEL_APK_VERSION=0.14.0-r17
ARG VERSION=0.14.0

LABEL org.opencontainers.image.title="quassel-core" \
      org.opencontainers.image.description="Lightweight Quassel IRC core for Kubernetes" \
      org.opencontainers.image.version="${VERSION}" \
      org.opencontainers.image.source="https://github.com/rich0/quassel-core"

RUN apk add --no-cache --no-scripts \
      quassel-core=${QUASSEL_APK_VERSION} \
      openssl \
    && addgroup -g 1000 quassel \
    && adduser -D -u 1000 -G quassel -h /config quassel

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENV HOME=/config

USER 1000:1000

VOLUME /config
EXPOSE 4242 10113

ENTRYPOINT ["/entrypoint.sh"]
CMD []
