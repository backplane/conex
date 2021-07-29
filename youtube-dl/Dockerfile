FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -x \
  && apk add --no-cache \
    ffmpeg \
    youtube-dl \
  && find / -name '__pycache__' -type d -print0 | xargs -0 rm -rf --

WORKDIR /work

ENTRYPOINT [ "/usr/bin/youtube-dl" ]
