FROM golang:alpine AS builder
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    ca-certificates \
  && true

WORKDIR /go/src/app
COPY . .

RUN export CGO_ENABLED=0 GOOS=linux GOARCH=amd64; \
  go build -a -tags netgo -ldflags '-w' -v -o app *.go

FROM scratch

COPY --from=builder /go/src/app/app /
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

ENTRYPOINT ["/app"]