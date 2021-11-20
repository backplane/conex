FROM backplane/ghlatest as getter

COPY arch.sh /

RUN set -eux; \
  /ghlatest dl -f "linux_$(/arch.sh)$" -o /yq mikefarah/yq

FROM scratch
COPY --from=getter /yq /
WORKDIR /work
USER 1000
ENTRYPOINT ["/yq"]
