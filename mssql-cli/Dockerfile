FROM debian:stretch-slim
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

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
  && useradd -r -g user user \
  && mkdir -p /home/user /work \
  && chown -R  user:user /home/user /work

WORKDIR /work

# Run as non-privileged user
USER user

# Run mssql-cli
ENTRYPOINT [ "mssql-cli" ]
