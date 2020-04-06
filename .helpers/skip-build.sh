#!/bin/sh

usage() {
  self="$(basename "$0")"

  printf '%s\n' \
    "Usage: ${self} target_directory" \
    "" \
    "This program returns true if the current daysum for the given subdir" \
    "matches the docker hub daysum for the corresponding image." \
    ""

  exit 1
}

warn() { 
  printf '%s %s\n' "$(date '+%FT%T')" "$*" 1>&2
}

die() { 
  warn "$* EXITING";
  exit 1
}

main() {
  target_dir="$1"; shift
  [ -d "$target_dir" ] || usage
  name="$(basename "$target_dir")"

  dh_daysum="$(.helpers/dhdaysum.sh "galvanist/conex:${name}")"
  current_daysum="$(.helpers/daysum.sh "$name")"

  if [ "$dh_daysum" != "$current_daysum" ]; then
    die "DH daysum: ${dh_daysum} != local daysum: ${current_daysum}. REBUILD REQUIRED."
  fi

  warn "daysum ${current_daysum} matches docker hub daysum. SKIP BUILD."
  exit 0
}

[ -n "$IMPORT" ] || main "$@"
