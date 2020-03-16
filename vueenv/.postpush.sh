#!/bin/sh

warn() {
  printf '%s %s\n' "$(date '+%FT%T')" "$*" >&2
}

die() {
  warn "$* EXITING"
  exit 1
}

main() {
  [ -n "$IMAGE" ] || die "postpush missing IMAGE environment variable"

  # an additional location at docker hub
  DH_TAG="galvanist/vueenv:latest"

  set -x
  docker tag "$IMAGE" "$DH_TAG" || die "tagging failed"
  docker push "$DH_TAG" || die "push failed"

  exit 1
}

main "$@"