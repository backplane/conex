FROM golang:alpine AS builder

RUN apk add --no-cache \
    ca-certificates \
    curl \
  && true

WORKDIR /build

ARG GHLATEST_VERSION="0.1.4"
RUN set -ex \
  && curl \
    --location \
    --show-error \
    --silent \
    --ssl-reqd \
    --tlsv1.2 \
    --output "archive.tgz" \
    "https://github.com/glvnst/ghlatest/releases/download/v${GHLATEST_VERSION}/ghlatest_${GHLATEST_VERSION}_linux_amd64.tar.gz" \
  && tar -xvzf "archive.tgz" \
  && find .

FROM busybox:latest
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

COPY --from=builder /build/ghlatest /
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

WORKDIR /work

ENTRYPOINT ["/ghlatest"]
