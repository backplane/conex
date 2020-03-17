FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"
LABEL upstream="https://github.com/tonistiigi/audiosprite"

RUN apk add --no-cache \
    ffmpeg \
    npm \
  && true

RUN npm install -g audiosprite

VOLUME /data
WORKDIR /data
ENTRYPOINT [ "audiosprite" ]
CMD [ "--help" ]
