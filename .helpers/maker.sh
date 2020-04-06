#!/bin/sh

LOCAL_IMG_PREFIX="${LOCAL_IMG_PREFIX:-conex_}"
GH_REGISTRY_PATH="${GH_REGISTRY_PATH:-docker.pkg.github.com/glvnst/conex}"
DH_REGISTRY_PATH="${DH_REGISTRY_PATH:-galvanist/conex}"


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

  .helpers/skip-build.sh "$target" 2>&1 && exit 0

  current_sum="$(.helpers/daysum.sh "$target")"
  [ -n "$current_sum" ] \
  || die "Unable to calculate current context checksum"

  docker build \
    --label "com.galvanist.daysum=${current_sum}" \
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
  # shellcheck source=/dev/null
  [ -f "$postbuild_file" ] && . "$postbuild_file"
  true
}

ghpush() {
  target="$1"; shift
  [ -n "$target" ] || die "ghpush requires target arg"

  local_tag="$1"; shift
  [ -n "$local_tag" ] || die "ghpush requires local_tag arg"

  skip_if_no_build "$target"

  tag="${GH_REGISTRY_PATH}/${target}:latest"
  docker tag "$local_tag" "$tag" || die "Couldn't tag ${local_tag} with gh registry tag ${tag}"
  docker push "$tag" || die "Couldn't push tag ${tag}"
}

dhpush() {
  target="$1"; shift
  [ -n "$target" ] || die "dhpush requires target arg"

  local_tag="$1"; shift
  [ -n "$local_tag" ] || die "dhpush requires local_tag arg"

  skip_if_no_build "$target"

  tag="${DH_REGISTRY_PATH}:${target}"
  docker tag "$local_tag" "$tag" || die "Couldn't tag ${local_tag} with dh registry tag ${tag}"
  docker push "$tag" || die "Couldn't push tag ${tag}"
}

postpush() {
  target="$1"; shift
  [ -n "$target" ] || die "postpush requires target arg"

  local_tag="$1"; shift
  [ -n "$local_tag" ] || die "postpush requires local_tag arg"

  skip_if_no_build "$target"

  postpush_file="${target}/.postpush.sh"
  # shellcheck source=/dev/null
  [ -f "$postpush_file" ] && . "$postpush_file"
  true
}

genreadme() {
  [ -f "README.md" ] || die "Couldn't find existing readme file"

  (
    grep -B 1000 '^## The Images$' README.md

    echo
    # the heading at the top of the readme
    for target in "$@"; do
      readme_file="${target}/README.md"
      [ -f "$target/.skip" ] && continue

      # shellcheck disable=SC2016
      grep --no-filename \
        '^## ' \
        "$readme_file" \
      | sed 's/^## .\(.*\).$/* [`\1`](#\1)/g'
    done

    echo
    # shellcheck disable=SC2016
    for target in "$@"; do
      readme_file="${target}/README.md"
      [ -f "$target/.skip" ] && continue

      cat "$readme_file"
      echo
    done \
    | sed 's/^## .\(.*\).$/## [`\1`](\1)/g'
  ) >README.md.new \
  || die "Couldn't generate new new README.md"

  mv README.md.new README.md
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
  receipt="${target}-${command}-rcpt.txt"
  local_tag="${LOCAL_IMG_PREFIX}${target}"

  case "$command" in 
    build)
      ( set -x; build "$target" "$local_tag" ) >"$receipt" 2>&1 || exit 1
      ;;

    postbuild)
      ( set -x; postbuild "$target" ) >"$receipt" 2>&1 || exit 1
      ;;

    ghpush)
      ( set -x; ghpush "$target" "$local_tag" ) >"$receipt" 2>&1 || exit 1
      ;;

    dhpush)
      ( set -x; postbuild "$target" "$local_tag" ) >"$receipt" 2>&1 || exit 1
      ;;

    postpush)
      ( set -x; postpush "$target" "$local_tag" ) >"$receipt" 2>&1 || exit 1
      ;;

    genreadme)
      ( genreadme "$target" "$@" ) || exit 1
      ;;

    *)
      die "Unknown command ${command}"
      ;;
  esac

  exit 0
}

[ -n "$IMPORT" ] || main "$@"
