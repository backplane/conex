FROM justincormack/nsenter1
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
LABEL upstream="https://github.com/djs55/desktop-reclaim-space"
ENTRYPOINT ["/usr/bin/nsenter1"]
CMD ["/bin/sh", "-c", "for mnt in /var/lib /containers/services; do fstrim -v \"$mnt\"; done"]
