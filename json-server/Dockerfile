FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache \
    npm \
  && npm install -g \
    json-server \
  && npm cache clean --force \
  && true

WORKDIR /work
ENTRYPOINT ["json-server"]
