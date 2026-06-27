#!/bin/sh
set -eu

CONFIG_DIR="${QUASSEL_CONFIG_DIR:-/config}"
CERT_FILE="${CONFIG_DIR}/quasselCert.pem"

if [ ! -f "${CERT_FILE}" ]; then
    openssl req -x509 -nodes -days 3650 \
        -newkey rsa:4096 \
        -keyout "${CERT_FILE}" \
        -out "${CERT_FILE}" \
        -subj "/CN=Quassel-core"
fi

if [ -n "${RUN_OPTS:-}" ]; then
    # shellcheck disable=SC2086
    exec quasselcore --configdir "${CONFIG_DIR}" ${RUN_OPTS} "$@"
fi

exec quasselcore --configdir "${CONFIG_DIR}" "$@"
