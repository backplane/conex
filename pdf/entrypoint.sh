#!/bin/sh
# wrapper around poppler-util commands


usage() {
  self="pdf"
  [ -n "$*" ] && printf "ERROR: %s\n\n" "$*" >&2

  printf '%s\n' \
    "Usage: ${self} [-h|--help] command [command_options [...]]" \
    '' \
    '"command" is one of the following, which runs the corresponding binary from the poppler-utils package:' \
    '' \
    '* attach - adds a new embedded file (attachment) to a PDF' \
    '* detach - lists or extracts embedded files in a PDF' \
    '* fonts - lists the fonts used in a PDF' \
    '* images - saves images from a PDF' \
    '* info - prints the contents of the "Info" dictionary (and other useful data) of a PDF' \
    '* separate - extract single pages from a PDF' \
    '* tocairo - converts PDF files to other formats such as PNG, JPEG, TIFF, PS, EPS, SVG' \
    '* tohtml - converts PDF files into HTML' \
    '* toppm - converts PDF files to PPM, PGM, or PBM files' \
    '* tops - converts PDF files to PostScript files' \
    '* totext - converts PDF files to text files' \
    '* unite - merges several PDF into one' \
    '' \
    'Each command has additional options (including "-h")' \
    >&2

  exit 1
}


main() {
  cmd="$1"; shift

  [ -n "$cmd" ] || usage

  # if the command begins with pdf, strip that
  cmd="${cmd##pdf}"

  case "$cmd" in
    -h|-help|--help)
      usage
      ;;

    attach|detach|fonts|images|info|separate|tocairo|tohtml|toppm|tops|totext|unite)
      exec "/usr/bin/pdf${cmd}" "$@"
      ;;

    *)
      usage "Unknown command ${cmd}"
      ;;
  esac

  # should be unreachable
  exit 2
}


[ -n "$IMPORT" ] || main "$@"
