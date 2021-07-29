FROM golang:alpine AS builder

RUN apk add --no-cache \
    ca-certificates \
  && true

WORKDIR /go/src/app
COPY . .

RUN export CGO_ENABLED=0 GOOS=linux GOARCH=amd64; \
  go build -a -tags netgo -ldflags '-w' -v -o app *.go

FROM scratch
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY --from=builder /go/src/app/app /
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

WORKDIR /work

ENTRYPOINT ["/app"]
