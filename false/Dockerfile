FROM alpine:3 as builder
RUN apk add --no-cache gcc musl-dev
RUN set -eux; \
  printf '%s\n' 'int main(void) { return 1; }' >false.c; \
  time gcc -Wall -O3 -static -s -o false false.c; \
  # run the test suite
  if ./false; then exit 1; else :; fi; \
  du -h false;


FROM scratch

COPY --from=builder false /

ENTRYPOINT ["/false"]
