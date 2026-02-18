FROM golang:alpine AS builder

RUN apk add --no-cache ca-certificates

WORKDIR /go/src/app

RUN go install codeberg.org/backplane/pingreporter@latest

FROM scratch
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY --from=builder /go/bin/pingreporter /
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

WORKDIR /work
USER 65534:65534
ENTRYPOINT ["/pingreporter"]
