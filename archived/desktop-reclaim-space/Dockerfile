FROM justincormack/nsenter1
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
ENTRYPOINT [ "/usr/bin/nsenter1" ]
CMD [ "/bin/sh", "-c", "set -eu; INTERVAL=\"${INTERVAL:-60}\"; while :; do printf '%s %s %s\\n' \"$(date -u -Iseconds)\" \"desktop-reclaim-space (every ${INTERVAL}s)\"  \"$( /usr/bin/awk '/ext4/ {system(\"/sbin/fstrim -v \" $2); print \";\"}' /proc/mounts | xargs )\"; sleep \"$INTERVAL\"; done; exit" ]
