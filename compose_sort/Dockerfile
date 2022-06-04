FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY [ "requirements.txt", "/" ]

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
  pip3 install -r requirements.txt; \
  pip3 cache purge; \
  apk del build-dependencies; \
  rm -rf \
    /var/cache/apk/* \
    ~/.cache \
  ; \
  find / -name __pycache__ -type d -print0 | xargs -0 -r rm -r --;

COPY [ "compose_sort.py", "/compose_sort" ]
WORKDIR /work
ENTRYPOINT [ "/usr/bin/python3", "/compose_sort" ]
