#!/bin/sh

warn() {
  printf '%s %s\n' "$(date '+%FT%T')" "$*" >&2
}

die() {
  warn "$* EXITING"
  exit 1
}

run() {
  export TESTING_TARGET="${1%%_test.sh}.sh"

  warn "Running: $*"
  "$@" || die "FAILED: '$*'"
}

main() {
  if [ -n "$*" ]; then
    for cmd in "$@"; do
      run "$cmd"
    done
  else
    find . \
      -name '*_test.sh' \
      -type 'f' \
      -maxdepth 1 \
    | while read -r cmd; do
      run "$cmd"
    done
  fi

  exit 0
}

[ -n "$IMPORT" ] || main "$@"