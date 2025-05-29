FROM ubuntu:latest

ARG AG="apt-get -yq --no-install-recommends"
ARG DEBIAN_FRONTEND=noninteractive
RUN set -eux; \
  $AG update; \
  $AG upgrade; \
  $AG install \
    age \
    bash \
    bind9-dnsutils \
    ca-certificates \
    chardet \
    curl \
    file \
    iproute2 \
    iputils-ping \
    mtr \
    nano \
    neovim \
    net-tools \
    netcat-traditional \
    openssl \
    p7zip \
    ripgrep \
    rsync \
    socat \
    tmux \
    traceroute \
    unzip \
  ; \
  $AG autoremove; \
  $AG clean; \
  rm -rf /var/lib/apt/lists/*;

WORKDIR /work
ENTRYPOINT [ "/bin/bash" ]
