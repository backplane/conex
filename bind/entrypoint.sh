#!/bin/sh
# entrypoint: script for staring bind9 in a container
set -eu
SELF="$(basename "$0" ".sh")"

BIND_DIR="${BIND_DIR:-/etc/bind}"
BIND_CONFIG="${BIND_CONFIG:-${BIND_DIR}/named.conf}"
ZONE_CONFIG="${ZONE_CONFIG:-${BIND_DIR}/zones.conf}"
ZONE_DIR="${ZONE_DIR:-${BIND_DIR}/zones}"
CONFIG_DIR="${CONFIG_DIR:-/config}"

usage() {
  exception="${1:-}"
  [ -n "$exception" ] && printf 'ERROR: %s\n\n' "$exception"

  printf '%s\n' \
    "Usage: $SELF [-h|--help] [arg [...]]" \
    "" \
    "-h / --help   show this message" \
    "-d / --debug  print additional debugging messages" \
    "" \
    "--bind-dir BIND_DIR        path of the bind configuration directory" \
    "                           (default: '$BIND_DIR')" \
    "--bind-config BIND_CONFIG  full path of the 'named.conf' bind config file" \
    "                           (default: '$BIND_CONFIG')" \
    "--zone-dir ZONE_DIR        path of a directory containing (only) zone" \
    "                           files to automatically serve" \
    "                           (default: '$ZONE_DIR')" \
    "--zone-config ZONE_CONFIG  full path of the 'zones.conf' file to generate" \
    "                           from the files found in ZONE_DIR" \
    "                           (default: '$ZONE_CONFIG')" \
    "--config-dir CONFIG_DIR    path of a directory whose contents could be" \
    "                           copied into the BIND_DIR" \
    "                           (default: '$CONFIG_DIR')" \
    "" \
    "--                         Pass the remaining command-line arguments to" \
    "                           bind directly" \
    "" \
    "Generates a zones.conf file which 'includes' all the zone files found in" \
    "the ZONE_DIR, runs named-checkconf, then starts bind" \
    "" # no trailing slash

  [ -n "$exception" ] && exit 1
  exit 0
}

warn() {
  printf '%s %s %s\n' "$(date '+%FT%T%z')" "$SELF" "$*" >&2
}

die() {
  warn "FATAL:" "$@"
  exit 1
}

main() {
  # arg-processing loop
  while [ $# -gt 0 ]; do
    arg="$1" # shift at end of loop
    case "$arg" in
      -h|-help|--help)
        usage
        ;;

      -d|--debug)
        set -x
        ;;

      --bind-dir)
        shift || usage "--bind-dir requires an argument"
        BIND_DIR="$1"
        ;;

      --bind-config)
        shift || usage "--bind-config requires an argument"
        BIND_CONFIG="$1"
        ;;

      --zone-config)
        shift || usage "--zone-config requires an argument"
        ZONE_CONFIG="$1"
        ;;

      --zone-dir)
        shift || usage "--zone-dir requires an argument"
        ZONE_DIR="$1"
        ;;

      --config-dir)
        shift || usage "--config-dir requires an argument"
        CONFIG_DIR="$1"
        ;;

      --)
        shift || true
        break
        ;;

      *)
        # unknown arg, leave it in the positional params
        break
        ;;
    esac
    shift || break
  done

  # ensure required environment variables are set
  # : "${USER:?the USER environment variable must be set}"

  # copy any config files & zones found in /config to /etc/bind
  if [ -d "$CONFIG_DIR" ]; then
    warn "found ${CONFIG_DIR}; copying contents to ${BIND_DIR}"
    cp -vaf "${CONFIG_DIR}/." "${BIND_DIR}/" | while read -r LINE; do
      warn "copy:" "$LINE"
    done
  fi

  # cd to /etc/bind
  cd "$BIND_DIR" || die "couldn't cd to ${BIND_DIR}/"

  # optionally construct the ZONE_CONFIG inclusion file
  if \
    [ -f "$BIND_CONFIG" ] && \
    grep -qF "include \"${ZONE_CONFIG}\";" "$BIND_CONFIG" \
  ; then
    # named.conf includes a reference to zones.conf, a file
    # that we dynamically create based on the contents of the
    # zones subdirectory
    warn "constructing ${ZONE_CONFIG}"
    if [ -f "${ZONE_CONFIG}" ]; then
      warn "found existing ${ZONE_CONFIG}, removing it for reconstruction"
      rm -vf "${ZONE_CONFIG}" 2>&1 | while read -r LINE; do
        warn "remove:" "$LINE"
      done
    fi

    for zone_file in "$(basename "${ZONE_DIR}")"/*; do \
      zone="$(basename "$zone_file")"
      if [ "$zone" = '*' ]; then
        die "no zone files were found in ${ZONE_DIR} but we need zone files" \
          "so that we can generate ${ZONE_CONFIG} and we MUST generate that" \
          "file because ${BIND_CONFIG} currently refers to it"
      fi
      printf 'zone "%s" IN { type primary; file "%s"; };\n' \
        "$zone" "$zone_file" \
        | tee -a "${ZONE_CONFIG}" \
        | while read -r LINE; do
          warn "config:" "$LINE"
        done
    done
  fi

  warn "resetting $BIND_DIR permissions"
  chown -R root:root "$BIND_DIR"
  chmod -R a-rwx,a+rX,u+w "$BIND_DIR"
  chown named:named "$BIND_DIR"

  warn "running named-checkconf"
  # we can't wrap the output of this command because we want a non-zero exit to
  # terminate the container
  /usr/bin/named-checkconf -z \
    || die "named-checkconf failed"

  # put the whole command in the positional params so we can report it
  set -- /usr/sbin/named \
    -u named \
    -c "$BIND_CONFIG" \
    -g \
    "$@"
  warn "exec-ing bind:" "$@"
  exec "$@"
}

main "$@"; exit
