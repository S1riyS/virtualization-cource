#!/bin/bash
# Пункт 4. MariaDB, каталог хоста /home/DB, порт 3306, база ankudinov.
# Суффикс :Z на томе — метка SELinux в Fedora.
set -euo pipefail

ROOT_PASSWORD=lab3-root
CONTAINER=lab3-mariadb

sudo mkdir -p /home/DB
if [[ -z "$(sudo ls -A /home/DB)" ]]; then
  sudo chown "$USER:$USER" /home/DB
fi

docker pull mariadb:11
docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
docker run -d --name "$CONTAINER" --restart unless-stopped \
  -e MARIADB_ROOT_PASSWORD="$ROOT_PASSWORD" \
  -p 3306:3306 \
  -v /home/DB:/var/lib/mysql:Z \
  mariadb:11

echo "Жду готовности MariaDB"
ready=0
for _ in $(seq 1 40); do
  if docker exec "$CONTAINER" mariadb-admin ping -uroot -p"$ROOT_PASSWORD" --silent; then
    ready=1
    break
  fi
  sleep 3
done
if [[ "$ready" -ne 1 ]]; then
  echo "MariaDB не ответила. Журнал: docker logs $CONTAINER" >&2
  exit 1
fi

docker exec "$CONTAINER" mariadb -uroot -p"$ROOT_PASSWORD" -e \
  "CREATE DATABASE IF NOT EXISTS ankudinov CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; SHOW DATABASES;"

echo "База ankudinov создана. Пароль root: $ROOT_PASSWORD. Порт 3306, данные в /home/DB."
