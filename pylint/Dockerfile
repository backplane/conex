FROM alpine:edge
LABEL maintainer="glvnst <glvnst@users.noreply.github.com>"

RUN set -x \
  && apk add --no-cache \
    py3-pip \
    python3 \
  && pip3 install \
    pylint \
  && rm -rf \
    /var/cache/apk/* \
    ~/.cache \
  && find / -name __pycache__ -type d -print0 | xargs -0 rm -r -- \
  && true

WORKDIR /work

ENTRYPOINT [ "/usr/bin/pylint" ]
