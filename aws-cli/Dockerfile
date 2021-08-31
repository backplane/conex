FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN apk add --no-cache aws-cli
COPY [ "entrypoint.sh", "/" ]

ARG NONROOT_GID=10001
ARG NONROOT_UID=10001
RUN set -ex \
  && addgroup \
    -g ${NONROOT_GID} \
    nonroot \
  && adduser \
    -h /work \
    -u ${NONROOT_UID} \
    -G nonroot \
    -D \
    nonroot
USER nonroot
WORKDIR /work

ENTRYPOINT [ "/entrypoint.sh" ]
