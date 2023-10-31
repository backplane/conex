FROM backplane/ghlatest as downloader
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN ghlatest dl --current-arch -x --keep '^upx-4.1.0-arm64_linux/?(upx)?$' upx/upx
RUN mv -i upx-*_linux upx-linux

FROM alpine:edge as alpine
RUN apk add --virtual temp-utils file
COPY --from=downloader /work/upx-linux/upx /bin/upx
RUN upx /bin/busybox
RUN find / -type f -executable -print0 | xargs -0 file | grep 'ELF' | cut -f 1 -d ':' >/tmp/executables.txt
RUN apk del --purge temp-utils
RUN rm -rf \
    /var/cache/apk/* \
    ~/.cache \
  ;
RUN set -eux; \
  while read -r FILE; do \
    upx "$FILE" || true; \
  done </tmp/executables.txt; \
  true;


FROM scratch
COPY --from=alpine / /
CMD /bin/sh