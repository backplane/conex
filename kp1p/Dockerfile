FROM python:3-alpine AS builder
COPY kp1p /kp1p
RUN python -m zipapp -p "/usr/bin/env python3" --compress kp1p

FROM python:3-alpine
LABEL maintainer="Backplane BV <backplane@users.noreply.github.com>"

COPY --from=builder /kp1p.pyz /bin/kp1p

WORKDIR /work
ENTRYPOINT ["kp1p"]