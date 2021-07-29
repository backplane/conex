FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
LABEL upstream="https://github.com/tonistiigi/audiosprite"

RUN apk add --no-cache \
    ffmpeg \
    npm \
  && true

RUN npm install -g 'audiosprite@^0.7.2'

VOLUME /work
WORKDIR /work

ENTRYPOINT [ "/usr/bin/audiosprite" ]
CMD [ "--help" ]
