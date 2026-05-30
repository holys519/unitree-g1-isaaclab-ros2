#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="${ROOT_DIR}/.env"

if [ ! -f "${ENV_FILE}" ]; then
  cp "${ROOT_DIR}/.env.example" "${ENV_FILE}"
fi

sed -i \
  -e "s/^HOST_UID=.*/HOST_UID=$(id -u)/" \
  -e "s/^HOST_GID=.*/HOST_GID=$(id -g)/" \
  -e "s#^DISPLAY=.*#DISPLAY=${DISPLAY:-}#" \
  "${ENV_FILE}"

echo "Created ${ENV_FILE}"
echo "Edit UNITREE_NET_IFACE after connecting the G1 Ethernet cable."
