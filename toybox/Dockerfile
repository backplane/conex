FROM alpine:edge as builder

RUN set -eux; \
  apk add --no-cache \
    curl \
  ;

COPY map-TARGETARCH.sh /bin/map-TARGETARCH
ARG TARGETARCH
RUN set -eux; \
  TOYBOXARCH=$(map-TARGETARCH); \
  curl -sSLO \
    --tlsv1.3 \
    --remote-time \
    "https://landley.net/toybox/bin/toybox-${TOYBOXARCH}"; \
  mv "toybox-${TOYBOXARCH}" /bin/toybox; \
  chmod +x /bin/toybox;

RUN set -eux; \
  TOYBOX_VERSION=$(toybox --version); \
  for target in $(/bin/toybox --long); do \
    dir=$(dirname "${target}"); \
    mkdir -p "/build/${dir}"; \
    ln -s /bin/toybox "/build/${target}"; \
  done; \
  mkdir -p /build/etc; \
  cp -p /bin/toybox /build/bin/; \
  adduser -s /bin/sh -S -D nonroot; \
  cp -pR \
    /etc/ca-certificates.conf \
    /etc/ca-certificates/ \
    /etc/ssl/ \
    /etc/ssl*.*/ \
    /etc/passwd \
    /etc/shadow \
    /etc/group \
    /etc/profile \
    /etc/profile.d \
    /build/etc/ \
  ; \
  cp -pR \
    /home \
    /build/ \
  ; \
  sed -i 's#/sbin/nologin#/bin/false#; s#/bin/ash#/bin/sh#' /etc/passwd; \
  printf '%s\n' \
    'NAME=toybox' \
    'ID=toybox' \
    "VERSION_ID=${TOYBOX_VERSION##* }" \
    "PRETTY_NAME=\"toybox ${TOYBOX_VERSION##* }\"" \
    'HOME_URL="https://landley.net/toybox"' \
    'BUG_REPORT_URL="https://github.com/landley/toybox/issues"' \
    | tee /build/etc/os-release;

FROM scratch
COPY --from=builder /build/. /.

CMD ["/bin/sh"]
