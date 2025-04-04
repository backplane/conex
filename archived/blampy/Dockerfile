FROM python:3-alpine AS builder
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --update-cache \
    inotify-tools \
  ; \
  apk add --virtual build-dependencies \
    curl \
    g++ \
    gcc \
    musl-dev \
  ; \
  pip3 install \
    black \
    bpython \
    mypy \
    pycodestyle \
    pylint \
  ; \
  pip cache purge; \
  apk del build-dependencies; \
  rm -r \
    /var/cache/apk/* \
    ~/.cache \
  ;

WORKDIR /work

COPY ["entrypoint.sh", "/"]

ENTRYPOINT [ "/entrypoint.sh" ]
