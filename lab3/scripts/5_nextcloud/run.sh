#!/bin/bash
# Пункт 5. Nextcloud с Docker Hub, каталог /home/www/NextCloud, порт 8088.
# Суффикс :Z на томе — метка SELinux в Fedora.
# Пользователи: ankudinov (Анкудинов К. К.) и belozubov (Белозубов А. В.).
set -euo pipefail

CONTAINER=lab3-nextcloud-single
ADMIN_USER=ankudinov
ADMIN_PASSWORD=lab3-ankudinov
TEACHER_USER=belozubov
TEACHER_PASSWORD=lab3-belozubov

sudo mkdir -p /home/www/NextCloud
if [[ -n "$(sudo ls -A /home/www/NextCloud)" ]]; then
  echo "Каталог /home/www/NextCloud не пуст. Nextcloud подхватит уже лежащую установку."
fi

docker pull nextcloud:apache
docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
docker run -d --name "$CONTAINER" --restart unless-stopped \
  -p 8088:80 \
  -e NEXTCLOUD_ADMIN_USER="$ADMIN_USER" \
  -e NEXTCLOUD_ADMIN_PASSWORD="$ADMIN_PASSWORD" \
  -e NEXTCLOUD_TRUSTED_DOMAINS="localhost 127.0.0.1" \
  -v /home/www/NextCloud:/var/www/html:Z \
  nextcloud:apache

echo "Жду установки Nextcloud (первая загрузка копирует файлы в /home/www/NextCloud)"
ready=0
for _ in $(seq 1 60); do
  if docker exec -u www-data "$CONTAINER" php occ status 2>/dev/null | grep -q "installed: true"; then
    ready=1
    break
  fi
  sleep 5
done
if [[ "$ready" -ne 1 ]]; then
  echo "Nextcloud не установился. Журнал: docker logs $CONTAINER" >&2
  exit 1
fi

docker exec -u www-data "$CONTAINER" php occ user:profile "$ADMIN_USER" displayname "Анкудинов К. К." \
  || echo "Отображаемое имя администратора не обновлено, логин $ADMIN_USER."

if ! docker exec -u www-data "$CONTAINER" php occ user:info "$TEACHER_USER" >/dev/null 2>&1; then
  docker exec -u www-data -e OC_PASS="$TEACHER_PASSWORD" "$CONTAINER" \
    php occ user:add --password-from-env --display-name="Белозубов А. В." "$TEACHER_USER"
fi

echo "Nextcloud: http://localhost:8088"
echo "Анкудинов К. К. — логин $ADMIN_USER, пароль $ADMIN_PASSWORD"
echo "Белозубов А. В. — логин $TEACHER_USER, пароль $TEACHER_PASSWORD"
echo "Список пользователей: docker exec -u www-data $CONTAINER php occ user:list"
