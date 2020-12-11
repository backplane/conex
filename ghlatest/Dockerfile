FROM golang:alpine AS builder

RUN apk add --no-cache \
    ca-certificates \
    git \
  && true

ARG SRC_REPO="https://github.com/glvnst/ghlatest.git"
ARG SRC_REF="v0.1.4"
RUN set -ex \
  && git clone "$SRC_REPO" "/build" \
  && if [ -n "$SRC_REF" ]; then \
    cd /build \
    && git checkout "$SRC_REF" \
  ; fi

WORKDIR /build

RUN set -ex \
  && export \
    CGO_ENABLED=0 \
    GOOS=linux \
  && go build -a -tags netgo -ldflags '-w' -v -o app

FROM scratch
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

COPY --from=builder /build/app /
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

WORKDIR /work

ENTRYPOINT ["/app"]