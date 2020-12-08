#!/bin/sh

chrome_ssb() {
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

  SECCOMP_PROFILE="${SSB_BASE}/.seccomp.json"
  if ! [ -f "$SECCOMP_PROFILE" ]; then
    if ! curl -sSLf -o "$SECCOMP_PROFILE" \
      "https://raw.githubusercontent.com/glvnst/conex/master/chrome/seccomp.json"; then
      echo "unable to obtain seccomp profile from github" 2>&1
      return 1
    fi
  fi

  SSB_ROOT="${SSB_BASE}/${SITE}"
  if ! mkdir -p "$SSB_ROOT"; then
    echo "unable to make ssb root directory \"${SSB_ROOT}\"" 2>&1
    return 1
  fi

  docker run \
    --rm \
    --interactive \
    --tty \
    --net host \
    --cpuset-cpus 0 \
    --memory 512mb \
    --env "DISPLAY=unix${DISPLAY:-:0}" \
    --volume "/tmp/.X11-unix:/tmp/.X11-unix" \
    --volume "${SSB_ROOT}/data:/data" \
    --volume "${HOME}/Downloads:/home/chrome/Downloads" \
    --security-opt "seccomp=${SECCOMP_PROFILE}" \
    --device /dev/snd \
    --device /dev/dri \
    --volume /dev/shm:/dev/shm \
    --name "chrome_ssb_${SITE}" \
    "galvanist/conex:chrome" \
    "$@"
}

[ -n "$IMPORT" ] || chrome_ssb "$@"
