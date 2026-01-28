FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --no-cache \
    "bind>=9.20" \
  ;

EXPOSE 53/tcp 53/udp

COPY named.conf /etc/bind/
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
