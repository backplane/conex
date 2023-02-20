FROM golang:alpine AS builder

RUN apk add --no-cache \
    ca-certificates \
  ;

RUN go install github.com/backplane/ghlatest@v0.3

FROM busybox:musl
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY shortarch.sh /bin/shortarch
COPY --from=builder /go/bin/ghlatest /bin/
COPY --from=builder /etc/ssl/certs /etc/ssl/certs

USER 65534:65534
WORKDIR /work
CMD ["ghlatest"]
