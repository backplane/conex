#!/bin/sh

DEPTH=${DEPTH:-32}
GEOMETRY=${GEOMETRY:-1700x800}
PASSWD_FILE=${PASSWD_FILE:-/tmp/vncpasswd}

if [ -f "$PASSWD_FILE" ]; then
    printf '%s\n%s\n%s\n' \
      "#############################" \
      "Using existing vncpasswd file" \
      "#############################"
else
    # the password file does not exist, so we generate a session-specific
    # password
    PASSWD="$(perl -e 'print STDOUT int(10000000 + rand(89999999));')"

    printf '%s\n%s\n%s\n' \
      "##########################" \
      "Session password: $PASSWD" \
      "##########################"

    printf '%s\n' "$PASSWD" | tigervncpasswd -f >"$PASSWD_FILE"
fi

touch "$HOME/.Xauthority"
sh -c "dbus-uuidgen >/var/lib/dbus/machine-id" 2>/dev/null

vncserver \
  :0 \
  -depth "$DEPTH" \
  -geometry "$GEOMETRY" \
  -fg \
  -PasswordFile "$PASSWD_FILE" \
  -xstartup "startlxde" \
  -interface 0.0.0.0 \
  -localhost 0
