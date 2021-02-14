#!/bin/sh
# blampy: python dev utility continer
set -e

PYLINT_IGNORE="${PYLINT_IGNORE:-C0301,R0913}"
PYCODESTYLE_IGNORE="${PYCODESTYLE_IGNORE:-E501}"

warn() {
  printf '%s %s\n' "$(date '+%FT%T')" "$*" >&2
}

die() {
  warn "FATAL:" "$@"
  exit 1
}

tprint() {
  # Usage: tprint [-p|-n] [-d] spec message [...]
  # spec is one or more dash-separated keywords such as
  # bright-underscore-magenta-bgblue
  # messge is the message to print
  # additional arguments will be concatenated into the message

  # arg parse
  while getopts "dnp" _opt; do
    case "$_opt" in
      'p')
        _output_mode='bash-prompt'
        ;;

      'n')
        _output_mode='no-newline'
        ;;

      'd')
        _tprint_debug='1'
        ;;

      *)
        warn "tprint: Unknown option ${_opt} IGNORING"
    esac
  done
  shift $(( OPTIND - 1 ))
  _spec="$1"; shift
  _message="$*"

  # init
  _term_codes=''

  # spec parse
  _old_IFS="$IFS"
  IFS="-"
  for _keyword_item in \
    'reset:0' \
    'bright:1' \
    'dim:2' \
    'standout:3' \
    'underscore:4' \
    'blink:5' \
    'reverse:6' \
    'black:30' \
    'red:31' \
    'green:32' \
    'yellow:33' \
    'blue:34' \
    'magenta:35' \
    'cyan:36' \
    'white:37' \
    'default:38' \
    'fgblack:30' \
    'fgred:31' \
    'fggreen:32' \
    'fgyellow:33' \
    'fgblue:34' \
    'fgmagenta:35' \
    'fgcyan:36' \
    'fgwhite:37' \
    'fgdefault:38' \
    'bgblack:40' \
    'bgred:41' \
    'bggreen:42' \
    'bgyellow:43' \
    'bgblue:44' \
    'bgmagenta:45' \
    'bgcyan:46' \
    'bgwhite:47' \
    'bgdefault:48' \
  ; do
    _keyword="${_keyword_item%%:*}"
    _code="${_keyword_item##*:}"
    # search the entire spec for this keyword and add it if it exists
    for _substr in $_spec; do
      [ "$_substr" = "$_keyword" ] && _term_codes="${_term_codes}${_code};"
    done
  done
  IFS="$_old_IFS"

  # strip the trailing ; if needed
  _term_codes="${_term_codes%%;}"

  [ -n "$_tprint_debug" ] && printf "term codes: %s\n" "$_term_codes" >&2

  # print
  if [ "$_output_mode" = "bash-prompt" ]; then
    printf '\[\e[%sm\]%s\[\e[0m\]' "$_term_codes" "$_message"
  else
    printf '\e[%sm%s\e[0m' "$_term_codes" "$_message"
    [ "$_output_mode" != "no-newline" ] && printf '\n'
  fi

  # it is critical to unset OPTIND here otherwise things will go Trump
  unset \
    _code \
    _fmt \
    _keyword \
    _keyword_item \
    _message \
    _old_IFS \
    _opt \
    _output_mode \
    _spec \
    _term_codes \
    _tprint_debug \
    OPTIND
}

ccenter() {
  # this function prints a ascii-colorized string center-padded to a given
  # minimum length -- it only considers the visible printing characters when
  # padding. these colorized sequences have a bunch of non-printing characters
  # that affect the string length, which frustrates formatting attempts with
  # printf or something like column
  desired_length="$1"; shift
  style="$1"; shift
  message="$*"

  # step 1, build a string which will be used later as a format arg for printf
  # it will look like this: '%s         ' with the proper number of trailing
  # spaces
  message_length="${#message}"
  total_padding=$(( desired_length - message_length ))
  left_pad_len=$(( total_padding / 2 ))
  right_pad_len=$(( total_padding - left_pad_len ))

  left_pad="$(printf "%${left_pad_len}s" '')"
  right_pad="$(printf "%${right_pad_len}s" '')"

  # short-circuit if we don't have any padding to add
  if [ "$message_length" -gt "$desired_length" ]; then
    # overflow rather than truncate (for now)
    tprint "$style" "$message"
    return
  fi

  # step 2, print the colorized message using the format string
  printf '%s%s%s' "$left_pad" "$(tprint -n "$style" "$message")" "$right_pad"
}

usage() {
  [ -n "$*" ] && printf 'ERROR: %s\n\n' "$*"
  printf '%s\n' \
    "Usage: blampy [-h|--help] [-d|--debug] [source_file [...]]" \
    "" \
    "This script checks python code or runs a REPL." \
    "" \
    " -h / --help           Prints this message" \
    " -d / --debug          Enables the POSIX shell '-x' flag which prints commands and results as they are run" \
    "" \
    "" \
  >&1
  [ -n "$*" ] && exit 1
  exit 0
}

note() {
  tprint -n dim-cyan '>>>>>>>>>>>>>>>>>>'
  ccenter 13 bright-standout "$*"
  tprint dim-cyan '<<<<<<<<<<<<<<<<<<'
}

main() {
  # argument processing loop
  while true; do
    ARG="$1"; shift || break

    case "$ARG" in
      -d|--debug)
        set -x
        ;;

      -h|--help)
        usage
        ;;

      --)
        break
        ;;

      *)
        if [ -f "$ARG" ]; then
          # put the arg back and end argument processing
          set -- "$ARG" "$@"
          break
        fi
        usage "Unknown argument \"${ARG}\""
        ;;
    esac
  done

  if [ -z "$*" ]; then
    # if there were no arguments then run bpython
    bpython
    exit
  fi

  note black
  black "$@"

  note pylint
  pylint "--disable=${PYLINT_IGNORE}" "$@" || true

  note pycodestyle
  pycodestyle "--ignore=${PYCODESTYLE_IGNORE}" "$@" || true

  note mypy
  mypy "$@"

  exit 0
}

[ -n "$IMPORT" ] || main "$@"
