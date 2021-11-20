FROM golang:alpine AS builder

RUN apk add --no-cache \
    ca-certificates \
    curl \
  && true

WORKDIR /build

COPY arch.sh downloader.sh .
RUN ./downloader.sh

FROM busybox:latest
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY --from=builder /build/ghlatest /build/arch.sh /
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

WORKDIR /work

ENTRYPOINT ["/ghlatest"]
