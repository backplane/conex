#!/bin/sh

if [ -n "$1" ]; then
  ARCH="$1"
else
  ARCH="$(uname -m)"
fi
case "$ARCH" in
  x86_64)
    ARCH="amd64"
    ;;
  aarch64)
    ARCH="arm64"
    ;;
esac
printf '%s\n' "$ARCH"
exit 0
