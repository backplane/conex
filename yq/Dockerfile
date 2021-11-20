FROM backplane/ghlatest as getter

RUN /ghlatest dl -f "linux_$(/arch.sh)$" -o /yq mikefarah/yq

FROM scratch
COPY --from=getter /yq /
WORKDIR /work
USER 1000
ENTRYPOINT ["/yq"]
