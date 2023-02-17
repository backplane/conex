FROM backplane/ghlatest as getter

ARG TARGETARCH
RUN ghlatest dl -f "linux_${TARGETARCH}$" -o yq mikefarah/yq

FROM scratch
COPY --from=getter /work/yq /
WORKDIR /work
USER 65532
ENTRYPOINT ["/yq"]
