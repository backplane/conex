FROM debian:unstable-slim
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
LABEL upstream="<https://github.com/jessfraz/dockerfiles/tree/master/firefox>"

# one of the names under /usr/share/i18n/SUPPORTED (e.g. es_MX or nl_BE)
ENV LANG=en_US.UTF-8

# one oe of the names under /usr/share/i18n/charmaps (e.g. ISO-8859-16)
ARG CHARSET=UTF-8

# Install Firefox
RUN set -x \
  && AG="env DEBIAN_FRONTEND=noninteractive apt-get -yq" \
  && $AG update \
  && $AG upgrade \
  && $AG install --no-install-recommends \
    ca-certificates \
    firefox \
    fonts-noto \
    fonts-noto-cjk \
    fonts-noto-color-emoji \
    fonts-symbola \
    hicolor-icon-theme \
    libasound2 \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpulse0 \
    locales \
  && rm -rf /var/lib/apt/lists/*

# Update locale
RUN set -x \
  && printf '%s %s\n' "$LANG" "$CHARSET" | tee /etc/locale.gen \
  && locale-gen \
  && /usr/sbin/update-locale

# Install fontconfig
COPY ["fonts.conf", "/etc/fonts/local.conf"]

# Firefox prefs
RUN printf '%s\n' \
  'pref("browser.tabs.remote.autostart", false);' \
  >>/etc/firefox/syspref.js

# Add non-privileged user
RUN set -x \
  && groupadd -r user \
  && useradd --no-log-init -r -g user -G audio,video user \
  && mkdir -p /home/user/Downloads \
  && chown -R user:user /home/user

# Create the data directory so named/managed volumes get the right permissions
RUN set -x \
  && mkdir /data \
  && chown user:user /data

# Run as non-privileged user
USER user

# Run firefox
COPY ["entrypoint.sh", "/"]
ENTRYPOINT [ "/entrypoint.sh" ]
