#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MUJOCO_DIR="${ROOT_DIR}/external/unitree_mujoco"

if [ ! -d "${MUJOCO_DIR}" ]; then
  echo "Missing ${MUJOCO_DIR}. Run: bash scripts/fetch_unitree_repos.sh"
  exit 1
fi

if [ ! -d "${ROOT_DIR}/install/unitree_robotics" ]; then
  echo "Missing local unitree_sdk2 install. Run: bash scripts/build_cpp_sdk2.sh"
  exit 1
fi

if [ ! -e "${MUJOCO_DIR}/simulate/mujoco" ]; then
  echo "MuJoCo is not linked yet."
  echo "Install MuJoCo under ~/.mujoco, then create the link expected by Unitree:"
  echo "  cd ${MUJOCO_DIR}/simulate"
  echo "  ln -s ~/.mujoco/mujoco-3.3.6 mujoco"
  exit 1
fi

export CMAKE_PREFIX_PATH="${ROOT_DIR}/install/unitree_robotics:${CMAKE_PREFIX_PATH:-}"

cmake -S "${MUJOCO_DIR}/simulate" -B "${MUJOCO_DIR}/simulate/build" \
  -DCMAKE_BUILD_TYPE=Release
cmake --build "${MUJOCO_DIR}/simulate/build" --parallel "$(nproc)"

echo "Built unitree_mujoco C++ simulator"
