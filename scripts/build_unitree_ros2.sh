#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROS2_DIR="${ROOT_DIR}/external/unitree_ros2"

if [ ! -d "${ROS2_DIR}" ]; then
  echo "Missing ${ROS2_DIR}. Run: bash scripts/fetch_unitree_repos.sh"
  exit 1
fi

set +u
source /opt/ros/humble/setup.bash
set -u

cd "${ROS2_DIR}/cyclonedds_ws"
colcon build

set +u
source install/setup.bash
set -u

cd "${ROS2_DIR}/example"
colcon build

echo "Built unitree_ros2 workspaces"
