#!/bin/bash
# Пункт 3. Готовый Nginx, затем свой образ: порт 8080, каталог хоста /home/www/html,
# страница со сведениями об Анкудинове К. К. Суффикс :Z на томе — метка SELinux в Fedora.
set -euo pipefail
cd "$(dirname "$0")"

docker pull nginx:alpine
docker rm -f lab3-nginx-stock >/dev/null 2>&1 || true
docker run -d --name lab3-nginx-stock -p 8080:80 nginx:alpine
echo "Готовый nginx:alpine слушает http://localhost:8080 (страница-заглушка)."
sleep 2
docker stop lab3-nginx-stock
docker rm lab3-nginx-stock

sudo mkdir -p /home/www/html
sudo cp index.html /home/www/html/index.html
sudo chown -R "$USER:$USER" /home/www/html

docker build -t lab3-web .
docker rm -f lab3-nginx >/dev/null 2>&1 || true
docker run -d --name lab3-nginx --restart unless-stopped \
  -p 8080:8080 \
  -v /home/www/html:/usr/share/nginx/html:ro,Z \
  lab3-web

echo "Свой образ lab3-web: http://localhost:8080"
echo "Каталог на хосте: /home/www/html"
