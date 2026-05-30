#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PY_SDK_DIR="${ROOT_DIR}/external/unitree_sdk2_python"

if [ ! -d "${PY_SDK_DIR}" ]; then
  echo "Missing ${PY_SDK_DIR}. Run: bash scripts/fetch_unitree_repos.sh"
  exit 1
fi

export CYCLONEDDS_HOME="${CYCLONEDDS_HOME:-/opt/cyclonedds}"
export CMAKE_PREFIX_PATH="${CYCLONEDDS_HOME}:${CMAKE_PREFIX_PATH:-}"

python3 -m pip install --user --upgrade pip "setuptools<80" wheel
python3 -m pip install --user -e "${PY_SDK_DIR}"

echo "Installed unitree_sdk2_python in editable mode"
