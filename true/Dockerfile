FROM alpine:edge AS builder
ARG EXIT_CODE=0

RUN apk add --no-cache gcc musl-dev

RUN set -eux; \
  printf '%s\n' \
    'int main(void) {' \
    "  return ${EXIT_CODE};" \
    '}' \
    >exit.c; \
  time gcc -Wl,--gc-sections -static -Os -s -fdata-sections -ffunction-sections -o exit exit.c; \
  time strip --strip-all --remove-section=.comment exit;

FROM scratch

COPY --from=builder exit /true

ENTRYPOINT ["/true"]
