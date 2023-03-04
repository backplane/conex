FROM alpine:3 as builder

RUN set -eux; \
  apk add --no-cache \
    curl \
    file \
  ;

COPY map-TARGETPLATFORM.sh /bin/map-TARGETPLATFORM
ARG TARGETPLATFORM
RUN set -eux; \
  TOYBOXARCH=$(map-TARGETPLATFORM); \
  curl -sSLO --tlsv1.3 --remote-time \
    "https://landley.net/toybox/bin/toybox-${TOYBOXARCH}"; \
  file "toybox-${TOYBOXARCH}" | grep -E 'ELF.+executable.+stripped'; \
  mv "toybox-${TOYBOXARCH}" /bin/toybox; \
  chmod +x /bin/toybox;

RUN set -eux; \
  # setup some directories under /build for the next step
  for d in etc bin sbin usr/bin usr/sbin; do mkdir -p "/build/${d}"; done; \
  # install all the symlinks toybox wants and toybox itself, both under /build
  for target in $(/bin/toybox --long); do \
    ln -s /bin/toybox "/build/${target}"; \
  done; \
  cp -p /bin/toybox /build/bin/; \
  # create a nonroot user account and install its /home directory to /build
  adduser -s /bin/sh -S -D nonroot; \
  cp -pR /home /build/; \
  # copy some useful resource from /etc to /build/
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
  # fix entries in the password file so they use what toybox provides
  sed -i 's#/sbin/nologin#/bin/false#; s#/bin/ash#/bin/sh#' /build/etc/passwd; \
  # create an /etc/os-release file
  TOYBOX_VERSION=$(toybox --version); \
  printf '%s\n' \
    "NAME=\"toybox ${TOYBOX_VERSION##* }\"" \
    'ID=toybox' \
    "VERSION_ID=${TOYBOX_VERSION##* }" \
    "PRETTY_NAME=\"toybox ${TOYBOX_VERSION##* } $(map-TARGETPLATFORM)\"" \
    'HOME_URL="https://landley.net/toybox"' \
    'BUG_REPORT_URL="https://github.com/landley/toybox/issues"' \
    | tee /build/etc/os-release;

FROM scratch
COPY --from=builder /build/. /.

CMD ["/bin/sh"]
