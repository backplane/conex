FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache \
    fd \
    fzf \
    ripgrep \
  ;

ARG NONROOT_GID=65532
ARG NONROOT_UID=65532
RUN set -eux; \
  addgroup \
    -g "${NONROOT_GID}" \
    nonroot \
  ; \
  adduser \
    -h /work \
    -u "${NONROOT_UID}" \
    -G nonroot \
    -D \
    nonroot \
  ;
USER nonroot

WORKDIR /work

ENTRYPOINT [ "/usr/bin/fzf" ]
