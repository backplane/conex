FROM alpine:edge
LABEL maintainer="glvnst <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    bash \
    npm \
  && true

RUN npm install --global \
    '@vue/cli' \
  && true

RUN adduser -D -h /work vue
USER vue

WORKDIR /work
CMD [ "/bin/bash" ]
