#!/bin/bash
QUASSEL_RELEASE=0.14.0
docker build . --pull --no-cache --build-arg QUASSEL_RELEASE=$QUASSEL_RELEASE --tag ghcr.io/rich0/quassel-core:$QUASSEL_RELEASE --tag ghcr.io/rich0/quassel-core:latest && docker push ghcr.io/rich0/quassel-core:$QUASSEL_RELEASE && docker push ghcr.io/rich0/quassel-core:latest
