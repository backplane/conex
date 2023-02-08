FROM alpine:3 as builder
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --update-cache \
    inotify-tools \
    py3-pip \
    python3 \
  ; \
  apk add --virtual build-dependencies \
    curl \
    g++ \
    gcc \
    musl-dev \
    python3-dev \
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
