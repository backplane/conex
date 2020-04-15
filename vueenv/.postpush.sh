#!/bin/sh

warn() {
  printf '%s %s\n' "$(date '+%FT%T')" "$*" >&2
}

die() {
  warn "$* EXITING"
  exit 1
}

main() {
  ${local_tag:?<- is missing from the environment}

  # if we're building for galvanist/conex, add an additional tag at docker hub
  [ "$DH_REGISTRY_PATH" = "galvanist/conex" ] || exit 0
  additional_tag='galvanist/vueenv:latest'

  set -x
  docker tag "$local_tag" "$additional_tag" || die "tagging failed"
  docker push "$additional_tag" || die "push failed"
}

[ -n "$IMPORT" ] || main "$@"