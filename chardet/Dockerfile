FROM python:3-alpine
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN pip install chardet
WORKDIR /work
ENTRYPOINT ["/usr/local/bin/chardetect"]