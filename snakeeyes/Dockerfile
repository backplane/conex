FROM backplane/ghlatest as downloader
RUN ghlatest download --current-os --current-arch --extract --rm --keep snakeeyes glvnst/snakeeyes

FROM scratch
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
COPY --from=downloader /work/snakeeyes /
# nonroot
USER 65532
ENTRYPOINT ["/snakeeyes"]
