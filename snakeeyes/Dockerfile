FROM backplane/ghlatest as dl
COPY arch.sh /arch.sh
RUN set -eux; \
  /ghlatest dl glvnst/snakeeyes -f "linux_$(/arch.sh)"
RUN tar -xvzf snakeeyes_*_linux_amd64.tar.gz

FROM scratch
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
COPY --from=dl /work/snakeeyes /
ENTRYPOINT ["/snakeeyes"]
