#!/bin/sh

LOCAL_IMG_PREFIX="${LOCAL_IMG_PREFIX:-conex_}"
GH_REGISTRY_PATH="${GH_REGISTRY_PATH:-docker.pkg.github.com/glvnst/conex}"
DH_REGISTRY_PATH="${DH_REGISTRY_PATH:-galvanist/conex}"
DISABLE_DAYSUM_QUERY="${DISABLE_DAYSUM_QUERY:-}"

usage() {
  self="$(basename "$0")"

  printf '%s\n' \
    "Usage: ${self} command target" \
    "" \
    "This build helper contains the build logic. It is called by the " \
    "Makefile." \
    ""

  exit 1
}

warn() { 
  printf '%s %s\n' "$(date '+%FT%T')" "$*" 1>&2
}

die() { 
  warn "$* EXITING";
  exit 1
}

build() {
  target="$1"; shift
  [ -n "$target" ] || die "build requires target arg"

  local_tag="$1"; shift
  [ -n "$local_tag" ] || die "build requires local_tag arg"

  current_daysum="$(.helpers/daysum.sh "$target")"
  [ -n "$current_daysum" ] \
  || die "Unable to calculate current context checksum"

  build_receipt="${target}-build-rcpt.txt"

  # can we skip? if the current local "daysum" matches the one on docker hub's
  # existing manifest for this image, we don't need to rebuild.
  if [ -z "$DISABLE_DAYSUM_QUERY" ]; then
    dh_daysum="$(.helpers/dhdaysum.sh "${DH_REGISTRY_PATH}:${target}")"

    if [ "$dh_daysum" = "$current_daysum" ]; then
      # this "SKIP BUILD" string is grepped for by skip_if_no_build
      printf 'current local daysum: %s matches DH daysum. SKIP BUILD.\n' \
        "$current_daysum" | tee "$build_receipt"
      return
    fi

    printf 'DH daysum: %s != current local daysum: %s. REBUILD REQUIRED.\n' \
      "$dh_daysum" \
      "$current_daysum"
  fi

  docker build \
    --label "com.galvanist.daysum=${current_daysum}" \
    --label "org.opencontainers.image.revision=${GITHUB_SHA:-unknown}" \
    --label "org.opencontainers.image.source=https://github.com/${GITHUB_REPOSITORY:-unknown}" \
    --tag "$local_tag" \
    "$target" \
  || die "build failed"
}

skip_if_no_build() {
  target="$1"; shift
  [ -n "$target" ] || die "skip_if_no_build requires target arg"

  build_receipt="${target}-build-rcpt.txt"
  grep "SKIP BUILD" "$build_receipt" 2>/dev/null && exit 0
}

postbuild() {
  target="$1"; shift
  [ -n "$target" ] || die "postbuild requires target arg"

  skip_if_no_build "$target"

  postbuild_file="${target}/.postbuild.sh"
  if [ -f "$postbuild_file" ]; then
    # shellcheck source=/dev/null
    . "$postbuild_file"
  fi
}

ghpush() {
  target="$1"; shift
  [ -n "$target" ] || die "ghpush requires target arg"

  local_tag="$1"; shift
  [ -n "$local_tag" ] || die "ghpush requires local_tag arg"

  skip_if_no_build "$target"

  push_registry_tag "$local_tag" "${GH_REGISTRY_PATH}/${target}:latest" \
  || die "ghpush failed"
}

dhpush() {
  target="$1"; shift
  [ -n "$target" ] || die "dhpush requires target arg"

  local_tag="$1"; shift
  [ -n "$local_tag" ] || die "dhpush requires local_tag arg"

  skip_if_no_build "$target"

  push_registry_tag "$local_tag" "${DH_REGISTRY_PATH}:${target}" \
  || die "dhpush failed"
}

push_registry_tag() {
  local_tag="$1"; shift
  [ -n "$local_tag" ] || die "push_registry_tag requires local_tag arg"

  registry_tag="$1"; shift
  [ -n "$registry_tag" ] || die "push_registry_tag requires registry_tag arg"

  docker tag "$local_tag" "$registry_tag" \
  || die "Couldn't tag ${local_tag} with registry tag ${registry_tag}"

  docker push "$registry_tag" \
  || die "Couldn't push registry tag ${registry_tag}"
}

postpush() {
  target="$1"; shift
  [ -n "$target" ] || die "postpush requires target arg"

  local_tag="$1"; shift
  [ -n "$local_tag" ] || die "postpush requires local_tag arg"

  skip_if_no_build "$target"

  postpush_file="${target}/.postpush.sh"
  if [ -f "$postpush_file" ]; then
    # shellcheck source=/dev/null
    . "$postpush_file"
  fi
}

main() {
  command="$1"; shift
  [ -n "$command" ] || {
    warn "didn't get a command argument"
    usage
  }

  target="$1"; shift
  [ -n "$target" ] || {
    warn "didn't get a target argument"
    usage
  }

  # strip the receipt suffix if there is one
  target="${target%-*-rcpt.txt}"
  local_tag="${LOCAL_IMG_PREFIX}${target}"

  case "$command" in 
    build|postbuild|ghpush|dhpush|postpush)
      "$command" "$target" "$local_tag"
      ;;

    *)
      die "Unknown command ${command}"
      ;;
  esac

  exit 0
}

[ -n "$IMPORT" ] || main "$@"
