#!/bin/sh

usage() {
  self="$(basename "$0")"

  printf '%s\n' \
    "Usage: ${self} target_directory" \
    "" \
    "This program calculates the checksum of the contents of a given" \
    "target_directory. The year and current UTC week number are embedded" \
    "in the data so that the checksum is guaranteed to change at least" \
    "weekly." \
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

sumdir() {
  target_dir="$1"; shift

  find "$(basename "$target_dir")" -type f -print \
    | sort \
    | tr '\n' '\0' \
    | xargs -0 shasum -a 256
}

daysum() {
  target_dir="$1"; shift

  # tee's output buffering here results in incomplete logs...
  { sumdir "$target_dir" \
    ; date -u '+%Y-%U'; } \
  | tee /dev/stderr \
  | shasum -a 256 - \
  | cut -f 1 -d ' '
}

main() {
  target_dir="$1"; shift
  [ -d "$target_dir" ] || usage

  daysum "$target_dir"
}

[ -n "$IMPORT" ] || main "$@"
