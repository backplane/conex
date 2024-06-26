#!/bin/sh

firefox_ssb() {
  if [ -n "$SSB_DEBUG" ]; then
    set -x
    SSB_DETACH=""
    SSB_RM=""
  else
    SSB_DETACH="--detach"
    SSB_RM="--rm"
  fi

  SITE=$1; shift
  if [ -z "$SITE" ]; then
    echo "a site name argument is required" 2>&1
    return 1
  fi

  if ! (printf '%s' "$SITE" | grep -Eq '^[A-Za-z0-9-]{1,}$'); then
    echo "the site name argument must only contain letters, numbers, dashes" 2>&1
    return 1
  fi

  if ! [ -d "$HOME" ]; then
    echo "the HOME environment variable must be set" 2>&1
    return 1
  fi

  SSB_BASE="${HOME}/.firefox_ssb"
  if ! [ -d "$SSB_BASE" ]; then
    if ! mkdir -p "$SSB_BASE"; then
      echo "unable to make ssb base directory \"${SSB_BASE}\"" 2>&1
      return 1
    fi
  fi

  # 15-May-2024 disabled for now
  #SECCOMP_PROFILE="${SSB_BASE}/seccomp.json"
  #if ! [ -f "$SECCOMP_PROFILE" ]; then
  #  if ! curl -sSLf --tlsv1.2 -o "$SECCOMP_PROFILE" \
  #    "https://raw.githubusercontent.com/backplane/conex/master/firefox/seccomp.json"; then
  #    echo "unable to obtain seccomp profile from github" 2>&1
  #    return 1
  #  fi
  #fi
  #
  #  --security-opt "seccomp=${SECCOMP_PROFILE}"

  # not on macOS:
  #  --device /dev/snd
  #  --device /dev/dri
  #  --volume "/tmp/.X11-unix:/tmp/.X11-unix"
  #  --volume /dev/shm:/dev/shm

  # if DISPLAY is blank or a file path, set it to docker container's host address
  case "${DISPLAY:-}" in
    ""|/*)
      DISPLAY="host.docker.internal:0"
      ;;
  esac

  docker run \
    $SSB_DETACH \
    $SSB_RM \
    --interactive \
    --tty \
    --cpuset-cpus "${SSB_CPUS:-0}" \
    --memory "${SSB_MEM:-512mb}" \
    --env "DISPLAY" \
    --volume "firefox_ssb_${SITE}:/data" \
    --volume "${HOME}/Downloads:/home/user/Downloads" \
    --name "firefox_ssb_${SITE}" \
    "${FIREFOX_SSB_IMAGE:-backplane/firefox}" \
    "$@"
  [ -n "$SSB_DEBUG" ] && printf '%s\n' \
    "" \
    "In debug mode this exited container is not automatically removed. To remote it, run:" \
    "" \
    "docker container rm 'firefox_ssb_${SITE}'" \
    ""
}

[ -n "$IMPORT" ] || firefox_ssb "$@"
