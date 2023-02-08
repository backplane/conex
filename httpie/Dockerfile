FROM alpine:3
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --no-cache \
    python3 \
    py3-pip \
  ; \
  pip3 --no-cache-dir install \
    httpie \
  ;

WORKDIR /work

ENTRYPOINT ["/usr/bin/http"]
CMD ["--help"]
