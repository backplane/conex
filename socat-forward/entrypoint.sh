#!/bin/sh
# entrypoint script for a socat docker container
set -eu
SELF=$(basename "$0" '.sh')

usage() {
  exception="${1:-}"
  [ -n "$exception" ] && printf 'ERROR: %s\n\n' "$exception"

  printf '%s\n' \
    "Usage: $SELF [-h|--help] [-d|--debug] [OPTION [...]]" \
    "" \
    "FLAGS:" \
    "-h / --help        show this message" \
    "-d / --debug       print additional debugging messages" \
    "" \
    "OPTIONS (respective envvar names appear below in UPPER_CASE):" \
    "--listen-port LISTEN_PORT  network port to listen for connections on" \
    "--dest-host DEST_HOST      network host to send connections to" \
    "--dest-port DEST_PORT      network port to send connections to" \
    "--rx-addendum RX_ADDENDUM  string to append to listen TCP4-LISTEN clause" \
    "--tx-addendum TX_ADDENDUM  string to append to TCP4 clause" \
    "--rx-override RX_OVERRIDE  argument to replace normal TCP4-LISTEN clause" \
    "--tx-override TX_OVERRIDE  argument to replace normal TCP4 clause" \
    "" \
    "Runs socat configured (by default) to listen for IPv4 connections and" \
    "forward them to a given IPv4 destination" \
    "" # no trailing slash

  [ -n "$exception" ] && exit 1
  exit 0
}

log() {
  printf '%s %s %s\n' "$(date '+%FT%T%z')" "$SELF" "$*" >&2
}

die() {
  log "FATAL:" "$@"
  exit 1
}

main() {
  LISTEN_PORT="${LISTEN_PORT:-443}"
  DEST_PORT="${DEST_PORT:-443}"
  DEST_HOST="${DEST_HOST:-dest}"
  RX_ADDENDUM="${RX_ADDENDUM:-}"
  TX_ADDENDUM="${TX_ADDENDUM:-}"
  RX_OVERRIDE="${RX_OVERRIDE:-}"
  TX_OVERRIDE="${TX_OVERRIDE:-}"

  # arg-processing loop
  while [ $# -gt 0 ]; do
    arg="$1" # shift at end of loop; if you break in the loop don't forget to shift first
    case "$arg" in
      -h|-help|--help)
        usage
        ;;

      -d|--debug)
        set -x
        ;;

      --listen-port)
        shift || usage "$arg requires an argument"
        LISTEN_PORT="$1"
        ;;

      --dest-port)
        shift || usage "$arg requires an argument"
        DEST_PORT="$1"
        ;;

      --dest-host)
        shift || usage "$arg requires an argument"
        DEST_HOST="$1"
        ;;

      --rx-addendum)
        shift || usage "$arg requires an argument"
        RX_ADDENDUM="$1"
        ;;

      --tx-addendum)
        shift || usage "$arg requires an argument"
        TX_ADDENDUM="$1"
        ;;

      --rx-override)
        shift || usage "$arg requires an argument"
        RX_OVERRIDE="$1"
        ;;

      --tx-override)
        shift || usage "$arg requires an argument"
        TX_OVERRIDE="$1"
        ;;

      --)
        shift || true
        break
        ;;

      *)
        # unknown arg, leave it back in the positional params
        break
        ;;
    esac
    shift || break
  done

  # ensure required environment variables are set
  : "${DEST_HOST:?environment variable must be set}"
  : "${DEST_PORT:?environment variable must be set}"
  : "${LISTEN_PORT:?environment variable must be set}"

  # sanity-check args
  [ -n "$RX_ADDENDUM" ] && [ -n "${RX_OVERRIDE}" ] && \
    die "RX_ADDENDUM and RX_OVERRIDE are mutually-exclusive"
  [ -n "$TX_ADDENDUM" ] && [ -n "${TX_OVERRIDE}" ] && \
    die "TX_ADDENDUM and TX_OVERRIDE are mutually-exclusive"

  # set things
  RX="${RX_OVERRIDE:-TCP4-LISTEN:${LISTEN_PORT},reuseaddr,fork${RX_ADDENDUM}}"
  TX="${TX_OVERRIDE:-TCP4:${DEST_HOST}:${DEST_PORT}${TX_ADDENDUM}}"

  log "starting as $(id -u) in ${PWD} with config:"
  log "  LISTEN_PORT: \"${LISTEN_PORT:-}\""
  log "  DEST_PORT: \"${DEST_PORT:-}\""
  log "  DEST_HOST: \"${DEST_HOST:-}\""
  log "  RX_ADDENDUM: \"${RX_ADDENDUM:-}\""
  log "  TX_ADDENDUM: \"${TX_ADDENDUM:-}\""
  log "  RX_OVERRIDE: \"${RX_OVERRIDE:-}\""
  log "  TX_OVERRIDE: \"${TX_OVERRIDE:-}\""
  log "computed config:"
  log "  RX: ${RX}"
  log "  TX: ${TX}"

  exec socat "$RX" "$TX"
}

main "$@"
# shellcheck disable=SC2317
exit
