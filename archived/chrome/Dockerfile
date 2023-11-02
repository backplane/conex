FROM debian:unstable-slim
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY ["arch.sh", "/bin/"]

# Install chrome
RUN set -eux; \
  export \
    AG="apt-get -yq" \
    DEBIAN_FRONTEND=noninteractive \
  ; \
  $AG update; \
  $AG upgrade; \
  $AG install --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    fonts-symbola \
    gnupg \
    hicolor-icon-theme \
    libcanberra-gtk* \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    # libpangox-1.0-0 \
    libpulse0 \
    libv4l-0 \
    wget \
  ; \
  wget -q -O - \
    "https://dl.google.com/linux/linux_signing_key.pub" \
    | apt-key add -; \
  printf "deb [arch=%s] %s stable main" \
    "$(/bin/arch.sh)" \
    "https://dl.google.com/linux/chrome/deb/" \
    > /etc/apt/sources.list.d/google.list; \
  $AG update; \
  $AG install --no-install-recommends \
    google-chrome-stable \
  ; \
  $AG clean; \
  $AG purge --auto-remove \
    gnupg \
  ; \
  rm -rf /var/lib/apt/lists/*

# Install fontconfig
COPY ["fonts.conf", "/etc/fonts/local.conf"]

# Add non-privileged user
RUN set -eux; \
  groupadd -r user; \
  useradd --no-log-init -r -g user -G audio,video user; \
  mkdir -p /home/user/Downloads; \
  chown -R user:user /home/user;

# Create the data directory so named/managed volumes get the right permissions
RUN set -eux; \
  mkdir /data; \
  chown user:user /data;

# Run as non-privileged user
USER user

# Run chrome
COPY ["entrypoint.sh", "/"]
ENTRYPOINT [ "/entrypoint.sh" ]
