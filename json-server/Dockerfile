FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    npm \
  && npm install -g \
    json-server \
  && npm cache clean --force \
  && true

WORKDIR /work
ENTRYPOINT ["json-server"]
