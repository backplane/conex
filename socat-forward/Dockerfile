FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
# http://www.dest-unreach.org/socat/CHANGES

RUN adduser \
  -h /work \
  -s /bin/sh \
  -D \
  -u 65532 \
  nonroot

# hadolint ignore=DL3059
RUN apk add --no-cache \
    "socat>=1.8" \
  ;

USER nonroot
WORKDIR /work

COPY entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
