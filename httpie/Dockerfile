FROM python:3-alpine
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  pip3 --no-cache-dir install \
    httpie \
  ; \
  pip cache purge

WORKDIR /work

ENTRYPOINT ["/usr/bin/http"]
CMD ["--help"]
