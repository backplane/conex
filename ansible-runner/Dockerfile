FROM python:3-alpine
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY ["requirements.txt", "/"]

RUN set -ex; \
  apk add --update-cache \
    libffi \
    openssh-client \
  ; \
  apk add --virtual build-dependencies \
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
    /var/cache/apk \
    ~/.cache \
  ;
  # this reduces the image size but makes container startup slow
  #find / -name '__pycache__' -print0 \
  #  | xargs -0 rm -rf --

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

ENTRYPOINT ["/usr/local/bin/ansible-runner"]
