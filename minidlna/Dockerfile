FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -x \
  && apk add --no-cache \
    gettext \
    minidlna \
  && true

COPY entrypoint.sh /
COPY minidlna.conf.tmpl /etc/

ARG NONROOT_GID=20000
ARG NONROOT_UID=20000
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
  ;

RUN set -ex; \
  mkdir /data /db; \
  chown 'nonroot:nonroot' /data /db
VOLUME /data /db
USER nonroot

ENTRYPOINT ["/entrypoint.sh"]
