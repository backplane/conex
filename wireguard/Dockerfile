FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    wireguard-tools \
  && true

ENTRYPOINT [ "/usr/bin/wg" ]

