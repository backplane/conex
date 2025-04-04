FROM golang:1-alpine AS builder

RUN apk add --no-cache \
    git \
    make \
  ;

# Environment variables required or used by the checkmake build system
ARG BUILDER_EMAIL=backplane@users.noreply.github.com
ARG BUILDER_NAME=github.com/backplane/conex
ARG CGO_ENABLED=0
ARG GOOS=linux

WORKDIR /build
RUN set -eux; \
  git clone "https://github.com/mrtazz/checkmake.git"; \
  cd checkmake; \
  git checkout "$(git tag | sort -V | tail -1)"; \
  make binaries;

FROM scratch
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY --from=builder /build/checkmake/checkmake /

USER 65534:65534
WORKDIR /work
ENTRYPOINT [ "/checkmake" ]
CMD [ "--help" ]
