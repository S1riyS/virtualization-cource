#!/bin/bash
# Пункт 9. Свой образ из пункта 3 (страница Анкудинова) уходит в Docker Hub.
# Имя учётки: аргумент скрипта или переменная DOCKERHUB_USER.
set -euo pipefail

USER_NAME="${1:-${DOCKERHUB_USER:-}}"
if [[ -z "$USER_NAME" ]]; then
  read -r -p "Имя пользователя Docker Hub: " USER_NAME
fi

if ! docker image inspect lab3-web >/dev/null 2>&1; then
  echo "Нет локального образа lab3-web. Сначала scripts/3_nginx/run.sh." >&2
  exit 1
fi

docker tag lab3-web:latest "${USER_NAME}/lab3-web:latest"
docker push "${USER_NAME}/lab3-web:latest"
echo "Образ опубликован: https://hub.docker.com/r/${USER_NAME}/lab3-web"
