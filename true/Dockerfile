FROM alpine:3 as builder
RUN apk add --no-cache gcc musl-dev
RUN set -eux; \
  printf 'int main(void) { return 0; }\n' >true.c; \
  time gcc -Wl,--gc-sections -static -Os -s -fdata-sections -ffunction-sections -o true true.c; \
  wc -c true; \
  time strip --strip-all --remove-section=.comment true; \
  wc -c true; \
  ./true

FROM scratch

COPY --from=builder true /

ENTRYPOINT ["/true"]
