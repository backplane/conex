FROM debian:unstable-slim
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
LABEL upstream="<https://github.com/jessfraz/dockerfiles/tree/master/chrome/stable>"

# Install chrome
RUN set -x \
  && AG="env DEBIAN_FRONTEND=noninteractive apt-get -yq" \
  && $AG update \
  && $AG upgrade \
  && $AG install --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    fonts-symbola \
    gnupg \
    hicolor-icon-theme \
    libcanberra-gtk* \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpangox-1.0-0 \
    libpulse0 \
    libv4l-0 \
    wget \
  && wget -O - \
    "https://dl.google.com/linux/linux_signing_key.pub" \
    | apt-key add - \
  && echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google.list \
  && $AG update \
  && $AG install --no-install-recommends \
    google-chrome-stable \
  && $AG purge --auto-remove \
    gnupg \
  && rm -rf /var/lib/apt/lists/*

# Install fontconfig
COPY ["fonts.conf", "/etc/fonts/local.conf"]

# Add non-privileged user
RUN set -x \
  && groupadd -r user \
  && useradd -r -g user -G audio,video user \
  && mkdir -p /home/user/Downloads \
  && chown -R user:user /home/user

# Create the data directory so named/managed volumes get the right permissions
RUN set -x \
  && mkdir /data \
  && chown user:user /data

# Run as non-privileged user
USER user

# Run chrome
COPY ["entrypoint.sh", "/"]
ENTRYPOINT [ "/entrypoint.sh" ]
