FROM alpine:3.12 AS builder
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache \
    libqrencode \
  && true

WORKDIR /work

ENTRYPOINT [ "/usr/bin/qrencode" ]
