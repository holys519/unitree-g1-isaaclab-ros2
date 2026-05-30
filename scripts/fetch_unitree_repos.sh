#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
EXTERNAL_DIR="${ROOT_DIR}/external"
mkdir -p "${EXTERNAL_DIR}"

clone_or_update() {
  local url="$1"
  local dest="$2"

  if [ -d "${dest}/.git" ]; then
    echo "Updating ${dest}"
    git -C "${dest}" pull --ff-only
  else
    echo "Cloning ${url}"
    git clone "${url}" "${dest}"
  fi
}

clone_or_update https://github.com/unitreerobotics/unitree_sdk2.git "${EXTERNAL_DIR}/unitree_sdk2"
clone_or_update https://github.com/unitreerobotics/unitree_sdk2_python.git "${EXTERNAL_DIR}/unitree_sdk2_python"
clone_or_update https://github.com/unitreerobotics/unitree_ros2.git "${EXTERNAL_DIR}/unitree_ros2"
clone_or_update https://github.com/unitreerobotics/unitree_mujoco.git "${EXTERNAL_DIR}/unitree_mujoco"

echo "Unitree repositories are ready in ${EXTERNAL_DIR}"
