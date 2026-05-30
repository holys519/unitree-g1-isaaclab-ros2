#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

source scripts/setup_env.sh

echo "Using UNITREE_NET_IFACE=${UNITREE_NET_IFACE}"
echo "ROS_DOMAIN_ID=${ROS_DOMAIN_ID}"
ros2 topic list
