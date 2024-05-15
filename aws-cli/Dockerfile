FROM debian:stable-slim as downloader

ARG AG="apt-get -yq --no-install-recommends"
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
  $AG update; \
  $AG install \
    ca-certificates \
    curl \
    unzip \
  ;

RUN set -eux; \
  zip="awscliv2.zip"; \
  curl \
    --silent \
    --show-error \
    --location \
    --tlsv1.3 \
    --output "$zip" \
    "https://awscli.amazonaws.com/awscli-exe-linux-$(arch).zip"; \
  unzip -q "$zip"; \
  rm -- "$zip"; \
  ./aws/install;

FROM debian:stable-slim
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

ARG AG="apt-get -yq --no-install-recommends"
ARG DEBIAN_FRONTEND=noninteractive

RUN set -eux; \
  $AG update; \
  $AG install \
    groff \
    less \
  ; \
  $AG clean; \
  $AG autoremove; \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    ~/.cache \
  ;

COPY --from=downloader /usr/local/aws-cli/ /usr/local/aws-cli/
RUN set -eux; \
  cd /usr/local/bin; \
  ln -s /usr/local/aws-cli/v2/current/dist/aws; \
  ln -s /usr/local/aws-cli/v2/current/dist/aws_completer;

ARG NONROOT_GID=65532
ARG NONROOT_UID=65532
RUN set -eux; \
  addgroup \
    --gid "${NONROOT_GID}" \
    nonroot \
  ; \
  adduser \
    --uid "${NONROOT_UID}" \
    --ingroup "nonroot" \
    --home /work \
    --disabled-login \
    --quiet \
    --gecos "" \
    nonroot \
  ;
USER nonroot
WORKDIR /work

ENTRYPOINT [ "/usr/local/bin/aws" ]
