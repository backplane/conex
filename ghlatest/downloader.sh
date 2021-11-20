#!/bin/sh

set -eux

curl \
  --ssl-reqd \
  --tlsv1.2 \
  --silent \
  --show-error \
  -o /dev/null \
  -w '%{redirect_url}\n' \
  'https://github.com/backplane/ghlatest/releases/latest' \
| while read -r URL; do
  # url is something like: https://github.com/backplane/ghlatest/releases/tag/v0.1.6
  VSEMVER="${URL##*/}"
  SEMVER="${VSEMVER##v}"
  ARCH="$(./arch.sh)"
  echo "https://github.com/backplane/ghlatest/releases/download/${VSEMVER}/ghlatest_${SEMVER}_linux_${ARCH}.tar.gz"
done \
| while read -r DL_URL; do \
  curl \
    --location \
    --show-error \
    --silent \
    --ssl-reqd \
    --tlsv1.2 \
    --output "ghlatest.tar.gz" \
    "${DL_URL}"
  tar -xf ghlatest.tar.gz ghlatest
  rm ghlatest.tar.gz
done
