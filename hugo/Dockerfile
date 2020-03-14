FROM debian:stable-slim
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

ARG HUGO_VERSION="0.67.0"

RUN AG="env DEBIAN_FRONTEND=noninteractive apt-get -yq" \
  && $AG update \
  && $AG upgrade \
  && $AG install --no-install-recommends \
    ca-certificates \
    curl \
  && rm -rf /var/lib/apt/lists/*

RUN curl --ssl-reqd --tlsv1.2 --silent --show-error -L \
    -O "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_Linux-64bit.deb" \
    -O "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_checksums.txt" \
  && grep -F -- \
      "hugo_extended_${HUGO_VERSION}_Linux-64bit.deb" \
      "hugo_${HUGO_VERSION}_checksums.txt" \
    | sha256sum --strict --status -c - \
  && dpkg --install "hugo_extended_${HUGO_VERSION}_Linux-64bit.deb" \
  && sha256sum \
    "hugo_extended_${HUGO_VERSION}_Linux-64bit.deb" \
    "$(which hugo)" \
  && rm -- \
    "hugo_extended_${HUGO_VERSION}_Linux-64bit.deb" \
    "hugo_${HUGO_VERSION}_checksums.txt"

ENV HUGO_BIND="0.0.0.0"

WORKDIR /work
