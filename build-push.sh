#!/bin/bash
set -euo pipefail

VERSION=0.14.0
QUASSEL_APK_VERSION=0.14.0-r17
IMAGE=registry.rich0.org/public/quassel-core

docker build . \
  --pull \
  --build-arg VERSION=0.14.0 \
  --build-arg QUASSEL_APK_VERSION="${QUASSEL_APK_VERSION}" \
  --tag "${IMAGE}:${VERSION}" \
  --tag "${IMAGE}:latest"

docker push "${IMAGE}:${VERSION}"
docker push "${IMAGE}:latest"
