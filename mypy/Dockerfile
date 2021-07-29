FROM alpine:edge as builder
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -x \
  && apk add --update-cache \
    py3-pip \
    python3 \
  && apk add --virtual build-dependencies \
    gcc \
    musl-dev \
    python3-dev \
  && pip3 install \
    mypy \
  && apk del build-dependencies \
  && rm -rf \
    /var/cache/apk/* \
    ~/.cache \
  && true

WORKDIR /work

ENTRYPOINT [ "/usr/bin/mypy" ]
