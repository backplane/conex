FROM debian:stable-slim
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN set -x \
  && AG="env DEBIAN_FRONTEND=noninteractive apt-get -yq" \
  && $AG update \
  && $AG upgrade \
  && $AG install --no-install-recommends \
    adb \
    bash \
    ca-certificates \
    curl \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /work
ENTRYPOINT ["adb"]