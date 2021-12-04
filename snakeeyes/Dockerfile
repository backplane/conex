FROM backplane/ghlatest as dl
RUN set -eux; \
  /ghlatest dl -f "linux_$(/arch.sh)" -o snakeeyes.tgz glvnst/snakeeyes
RUN tar -xvzf snakeeyes.tgz

FROM scratch
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
COPY --from=dl /work/snakeeyes /
# nonroot
USER 65532
ENTRYPOINT ["/snakeeyes"]
