ARG PYTHON_VERSION=3.14
FROM ghcr.io/astral-sh/uv:python${PYTHON_VERSION}-alpine
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

ARG DATASETTE_VERSION=0.65.2
ARG SQLITE_VERSION=3.51
ARG SPATIALITE_VERSION=5.1

RUN apk add --no-cache \
    "sqlite=~${SQLITE_VERSION}" \
    "libspatialite=~${SPATIALITE_VERSION}" \
    ;

ARG UV_TOOL_DIR=/usr/local/share/uv
RUN uv tool install \
    "datasette>=${DATASETTE_VERSION}" \
    ;

ARG NONROOT_UID=65532 NONROOT_GID=65532
RUN set -eux; \
  addgroup -g "$NONROOT_GID" nonroot; \
  adduser -h /work -s /bin/sh -D -u "$NONROOT_UID" -G nonroot nonroot;
USER nonroot

EXPOSE 8001

WORKDIR /work
ENTRYPOINT [ \
    "/usr/local/bin/datasette", \
    "--load-extension=/usr/lib/mod_spatialite.so.8", \
    "--host=0.0.0.0", \
    "--port=8001" \
]
