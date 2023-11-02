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
  desired_len="$1"; shift
  style="$1"; shift
  message="$*"

  message_len="${#message}"
  # short-circuit if we don't have any padding to add
  if [ "$message_len" -gt "$desired_len" ]; then
    # overflow rather than truncate (for now)
    tprint -n "$style" "$message"
    return
  fi

  padding_len=$(( desired_len - message_len ))
  left_pad_len=$(( padding_len / 2 ))
  right_pad_len=$(( padding_len - left_pad_len ))

  # we just need to build two strings of spaces to print before and after the
  # styled text
  left_pad="$(printf "%${left_pad_len}s" '')"
  right_pad="$(printf "%${right_pad_len}s" '')"

  printf '%s%s%s' "$left_pad" "$(tprint -n "$style" "$message")" "$right_pad"
}

usage() {
  [ -n "$*" ] && printf 'ERROR: %s\n\n' "$*"
  printf '%s\n' \
    "Usage: blampy [-h|--help] [-d|--debug] [utility_selection(s)] [--watch] [source_file [...]]" \
    "" \
    "Container which reformats and checks python source code" \
    "" \
    "Source Files vs REPL" \
    " The source_file arguments you give are passed to all the utilities (or" \
    " the utilities you select (see below). If no source_file arguments are" \
    " given, the container run the bpython REPL instead." \
    "" \
    " -h / --help           Prints this message" \
    " -d / --debug          Enables the POSIX shell '-x' flag which prints" \
    "                       commands and results as they are run" \
    "" \
    "Utilities" \
    " The following utilties are available. By default the container runs them" \
    " all. Alternatively, you may use the flags below to specify which" \
    " utilities to run and in what order (flag repetition is honored)." \
    "" \
    " --black               Run the black code formatting utility" \
    "                       NOTE: BLACK ALTERS YOUR SOURCE FILES DIRECTLY" \
    " --pylint              Run the pylint code linter" \
    " --pycodestyle         Run the pycodestyle error checker" \
    " --mypy                Run the mypy type checker" \
    "" \
    "Watch Mode" \
    " --watch               In watch mode the container runs forever watching" \
    "                       for changes in the given source files. When they" \
    "                       change, the selected utilities are run on them" \
    "                       again" \
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

blampy() {
  # GIVE IT THE WORKS!
  utils=$1; shift

  # word-splitting desired here
  for util in $utils; do
    note "$util"
    case "$util" in
      black)
        black "$@"
        ;;

      pylint)
        pylint "--disable=${PYLINT_IGNORE}" "$@" || true
        ;;

      pycodestyle)
        pycodestyle "--ignore=${PYCODESTYLE_IGNORE}" "$@" || true
        ;;

      mypy)
        mypy "$@"
        ;;

      *)
        die "unknown util \"${util}\" requested"
    esac
  done
}

watch_loop() {
  # watch the given paths for FS changes; when they change... BLAMPY!
  utils=$1; shift
  note watching
  while /usr/bin/inotifywait -e modify "$@"; do
    blampy "$utils" "$@"  # fixme: one day: probably best to only re-check the changed items
    note watching
  done
}

main() {
  watch_mode=""
  utils=""

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

      --black)
        utils="${utils} black"
        ;;

      --pylint)
        utils="${utils} pylint"
        ;;

      --pycodestyle)
        utils="${utils} pycodestyle"
        ;;

      --mypy)
        utils="${utils} mypy"
        ;;

      --watch)
        watch_mode=1
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
    # if there were no positional arguments then run bpython
    bpython
    exit
  fi

  if [ -z "$utils" ]; then
    # if no specific util was requested, we will run them all
    utils="black pylint pycodestyle mypy"
  fi

  blampy "$utils" "$@"

  # in watch mode we run forever, waiting for filesystem changes to trigger
  # another (responsible) run of BLAMPY! YAY!
  [ -n "$watch_mode" ] && watch_loop "$utils" "$@"

  exit 0
}

[ -n "$IMPORT" ] || main "$@"
