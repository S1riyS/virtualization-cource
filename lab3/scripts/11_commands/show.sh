#!/bin/bash
# Пункт 11. Команды, которыми пользуются в работе.
# stop, kill и rm показаны на отдельном контейнере lab3-demo, рабочие сервисы не трогаются.
set -euo pipefail

section() {
  echo
  echo "===== $* ====="
}

section "docker version"
docker version

section "docker ps и docker ps -a"
docker ps
docker ps -a

section "docker images"
docker images

if docker container inspect Hello-Ankudinov >/dev/null 2>&1; then
  section "docker inspect и docker logs контейнера Hello-Ankudinov"
  docker inspect Hello-Ankudinov
  docker logs Hello-Ankudinov
else
  echo "Контейнера Hello-Ankudinov нет. Сначала scripts/2_hello/run.sh."
fi

if docker image inspect lab3-web >/dev/null 2>&1; then
  section "docker history и docker image inspect образа lab3-web"
  docker history lab3-web
  docker image inspect lab3-web
else
  echo "Образа lab3-web нет. Сначала scripts/3_nginx/run.sh."
fi

section "create, start, stop, kill, rm на временном контейнере"
docker pull alpine:3.20
docker rm -f lab3-demo >/dev/null 2>&1 || true
docker create --name lab3-demo alpine:3.20 sleep 60
docker start lab3-demo
docker logs lab3-demo || true
docker stop lab3-demo
docker start lab3-demo
docker kill lab3-demo
docker rm lab3-demo

section "docker volume ls и docker network ls"
docker volume ls
docker network ls
