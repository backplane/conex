FROM alpine:edge as builder
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN set -x \
  && apk add --update-cache \
    py3-pip \
    python3 \
  && apk add --update-cache --virtual build-dependencies \
    gcc \
    musl-dev \
    python3-dev \
  && pip3 install \
    black \
  && apk del build-dependencies \
  && rm -rf \
    /var/cache/apk/* \
    ~/.cache \
  && find / -name __pycache__ -type d -print0 | xargs -0 rm -r -- \
  && true

WORKDIR /work

ENTRYPOINT [ "/usr/bin/black" ]
