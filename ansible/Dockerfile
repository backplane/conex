FROM alpine:3
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY ["requirements.txt", "entrypoint.sh", "/"]

RUN set -ex; \
  apk add --update-cache \
    ansible \
    openssh-client \
    py3-pip \
  ; \
  pip install -r requirements.txt; \
  pip cache purge; \
  rm -rf \
    /tmp/* \
    /var/cache/apk \
    ~/.cache \
  ;

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
USER nonroot
WORKDIR /work

ENTRYPOINT ["/entrypoint.sh"]
