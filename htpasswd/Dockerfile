FROM alpine:3
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache \
    apache2-utils \
  ;

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
  ;
USER nonroot

WORKDIR /work
VOLUME /work
ENTRYPOINT ["/usr/bin/htpasswd"]