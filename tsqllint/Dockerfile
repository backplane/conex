FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -x \
  && apk add --no-cache \
    gcompat \
    icu \
    libunwind \
    libuuid \
    musl-dev \
    npm \
  && true

# this node package has strange "npm install -g" behavior when running as root
ENV NPM_CONFIG_PREFIX="/npm" \
  PATH="/npm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN set -x \
  && adduser -D -h /work user \
  && mkdir -p -- "$NPM_CONFIG_PREFIX" \
  && chown -R user:user -- "$NPM_CONFIG_PREFIX"
USER user

RUN npm install -g tsqllint || sh -c "cat ${NPM_CONFIG_PREFIX}/_logs/*; false"

WORKDIR /work

ENTRYPOINT ["/npm/bin/tsqllint"]
