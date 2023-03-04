#!/bin/sh
SELF=$(basename "$0" ".sh")

# Supported by docker, but no toybox binary releases:
# * riscv64

# Supported by toybox, but possibly not docker:
# * armv4l
# * armv7m
# * i486
# * m68k
# * microblaze
# * mips
# * mipsel
# * powerpc
# * powerpc64
# * sh2eb
# * sh4

warn() {
  printf '%s %s %s\n' "$(date '+%FT%T%z')" "$SELF" "$*" >&2
}

main() {
  arch="${TARGETARCH:-$(arch)}"
  case "$arch" in
    386|i686) arch="i686" ;;
    amd64|x86_64) arch="x86_64" ;;
    arm/v5|armv5l) arch="armv5l" ;;
    arm/v7|armv7l|arm32v7) arch="armv7l" ;;
    arm64*|aarch64) arch="aarch64" ;;
    mips64*) arch="mips64" ;;
    ppc64le|powerpc64le) arch="powerpc64le" ;;
    s390x) arch="s390x" ;;
    *) warn "Architecture \"${TARGET_ARCH}\" is unsupported" ;;
  esac
  echo "$arch"
}

main "$@"; exit