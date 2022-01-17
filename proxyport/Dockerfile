FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --no-cache \
    curl \
    haproxy \
    tini \
  ;

COPY ["haproxy.cfg.tmpl", "/etc/haproxy/"]
COPY ["entrypoint.sh", "/"]

ARG NONROOT_GID=65532
ARG NONROOT_UID=65532
RUN set -ex; \
  addgroup \
    -g ${NONROOT_GID} \
    nonroot \
  ; \
  adduser \
    -h /work \
    -u ${NONROOT_UID} \
    -G nonroot \
    -D \
    nonroot \
  ; \
  mkdir /config; \
  chown nonroot:nonroot \
    /config \
    /etc/haproxy \
  ;
USER nonroot
WORKDIR /work
VOLUME /config

ENTRYPOINT ["/entrypoint.sh"]
