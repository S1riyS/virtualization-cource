#!/bin/bash
# Пункт 10. Чужая игра 2048 из Docker Hub, не локальная сборка.
set -euo pipefail

docker pull alexwhen/docker-2048
docker rm -f lab3-2048 >/dev/null 2>&1 || true
docker run -d --name lab3-2048 --restart unless-stopped \
  -p 8082:80 \
  alexwhen/docker-2048

echo "2048: http://localhost:8082"
echo "Образ пришёл из реестра: alexwhen/docker-2048"
