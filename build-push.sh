#!/bin/bash
set -euo pipefail

VERSION=0.15.0
QUASSEL_APK_VERSION=0.14.0-r17

docker build . \
  --pull \
  --build-arg VERSION=0.14.0 \
  --build-arg QUASSEL_APK_VERSION="${QUASSEL_APK_VERSION}" \
  --tag "ghcr.io/rich0/quassel-core:${VERSION}" \
  --tag ghcr.io/rich0/quassel-core:latest

docker push "ghcr.io/rich0/quassel-core:${VERSION}"
docker push ghcr.io/rich0/quassel-core:latest
