#!/bin/sh

chrome_ssb() {
  if [ -n "$SSB_DEBUG" ]; then
    set -x
    SSB_DETACH=""
    SSB_RM=""
  else
    SSB_DETACH="--detach"
    SSB_RM="--rm"
  fi

  [ -n "$SSB_DEBUG" ] && set -x

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

  SSB_BASE="${HOME}/.chrome_ssb"
  if ! [ -d "$SSB_BASE" ]; then
    if ! mkdir -p "$SSB_BASE"; then
      echo "unable to make ssb base directory \"${SSB_BASE}\"" 2>&1
      return 1
    fi
  fi

  SECCOMP_PROFILE="${SSB_BASE}/seccomp.json"
  if ! [ -f "$SECCOMP_PROFILE" ]; then
    if ! curl -sSLf -o "$SECCOMP_PROFILE" \
      "https://raw.githubusercontent.com/glvnst/conex/master/chrome/seccomp.json"; then
      echo "unable to obtain seccomp profile from github" 2>&1
      return 1
    fi
  fi

  # not on macOS:
  #  --device /dev/snd
  #  --device /dev/dri
  #  --volume "/tmp/.X11-unix:/tmp/.X11-unix"
  #  --volume /dev/shm:/dev/shm

  docker run \
    $SSB_DETACH \
    $SSB_RM \
    --interactive \
    --tty \
    --cpuset-cpus "${SSB_CPUS:-0}" \
    --memory "${SSB_MEM:-512mb}" \
    --env "DISPLAY=${DISPLAY:-host.docker.internal:0}" \
    --volume "chrome_ssb_${SITE}:/data" \
    --volume "${HOME}/Downloads:/home/user/Downloads" \
    --security-opt "seccomp=${SECCOMP_PROFILE}" \
    --name "chrome_ssb_${SITE}" \
    "galvanist/conex:chrome" \
    "--use-gl=swiftshader" \
    "--disable-dev-shm-usage" \
    "--disable-audio-output" \
    "--reset-variation-state" \
    "--disable-field-trial-config" \
    "$@"
    [ -n "$SSB_DEBUG" ] && printf '%s\n' \
    "" \
    "In debug mode this exited container is not automatically removed. To remote it, run:" \
    "" \
    "docker container rm 'chrome_ssb_${SITE}'" \
    ""

}

[ -n "$IMPORT" ] || chrome_ssb "$@"
