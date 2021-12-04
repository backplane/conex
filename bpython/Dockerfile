FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --update-cache \
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
    bpython \
  ; \
  pip cache purge; \
  apk del build-dependencies; \
  rm -rf \
    /var/cache/apk/* \
    ~/.cache \
  ; \
  find / -name __pycache__ -type d -print0 | xargs -0 rm -r --;

WORKDIR /work

ENTRYPOINT [ "/usr/bin/bpython" ]
