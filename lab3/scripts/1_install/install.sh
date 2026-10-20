#!/bin/bash
# Пункт 1. Docker и VirtualBox на Fedora, пользователь в группе docker.
# Пакеты из репозиториев Fedora: moby-engine даёт dockerd и команду docker,
# docker-compose — плагин `docker compose`.
set -euo pipefail

TARGET_USER="${SUDO_USER:-$USER}"

sudo dnf install -y moby-engine docker-compose
sudo systemctl enable --now docker

sudo usermod -aG docker "$TARGET_USER"

if command -v VBoxManage >/dev/null 2>&1; then
  sudo usermod -aG vboxusers "$TARGET_USER" || true
  VBoxManage --version
else
  echo "VBoxManage не найден. В стандартных репозиториях Fedora VirtualBox нет."
  echo "Он уже ставился в лабораторной 1 из RPM Fusion."
fi

docker --version
docker compose version
echo
echo "Пользователь $TARGET_USER добавлен в группу docker."
echo "Выйдите из сессии и зайдите снова, иначе следующие скрипты получат permission denied."
