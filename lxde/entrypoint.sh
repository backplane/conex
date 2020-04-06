#!/bin/sh

INTERFACE="${INTERFACE:-0.0.0.0}"
DEPTH="${DEPTH:-32}"
GEOMETRY="${GEOMETRY:-1700x800}"
VNC_PASSWORD_FILE="${VNC_PASSWORD_FILE:-/tmp/vncpasswd}"

if [ -f "$VNC_PASSWORD_FILE" ]; then
    printf '%s\n%s\n%s\n' \
      "#############################" \
      "Using existing vncpasswd file" \
      "#############################"
else
    # the password file does not exist, so we generate a session-specific
    # password (and print it to the console/logs)
    printf '%s\n%s' \
      "##########################" \
      "Session password: "

    { openssl rand -hex 4 \
      | tee /dev/stderr \
      | tigervncpasswd -f >"$VNC_PASSWORD_FILE"; } 2>&1

    printf '%s\n' \
      "##########################"
fi

touch "$HOME/.Xauthority"

dbus-uuidgen --ensure

exec vncserver \
  :0 \
  -depth "$DEPTH" \
  -geometry "$GEOMETRY" \
  -fg \
  -PasswordFile "$VNC_PASSWORD_FILE" \
  -xstartup "/usr/bin/startlxde" \
  -interface "$INTERFACE" \
  -localhost no \
  "$@"
