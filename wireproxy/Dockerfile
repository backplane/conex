FROM golang:1 AS builder

WORKDIR /build

# Shallow-clone the repo to fetch tags only
ARG REPO_URL=https://github.com/whyvl/wireproxy.git
RUN set -eux; \
  git init; \
  git remote add origin $REPO_URL; \
  git fetch --depth=1 origin "+refs/tags/*:refs/tags/*";

# Checkout the newest semantic version tag
RUN set -eux; \
  TAG=$(git tag --sort=-v:refname | grep -P '^v?\d+\.\d+\.\d+$' | head -n 1); \
  [ -n "$TAG" ] || { echo "NO MATCHING TAGS" >&2; exit 1; }; \
  echo "SELECTED TAG: ${TAG}"; \
  git fetch --depth=1 origin "$TAG"; \
  git checkout "$TAG";

RUN make
RUN set -eux; \
  mkdir -p etc_files; \
  cd etc_files; \
  printf '%s\n' \
    'root:x:0:0::/:/bin/sh' \
    'nonroot:x:65532:65532::/tmp:/wireproxy' \
    >passwd; \
  printf '%s\n' \
    "root:x:0:" \
    "nonroot:x:65532:" \
    >group;

FROM scratch
LABEL org.opencontainers.image.licenses="ISC"

COPY --from=builder /etc/ssl /etc/ssl/
COPY --from=builder /build/wireproxy /wireproxy
COPY --from=builder /build/etc_files/* /etc/
USER nonroot:nonroot

VOLUME [ "/etc/wireproxy"]

ENTRYPOINT [ "/wireproxy" ]
CMD [ "--config", "/etc/wireproxy/config" ]
