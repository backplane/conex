#!/bin/sh
# util: entrypoint for bind container
set -eu
SELF="$(basename "$0" ".sh")"

usage() {
  exception="$1"; shift
  [ -n "$exception" ] && printf 'ERROR: %s\n\n' "$exception"

  printf '%s\n' \
    "Usage: $SELF [-h|--help] [arg [...]]" \
    "" \
    "-h / --help   show this message" \
    "-d / --debug  print additional debugging messages" \
    "arg           description of arg" \
    "" \
    "Description of functionality" \
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

      --mega-turtles)
        usage "You can't handle MEGA-TURTLES."
        ;;

      --)
        break
        ;;

      *)
        # unknown arg, put it back in the positional params & break
        set -- "$arg" "$@"
        break
        ;;
    esac
    shift || break
  done

  # ensure required environment variables are set
  # : "${USER:?the USER environment variable must be set}"

  bind_dir="/etc/bind"
  bind_config="${bind_dir}/named.conf"
  zone_config="${bind_dir}/zones.conf"
  zone_dir="${bind_dir}/zones"

  # copy any config files & zones found in /config to /etc/bind
  [ -d '/config' ] && cp -vaf /config/. "${bind_dir}"/.

  # cd to /etc/bind
  cd "$bind_dir" || die "couldn't cd to ${bind_dir}/"

  # optionally construct the zone_config inclusion file
  if \
    [ -f "$bind_config" ] && \
    grep -qF "include \"${zone_config}\";" "$bind_config" \
  ; then
    # named.conf includes a reference to zones.conf, a file
    # that we dynamically create based on the contents of the
    # zones subdirectory
    warn "constructing ${zone_config}"
    for zone_file in "$(basename "${zone_dir}")"/*; do \
      zone="$(basename "$zone_file")"
      [ "$zone" != '*' ] || die "no zone files were found (normally these should be placed in /config/zones/)"
      printf 'zone "%s" IN { type primary; file "%s"; };\n' \
        "$zone" "$zone_file" \
        | tee -a "${zone_config}"; \
    done
  fi

  warn "resetting $bind_dir permissions"
  chown -R root:root "$bind_dir"
  chmod -R a-rwx,a+rX,u+w "$bind_dir"
  chown named:named "$bind_dir"

  warn "running named-checkconf"
  /usr/sbin/named-checkconf -z \
    || die "named-checkconf failed"

  warn "starting named"
  exec /usr/sbin/named \
    -u named \
    -c "${CONFIG_FILE:-${bind_config}}" \
    -g
}

main "$@"; exit