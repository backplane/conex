FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache p7zip

WORKDIR /work

ENTRYPOINT [ "/usr/bin/7z" ]
