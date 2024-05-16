FROM python:3-alpine
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY ["requirements.txt", "/"]

RUN set -ex; \
  apk add --update-cache \
    openssh-client \
  ; \
  apk add --virtual build-dependencies \
    cargo \
    gcc \
    libffi-dev \
    musl-dev \
    python3-dev \
    rust \
  ; \
  pip install -r requirements.txt; \
  pip cache purge; \
  apk del build-dependencies; \
  rm -rf \
    /tmp/* \
    /usr/bin/__pycache__ \
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
