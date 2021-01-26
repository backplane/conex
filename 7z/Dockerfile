FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN set -x \
  && apk add --no-cache \
    p7zip \
  && true

WORKDIR /work

ENTRYPOINT [ "/usr/bin/7z" ]
