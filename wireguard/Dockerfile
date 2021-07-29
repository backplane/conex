FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache \
    wireguard-tools \
  && true

WORKDIR /work

ENTRYPOINT [ "/usr/bin/wg" ]
