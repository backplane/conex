FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    jq \
  && true

WORKDIR /work

ENTRYPOINT [ "jq" ]
CMD ["--help"]

