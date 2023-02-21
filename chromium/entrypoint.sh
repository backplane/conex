#!/bin/sh
SELF="${SELF:-$(basename "$0" ".sh")}"
set -eu

warn() {
  printf '%s %s %s\n' "$(date '+%FT%T')" "$SELF" "$*" 1>&2
}

# the user can run: docker run --rm backplane/chromium --get-util >chromium_ssb.sh
if [ "$*" = "--get-util" ]; then
  warn "writing chromium_ssb.sh to STDOUT"
  cat "/chromium_ssb.sh"
  exit 0
fi

NMERGE_FILE="${NMERGE_FILE:-/xauth/nmerge}"
if [ -f "$NMERGE_FILE" ]; then
  if ! [ -f "${HOME}/.Xauthority" ]; then
    cd || exit 1
    touch .Xauthority || exit 1
  fi

  warn "merging xauth data from xauth docker volume"
  xauth nmerge "$NMERGE_FILE" || exit 2

  warn "cloning xauth cookie to new entry with appropriate DISPLAY value"
  # we make a copy of all the cookies found with the display changed to $DISPLAY
  xauth list | awk '{system("xauth -n add " ENVIRON["DISPLAY"] " . " $3)}'
fi

set -- /usr/bin/chromium --user-data-dir=/data "$@"
warn "exec-ing into chromium:" "$@"
"$@"; exit
