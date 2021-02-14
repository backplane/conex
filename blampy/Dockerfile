FROM alpine:edge as builder
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN set -x \
  && apk add --update-cache \
    inotify-tools \
    py3-pip \
    python3 \
  && apk add --virtual build-dependencies \
    curl \
    g++ \
    gcc \
    musl-dev \
    python3-dev \
  && pip3 install \
    black \
    bpython \
    mypy \
    pycodestyle \
    pylint \
  && apk del build-dependencies \
  && pip cache purge \
  && rm -r \
    /var/cache/apk/* \
    ~/.cache \
  && true

WORKDIR /work

COPY ["entrypoint.sh", "/"]

ENTRYPOINT [ "/entrypoint.sh" ]
