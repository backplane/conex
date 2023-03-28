FROM backplane/ghlatest as dl
RUN set -eux; \
  mkdir -p /work/mssqltoolsservice; \
  cd /work/mssqltoolsservice; \
  ghlatest download \
    -f ServiceLayer \
    -f rhel \
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
    libicu67 \
    libssl1.1 \
  ; \
  $AG autoremove; \
  $AG clean; \
  rm -rf /var/lib/apt/lists/*;

RUN set -eux; \
  pip install --upgrade pip; \
  pip install \
    mssql-scripter \
  ; \
  pip cache purge;

ENV MSSQLTOOLSSERVICE_PATH="/opt/mssqltoolsservice"
ENV PYTHONIOENCODING="utf_8"
COPY --from=dl /work/mssqltoolsservice /opt/mssqltoolsservice

WORKDIR /app
ENTRYPOINT ["python3", "-m", "mssqlscripter"]
