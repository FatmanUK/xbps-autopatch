#!/bin/bash
set -euo pipefail

XBPS_VER='0.59.1_5'
XBPS_ARCH='x86_64-musl'
XBPS_PACKAGE_NAME="xbps-static-${XBPS_VER}.${XBPS_ARCH}"
XBPS_PACKAGE_FILE="${XBPS_PACKAGE_NAME}.tar.gz"
XBPS_URL="https://alpha.de.repo.voidlinux.org/static/${XBPS_PACKAGE_FILE}"
XBPS_ROOT='/opt'

pushd "${XBPS_ROOT}"
rm -f "${XBPS_PACKAGE_FILE}"
wget "${XBPS_URL}"
install -d -m0755 "${XBPS_PACKAGE_NAME}"
pushd "${XBPS_ROOT}/${XBPS_PACKAGE_NAME}"
tar xvpzf "../${XBPS_PACKAGE_FILE}"
popd
popd
