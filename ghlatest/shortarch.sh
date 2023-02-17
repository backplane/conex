#!/bin/sh

ARCH="${1:-$(uname -m)}"

case "$ARCH" in
  x86_64)
    ARCH="amd64"
    ;;
  aarch64)
    ARCH="arm64"
    ;;
  armv7l)
    ARCH="armv7"
    ;;
esac

printf '%s\n' "$ARCH"
exit 0
