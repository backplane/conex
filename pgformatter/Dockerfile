FROM backplane/ghlatest AS dl
RUN ghlatest download --source --extract --rm darold/pgformatter
RUN mv darold-pgFormatter-* src

FROM perl:5.40-slim AS builder
ARG CHARSET=UTF-8
WORKDIR /work

COPY --from=dl /work/src /work/src
RUN set -eux; \
  cd src; \
  perl Makefile.PL; \
  make; \
  make install; \
  cd /; \
  rm -rf /work

FROM scratch
ARG CHARSET=UTF-8
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
COPY --from=builder / /

# Add non-privileged user
RUN set -eux; \
  groupadd -g 65532 nonroot; \
  useradd --no-log-init -u 65532 -g nonroot nonroot; \
  mkdir -p /home/nonroot /work; \
  chown -R nonroot:nonroot /home/nonroot /work;

# Run as non-privileged user
USER nonroot
VOLUME [ "/work" ]
WORKDIR /work

ENTRYPOINT [ "/usr/local/bin/pg_format" ]
