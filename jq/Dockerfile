FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache jq;

WORKDIR /work

USER nobody
ENTRYPOINT [ "/usr/bin/jq" ]
CMD ["--help"]

