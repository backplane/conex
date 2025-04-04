FROM alpine:3 AS builder
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --update-cache \
    py3-pip \
    python3 \
  ; \
  apk add --virtual build-dependencies \
    gcc \
    musl-dev \
    python3-dev \
  ; \
  pip3 install \
    mypy \
  ; \
  apk del build-dependencies; \
  rm -rf \
    /var/cache/apk/* \
    ~/.cache \
  ;

WORKDIR /work

ENTRYPOINT [ "/usr/bin/mypy" ]
