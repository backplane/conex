FROM alpine:3
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --update-cache \
    libxml2 \
    libxslt \
    py3-pip \
    python3 \
  ; \
  apk add --update-cache --virtual build-dependencies \
    curl \
    gcc \
    libxml2-dev \
    libxslt-dev \
    musl-dev \
    python3-dev \
  ; \
  pip3 install \
    pyexcel-ods3 \
  ; \
  apk del build-dependencies; \
  rm -r \
    /var/cache/apk/* \
    ~/.cache \
  ; \
  find / -name __pycache__ -type d -print0 | xargs -0 rm -r --;

WORKDIR /work

COPY ["ods_conv.py", "/"]

ENTRYPOINT ["/ods_conv.py"]
