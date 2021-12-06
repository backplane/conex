FROM debian:unstable-slim
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY ["arch.sh", "/bin/"]

# Install chromium
RUN set -eux; \
  export \
    AG="apt-get -yq" \
    DEBIAN_FRONTEND=noninteractive \
  ; \
  $AG update; \
  $AG upgrade; \
  $AG install --no-install-recommends \
    ca-certificates \
    chromium \
    chromium-l10n \
    chromium-sandbox \
    fonts-liberation \
    fonts-roboto \
    fonts-symbola \
    hicolor-icon-theme \
    libgtk-4-1 \
  ; \
  $AG autoremove; \
  $AG clean; \
  rm -rf \
    /var/cache/debconf/*-old \
    /var/lib/apt/lists/* \
    /var/lib/dpkg/*-old \
  ;

# Install fontconfig
COPY ["fonts.conf", "/etc/fonts/local.conf"]

# Add non-privileged user and create a data directory so named/managed volumes
# get the right permissions
RUN set -eux; \
  groupadd -r user; \
  useradd --no-log-init -r -g user -G audio,video user; \
  mkdir -p /home/user/Downloads; \
  chown -R user:user /home/user; \
  mkdir /data; \
  chown user:user /data;

# Run as non-privileged user
USER user

# Run chromium
COPY ["entrypoint.sh", "/"]
ENTRYPOINT [ "/entrypoint.sh" ]
