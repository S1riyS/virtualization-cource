#!/bin/bash
# Пункт 7. Compose: Nextcloud, Nginx и MariaDB. С хоста Nextcloud открывается на порту 2022.
# Отдельный контейнер из пункта 5 занимает 8088 и в этот проект не входит.
# Перед запуском его можно остановить, чтобы не держать вторую копию: docker stop lab3-nextcloud-single
set -euo pipefail
cd "$(dirname "$0")"

if docker compose version >/dev/null 2>&1; then
  COMPOSE=(docker compose)
elif command -v docker-compose >/dev/null 2>&1; then
  COMPOSE=(docker-compose)
else
  echo "Нет docker compose. Сначала scripts/1_install/install.sh." >&2
  exit 1
fi

"${COMPOSE[@]}" up -d

echo "Жду установки Nextcloud в Compose"
ready=0
for _ in $(seq 1 60); do
  if docker exec -u www-data lab3-nextcloud php occ status 2>/dev/null | grep -q "installed: true"; then
    ready=1
    break
  fi
  sleep 5
done
if [[ "$ready" -ne 1 ]]; then
  echo "Nextcloud в Compose не установился. Журнал: docker logs lab3-nextcloud" >&2
  exit 1
fi

WEB_IP="$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' lab3-proxy)"
if [[ -n "$WEB_IP" ]]; then
  docker exec -u www-data lab3-nextcloud php occ config:system:set trusted_proxies 0 --value="$WEB_IP"
fi
docker exec -u www-data lab3-nextcloud php occ config:system:set overwritehost --value="localhost:2022"
docker exec -u www-data lab3-nextcloud php occ config:system:set overwriteprotocol --value="http"
docker exec -u www-data lab3-nextcloud php occ config:system:set overwrite.cli.url --value="http://localhost:2022"
docker exec -u www-data lab3-nextcloud php occ user:profile ankudinov displayname "Анкудинов К. К." || true

if ! docker exec -u www-data lab3-nextcloud php occ user:info belozubov >/dev/null 2>&1; then
  docker exec -u www-data -e OC_PASS=lab3-belozubov lab3-nextcloud \
    php occ user:add --password-from-env --display-name="Белозубов А. В." belozubov
fi

"${COMPOSE[@]}" ps
echo "Nextcloud через Nginx: http://localhost:2022"
echo "Анкудинов К. К. — ankudinov / lab3-ankudinov"
echo "Белозубов А. В. — belozubov / lab3-belozubov"
