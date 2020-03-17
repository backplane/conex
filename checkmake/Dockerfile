FROM golang:1-alpine as builder
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    git \
    make \
  && true

WORKDIR /build
RUN set -x \
  && git clone "https://github.com/mrtazz/checkmake" \
  && cd checkmake \
  && export GOOS=linux CGO_ENABLED=0 \
  && make binaries

FROM alpine:edge
COPY --from=builder /build/checkmake /
WORKDIR /work
USER nobody

ENTRYPOINT ["/checkmake"]
CMD [ "--help" ]
