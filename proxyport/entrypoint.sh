#!/bin/sh
# utility container which proxies http connections to remote hosts
SELF="$(basename "$0" ".sh")"

ACL_PATH_ALLOW="/etc/haproxy/allow.acl"
ACL_PATH_DENY="/etc/haproxy/deny.acl"
CONFIG_PATH="/etc/haproxy/haproxy.cfg"
CONFIG_TEMPLATE_PATH="/etc/haproxy/haproxy.cfg.tmpl"
LOCAL_CONFIG_PATH="/etc/haproxy/local.cfg"
TEMPLATE='

frontend f-%s
    bind *:%s
    acl acl_ip_src_allow src -n -f %s
    acl acl_ip_src_deny src -n -f %s
    tcp-request connection reject if acl_ip_src_deny or !acl_ip_src_allow
    default_backend b-%s

backend b-%s
    balance roundrobin
    server static %s

'


usage() {
  exception="$1"
  [ -n "$exception" ] && printf 'ERROR: %s\n\n' "$exception"

  printf '%s\n' \
    "Usage: $SELF [-h|--help] [arg [...]]" \
    "" \
    "-h / --help   show this message" \
    "-d / --debug  print additional debugging messages" \
    "" \
    "allow:<ip_cidr>    add an ACL allow entry for the given IP subnet" \
    "deny:<ip_cidr>     add an ACL deny entry for the given IP subnet" \
    "proxy:<listen_port>:<upstream_host>:<upstream_port>" \
    "                   add a frontend and backend pair that proxies" \
    "                   connections to the given port to the the given" \
    "                   upstream host and port" \
    "" \
    "This container proxies HTTP connections to remote hosts." \
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

append_service() {
  name="$1"
  listen_port="$2"
  upstream_hostport="$3"


  # shellcheck disable=SC2059
  printf "$TEMPLATE" \
    "$name" \
    "$listen_port" \
    "$ACL_PATH_ALLOW" \
    "$ACL_PATH_DENY" \
    "$name" \
    "$name" \
    "$upstream_hostport" \
    >>"$CONFIG_PATH"

  warn "proxying connections on port ${listen_port} to ${upstream_hostport}"
}

append_acl() {
  mode=$1
  pattern=$2
  output_file="/dev/null"

  case "$mode" in
    allow)
      output_file="$ACL_PATH_ALLOW"
      ;;

    deny)
      output_file="$ACL_PATH_DENY"
      ;;

    *)
      die "Unknown ACL arguments: $*"
      ;;
  esac

  printf '%s\n' "$pattern" >>"$output_file"

  warn "${mode}ing connections from ${pattern}"
}

main() {
  # copy the haproxy.cfg.tmpl to haproxy.cfg
  cp -- \
    "$CONFIG_TEMPLATE_PATH" \
    "$CONFIG_PATH" \
    || die "Couldn't copy ${CONFIG_TEMPLATE_PATH} to ${CONFIG_PATH}"

  # if the local config file exists, append it to the main config
  if [ -f "$LOCAL_CONFIG_PATH" ]; then
    warn "Appending the contents of ${LOCAL_CONFIG_PATH} to ${CONFIG_PATH}"
    cat "$LOCAL_CONFIG_PATH" >>"$CONFIG_PATH"
  fi

  # if there are existing ACL files, remove them and warn the user
  for acl_file in "$ACL_PATH_ALLOW" "$ACL_PATH_DENY"; do
    if [ -f "$acl_file" ]; then
      warn "${acl_file} already exists. Removing to prevent double-config."
      unlink "$acl_file" || die "Couldn't remove ${acl_file}! Exiting."
    fi
  done

  # arg-processing loop
  i=0
  acl_allow_defined=""
  acl_deny_defined=""
  while [ $# -gt 0 ]; do
    arg="$1" # shift at end of loop; if you break in the loop don't forget to shift first
    case "$arg" in
      -h|-help|--help)
        usage
        ;;

      -d|--debug)
        set -x
        ;;

      --)
        shift || true
        break
        ;;

      allow:*)
        # argument is in the form allow:<ip_addr>
        ip="$(printf '%s' "$arg" | cut -f 2- -d ':')"
        append_acl "allow" "$ip" || die "failed to apply allow acl entry"
        acl_allow_defined=1
        ;;

      deny:*)
        # argument is in the form deny:<ip_addr>
        ip="$(printf '%s' "$arg" | cut -f 2- -d ':')"
        append_acl "deny" "$ip" || die "failed to apply deny acl entry"
        acl_deny_defined=1
        ;;

      proxy:*:*:*)
        # argument is in the form proxy:<listen_port>:<upstream_host>:<upstream_port>
        listen_port="$(printf '%s' "$arg" | cut -f 2 -d ':')"
        upstream_hostport="$(printf '%s' "$arg" | cut -f 3- -d ':')"
        append_service \
          "$i" \
          "$listen_port" \
          "$upstream_hostport"
        i=$((i+1))
        ;;

      *)
        usage "Unknown argument: ${arg}"
        ;;
    esac
    shift || break
  done

  # ensure required environment variables are set
  # : "${USER:?the USER environment variable must be set}"

  # if either list didn't get set during arg parsing, use some defaults
  [ "$i" = "0" ] && usage "You must define at least one proxy argument"
  [ -z "$acl_allow_defined" ] && append_acl "allow" "127.0.0.1/32"
  [ -z "$acl_deny_defined" ] && append_acl "deny" "203.0.113.0/24" # only RFC5737, a dummy value

  warn "starting haproxy"
  exec tini -- haproxy -f /etc/haproxy/haproxy.cfg "$@"
}

main "$@"; exit
