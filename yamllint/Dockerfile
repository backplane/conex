FROM python:3-alpine
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  pip install yamllint; \
  pip cache purge;

ARG NONROOT_UID=1000 NONROOT_GID=1000

RUN set -eux; \
  addgroup -g "$NONROOT_GID" nonroot; \
  adduser -h /work -s /bin/sh -D -u "$NONROOT_UID" -G nonroot nonroot;

USER nonroot
WORKDIR /work

ENTRYPOINT ["/usr/local/bin/yamllint"]
