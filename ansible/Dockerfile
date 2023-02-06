FROM alpine:3
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY ["requirements.txt", "entrypoint.sh", "/"]

RUN set -ex; \
  apk add --update-cache \
    openssh-client \
    py3-pip \
    python3 \
  ; \
  apk add --virtual build-dependencies \
    gcc \
    libffi-dev \
    musl-dev \
    python3-dev \
    rust \
    cargo \
  ; \
  pip install -r requirements.txt; \
  pip cache purge; \
  apk del build-dependencies; \
  rm -rf \
    /tmp/* \
    /var/cache/apk \
    ~/.cache \
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

ENTRYPOINT ["/entrypoint.sh"]
