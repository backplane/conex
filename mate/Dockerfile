FROM debian:stable-slim
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

# one of the names under /usr/share/i18n/SUPPORTED (e.g. es_MX or nl_BE)
ENV LANG=en_US.UTF-8

# one oe of the names under /usr/share/i18n/charmaps (e.g. ISO-8859-16)
ARG CHARSET=UTF-8
ARG AG="apt-get -yq --no-install-recommends"
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
  $AG update; \
  $AG upgrade; \
  $AG install \
    apt-transport-https \
    busybox \
    bzip2 \
    ca-certificates \
    curl \
    fonts-anonymous-pro \
    fonts-droid-fallback \
    fonts-hack \
    fonts-inconsolata \
    fonts-monoid \
    fonts-roboto \
    fonts-symbola \
    git \
    iproute2 \
    iputils-ping \
    less \
    locales \
    make \
    mate-desktop-environment \
    nano \
    netbase \
    netcat-openbsd \
    sudo \
    tigervnc-common \
    tigervnc-standalone-server \
    tigervnc-tools \
    traceroute \
    unzip \
    vim \
    x11-xserver-utils \
  ; \
  $AG autoremove; \
  $AG clean; \
  rm -rf \
    /var/cache/debconf/*-old \
    /var/lib/apt/lists/* \
    /var/lib/dpkg/*-old \
  ; \
  busybox --install;

RUN set -eux; \
  printf '%s %s\n' "$LANG" "$CHARSET" | tee /etc/locale.gen; \
  locale-gen; \
  /usr/sbin/update-locale;

RUN set -eux; \
  useradd \
    --no-log-init \
    --base-dir / \
    --home-dir "/work" \
    --create-home \
    --no-user-group \
    --groups sudo,adm \
    --shell "/bin/bash" \
    --uid "65532" \
    user \
  ; \
  passwd \
    --delete \
    --expire \
    user \
  ;

# do this before dropping privs
COPY ["entrypoint.sh", "/"]

USER user

WORKDIR /work
ENTRYPOINT ["/entrypoint.sh"]
