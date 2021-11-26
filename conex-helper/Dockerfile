FROM python:3-alpine
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY requirements.txt /

RUN set -eux; \
  pip install -r /requirements.txt; \
  pip cache purge;

COPY app /app/

WORKDIR /work

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

ENTRYPOINT ["/app/main.py"]