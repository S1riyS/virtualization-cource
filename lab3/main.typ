// Отчёт по лабораторной работе 3.
// Раздел «Выполнение» размечен по заданию: в каждый пункт добавляется ход работы,
// скриншоты из images/ и вывод команд.

// ---------------------------------------------------------------------------
// Данные отчёта
// ---------------------------------------------------------------------------
#let lab-number = 3
#let lab-title = [Знакомство с Docker]
#let variant = none // например: 3  или  none, если варианта нет
#let group = [P3418]
#let student = [Анкудинов К. К.]
#let teacher-degree = [к.т.н.]
#let teacher-position = [доцент]
#let teacher = [Белозубов А. В.]
#let city = [Санкт-Петербург]
#let year = datetime.today().year()
#let text-font = ("Times New Roman", "PT Serif")
#let mono-font = ("Courier New", "Menlo")
#let indent = 1.25cm
#let line-gap = 0.5em // полуторный интервал при кегле 14 pt

// ---------------------------------------------------------------------------
// Оформление
// ---------------------------------------------------------------------------
#set text(
  font: text-font,
  size: 14pt,
  fill: black,
  lang: "ru",
  region: "RU",
  hyphenate: true,
)

#set par(
  justify: true,
  leading: line-gap,
  spacing: line-gap,
  first-line-indent: (amount: indent, all: true),
  linebreaks: "optimized",
)

#set list(indent: indent, marker: [•])
#set enum(indent: indent, numbering: "1.")
#set terms(separator: [ — ], hanging-indent: indent)
#set heading(numbering: none)

#show heading: it => {
  let size = if it.level == 1 { 16pt } else if it.level == 2 { 15pt } else { 14pt }
  set align(center)
  set text(font: text-font, size: size, weight: "bold", hyphenate: false)
  set par(first-line-indent: 0pt, justify: false, leading: line-gap)
  if it.level == 1 { pagebreak(weak: true) }
  block(width: 100%, above: 1.6em, below: 1.2em, sticky: true, upper(it.body))
}

#set figure(supplement: [Рисунок], numbering: "1")
#set figure.caption(separator: [ — ])
#show figure.where(kind: table): set figure(supplement: [Таблица])
#show figure.where(kind: table): set figure.caption(position: top)
#show figure: set par(first-line-indent: 0pt, justify: false)
#show figure: set align(center)
#show figure: set block(above: 1em, below: 1.2em)
#show figure.caption: it => {
  set text(size: 14pt, weight: "regular")
  set par(first-line-indent: 0pt, justify: false)
  it
}

#show table: set par(first-line-indent: 0pt, justify: false)
#set table(inset: 6pt, stroke: 0.5pt + black, align: left)

#show raw.where(block: false): set text(font: mono-font, size: 12pt)
#show raw.where(block: true): it => {
  set text(font: mono-font, size: 12pt)
  set par(first-line-indent: 0pt, justify: false, leading: 0.55em)
  block(width: 100%, inset: (left: indent, y: 0.35em), it)
}

#show link: set text(fill: black)

#let source(path, lang) = {
  set par(first-line-indent: 0pt, justify: false)
  raw(read(path), lang: lang, block: true)
}

// ---------------------------------------------------------------------------
// Титульный лист
// ---------------------------------------------------------------------------
#set page(
  paper: "a4",
  margin: (left: 30mm, right: 20mm, top: 10mm, bottom: 10mm),
  numbering: none,
  header: none,
  footer: none,
)

#set align(center)
#set par(justify: false, first-line-indent: 0pt)
#set text(hyphenate: false)

Министерство науки и высшего образования Российской Федерации \
федеральное государственное автономное образовательное учреждение высшего образования \
«Национальный исследовательский университет ИТМО»

#v(1.5em)
Факультет программной инженерии и компьютерной техники \

#v(1fr)
Дисциплина «Технологии виртуализации» \

#v(1em)
*Отчёт по лабораторной работе № #lab-number* \
#lab-title

#if variant != none {
  v(1em)
  [Вариант № #variant]
}

#v(1fr)

#align(right)[
  #box[
    #set align(left)
    #underline[Группа:  #group]
    #v(1em)
    #underline[Выполнил]: #student
    #v(1em)
    #underline[Проверил]: \
    #teacher-degree #teacher-position \
    #teacher
  ]
]

#v(1fr)

#city
#linebreak()
#year

// ---------------------------------------------------------------------------
// Основной текст
// ---------------------------------------------------------------------------
#set page(
  paper: "a4",
  margin: (left: 30mm, right: 10mm, top: 20mm, bottom: 20mm),
  header: none,
  footer: context {
    set text(font: text-font, size: 11pt, weight: "regular")
    align(center, counter(page).display("1"))
  },
)
#set align(left)
#set par(justify: true, first-line-indent: (amount: indent, all: true))
#set text(hyphenate: true)
#counter(page).update(2)

#heading(outlined: false)[Оглавление]
#{
  set par(first-line-indent: 0pt, justify: false)
  outline(title: none, indent: 1.2em, depth: 3)
}

= Введение
Лабораторная работа посвящена Docker. Образ задаёт файловую систему и команду запуска. Контейнер — процесс, запущенный из этого образа, со своими файлами, сетью и лимитами. Несколько контейнеров одного приложения описываются в Docker Compose и поднимаются одной командой.

Окружение — Unix-система, в которой стоят Docker и VirtualBox. Все шаги выполняются в терминале: проверка клиента, запуск готовых образов, сборка своего образа с HTML-страницей, база MariaDB, Nextcloud и phpVirtualBox. Nextcloud вместе с веб-сервером и MariaDB собирается в один проект Compose. Проект публикуется на Docker Hub, оттуда же скачивается чужое приложение — игра 2048 или Mine. В тот же проект добавляется Portainer, веб-интерфейс для просмотра контейнеров и управления ими.

== Цель работы
Изучить основы работы с Docker: основные команды, создание и запуск контейнеров, управление несколькими контейнерами и публикацию на Docker Hub.

== Задачи работы
+ Установить Docker и VirtualBox в Unix-системе. При необходимости добавить пользователя в группу `docker`, чтобы команды выполнялись без `sudo`.
+ Проверить клиент командой `docker --version` и запустить контейнер `Hello-Ваша_Фамилия`.
+ Скачать и запустить контейнер с Apache2 или Nginx. Собрать Dockerfile: порт 8080, рабочий каталог хоста `/home/www/html`, HTML-страница со сведениями о себе, которая открывается при старте.
+ Скачать и запустить контейнер MariaDB с рабочим каталогом `/home/DB` и портом по умолчанию. Подключиться к серверу из терминала и создать базу с фамилией.
+ Скачать Nextcloud с Docker Hub, смонтировать каталог хоста `/home/www/NextCloud`, назначить порт 8088 и зарегистрировать двух пользователей: себя и преподавателя.
+ Скачать и запустить контейнер phpVirtualBox.
+ Собрать проект Docker Compose: Nextcloud, связанный с веб-сервером (Apache2 или Nginx) и базой MariaDB. Для доступа к Nextcloud назначить порт 2022.
+ Зарегистрироваться на Docker Hub.
+ Выложить свой проект на Docker Hub.
+ Скачать с Docker Hub и запустить игру 2048 или Mine.
+ Описать основные команды, которые использованы в работе.
+ Добавить в проект Compose сервис Portainer и описать его возможности мониторинга и администрирования.

= Выполнение

== Установка
+ *Docker и VirtualBox*

  Установлены Docker и VirtualBox. Пользователь входит в группы `docker` и `vboxusers`, команды Docker выполняются без sudo (рис. @fig-versions).

  #figure(
    image("images/1_versions.png", width: 85%),
    caption: [Установлены Docker и VirtualBox],
  ) <fig-versions>

== Тестовый контейнер
+ *Запуск hello-ankudinov*

  Команда `docker run hello-ankudinov` завершилась ошибкой: такого образа в реестре нет (рис. @fig-hello-fail).

  #figure(
    image("images/2_hello_fail.png", width: 95%),
    caption: [Неудачная попытка запустить контейнер hello-ankudinov],
  ) <fig-hello-fail>

  Образ собран из Dockerfile. Контейнер печатает приветствие и завершается (рис. @fig-hello-dockerfile, @fig-hello-run).

  #figure(
    image("images/3_hello_dockerfile.png", width: 80%),
    caption: [Dockerfile образа hello-ankudinov],
  ) <fig-hello-dockerfile>

  #figure(
    image("images/4_hello_run.png", width: 95%),
    caption: [Сборка образа и запуск контейнера],
  ) <fig-hello-run>

== Веб-сервер
+ *Nginx и страница со сведениями*

  Подготовлены страница со сведениями об Анкудинове К. К. и конфигурация Nginx на порту 8080 (рис. @fig-nginx-files). Dockerfile на базе `nginx:alpine` копирует их в образ (рис. @fig-nginx-dockerfile).

  #figure(
    image("images/5_nginx_files.png", width: 95%),
    caption: [Страница index.html и конфигурация Nginx],
  ) <fig-nginx-files>

  #figure(
    image("images/6_nginx_dockerfile.png", width: 95%),
    caption: [Dockerfile образа lab3-web],
  ) <fig-nginx-dockerfile>

  Образ `lab3-web` собран. Контейнер запущен с каталогом хоста `/home/www/html` и портом 8080. Страница открывается по адресу http://localhost:8080 (рис. @fig-nginx-build, @fig-nginx-page).

  #figure(
    image("images/7_nginx_build.png", width: 95%),
    caption: [Сборка образа lab3-web],
  ) <fig-nginx-build>

  #figure(
    image("images/8_nginx_page.png", width: 95%),
    caption: [Страница по адресу http://localhost:8080],
  ) <fig-nginx-page>

== MariaDB
+ *База ankudinov*

  Запущен контейнер MariaDB: порт 3306, данные в каталоге хоста `/home/DB` (рис. @fig-mariadb-run). Через терминал создана база `ankudinov` (рис. @fig-mariadb-create). Файлы базы лежат в смонтированном каталоге (рис. @fig-mariadb-dir).

  #figure(
    image("images/9_mariadb_run.png", width: 95%),
    caption: [Запуск контейнера MariaDB],
  ) <fig-mariadb-run>

  #figure(
    image("images/10_mariadb_create.png", width: 95%),
    caption: [Создание базы данных ankudinov],
  ) <fig-mariadb-create>

  #figure(
    image("images/11_mariadb_dir.png", width: 95%),
    caption: [Содержимое каталога /home/DB],
  ) <fig-mariadb-dir>

== Nextcloud
+ *Пользователи на порту 8088*

  Образ Nextcloud скачан с Docker Hub. Контейнер слушает порт 8088, каталог хоста — `/home/www/NextCloud` (рис. @fig-nextcloud-run). Зарегистрированы Анкудинов Кирилл Константинович и Белозубов Александр Владимирович (рис. @fig-nextcloud-ankudinov, @fig-nextcloud-belozubov, @fig-nextcloud-users).

  #figure(
    image("images/12_nextcloud_run.png", width: 95%),
    caption: [Запуск контейнера Nextcloud],
  ) <fig-nextcloud-run>

  #figure(
    image("images/13_nextcloud_ankudinov.png", width: 75%),
    caption: [Создание учётной записи Анкудинова К. К.],
  ) <fig-nextcloud-ankudinov>

  #figure(
    image("images/14_nextcloud_belozubov.png", width: 75%),
    caption: [Создание учётной записи Белозубова А. В.],
  ) <fig-nextcloud-belozubov>

  #figure(
    image("images/15_nextcloud_users.png", width: 95%),
    caption: [Список пользователей Nextcloud],
  ) <fig-nextcloud-users>

== phpVirtualBox
+ *Веб-интерфейс VirtualBox*

  Запущена служба `vboxwebsrv` (рис. @fig-vboxwebsrv). Контейнер `joweisberg/phpvirtualbox` слушает порт 8081 (рис. @fig-phpvirtualbox-run). Вход в интерфейс — `admin` / `admin` (рис. @fig-phpvirtualbox-login). В списке видны машины VirtualBox хоста (рис. @fig-phpvirtualbox-ui).

  #figure(
    image("images/16_vboxwebsrv.png", width: 95%),
    caption: [Запуск веб-службы VirtualBox],
  ) <fig-vboxwebsrv>

  #figure(
    image("images/17_phpvirtualbox_run.png", width: 95%),
    caption: [Запуск образа phpVirtualBox],
  ) <fig-phpvirtualbox-run>

  #figure(
    image("images/18_phpvirtualbox_login.png", width: 90%),
    caption: [Вход в phpVirtualBox],
  ) <fig-phpvirtualbox-login>

  #figure(
    image("images/19_phpvirtualbox_ui.png", width: 95%),
    caption: [Веб-интерфейс phpVirtualBox],
  ) <fig-phpvirtualbox-ui>

== Docker Compose
+ *Nextcloud, Nginx и MariaDB*

  Проект описывает три сервиса: MariaDB, Nextcloud и Nginx. Nextcloud подключён к каталогу `/home/www/NextCloud`, с хоста он открывается через Nginx на порту 2022 (рис. @fig-compose-file).

  #figure(
    image("images/20_compose_file.png", width: 80%),
    caption: [Файл compose.yaml],
  ) <fig-compose-file>

  Сервисы запущены (рис. @fig-compose-ps). По адресу http://localhost:2022 открывается тот же Nextcloud: в списке пользователи, зарегистрированные ранее (рис. @fig-compose-nextcloud, @fig-compose-users).

  #figure(
    image("images/21_compose_ps.png", width: 95%),
    caption: [Состояние сервисов Compose],
  ) <fig-compose-ps>

  #figure(
    image("images/22_compose_nextcloud.png", width: 70%),
    caption: [Nextcloud по адресу http://localhost:2022],
  ) <fig-compose-nextcloud>

  #figure(
    image("images/23_compose_users.png", width: 95%),
    caption: [Пользователи Nextcloud в проекте Compose],
  ) <fig-compose-users>

== Docker Hub
+ *Регистрация*

  Создана учётная запись на Docker Hub (рис. @fig-dockerhub).

  #figure(
    image("images/24_dockerhub_profile.png", width: 85%),
    caption: [Профиль на Docker Hub],
  ) <fig-dockerhub>

+ *Публикация образа*

  Образ `lab3-web` помечен тегом и отправлен в репозиторий `s1riys/lab3-web` (рис. @fig-docker-push). Репозиторий виден в профиле (рис. @fig-dockerhub-repo).

  #figure(
    image("images/25_docker_push.png", width: 95%),
    caption: [Публикация образа lab3-web],
  ) <fig-docker-push>

  #figure(
    image("images/26_dockerhub_repo.png", width: 85%),
    caption: [Опубликованный образ на Docker Hub],
  ) <fig-dockerhub-repo>

== Игра с Docker Hub
+ *Minesweeper*

  Скачан и запущен образ `ghcr.io/bhb603/minesweeper-cli` (рис. @fig-minesweeper).

  #figure(
    image("images/27_minesweeper.png", width: 90%),
    caption: [Скачивание и запуск игры minesweeper],
  ) <fig-minesweeper>

== Команды Docker
В ходе выполнения лабораторной работы были применены следующие команды Docker для управления контейнерами, образами и многоконтейнерными приложениями.

Команды для управления контейнерами:

- `docker create` — создаёт контейнер из образа без его запуска
- `docker start` — запускает ранее созданный или остановленный контейнер
- `docker run` — создаёт и сразу запускает новый контейнер из образа
- `docker stop` — останавливает контейнер, отправляя сигнал завершения (SIGTERM)
- `docker kill` — принудительно завершает работу контейнера, отправляя сигнал SIGKILL
- `docker rm` — удаляет остановленный контейнер из системы
- `docker ps` — отображает список только запущенных контейнеров
- `docker ps -a` — отображает все контейнеры, включая остановленные
- `docker inspect` — выводит подробную информацию о контейнере
- `docker logs` — показывает журнал (логи) работы контейнера
- `docker exec` — выполняет указанную команду внутри уже запущенного контейнера
- `docker system df` — отображает использование дискового пространства Docker
- `docker volume ls` — перечисляет все тома, созданные Docker
- `docker network ls` — перечисляет все сети, управляемые Docker
- `docker version` — показывает версии Docker Engine и других компонентов
- `docker info` — выводит подробную информацию о конфигурации и состоянии Docker-окружения

Команды для управления образами:

- `docker build` — собирает образ на основе инструкций из файла Dockerfile
- `docker pull` — загружает образ из реестра
- `docker push` — отправляет локальный образ в удалённый реестр
- `docker images` (или `docker image ls`) — отображает список всех локальных образов
- `docker image inspect` — выводит детальную информацию о метаданных и конфигурации образа
- `docker rmi` (или `docker image rm`) — удаляет указанный образ из локального хранилища
- `docker login` — выполняет аутентификацию в Docker Hub или другом реестре контейнеров

Команды Docker Compose:

- `docker compose up` — создаёт и запускает все сервисы, описанные в файле `compose.yaml`
- `docker compose down` — останавливает и удаляет контейнеры, сети и тома, созданные через `docker compose up`
- `docker compose ps` — отображает статус всех сервисов в проекте
- `docker compose logs` — выводит журналы всех запущенных сервисов
- `docker compose build` — пересобирает образы, указанные в конфигурации Compose

= Заключение
В ходе лабораторной работы освоен полный цикл работы с Docker — от базовых операций до запуска нескольких связанных контейнеров. Сначала проверены клиент и VirtualBox, затем собран образ `hello-ankudinov`. Дальше практика включала создание Dockerfile, сборку образа и развёртывание веб-сервера Nginx со страницей Анкудинова К. К. на порту 8080. Каталог хоста `/home/www/html` был смонтирован в контейнер.

Отдельно подняты MariaDB с базой `ankudinov` в каталоге `/home/DB` и Nextcloud с Docker Hub на порту 8088. В Nextcloud зарегистрированы Анкудинов Кирилл Константинович и Белозубов Александр Владимирович, данные сохранены в `/home/www/NextCloud`. Через phpVirtualBox открыт веб-интерфейс VirtualBox хоста: в списке видны машины, созданные ранее.

Основной акцент сделан на Docker Compose. Развёрнут проект из Nginx, MariaDB и Nextcloud: сервисы связаны одной сетью, для Nextcloud назначен порт 2022, а том указывает на уже заполненный каталог `/home/www/NextCloud`, поэтому ранее созданные пользователи доступны и в этом проекте.

Завершающим этапом стала публикация собственного образа `lab3-web` в реестре Docker Hub под именем `s1riys/lab3-web`. Из реестра скачана и запущена игра minesweeper. Таким образом отработаны создание образов, запуск контейнеров, настройка портов и томов и сборка многоконтейнерного приложения.
