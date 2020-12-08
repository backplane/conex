FROM debian:unstable-slim
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"
LABEL upstream="<https://github.com/jessfraz/dockerfiles/tree/master/chrome/stable>"

# Install chrome
RUN set -x \
  && AG="env DEBIAN_FRONTEND=noninteractive apt-get -yq" \
  && $AG update \
  && $AG upgrade \
  && $AG install --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    curl \
    fonts-symbola \
    gnupg \
    hicolor-icon-theme \
    libcanberra-gtk* \
    libgl1-mesa-dri \
    libgl1-mesa-glx \
    libpangox-1.0-0 \
    libpulse0 \
    libv4l-0 \
	&& curl -sSL "https://dl.google.com/linux/linux_signing_key.pub" \
    | apt-key add - \
	&& echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" \
    > /etc/apt/sources.list.d/google.list \
  && $AG update \
  && $AG install --no-install-recommends \
    google-chrome-stable \
	&& $AG purge --auto-remove \
    curl \
	&& rm -rf /var/lib/apt/lists/*

# Add chrome user
RUN set -x \
  && groupadd -r chrome \
  && useradd -r -g chrome -G audio,video chrome \
  && mkdir -p /home/chrome/Downloads \
  && chown -R chrome:chrome /home/chrome

# Install fontconfig
COPY ["fonts.conf", "/etc/fonts/local.conf"]

# Run chrome as non privileged user
USER chrome

# Run chrome
COPY ["entrypoint.sh", "/"]
ENTRYPOINT [ "/entrypoint.sh" ]
