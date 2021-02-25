FROM galvanist/conex:ghlatest as dl
RUN /ghlatest dl glvnst/snakeeyes -f linux_amd64
RUN tar -xvzf snakeeyes_*_linux_amd64.tar.gz

FROM scratch
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"
COPY --from=dl /work/snakeeyes /
ENTRYPOINT ["/snakeeyes"]
