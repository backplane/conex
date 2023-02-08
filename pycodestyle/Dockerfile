FROM alpine:3
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --no-cache \
    py3-pip \
    python3 \
  ; \
  pip3 install \
    pycodestyle \
  ; \
  rm -rf \
    /var/cache/apk/* \
    ~/.cache \
  ; \
  find / -name __pycache__ -type d -print0 | xargs -0 rm -r --;

WORKDIR /work

ENTRYPOINT [ "/usr/bin/pycodestyle" ]
