FROM debian:stable-slim
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

# one of the names under /usr/share/i18n/SUPPORTED (e.g. es_MX or nl_BE)
ENV LANG=en_US.UTF-8

# one oe of the names under /usr/share/i18n/charmaps (e.g. ISO-8859-16)
ARG CHARSET=UTF-8

RUN set -x \
  && AG="env DEBIAN_FRONTEND=noninteractive apt-get -yq" \
  && $AG update \
  && $AG upgrade \
  && $AG install --no-install-recommends \
    apt-transport-https \
    bash \
    busybox \
    bzip2 \
    ca-certificates \
    curl \
    fonts-droid-fallback \
    fonts-hack \
    fonts-inconsolata \
    fonts-monoid \
    fonts-noto \
    fonts-roboto \
    fonts-symbola \
    git \
    iproute2 \
    iputils-ping \
    less \
    locales \
    lxde \
    make \
    nano \
    netbase \
    netcat \
    sudo \
    tigervnc-common \
    tigervnc-standalone-server \
    traceroute \
    ttf-anonymous-pro \
    unzip \
    vim \
    x11-xserver-utils \
  && rm -rf /var/lib/apt/lists/*

RUN set -x \
  && printf '%s %s\n' "$LANG" "$CHARSET" | tee /etc/locale.gen \
  && locale-gen \
  && /usr/sbin/update-locale

RUN set -eux \
  && useradd \
    --base-dir / \
    --home-dir "/work" \
    --create-home \
    --no-user-group \
    --groups sudo,adm \
    --shell "/bin/bash" \
    --uid "1111" \
    user \
  && passwd \
    --delete \
    --expire \
    user

# do this before dropping privs
COPY ["entrypoint.sh", "/"]

USER user
WORKDIR /work

ENTRYPOINT ["/entrypoint.sh"]
