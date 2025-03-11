ARG RELEASE=latest
FROM fedora:${RELEASE}
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

ARG DNF="dnf -y -q --setopt=install_weak_deps=False"
RUN set -eux; \
  $DNF update; \
  $DNF install @server-product-environment; \
  $DNF clean all; \
  rm -rf /var/cache/dnf;

