FROM golang:1-alpine as builder

RUN apk add --no-cache \
    git \
    make \
  && true

# Environment variables required by the checkmake build system
ARG BUILDER_NAME=github.com/backplane/conex
ARG BUILDER_EMAIL=backplane@users.noreply.github.com

WORKDIR /build
RUN set -x \
  && git clone "https://github.com/mrtazz/checkmake" \
  && cd checkmake \
  && export GOOS=linux CGO_ENABLED=0 \
  && make binaries

FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY --from=builder /build/checkmake /
WORKDIR /work
USER nobody

ENTRYPOINT ["/checkmake"]
CMD [ "--help" ]
