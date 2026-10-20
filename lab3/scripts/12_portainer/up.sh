#!/bin/bash
# Пункт 12. Portainer добавляется в тот же проект Compose, что и пункт 7.
# Соответствует запуску из документации:
# https://docs.portainer.io/start/install-ce/server/docker/linux#docker-run
set -euo pipefail

BASE="$(cd "$(dirname "$0")/../7_compose" && pwd)"
EXTRA="$(cd "$(dirname "$0")" && pwd)/portainer.yaml"

if docker compose version >/dev/null 2>&1; then
  COMPOSE=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE=(docker-compose)
else
  echo "Нет docker compose. Сначала scripts/1_install/install.sh." >&2
  exit 1
fi

"${COMPOSE[@]}" -f "$BASE/compose.yaml" -f "$EXTRA" --project-directory "$BASE" up -d
"${COMPOSE[@]}" -f "$BASE/compose.yaml" -f "$EXTRA" --project-directory "$BASE" ps

echo "Portainer: https://localhost:9443"
echo "При первом входе задайте пароль администратора. В интерфейсе видны контейнеры, образы, тома, сети и журналы этого проекта."
