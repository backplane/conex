#!/bin/sh

usage() {
  self="$(basename "$0")"

  printf '%s\n' \
    "Usage: ${self} repotag [repotag [...]]" \
    "" \
    "This program returns the value of the 'com.galvanist.daysum' label on a" \
    "docker hub image -- as identified by the given 'repotag'. For example" \
    "'galvanist/conex:bpython'" \
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

checkpath() {
  for cmd in "$@"; do
    $cmd -h >/dev/null 2>&1 \
      || die "Couldn't find ${cmd} on your path." \
        "Maybe add .helpers to it or work from there."
  done
}

main() {
  [ -n "$*" ] || usage

  PATH=".:.helpers:${PATH}"
  checkpath dhmanifest.py jq


  for repotag in "$@"; do
    dhmanifest.py "$repotag" \
    | jq -r '.history[0].v1Compatibility | fromjson .config.Labels["com.galvanist.daysum"]'
  done
}

[ -n "$IMPORT" ] || main "$@"

