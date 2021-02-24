FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    bash \
    ca-certificates \
    git \
    go \
    make \
    nano \
    vim \
  && true

RUN set -eux \
  && adduser \
    -h "/home/user" \
    -s "/bin/bash" \
    -u "1111" \
    -D \
    user
USER user

ENV PATH="/home/user/go/bin:$PATH"

# https://staticcheck.io/docs
# https://github.com/golang/lint
RUN set -eux \
  && go get -u golang.org/x/lint/golint \
  && go get -u honnef.co/go/tools/...

WORKDIR /home/user/go/src/local
