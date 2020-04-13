FROM alpine:edge
LABEL maintainer="Ben Burke <glvnst@users.noreply.github.com>"

RUN apk add --no-cache \
    py3-pip \
    python3 \
    yaml \
  && find / -name '__pycache__' -type d -print0 | xargs -0 rm -rf --

COPY [ "requirements.txt", "/" ]

RUN pip3 install \
    -r /requirements.txt \
  && find / -name '__pycache__' -type d -print0 | xargs -0 rm -rf --

COPY [ "compose_sort.py", "/compose_sort" ]

WORKDIR /work

ENTRYPOINT [ "/usr/bin/python3", "/compose_sort" ]
