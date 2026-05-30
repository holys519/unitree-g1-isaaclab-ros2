#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

if [ ! -f .env ]; then
  bash scripts/bootstrap.sh
fi

docker compose up -d --build
docker compose exec g1-dev bash
