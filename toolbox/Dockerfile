FROM ubuntu:latest

ARG AG="apt-get -yq --no-install-recommends"
ARG DEBIAN_FRONTEND=noninteractive
RUN set -eux; \
  $AG update; \
  $AG upgrade; \
  $AG install \
    bash \
    bind9-dnsutils \
    curl \
    iproute2 \
    iputils-ping \
    nano \
    neovim \
    net-tools \
    netcat-traditional \
    p7zip \
    ripgrep \
    tmux \
    traceroute \
    unzip \
  ; \
  $AG autoremove; \
  $AG clean; \
  rm -rf /var/lib/apt/lists/*;

WORKDIR /work
ENTRYPOINT [ "/bin/bash" ]