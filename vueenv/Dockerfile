FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache \
    bash \
    git \
    npm \
    python3 \
  ;

RUN npm install --global \
    '@vue/cli' \
    'vue@next' \
    'yarn' \
  ;

RUN adduser -D -h /work vue
USER vue

WORKDIR /work
CMD [ "/bin/bash" ]
