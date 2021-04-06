FROM debian:buster-slim

# This is actually a terrible idea.
# MS binary blob depends on libssl1.0.0
# using https://packages.debian.org/jessie/libssl1.0.0
ARG BAD_IDEA="http://security.debian.org/debian-security/pool/updates/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u12_amd64.deb"

RUN set -x \
  && AG="env DEBIAN_FRONTEND=noninteractive apt-get -yq" \
  && $AG update \
  && $AG install --no-install-recommends \
    curl \
    libicu63 \
    multiarch-support \
    python3 \
    python3-pip \
  && rm -rf /var/lib/apt/lists/* \
  && curl -L -o "libssl.deb" "${BAD_IDEA}" \
  && dpkg -i "libssl.deb" \
  && rm "libssl.deb"

RUN set -x \
  && pip3 install --upgrade \
    pip \
    setuptools \
  && pip install \
    mssql-scripter \
  && pip cache purge \
  && true

ENV PYTHONIOENCODING="utf_8"

WORKDIR /app
ENTRYPOINT ["python3", "-m", "mssqlscripter"]
