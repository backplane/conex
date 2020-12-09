#!/bin/sh

exec firefox \
  --profile "/data" \
  --no-remote \
  "$@"