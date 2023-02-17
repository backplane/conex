FROM backplane/ghlatest as dl

ARG TARGETARCH
RUN ghlatest dl -f "linux_${TARGETARCH}" -o snakeeyes.tgz glvnst/snakeeyes
RUN tar -xvzf snakeeyes.tgz

FROM scratch
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
COPY --from=dl /work/snakeeyes /
# nonroot
USER 65532
ENTRYPOINT ["/snakeeyes"]
