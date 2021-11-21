FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache \
    npm \
    tini \
  && npm install -g \
    json-server \
  && npm cache clean --force \
  && true

COPY /entrypoint.sh /

WORKDIR /work
ENTRYPOINT ["/entrypoint.sh"]
