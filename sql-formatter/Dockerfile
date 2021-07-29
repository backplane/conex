FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -x \
  && apk add --no-cache \
    nodejs \
    npm \
  && npm install -g sql-formatter \
  && apk del \
    npm \
  && true

RUN set -x \
  && adduser -D -h /work user
USER user

WORKDIR /work

ENTRYPOINT ["sql-formatter"]
