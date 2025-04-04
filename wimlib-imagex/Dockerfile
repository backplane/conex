FROM alpine:edge AS builder

# for updates, see: https://wimlib.net/downloads/index.html
ARG TAG="v1.14.4"

RUN set -eux; \
  apk add --no-cache \
    autoconf \
    automake \
    file \
    fuse3-dev \
    gcc \
    git \
    libtool \
    libxml2-dev \
    linux-headers \
    make \
    musl-dev \
    ntfs-3g-dev \
    openssl-dev \
    pkgconf \
  ;


WORKDIR /build
RUN git clone "git://wimlib.net/wimlib" /build

COPY patch /patch/
RUN set -eux; \
  ( [ -z "$TAG" ] || git checkout "tags/${TAG}" -b "$TAG" ); \
  find /patch -type f -print | xargs -r -t -n 1 git apply; \
  ./bootstrap; \
  ( ./configure --prefix=/usr --disable-dependency-tracking || ( cat "config.log"; false ) ); \
  make install

FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

RUN set -eux; \
  apk add --no-cache \
    fuse3 \
    libxml2 \
    ntfs-3g \
    xz-libs \
  ;

COPY --from=builder /usr/bin/wimlib-imagex /usr/bin/mkwinpeimg /usr/bin/
COPY --from=builder /usr/lib/libwim.so.?? /usr/lib/

RUN set -eux; \
  for name in \
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
