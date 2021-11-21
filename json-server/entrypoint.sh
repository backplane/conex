#!/bin/sh

main() {
  HOST="${HOST:-0.0.0.0}"
  PORT="${PORT:-3000}"

  # arg-processing loop
  while [ $# -gt 0 ]; do
    arg="$1" # shift at end of loop; if you break in the loop don't forget to shift first
    case "$arg" in

      -H|--host)
        shift || true
        HOST="$1"
        ;;

      -p|--port)
        shift || true
        PORT="$1"
        ;;

      *)
        # unknown arg, leave it back in the positional params
        break
        ;;
    esac
    shift || break
  done

  # ensure required environment variables are set
  # : "${USER:?the USER environment variable must be set}"

  set -eux
  exec /sbin/tini -- \
    /usr/local/bin/json-server \
      --host "$HOST" \
      --port "$PORT" \
      "$@"

  exit 0
}

main "$@"; exit
