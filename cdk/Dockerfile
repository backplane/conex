FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --no-cache \
    g++ \
    git \
    musl-dev \
    nodejs \
    npm \
    py3-pip \
    py3-yaml \
    python3 \
    python3-dev \
  ;

RUN set -eux; \
  npm install -g aws-cdk; 

RUN set -eux; \
  pip install \
    bandit \
    black \
    bpython \
    flake8 \
    isort \
    mypy \
    pycodestyle \
    pylint \
    pytest \
  ; \
  pip cache purge;

ARG NONROOT_UID=1000 NONROOT_GID=1000

RUN set -eux; \
  addgroup -g "$NONROOT_GID" nonroot; \
  adduser -h /work -s /bin/sh -D -u "$NONROOT_UID" -G nonroot nonroot; \
  mkdir /config; \
  chown nonroot:nonroot /config /work;

ENV AWS_CONFIG_FILE=/config/config
USER nonroot
WORKDIR /work
