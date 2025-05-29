FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --update-cache \
    nodejs \
    npm \
    git \
    py3-pip \
    py3-yaml \
    python3 \
  ; \
  apk add --virtual build-dependencies \
    g++ \
    musl-dev \
    python3-dev \
  ; \
  npm install -g aws-cdk; \
  apk del build-dependencies; \
  rm -rf \
    /var/cache/apk/* \
    ~/.cache \
  ;

ARG NONROOT_UID=65532 NONROOT_GID=65532

RUN set -eux; \
  addgroup -g "$NONROOT_GID" nonroot; \
  adduser -h /work -s /bin/sh -D -u "$NONROOT_UID" -G nonroot nonroot; \
  mkdir /config; \
  chown nonroot:nonroot /config /work;

ENV AWS_CONFIG_FILE=/config/config
USER nonroot
WORKDIR /work
