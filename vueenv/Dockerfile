FROM alpine:3
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache \
    bash \
    git \
    npm \
    python3 \
  ;

RUN set -eux; \
  npm install --global \
    '@vue/cli' \
    'yarn' \
  ; \
  # for the disk space
  npm cache clean --force;

RUN adduser -D -h /work vue
USER vue

WORKDIR /work
CMD [ "/bin/bash" ]
