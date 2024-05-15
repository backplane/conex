FROM debian:unstable-slim
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

# one of the names under /usr/share/i18n/SUPPORTED (e.g. es_MX or nl_BE)
ENV LANG=en_US.UTF-8

# one oe of the names under /usr/share/i18n/charmaps (e.g. ISO-8859-16)
ARG CHARSET=UTF-8
ARG AG="apt-get -yq --no-install-recommends"
ARG DEBIAN_FRONTEND=noninteractive

# Install Firefox
RUN set -eux; \
  $AG update; \
  $AG upgrade; \
  $AG install --no-install-recommends \
    ca-certificates \
    firefox \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    fonts-symbola \
    hicolor-icon-theme \
    libgl1 \
    libglx-mesa0 \
    libpulse0 \
    locales \
  ; \
  $AG clean; \
  $AG autoremove; \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    ~/.cache \
  ;


# Update locale
RUN set -eux; \
  printf '%s %s\n' "$LANG" "$CHARSET" | tee /etc/locale.gen; \
  locale-gen; \
  /usr/sbin/update-locale;

# Install fontconfig
COPY ["fonts.conf", "/etc/fonts/local.conf"]

# Firefox prefs
RUN printf '%s\n' \
  'pref("browser.tabs.remote.autostart", false);' \
  >>/etc/firefox/syspref.js

# Add non-privileged user
RUN set -eux; \
  groupadd -r user; \
  useradd --no-log-init -r -g user -G audio,video user; \
  mkdir -p /home/user/Downloads; \
  chown -R user:user /home/user;

# Create the data directory so named/managed volumes get the right permissions
RUN set -eux; \
  mkdir /data; \
  chown user:user /data

# Run as non-privileged user
USER user

# Run firefox
COPY ["entrypoint.sh", "/"]
ENTRYPOINT [ "/entrypoint.sh" ]
