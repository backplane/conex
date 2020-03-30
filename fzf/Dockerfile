FROM alpine:edge

FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    fzf \
  && true

WORKDIR /work

ENTRYPOINT [ "/usr/bin/fzf" ]
