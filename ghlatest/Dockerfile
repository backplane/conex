FROM alpine:edge as downloader
RUN set -eux; \
  apk add --no-cache \
    ca-certificates \
    curl \
  ;

WORKDIR /work

ARG TARGETARCH
RUN set -eux; \
  case "$TARGETARCH" in \
    arm/v7) \
      ARCH="arm"; \
      ;; \
    *) \
      ARCH="$TARGETARCH"; \
     ;; \
  esac; \
  BASE_URL="https://github.com/backplane/ghlatest"; \
  LATEST_URL=$(curl -sS -w "%{redirect_url}\n" "${BASE_URL}/releases/latest"); \
  LATEST_TAG="${LATEST_URL##*/v}"; \
  DL_URL="${BASE_URL}/releases/download/v${LATEST_TAG}/ghlatest_${LATEST_TAG}_linux_${ARCH}.tar.gz"; \
  TAR="ghlatest.tgz"; \
  curl -sSL -o "$TAR" "$DL_URL"; \
  tar -xvzf "$TAR" ghlatest; \
  rm -- "$TAR";


FROM alpine:3 AS alpine
RUN apk add --no-cache \
    ca-certificates \
  ;

FROM busybox:musl
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY shortarch.sh /bin/shortarch
COPY --from=downloader /work/ghlatest /bin/
COPY --from=alpine /etc/ssl/certs /etc/ssl/certs

USER 65534:65534
WORKDIR /work
ENTRYPOINT ["/bin/ghlatest"]
