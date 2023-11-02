FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -x \
  && apk add --no-cache \
    bash \
    cabal \
    ghc \
    git \
    make \
    musl-dev \
  && true

WORKDIR /work
CMD ["/bin/bash"]