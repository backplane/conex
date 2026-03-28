FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --no-cache \
    'curl>=8.19' \
    'deno>=2.7' \
    'ffmpeg>=8.1' \
  ;

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

ARG YTDLP_VERSION=2026
ARG UV_TOOL_DIR=/usr/local/share/uv/bin
ARG UV_TOOL_BIN_DIR=/usr/local/bin
ARG UV_PYTHON_INSTALL_DIR=usr/local/share/uv
RUN set -eux; \
  uv tool install "yt-dlp[default,curl-cffi]>=${YTDLP_VERSION}"; \
  /usr/local/bin/yt-dlp --version;

ARG NONROOT_UID=65532 NONROOT_GID=65532
RUN set -eux; \
  addgroup -g "$NONROOT_GID" nonroot; \
  adduser -h /home/nonroot -s /bin/sh -D -u "$NONROOT_UID" -G nonroot nonroot;
USER nonroot
WORKDIR /work

ENTRYPOINT [ "/usr/local/bin/yt-dlp" ]
