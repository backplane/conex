FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -x \
  && apk add --no-cache \
    poppler-utils \
  && true

RUN adduser \
  -h /work \
  -s /bin/sh \
  -D \
  -u 1000 \
  user

COPY ["entrypoint.sh", "/"]

USER user

WORKDIR /work
ENTRYPOINT ["/entrypoint.sh"]