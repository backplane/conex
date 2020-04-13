FROM alpine:edge as builder

RUN apk add --no-cache \
    wpa_supplicant \
  && true

FROM scratch
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

COPY --from=builder /lib/ld-musl-x86_64.so.1 /lib/libcrypto.so.1.1 /lib/
COPY --from=builder /sbin/wpa_passphrase /sbin/

ENTRYPOINT [ "/sbin/wpa_passphrase" ]
