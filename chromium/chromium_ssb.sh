#!/bin/sh
# chromium_ssb: utility for launching site-specific Chromium browsers in Docker
# shellcheck disable=SC2317
SELF="$(basename "$0" ".sh")"
set -eu

usage() {
  exception="${1:-}"
  [ -n "$exception" ] && printf 'ERROR: %s\n\n' "$exception"

  printf '%s\n' \
    "Usage: $SELF [-h|--help] NAME" \
    "" \
    "Options:" \
    "-h / --help   show this message" \
    "" \
    "Arguments:" \
    "NAME          the name for the site specific browser, such as 'work' or 'reddit'" \
    "" \
    "This script launches an X11 browser inside a docker container and directs " \
    "the display back to the host " \
    "" # no trailing slash

  [ -n "$exception" ] && exit 1
  exit 0
}

chromium_ssb() {
  [ -n "${SSB_DEBUG:-}" ] && set -x

  # first verify that we have a copy of the seccomp profile in our home dir
  # (or try to get one)
  SSB_BASE="${HOME}/.chromium_ssb"
  if ! [ -d "$SSB_BASE" ]; then
    warn "${SSB_BASE} does not exist, creating"
    if ! mkdir -p "$SSB_BASE"; then
      die "${SSB_BASE} creation failed"
    fi
  fi
  SECCOMP_PROFILE="${SSB_BASE}/seccomp.json"
  if ! [ -f "$SECCOMP_PROFILE" ]; then
    warn "${SECCOMP_PROFILE} not found; downloading"
    if ! curl -sSLf --tlsv1.2 -o "$SECCOMP_PROFILE" \
      "https://raw.githubusercontent.com/backplane/conex/main/chromium/seccomp.json"
    then
      die "unable to obtain seccomp profile from github"
    fi
  fi

  # the first argument given to this function is the "name" of the SSB -- it
  # determines where SSB state is stored
  SITE=$1; shift
  [ -n "$SITE" ] || die "a site name argument is required"
  if ! (printf '%s' "$SITE" | grep -Eq '^[A-Za-z0-9-]{1,}$'); then
    die "the site name argument must only contain letters, numbers, dashes"
  fi

  # subsequent arguments to this function are passed to chromium

  # In this function we repeatedly use the form:
  # set -- --some-docker-option "$@"
  # to build up the "docker run" arguments within the positional paramaters
  # list

  # the chromium application arguments (put these first)
  set -- \
    "--use-gl=swiftshader" \
    "--disable-dev-shm-usage" \
    "--disable-audio-output" \
    "--reset-variation-state" \
    "--disable-field-trial-config" \
    "$@"

  # the image to run (put this second)
  set -- "${CHROMIUM_SSB_IMAGE:-backplane/chromium}" "$@"

  # the rest are docker run flags (put these last)

  if [ -z "${SSB_DEBUG:-}" ]; then
    set -- \
      "--rm" \
      "$@"
  fi

  if [ -z "${SSB_FOREGROUND:-}" ]; then
    set -- \
      "--detach" \
      "$@"
  fi

  # some os-specific features
  case "$(uname -s)" in
    Darwin)
      warn "applying OS-specific customizations for macOS"
      export PATH="$PATH:/usr/X11/bin:/usr/local/bin"

      # start the display server
      open -a "${SSB_XSERVER:-Xquartz}"

      # if the DISPLAY variable is set and if it begins with a "/" then unset
      # it so the default will be used. on darwin you can't mount unix sockets
      # across the hyperkit vm boundry

      warn "exporting host xauth cookie to xauth volume"
      # first let's grab an x11 cookie and save it to a volume
      xauth -n nextract - ":0" \
        | docker run --rm -i --volume "chromium_ssb__auth:/xauth:rw" busybox:musl \
          sh -c "cat >/xauth/nmerge"
      # we'll mount that volume in the container
      set -- \
        "--volume" "chromium_ssb__auth:/xauth:ro" \
        "$@"

      # if DISPLAY begins with a slash we unset the display in favorite of a
      # better default below
      if [ "${DISPLAY#/}" != "$DISPLAY" ]; then
        DISPLAY="" # see default set in common docker run arguments below
      fi
      ;;

    Linux)
      warn "applying OS-specific customizations for Linux"
      set -- \
        "--device" "/dev/dri" \
        "--device" "/dev/snd" \
        "--volume" "/dev/shm:/dev/shm" \
        "--volume" "/tmp/.X11-unix:/tmp/.X11-unix" \
        "$@"
      ;;

    *)
      printf '%s\n' "warning: unknown OS $(uname -s)" >&2

      ;;
  esac

  # common docker run arguments
  set -- \
    "--tty" \
    "--cpu-quota" "${SSB_CPU_QUOTA:-75000}" \
    "--env" "DISPLAY=${DISPLAY:-host.docker.internal:0}" \
    "--memory" "${SSB_MEM:-4g}" \
    "--name" "chromium_ssb_${SITE}" \
    "--security-opt" "seccomp=${SECCOMP_PROFILE}" \
    "--volume" "chromium_ssb_${SITE}:/data" \
    "$@"

  # mount the downloads folder unless otherwise specified
  if [ -d "${HOME}/Downloads" ] && [ -z "${SSB_NO_DL:-}" ]; then
    set -- \
      "--volume" "${HOME}/Downloads:/home/user/Downloads" \
      "$@"
  fi

  warn "Starting container"
  printf '%s\n\n' "docker run $*" | sed 's/--/\n--/g' >&2
  docker run "$@"

  if [ -n "${SSB_DEBUG:-}" ]; then
    set +x
    printf '%s\n' \
      "" \
      "In debug mode this exited container is not automatically removed." \
      "To remote it, run:" \
      "" \
      "docker container rm 'chromium_ssb_${SITE}'" \
      ""
  fi

  return
}

warn() {
  printf '%s %s %s\n' "$(date '+%FT%T%z')" "$SELF" "$*" >&2
}

die() {
  warn "FATAL:" "$@"
  exit 1
}

main() {

  while [ $# -gt 0 ]; do
    arg="$1" # shift at end of loop; if you break in the loop don't forget to shift first
    case "$arg" in
      -h|-help|--help)
        usage ""
        ;;

      -d|--debug)
        set -x
        ;;

      --foreground)
        SSB_FOREGROUND="1"
        ;;

      --)
        shift || true
        break
        ;;

      *)
        # unknown arg, leave in the positional params
        break
        ;;
    esac
    shift || break
  done

  # ensure required environment variables are set
  # : "${USER:?the USER environment variable must be set}"
  : "${HOME?this variable must be defined in the environment}"
  : "${DISPLAY?this variable must be defined in the environment}"

  if [ -z "$*" ]; then
    usage "you must specify a NAME for the site specific browser"
  fi

  # do things
  chromium_ssb "$@"

  exit
}

main "$@"; exit
