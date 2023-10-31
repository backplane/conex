FROM backplane/ghlatest as dl
RUN ghlatest download backplane/update_requirements

FROM python:3-alpine
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY --from=dl /work /tmp/dl/
RUN set -eux; \
  pip install /tmp/dl/*.whl; \
  rm -rf /tmp/dl;

ARG NONROOT_GID=65532
ARG NONROOT_UID=65532
RUN set -ex; \
  addgroup \
    -g ${NONROOT_GID} \
    nonroot \
  ; \
  adduser \
    -h /work \
    -u ${NONROOT_UID} \
    -G nonroot \
    -D \
    nonroot \
  ;
USER nonroot

WORKDIR /work
ENTRYPOINT ["/usr/local/bin/python3", "-m", "update_requirements"]