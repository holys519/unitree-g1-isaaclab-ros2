#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ISAACLAB_DIR="${ROOT_DIR}/IsaacLab"

if [ -d "${ISAACLAB_DIR}/.git" ]; then
  echo "Updating ${ISAACLAB_DIR}"
  git -C "${ISAACLAB_DIR}" pull --ff-only
else
  echo "Cloning Isaac Lab into ${ISAACLAB_DIR}"
  git clone --depth 1 https://github.com/isaac-sim/IsaacLab.git "${ISAACLAB_DIR}"
fi

echo "Isaac Lab is ready in ${ISAACLAB_DIR}"
