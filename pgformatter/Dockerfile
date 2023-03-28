FROM backplane/ghlatest as downloader

RUN set -eux; \
  mkdir -p /work/pgFormatter; \
  cd /work/pgFormatter; \
  ghlatest download --source --extract --rm darold/pgFormatter; \
  mv /work/pgFormatter/* /work/pgFormatter/src

FROM perl:5-slim
ARG CHARSET=UTF-8

COPY --from=downloader /work/pgFormatter/src /src/
RUN set -eux; \
  cd /src; \
  perl Makefile.PL; \
  make; \
  make install;

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