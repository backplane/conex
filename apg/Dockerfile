FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache \
    apg \
  && true

WORKDIR /work

ENTRYPOINT [ "/usr/bin/apg" ]
