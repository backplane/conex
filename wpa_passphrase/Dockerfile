FROM alpine:edge as builder

RUN apk add --no-cache \
    wpa_supplicant \
  && true

FROM scratch
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY --from=builder /lib/ld-musl-*.so.1 /lib/libcrypto.so.* /lib/
COPY --from=builder /sbin/wpa_passphrase /sbin/

WORKDIR /work

ENTRYPOINT [ "/sbin/wpa_passphrase" ]
