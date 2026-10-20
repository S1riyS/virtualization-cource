#!/bin/bash
# Пункт 2. docker --version и контейнер Hello-Фамилия.
# Имя образа в Docker — только латиница в нижнем регистре, поэтому тег hello-ankudinov.
# Контейнер называется Hello-Ankudinov: кириллицу демон в ссылке на образ не принимает.
set -euo pipefail
cd "$(dirname "$0")"

docker --version

echo "Команда из задания. Такого образа в реестре нет, ниже будет отказ."
docker run --rm Hello-Анкудинов || echo "Отказ ожидаемый: образа Hello-Анкудинов нет, имя ещё и не подходит реестру."

docker build -t hello-ankudinov .
docker rm -f Hello-Ankudinov >/dev/null 2>&1 || true
docker run --name Hello-Ankudinov hello-ankudinov
docker ps -a --filter name=Hello-Ankudinov
