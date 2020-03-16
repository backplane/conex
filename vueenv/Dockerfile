FROM alpine:edge
LABEL maintainer="glvnst <glvnst@users.noreply.github.com>"
LABEL repo="https://github.com/glvnst/vueenv/"

RUN apk add --no-cache \
    bash \
    npm \
  && true

#RUN npm install --global \
#    '@vue/cli' \
#  && true

WORKDIR /app
CMD [ "/bin/bash" ]
