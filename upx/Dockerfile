FROM backplane/ghlatest AS downloader
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

# download the latest upx release
RUN ghlatest download --current-arch -x --keep '^upx-.+?-.+?_linux/?(upx)?$' upx/upx
RUN mv -i upx-*_linux upx-linux

# test upx by compressing the executables in the image
FROM alpine:edge AS alpine
COPY --from=downloader /work/upx-linux/upx /bin/upx
RUN find / \
    -path '*bin/*' \
    -type f \
    -executable \
    -size '+10k' \
    -not -path /bin/upx \
    -exec /bin/upx -- '{}' + \
  ;

# start fresh image so we can benefit from the compression
FROM scratch
COPY --from=alpine / /
CMD /bin/sh
