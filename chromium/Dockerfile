FROM debian:unstable-slim
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

# Install chromium
ARG AG="apt-get -yq --no-install-recommends"
ARG DEBIAN_FRONTEND="noninteractive"

RUN set -eux; \
  $AG update; \
  $AG upgrade; \
  $AG install  \
    ca-certificates \
    chromium \
    chromium-l10n \
    chromium-sandbox \
    fonts-liberation \
    fonts-roboto \
    fonts-symbola \
    hicolor-icon-theme \
    libgtk-4-1 \
    xauth \
  ; \
  $AG autoremove; \
  $AG clean; \
  rm -rf \
    /var/cache/debconf/*-old \
    /var/lib/apt/lists/* \
    /var/lib/dpkg/*-old \
  ;

# Install fontconfig
COPY [ "fonts.conf", "/etc/fonts/local.conf" ]

# Add non-privileged user and create a data directory so named/managed volumes
# get the right permissions
RUN set -eux; \
  groupadd -r user; \
  useradd --no-log-init --system --create-home -g user -G audio,video user; \
  mkdir -p ~user/Downloads; \
  chown -R user:user ~user; \
  mkdir /data; \
  chown user:user /data;

WORKDIR /home/user

# Last call for root-permissions
COPY [ "entrypoint.sh", "chromium_ssb.sh", "/" ]

# Run as non-privileged user
USER user

# Run chromium
ENTRYPOINT [ "/entrypoint.sh" ]
