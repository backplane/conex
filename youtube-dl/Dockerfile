FROM ghcr.io/astral-sh/uv:alpine
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --no-cache \
    'curl>=8.17' \
    'ffmpeg>=6' \
  ;

ARG YTDLP_VERSION=2026
ARG UV_TOOL_DIR=/usr/local/share/uv/bin
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

RUN set -eux; \
  INSTALLER="${HOME}/install.sh"; \
  curl -fsSL -o "$INSTALLER" 'https://deno.land/install.sh'; \
  /bin/sh "$INSTALLER";

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/nonroot/.deno/bin"

ENTRYPOINT [ "/usr/local/bin/yt-dlp" ]
