FROM golang:alpine AS builder

RUN apk add --no-cache \
    ca-certificates \
  && true

WORKDIR /go/src/app

RUN go install github.com/backplane/myip@latest

FROM scratch
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY --from=builder /go/bin/myip /
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

WORKDIR /work
USER 65534:65534
ENTRYPOINT ["/myip"]
