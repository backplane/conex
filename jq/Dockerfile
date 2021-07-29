FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache \
    jq \
  && true

WORKDIR /work

ENTRYPOINT [ "jq" ]
CMD ["--help"]

