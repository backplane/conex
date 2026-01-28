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
    curl \
    file \
    iproute2 \
    iputils-ping \
    jq \
    mtr \
    nano \
    neovim \
    net-tools \
    netcat-traditional \
    openssl \
    p7zip \
    python3-charset-normalizer \
    ripgrep \
    rsync \
    socat \
    tmux \
    traceroute \
    unzip \
    yq \
  ; \
  $AG autoremove; \
  $AG clean; \
  rm -rf /var/lib/apt/lists/*;

# "alias" chardet to normalizer in a way that reminds the user what's happening
COPY chardet.sh /bin/chardet

WORKDIR /work
ENTRYPOINT [ "/bin/bash" ]
