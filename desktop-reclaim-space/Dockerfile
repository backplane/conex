FROM justincormack/nsenter1
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
LABEL upstream="https://github.com/djs55/desktop-reclaim-space"
ENTRYPOINT ["/usr/bin/nsenter1", "/sbin/fstrim", "/var/lib/docker"]
