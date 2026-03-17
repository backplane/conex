FROM alpine:3.23
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache \
    bash \
    ca-certificates \
    cargo \
    curl \
    deno \
    docker-cli \
    docker-cli-compose \
    gcc \
    git \
    go \
    gpg \
    jq \
    libgcc \
    libstdc++ \
    libxml2-utils \
    musl \
    openssh-client \
    patch \
    perl \
    pnpm \
    rage \
    ripgrep \
    rsync \
    shellcheck \
    uv \
    yq-go \
    zstd \
  ;

# get the first stage installer script, make some light edits
ARG INSTALLER=/var/claude-install.sh
RUN set -eux; \
  curl -fsSL -o "${INSTALLER}" https://claude.ai/install.sh; \
  chmod a=r "${INSTALLER}"; \
  perl -i \
    -e 's/^set -e$/set -ex/;' \
    -e 's/^(\s*rm -f) /\1 -v /;' \
    "${INSTALLER}";

# create a non-root user
ARG NONROOT_GID=65532
ARG NONROOT_UID=65532
ARG NONROOT_HOME="/home/nonroot"
ARG NONROOT_SKEL="/.nonroot_skeleton"

RUN set -eux; \
  addgroup -g "${NONROOT_GID}"    nonroot; \
  adduser  -u "${NONROOT_UID}" -G nonroot \
    -s "/bin/bash" \
    -h "${NONROOT_HOME}" \
    -D \
    nonroot; \
  for d in \
    "/work" \
    "${NONROOT_HOME}/.claude" \
    "${NONROOT_SKEL}" \
  ; do \
    mkdir -m "0770" -p "$d"; \
    chown "nonroot:nonroot" "$d"; \
  done;
USER nonroot
WORKDIR /work

# add ~nonroot/.local/bin to the search path
ENV PATH="${NONROOT_HOME}/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

# install claude (as non-root)
ARG INSTALL_LOG="${NONROOT_HOME}/.claude-install-log.txt"
RUN set -eux; \
  bash "$INSTALLER" 2>&1 | tee "$INSTALL_LOG"; \
  gzip -9 "$INSTALL_LOG";

  
# see https://code.claude.com/docs/en/memory#claude-md-files
# this one advises about the tools that are locally installed
COPY --chown=nonroot:nonroot skel-CLAUDE.md "${NONROOT_HOME}/.claude/CLAUDE.md"

# copy (via hard link) the nonroot homedir to a skeleton dir, so that if a volume
# is placed over the nonroot homedir, that volume gets a copy of the contents of
# the skeleton
RUN cp -al "${NONROOT_HOME}/." "${NONROOT_SKEL}/";

COPY --chown=root:root entrypoint.sh /
ENTRYPOINT [ "/entrypoint.sh" ]
