#!/usr/bin/env bash

_UNITREE_SETUP_HAD_NOUNSET=0
case "$-" in
  *u*)
    _UNITREE_SETUP_HAD_NOUNSET=1
    set +u
    ;;
esac

if [ -f /opt/ros/humble/setup.bash ]; then
  source /opt/ros/humble/setup.bash
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

export RMW_IMPLEMENTATION="${RMW_IMPLEMENTATION:-rmw_cyclonedds_cpp}"
export ROS_DOMAIN_ID="${ROS_DOMAIN_ID:-0}"
export UNITREE_NET_IFACE="${UNITREE_NET_IFACE:-lo}"
export CYCLONEDDS_HOME="${CYCLONEDDS_HOME:-/opt/cyclonedds}"
export CMAKE_PREFIX_PATH="${ROOT_DIR}/install/unitree_robotics:${CYCLONEDDS_HOME}:${CMAKE_PREFIX_PATH:-}"
export PATH="${HOME}/.local/bin:${PATH}"

if [ -f "${ROOT_DIR}/external/unitree_ros2/cyclonedds_ws/install/setup.bash" ]; then
  source "${ROOT_DIR}/external/unitree_ros2/cyclonedds_ws/install/setup.bash"
fi

if [ -f "${ROOT_DIR}/external/unitree_ros2/example/install/setup.bash" ]; then
  source "${ROOT_DIR}/external/unitree_ros2/example/install/setup.bash"
fi

if [ "${UNITREE_NET_IFACE}" = "default" ]; then
  unset CYCLONEDDS_URI
else
  export CYCLONEDDS_URI="<CycloneDDS><Domain><General><Interfaces><NetworkInterface name=\"${UNITREE_NET_IFACE}\" priority=\"default\" multicast=\"default\" /></Interfaces></General></Domain></CycloneDDS>"
fi

if [ "${_UNITREE_SETUP_HAD_NOUNSET}" = "1" ]; then
  set -u
fi
unset _UNITREE_SETUP_HAD_NOUNSET
