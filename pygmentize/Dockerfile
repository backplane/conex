FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    py3-pygments \
  && true

WORKDIR /work
ENTRYPOINT ["/usr/bin/pygmentize"]
CMD ["--help"]
