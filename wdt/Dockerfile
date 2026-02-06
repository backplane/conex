ARG AG="apt-get -yq --no-install-recommends"
ARG DEBIAN_FRONTEND="noninteractive"

FROM debian:unstable AS builder

ARG AG
ARG DEBIAN_FRONTEND

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

# v2025.10.27.00 is the last release with "folly/detail/SplitStringSimd.cpp"
# which is used in wdt's CMakeLists.txt as of 26-Jan-2026
ADD https://github.com/facebook/folly.git#v2025.10.27.00 /build/folly

# yolo; but for reference, known good semver as of 26-Jan-2026 is "v1.27.1612021"
ADD https://github.com/facebook/wdt.git /build/wdt

COPY patches /build/patches/

# we don't need to actually build folly, we just need the source tree to be there (for emotional support)
# WORKDIR /build/folly
# RUN set -eux; \
  # mkdir -p ~/.config/pip; \
  # printf '%s\n' "[global]" "break-system-packages = true" >~/.config/pip/pip.conf; \
  # python3 ./build/fbcode_builder/getdeps.py install-system-deps --allow-system-packages --recursive folly; \
  # python3 ./build/fbcode_builder/getdeps.py --allow-system-packages build folly;

WORKDIR /build/wdt/_build
RUN set -eux; \
  (cd ..; for patch in /build/patches/*; do patch -i "$patch"; done); \
  cmake .. -DBUILD_TESTING=off; \
  make -j$(nproc); \
  make install;

FROM debian:unstable-slim

ARG AG
ARG DEBIAN_FRONTEND

RUN set -eux; \
  $AG update; \
  $AG upgrade; \
  $AG install \
    ca-certificates \
    'libgoogle-glog?v*' \
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
