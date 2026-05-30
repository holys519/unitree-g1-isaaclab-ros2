#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SDK_DIR="${ROOT_DIR}/external/unitree_sdk2"
INSTALL_DIR="${ROOT_DIR}/install/unitree_robotics"

if [ ! -d "${SDK_DIR}" ]; then
  echo "Missing ${SDK_DIR}. Run: bash scripts/fetch_unitree_repos.sh"
  exit 1
fi

cmake -S "${SDK_DIR}" -B "${SDK_DIR}/build" \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_DIR}"
cmake --build "${SDK_DIR}/build" --parallel "$(nproc)"
cmake --install "${SDK_DIR}/build"

echo "Installed unitree_sdk2 to ${INSTALL_DIR}"
