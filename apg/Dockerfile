FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    apg \
  && true

WORKDIR /work

ENTRYPOINT [ "/usr/bin/apg" ]
