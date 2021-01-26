FROM debian:stretch-slim
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

# Install chrome
RUN set -x \
  && AG="env DEBIAN_FRONTEND=noninteractive apt-get -yq" \
  && $AG update \
  && $AG upgrade \
  && $AG install --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    gnupg \
    wget \
  && wget -O - \
    "https://packages.microsoft.com/keys/microsoft.asc" \
    | apt-key add - \
  && echo "deb [arch=amd64] https://packages.microsoft.com/debian/9/prod stretch main" \
    > /etc/apt/sources.list.d/mssql-cli.list \
  && $AG update \
  && $AG install --no-install-recommends \
    mssql-cli \
  && $AG purge --auto-remove \
    gnupg \
  && rm -rf /var/lib/apt/lists/*

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

# Run mssql-cli
ENTRYPOINT [ "mssql-cli" ]
