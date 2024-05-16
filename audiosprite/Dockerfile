FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
LABEL upstream="https://github.com/tonistiigi/audiosprite"

RUN apk add --no-cache \
    ffmpeg \
    npm \
  ;

RUN npm install -g 'audiosprite'

VOLUME /work
WORKDIR /work

ENTRYPOINT [ "/usr/local/bin/audiosprite" ]
CMD [ "--help" ]
