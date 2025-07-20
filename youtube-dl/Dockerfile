FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --no-cache \
    ffmpeg \
    yt-dlp \
  ; \
  find / -name '__pycache__' -type d -print0 | xargs -0 rm -rf --

WORKDIR /work

ENTRYPOINT [ "/usr/bin/youtube-dl" ]
