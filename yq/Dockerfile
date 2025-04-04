FROM backplane/ghlatest AS dl
RUN ghlatest download --current-arch --current-os --filter '[^g][^z]$' -o yq mikefarah/yq

FROM scratch
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
COPY --from=dl /work/yq /

WORKDIR /work
USER 65532:65532
ENTRYPOINT ["/yq"]
