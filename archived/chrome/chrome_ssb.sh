#!/bin/sh

chrome_ssb() {
  [ -n "$SSB_DEBUG" ] && set -x

  # first verify that we have a copy of the seccomp profile in our home dir
  # (or try to get one)
  if ! [ -d "$HOME" ]; then
    echo "the HOME environment variable must be set" 2>&1
    return 1
  fi
  SSB_BASE="${HOME}/.chrome_ssb"
  if ! [ -d "$SSB_BASE" ]; then
    if ! mkdir -p "$SSB_BASE"; then
      echo "unable to make ssb base directory \"${SSB_BASE}\"" 2>&1
      return 1
    fi
  fi
  SECCOMP_PROFILE="${SSB_BASE}/seccomp.json"
  if ! [ -f "$SECCOMP_PROFILE" ]; then
    if ! curl -sSLf --tlsv1.2 -o "$SECCOMP_PROFILE" \
      "https://raw.githubusercontent.com/backplane/conex/master/chrome/seccomp.json"
    then
      echo "unable to obtain seccomp profile from github" 2>&1
      return 1
    fi
  fi

  # the first argument given to this function is the "name" of the SSB -- it
  # determines where SSB state is stored
  SITE=$1; shift
  if [ -z "$SITE" ]; then
    echo "a site name argument is required" 2>&1
    return 1
  fi
  if ! (printf '%s' "$SITE" | grep -Eq '^[A-Za-z0-9-]{1,}$'); then
    echo "the site name argument must only contain letters, numbers, dashes" 2>&1
    return 1
  fi

  # subsequent arguments to this function are passed to chrome

  # In this function we repeatedly use the form:
  # set -- --some-docker-option "$@"
  # to build up the "docker run" arguments within the positional paramaters
  # list

  # the chrome application arguments (put these first)
  set -- \
    "--use-gl=swiftshader" \
    "--disable-dev-shm-usage" \
    "--disable-audio-output" \
    "--reset-variation-state" \
    "--disable-field-trial-config" \
    "$@"

  # the image to run (put this second)
  set -- "${CHROME_SSB_IMAGE:-backplane/chrome}" "$@"

  # the rest are docker run flags (put these last)

  # tell docker to detach the container on startup and remove the container on
  # exit (unless we're debugging)
  if [ -z "$SSB_DEBUG" ]; then
    set -- \
      "--detach" \
      "--rm" \
      "$@"
  fi

  # some os-specific features
  case "$(uname -s)" in
    Darwin)
      # if the DISPLAY variable is set and if it begins with a "/" then unset
      # it so the default will be used. on darwin you can't mount unix sockets
      # across the hyperkit vm boundry
      if [ "${DISPLAY#/}" != "$DISPLAY" ]; then
        unset DISPLAY
      fi
      ;;

    Linux)
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
    "--cpuset-cpus" "${SSB_CPUS:-0}" \
    "--env" "DISPLAY=${DISPLAY:-host.docker.internal:0}" \
    "--interactive" \
    "--memory" "${SSB_MEM:-512mb}" \
    "--name" "chrome_ssb_${SITE}" \
    "--security-opt" "seccomp=${SECCOMP_PROFILE}" \
    "--tty" \
    "--volume" "chrome_ssb_${SITE}:/data" \
    "$@"

  # mount the downloads folder unless otherwise specified
  if [ -d "${HOME}/Downloads" ] && [ -z "$SSB_NO_DL" ]; then
    set -- \
      "--volume" "${HOME}/Downloads:/home/user/Downloads" \
      "$@"
  fi

  docker run "$@"

  set +x
  [ -n "$SSB_DEBUG" ] && printf '%s\n' \
    "" \
    "In debug mode this exited container is not automatically removed." \
    "To remote it, run:" \
    "" \
    "docker container rm 'chrome_ssb_${SITE}'" \
    ""
}

[ -n "$IMPORT" ] || chrome_ssb "$@"
