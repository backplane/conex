FROM alpine:edge as downloader

# for ABE updates, see:
# https://github.com/nelenkov/android-backup-extractor/releases
ARG ABE_VERSION="20210709062403-4c55371"
ENV ABE_URL="https://github.com/nelenkov/android-backup-extractor/releases/download/${ABE_VERSION}/abe.jar"

RUN apk add --no-cache curl
RUN curl -sSL --tlsv1.3 -o "/abe.jar" "$ABE_URL"

FROM amazoncorretto:16-alpine
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"
LABEL upstream="https://github.com/nelenkov/android-backup-extractor"

COPY --from=downloader /abe.jar /

WORKDIR /work
ENTRYPOINT ["java", "-jar", "/abe.jar"]