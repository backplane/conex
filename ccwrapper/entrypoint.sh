#!/bin/sh
# entrypoint for claude code wrapper, which allows the nonroot homedir to be a volume
set -eu
SELF=$(basename "$0" '.sh')

NR_HOME="${NR_HOME:-/home/nonroot}"
NR_SKEL="${NR_SKEL:-/.nonroot_skeleton}"

log() {
  printf '%s %s %s\n' "$(date '+%FT%T%z')" "$SELF" "$*" >&2
}

die() {
  log "FATAL:" "$@"
  exit 1
}

main() {
  if find "$NR_HOME" -maxdepth 0 -empty | grep -q .; then
    log "populating ${NR_HOME} from ${NR_SKEL}"
    rsync -avHP8 "${NR_SKEL}/." "${NR_HOME}/." || die "failed to rsync home directory from skeleton"
  fi

  exec "${NR_HOME}/.local/bin/claude" "$@"
}

main "$@"
# shellcheck disable=SC2317
exit
