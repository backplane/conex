#!/bin/sh
# minidlnad entrypoint
SELF=$(basename "$0" ".sh")

usage() {
  exception="${1:-}"
  [ -n "$exception" ] && printf 'ERROR: %s\n\n' "$exception"

  printf '%s\n' \
    "Usage: $SELF [-h|--help] [arg [...]]" \
    "" \
    "-h / --help   show this message" \
    "-d / --debug  print additional debugging messages" \
    "" \
    "starts minidlnad with the given arguments" \
    "" # no trailing slash

  [ -n "$exception" ] && exit 1
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
  # arg-processing loop
  while [ $# -gt 0 ]; do
    arg="$1" # shift at end of loop; if you break in the loop don't forget to shift first
    case "$arg" in
      -h|-help|--help)
        usage
        ;;

      -d|--debug)
        set -x
        ;;

      --mega-turtles)
        usage "You can't handle MEGA-TURTLES."
        ;;

      --)
        shift || true
        break
        ;;

      *)
        # unknown arg, leave it back in the positional params
        break
        ;;
    esac
    shift || break
  done

  # ensure required environment variables are set
  # : "${USER:?the USER environment variable must be set}"
  export \
    MINIDLNA_ALBUM_ART_NAMES="${MINIDLNA_ALBUM_ART_NAMES:-Cover.jpg/cover.jpg/AlbumArtSmall.jpg/albumartsmall.jpg/AlbumArt.jpg/albumart.jpg/Album.jpg/album.jpg/Folder.jpg/folder.jpg/Thumb.jpg/thumb.jpg}" \
    MINIDLNA_DB_DIR="${MINIDLNA_DB_DIR:-/db/minidlnad}" \
    MINIDLNA_ENABLE_SUBTITLES="${MINIDLNA_ENABLE_SUBTITLES:-yes}" \
    MINIDLNA_ENABLE_TIVO="${MINIDLNA_ENABLE_TIVO:-no}" \
    MINIDLNA_FRIENDLY_NAME="${MINIDLNA_FRIENDLY_NAME:-MiniDLNA}" \
    MINIDLNA_INOTIFY="${MINIDLNA_INOTIFY:-yes}" \
    MINIDLNA_LOG_DIR="${MINIDLNA_LOG_DIR:-/var/log}" \
    MINIDLNA_LOG_LEVEL="${MINIDLNA_LOG_LEVEL:-general,artwork,database,inotify,scanner,metadata,http,ssdp,tivo=warn}" \
    MINIDLNA_MAX_CONNECTIONS="${MINIDLNA_MAX_CONNECTIONS:-50}" \
    MINIDLNA_MEDIA_DIR="${MINIDLNA_MEDIA_DIR:-/data}" \
    MINIDLNA_MERGE_MEDIA_DIRS="${MINIDLNA_MERGE_MEDIA_DIRS:-no}" \
    MINIDLNA_MODEL_NUMBER="${MINIDLNA_MODEL_NUMBER:-1}" \
    MINIDLNA_NOTIFY_INTERVAL="${MINIDLNA_NOTIFY_INTERVAL:-900}" \
    MINIDLNA_PORT="${MINIDLNA_PORT:-8200}" \
    MINIDLNA_PRESENTATION_URL="${MINIDLNA_PRESENTATION_URL:-http://www.mylan/index.php}" \
    MINIDLNA_ROOT_CONTAINER="${MINIDLNA_ROOT_CONTAINER:-.}" \
    MINIDLNA_SERIAL="${MINIDLNA_SERIAL:-12345678}" \
    MINIDLNA_STRICT_DLNA="${MINIDLNA_STRICT_DLNA:-no}" \
    MINIDLNA_TIVO_DISCOVERY="${MINIDLNA_TIVO_DISCOVERY:-beacon}" \
    MINIDLNA_WIDE_LINKS="${MINIDLNA_WIDE_LINKS:-no}"
  
  # the following options are commented-out in the config file (but you should still export them here)
  export \
    MINIDLNA_FORCE_SORT_CRITERIA="${MINIDLNA_FORCE_SORT_CRITERIA:-+upnp:class,+upnp:originalTrackNumber,+dc:title}" \
    MINIDLNA_MINISSDPDSOCKET="${MINIDLNA_MINISSDPDSOCKET:-/var/run/minissdpd.sock}" \
    MINIDLNA_NETWORK_INTERFACE="${MINIDLNA_NETWORK_INTERFACE:-eth0}" \
    MINIDLNA_USER="${MINIDLNA_USER:-jmaggard}"

  # fill in the config file template from the environment variables
  envsubst \
    </etc/minidlna.conf.tmpl \
    >/tmp/minidlna.conf

  # start the server in the foreground
  exec /usr/sbin/minidlnad \
    -d \
    -P /tmp/minidlnad.pid \
    -f /tmp/minidlna.conf \
    "$@"
}

main "$@"

