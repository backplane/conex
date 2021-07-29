FROM koalaman/shellcheck:stable as shellcheck

FROM alpine:edge
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY --from=shellcheck /bin/shellcheck /bin/

RUN set -x \
  && wget "https://raw.githubusercontent.com/kward/shunit2/master/shunit2" \
  && grep '^# Copyright 2008-20\d\d Kate Ward.' shunit2 \
  && sha256sum shunit2 \
  && chmod +x "/shunit2" \
  && true

ENV SHUNIT_PATH /shunit2

COPY [ "runner.sh", "/" ]

WORKDIR /work

ENTRYPOINT [ "/runner.sh" ]
