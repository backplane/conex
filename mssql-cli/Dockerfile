FROM debian:stretch-slim
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

# a helper utility
COPY arch.sh /

ARG AG="apt-get -yq --no-install-recommends"
ARG DEBIAN_FRONTEND="noninteractive"

RUN set -eux; \
  DEBIAN_VERSION_CODENAME=$(. /etc/os-release; echo "$VERSION_CODENAME"); \
  DEBIAN_VERSION_ID=$(. /etc/os-release; echo "$VERSION_ID"); \
  $AG update; \
  $AG upgrade; \
  $AG install \
    apt-transport-https \
    ca-certificates \
    gnupg \
    wget \
  ; \
  wget -O - \
    "https://packages.microsoft.com/keys/microsoft.asc" \
    | apt-key add -; \
  printf "deb [arch=%s] %s %s main\n" \
    "$(/arch.sh)" \
    "https://packages.microsoft.com/debian/${DEBIAN_VERSION_ID}/prod" \
    "$DEBIAN_VERSION_CODENAME" \
    | tee /etc/apt/sources.list.d/mssql-cli.list; \
  $AG update; \
  $AG install \
    mssql-cli \
  ; \
  $AG purge --auto-remove \
    gnupg \
  ; \
  rm -rf /var/lib/apt/lists/*;

# Add non-privileged user
RUN set -eux; \
  groupadd -g 65532 nonroot; \
  useradd --no-log-init -u 65532 -g nonroot nonroot; \
  mkdir -p /home/nonroot /work; \
  chown -R nonroot:nonroot /home/nonroot /work;

ENV MSSQL_CLI_TELEMETRY_OPTOUT=True

WORKDIR /work

# Run as non-privileged user
USER nonroot

# Run mssql-cli
ENTRYPOINT [ "mssql-cli" ]
