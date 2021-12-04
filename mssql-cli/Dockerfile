FROM debian:stretch-slim
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

# a helper utility
COPY arch.sh /

RUN set -eux; \
  export \
    AG="apt-get -yq" \
    DEBIAN_FRONTEND="noninteractive" \
    DEBIAN_VERSION_CODENAME="$(. /etc/os-release; echo "$VERSION_CODENAME")" \
    DEBIAN_VERSION_ID="$(. /etc/os-release; echo "$VERSION_ID")" \
  ; \
  $AG update; \
  $AG upgrade; \
  $AG install --no-install-recommends \
    apt-transport-https \
    ca-certificates \
    gnupg \
    wget \
  ; \
  wget -O - \
    "https://packages.microsoft.com/keys/microsoft.asc" \
    | apt-key add -; \
  printf "deb [arch=$(/arch.sh)] %s %s main\n" \
    "https://packages.microsoft.com/debian/${DEBIAN_VERSION_ID}/prod" \
    "$DEBIAN_VERSION_CODENAME" \
    | tee /etc/apt/sources.list.d/mssql-cli.list; \
  $AG update; \
  $AG install --no-install-recommends \
    mssql-cli \
  ; \
  $AG purge --auto-remove \
    gnupg \
  ; \
  rm -rf /var/lib/apt/lists/*;

# Add non-privileged user
RUN set -eux; \
  groupadd -g 65532 nonroot; \
  useradd -u 65532 -g nonroot nonroot; \
  mkdir -p /home/nonroot /work; \
  chown -R nonroot:nonroot /home/nonroot /work;

ENV MSSQL_CLI_TELEMETRY_OPTOUT=True

WORKDIR /work

# Run as non-privileged user
USER nonroot

# Run mssql-cli
ENTRYPOINT [ "mssql-cli" ]
