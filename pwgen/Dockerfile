FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    pwgen \
  && true

ENTRYPOINT [ "/usr/bin/pwgen" ]

