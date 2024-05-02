FROM backplane/ghlatest AS downloader
RUN ghlatest --verbosity debug download --current-arch --current-os --extract --rm backplane/registryproxy

FROM alpine:3 AS alpine
RUN apk add --no-cache \
    ca-certificates \
  ;

FROM busybox:musl
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY --from=downloader /work/registryproxy /bin/
COPY --from=alpine /etc/ssl/certs /etc/ssl/certs

USER 65534:65534
WORKDIR /work
ENTRYPOINT ["/bin/registryproxy"]
