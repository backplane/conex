FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    bash \
    git \
    npm \
  && true

RUN npm install --global \
    '@vue/cli' \
  && true

RUN adduser -D -h /work vue
USER vue

WORKDIR /work
CMD [ "/bin/bash" ]
