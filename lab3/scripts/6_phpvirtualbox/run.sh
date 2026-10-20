#!/bin/bash
# Пункт 6. phpVirtualBox с Docker Hub и vboxwebsrv на этой же машине.
# Веб-вход образа: admin / admin. До него интерфейс ходит в VirtualBox
# от имени пользователя группы vboxusers.
#
# Пароль можно передать заранее: VBOX_USER=... VBOX_PASSWORD=... bash run.sh
# Если пароль системы вводить нельзя, один раз (это меняет настройку VirtualBox):
#   VBoxManage setproperty websrvauthlibrary null
#   VBOX_USER=vbox VBOX_PASSWORD=vbox bash run.sh
set -euo pipefail

CONTAINER=lab3-phpvirtualbox
WEB_PORT=18080
VBOX_USER="${VBOX_USER:-${SUDO_USER:-$USER}}"

if ! command -v VBoxManage >/dev/null 2>&1 || ! command -v vboxwebsrv >/dev/null 2>&1; then
  echo "Нужны VBoxManage и vboxwebsrv. Сначала scripts/1_install/install.sh." >&2
  exit 1
fi

if [[ -z "${VBOX_PASSWORD:-}" ]]; then
  read -r -s -p "Пароль пользователя $VBOX_USER для vboxwebsrv: " VBOX_PASSWORD
  echo
fi

ports=""
if command -v ss >/dev/null 2>&1; then
  ports="$(ss -ltn)"
elif command -v netstat >/dev/null 2>&1; then
  ports="$(netstat -ltn)"
fi
if ! grep -q ':18083' <<<"$ports"; then
  vboxwebsrv -b -H 0.0.0.0 -p 18083
  sleep 1
fi

docker pull joweisberg/phpvirtualbox
docker rm -f "$CONTAINER" >/dev/null 2>&1 || true
docker run -d --name "$CONTAINER" --restart unless-stopped \
  -p "${WEB_PORT}:80" \
  --add-host=host.docker.internal:host-gateway \
  -e TZ=Europe/Moscow \
  -e ID_NAME=lab3 \
  -e ID_HOSTPORT=host.docker.internal:18083 \
  -e ID_USER="$VBOX_USER" \
  -e ID_PW="$VBOX_PASSWORD" \
  joweisberg/phpvirtualbox

echo "phpVirtualBox: http://localhost:${WEB_PORT}"
echo "Вход в веб-интерфейс: admin / admin"
echo "Образ: joweisberg/phpvirtualbox"
