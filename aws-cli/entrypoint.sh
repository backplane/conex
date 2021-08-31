#!/bin/sh
# entrypoint: a wrapper for the aws cli which warns if certain envvars are missing
SELF="$(basename "$0" ".sh")"

warn() {
  printf '%s %s %s\n' "$(date '+%FT%T%z')" "$SELF" "$*" >&2
}

warn_missing() {
  warn "WARNING:" "'$*' is not set in the environment as expected"
}

main() {
  if [ -z "$NO_WARN" ]; then
    [ -z "$AWS_ACCESS_KEY_ID" ] && warn_missing "AWS_ACCESS_KEY_ID"
    [ -z "$AWS_SECRET_ACCESS_KEY" ] && warn_missing "AWS_SECRET_ACCESS_KEY"
    [ -z "$AWS_DEFAULT_REGION" ] && warn_missing "AWS_DEFAULT_REGION"
  fi

  exec /usr/bin/aws "$@"
}

main "$@"; exit

