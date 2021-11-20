FROM backplane/ghlatest as dl
COPY arch.sh /arch.sh
RUN set -eux; \
  /ghlatest dl -f "linux_$(/arch.sh)" -o snakeeyes.tgz glvnst/snakeeyes
RUN tar -xvzf snakeeyes.tgz

FROM scratch
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
COPY --from=dl /work/snakeeyes /
ENTRYPOINT ["/snakeeyes"]
