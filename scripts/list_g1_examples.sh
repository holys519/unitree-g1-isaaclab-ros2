#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

if [ ! -d external/unitree_sdk2_python/example/g1 ]; then
  echo "Missing Python SDK examples. Run: bash scripts/fetch_unitree_repos.sh"
  exit 1
fi

find external/unitree_sdk2_python/example/g1 -maxdepth 3 -type f -name "*.py" | sort
