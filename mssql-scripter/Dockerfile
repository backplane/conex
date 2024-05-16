FROM backplane/ghlatest as dl
RUN set -eux; \
  mkdir -p /work/mssqltoolsservice; \
  cd /work/mssqltoolsservice; \
  ghlatest download \
    -f ServiceLayer \
    --current-arch \
    --current-os \
    --rm \
    --extract \
    microsoft/sqltoolsservice;

FROM python:3-slim
ARG DEBIAN_FRONTEND=noninteractive
ARG AG="apt-get -yq --no-install-recommends"
RUN set -eux; \
  $AG update; \
  $AG upgrade; \
  $AG install \
    curl \
    libicu72 \
    libssl3 \
  ; \
  $AG autoremove; \
  $AG clean; \
  rm -rf /var/lib/apt/lists/*;

ENV MSSQLTOOLSSERVICE_PATH="/opt/mssqltoolsservice"
ENV PYTHONIOENCODING="utf_8"
COPY --from=dl /work/mssqltoolsservice /opt/mssqltoolsservice

RUN set -eux; \
  pip install --upgrade pip; \
  pip install \
    mssql-scripter \
  ; \
  pip cache purge;

WORKDIR /app
ENTRYPOINT ["python3", "-m", "mssqlscripter"]
