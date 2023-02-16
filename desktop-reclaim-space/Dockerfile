FROM justincormack/nsenter1
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
LABEL upstream="https://github.com/djs55/desktop-reclaim-space"
ENTRYPOINT ["/usr/bin/nsenter1"]
CMD ["/usr/bin/awk", "/ext4/ {system(\"/sbin/fstrim -v \" $2)}", "/proc/mounts"]
