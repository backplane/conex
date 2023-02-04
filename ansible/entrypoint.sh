#!/bin/sh
# util: ansible container entrypoint
SELF="$(basename "$0" ".sh")"

usage() {
  printf '%s\n' \
    "Note: this is the help text for an ansible container entrypoint, if you" \
    "      want to see the help text for ansible itself, use something like:" \
    "      docker run --rm -it backplane/ansible ansible -h" \
    "" \
    "" \
    "Usage: $SELF [-h|--help] <utility> [arg [...]]" \
    "" \
    "-h / --help   show this message" \
    "-d / --debug  print additional debugging messages" \
    "<utility>     run the named ansible utility with any given arguments" \
    "              must be one of the following:" \
    "                ansible" \
    "                ansible-config" \
    "                ansible-connection" \
    "                ansible-console" \
    "                ansible-doc" \
    "                ansible-galaxy" \
    "                ansible-inventory" \
    "                ansible-playbook" \
    "                ansible-pull" \
    "                ansible-runner" \
    "                ansible-test" \
    "                ansible-vault" \
    "                molecule" \
    "" \
    "If no utility is specified, 'ansible' will be used." \
    "" # no trailing slash

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
  util="ansible"

  # arg-processing loop
  while [ $# -gt 0 ]; do
    arg="$1" # shift at end of loop
    case "$arg" in
      -h|-help|--help)
        usage
        ;;

      -d|--debug)
        warn "enabling debug outout"
        set -x
        ;;

      --)
        shift || true
        break
        ;;

      ansible|ansible-config|ansible-connection|ansible-console|ansible-doc|ansible-galaxy|ansible-inventory|ansible-playbook|ansible-pull|ansible-runner|ansible-test|ansible-vault|molecule)
        util="$arg";
        shift || true
        break
        ;;

      *)
        # unknown arg, leave it in the positional params & break
        break
        ;;
    esac
    shift || break
  done

  # ensure required environment variables are set
  # : "${USER:?the USER environment variable must be set}"

  # should be unreachable
  [ -n "$util" ] || die "no util selected during arg processing loop"

  # do things
  exec "$util" "$@"
}

main "$@"; exit

