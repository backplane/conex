FROM alpine:3 as builder
RUN apk add --no-cache gcc musl-dev
RUN set -eux; \
  printf 'int main(void) { return 0; }\n' >true.c; \
  time gcc -Wall -O3 -static -s -o true true.c; \
  ./true; \
  du -k true;

FROM scratch

COPY --from=builder true /

ENTRYPOINT ["/true"]
