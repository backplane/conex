FROM python:3-alpine AS builder
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  # apk add --no-cache --virtual build-dependencies \
  #   gcc \
  #   musl-dev \
  # ; \
  pip3 install \
    black \
  ; \
  pip3 cache purge; \
  # apk del build-dependencies; \
  rm -rf \
    /var/cache/apk/* \
    ~/.cache \
  ; \
  find / -name __pycache__ -type d -print0 | xargs -0 rm -r --;

WORKDIR /work

ENTRYPOINT [ "/usr/bin/black" ]
