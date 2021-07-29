FROM alpine:3.13 as builder

ARG TAG="v1.13.3"

RUN set -x \
  && apk add --no-cache \
    autoconf \
    automake \
    file \
    fuse-dev \
    gcc \
    git \
    libtool \
    libxml2-dev \
    make \
    musl-dev \
    ntfs-3g-dev \
    openssl-dev \
    pkgconf \
  && true

WORKDIR /build

RUN set -x \
  && git clone "git://wimlib.net/wimlib" . \
  && ( [ -z "$TAG" ] || git checkout "tags/${TAG}" -b "$TAG" ) \
  && ./bootstrap \
  && ( ./configure --prefix=/usr --disable-dependency-tracking || ( cat "config.log"; false ) ) \
  && make install

FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -x \
  && apk add --no-cache \
    fuse \
    libxml2 \
    ntfs-3g \
    xz-libs \
  && true

COPY --from=builder /usr/bin/wimlib-imagex /usr/bin/mkwinpeimg /usr/bin/
COPY --from=builder /usr/lib/libwim.so.?? /usr/lib/

RUN set -x \
  && for name in \
    wimappend \
    wimapply \
    wimcapture \
    wimdelete \
    wimdir \
    wimexport \
    wimextract \
    wiminfo \
    wimjoin \
    wimmount \
    wimmountrw \
    wimoptimize \
    wimsplit \
    wimunmount \
    wimupdate \
    wimverify \
  ; do \
    ln -s /usr/bin/wimlib-imagex "/usr/bin/${name}"; \
  done

WORKDIR /work

ENTRYPOINT [ "/usr/bin/wimlib-imagex" ]
