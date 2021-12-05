#!/bin/sh

export CHROME_VERSION_EXTRA="stable"

# Beware possible issues with the following bug which may be resurrected by our
# use of chrome without the wrapper:
# https://bugs.chromium.org/p/chromium/issues/detail?id=376567

# exec /opt/google/chrome/chrome --user-data-dir=/data "$@"
exec /usr/bin/google-chrome --user-data-dir=/data "$@"
