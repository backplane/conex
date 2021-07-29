FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

ARG KOTLINC_URL="https://github.com/JetBrains/kotlin/releases/download/v1.3.70/kotlin-compiler-1.3.70.zip"
ARG KOTLINC_SHA512="13ed11fc82f1a20930589e578c9e247e88a5a5250eea966d7604766e219513d161bca65ee8255fc1cc370f738908957481fc829135e14a958f60626ea9ec99dd"

# you can make the image smaller by setting these image build args to empty
# strings
ARG INTERACTIVE_EXTRAS="nano vim"
ARG DEV_EXTRAS="gradle"

RUN apk add --no-cache $INTERACTIVE_EXTRAS $DEV_EXTRAS \
    bash \
    openjdk8 \
    openjdk9 \
  && true

ENV JDK_19="/usr/lib/jvm/java-9-openjdk"
ENV JDK_18="/usr/lib/jvm/java-8-openjdk"
ENV JDK_17="$JDK_18"
ENV JDK_16="$JDK_18"

RUN set -x \
  && wget -q \
    -O "kotlinc.zip" \
    "$KOTLINC_URL" \
  && printf '%s  %s\n' "$KOTLINC_SHA512" "kotlinc.zip" | sha512sum -cw \
  && unzip -d / kotlinc.zip \
  && rm kotlinc.zip

ENV PATH="/kotlinc/bin/:$PATH"

WORKDIR /work

ENTRYPOINT [ "/kotlinc/bin/kotlinc" ]
