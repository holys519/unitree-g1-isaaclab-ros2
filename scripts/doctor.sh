#!/usr/bin/env bash
set -euo pipefail

echo "[Host tools]"
docker --version || true
docker compose version || true
git --version || true
python3 --version || true

echo
echo "[Network interfaces]"
ip -br addr || true

echo
echo "[Container]"
if docker compose ps g1-dev >/dev/null 2>&1; then
  docker compose exec g1-dev bash -lc 'source scripts/setup_env.sh && echo "ROS_DISTRO=${ROS_DISTRO:-}" && echo "RMW_IMPLEMENTATION=${RMW_IMPLEMENTATION}" && echo "UNITREE_NET_IFACE=${UNITREE_NET_IFACE}" && ros2 --help >/dev/null && echo "ros2: ok"'
else
  echo "Container is not running. Run: bash scripts/dev_up.sh"
fi
