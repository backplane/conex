FROM debian:unstable AS builder

ARG AG="apt-get -yq --no-install-recommends"
ARG DEBIAN_FRONTEND="noninteractive"

RUN set -eux; \
  $AG update; \
  $AG install \
    binutils-dev \
    ca-certificates \
    cmake \
    g++ \
    git \
    libboost-all-dev \
    libdouble-conversion-dev \
    libevent-dev \
    libfast-float-dev \
    libfmt-dev \
    libgflags-dev \
    libgoogle-glog-dev \
    libgtest-dev \
    libiberty-dev \
    libjemalloc-dev \
    liblz4-dev \
    liblzma-dev \
    libsnappy-dev \
    libssl-dev \
    make \
    patch \
    pkg-config \
    python3.12 \
    wget \
    zlib1g-dev \
  ;

ADD https://github.com/facebook/folly.git /build/folly
ADD https://github.com/facebook/wdt.git /build/wdt

COPY patches /build/patches/

WORKDIR /build/folly
RUN set -eux; \
  echo python3.12 ./build/fbcode_builder/getdeps.py --allow-system-packages build folly

WORKDIR /build/wdt/_build
RUN set -eux; \
  (cd ..; for patch in /build/patches/*; do patch -i "$patch"; done); \
  (cd ..; grep -ir hash .); \
  cmake .. -DBUILD_TESTING=off; \
  make -j$(nproc); \
  make install;


FROM debian:unstable-slim

ARG AG="apt-get -yq --no-install-recommends"
RUN set -eux; \
  $AG update; \
  $AG upgrade; \
  $AG install \
    ca-certificates \
    libgoogle-glog0v6 \
    tini \
  ; \
  $AG autoremove; \
  $AG clean; \
  rm -rf \
    /var/cache/debconf/*-old \
    /var/lib/apt/lists/* \
    /var/lib/dpkg/*-old \
  ;

COPY --from=builder \
  /usr/local/lib/libfolly4wdt.so \
  /usr/local/lib/libwdt_min.so \
  /usr/local/lib/libwdt_min.so.* \
  /usr/local/lib/libwdt.so \
  /usr/local/lib/libwdt.so.* \
  /usr/local/lib/

COPY --from=builder \
  /usr/local/bin/wcp \
  /usr/local/bin/wdt \
  /usr/local/bin/

ENTRYPOINT [ "/usr/bin/tini", "--", "/usr/local/bin/wdt" ]