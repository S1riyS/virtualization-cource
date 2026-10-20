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
// Скриншоты — в каталог images/. Вставка:
// #figure(
//   image("images/имя.png", width: 95%),
//   caption: [Подпись],
// ) <fig-id>
// Команды давать блоком ```bash ... ``` или через #source("scripts/файл.sh", "bash").
// Dockerfile и compose-файл класть в scripts/.

== Установка и проверка
+ *Установка Docker и VirtualBox*

  // Unix-система предыдущих работ: Fedora-хост с VirtualBox и гостевая Ubuntu.
  // VirtualBox уже установлен на хосте в лабораторной 1 — показать версию.
  // Docker ставится там, где выполняются остальные пункты.
  // Если команды требуют sudo, добавить пользователя в группу docker и перелогиниться:
  // sudo usermod -aG docker $USER

+ *Версия клиента и первый контейнер*

  // docker --version
  // В задании вторая команда записана так: docker run Hello-Ваша_Фамилия
  // Фамилия — Анкудинов, то есть docker run Hello-Анкудинов.
  // Если реестр не отдаёт образ с таким именем, в отчёте показать фактическую команду
  // и пояснить, куда подставлено имя: --name контейнера или тег своего образа.

== Веб-сервер
+ *Контейнер Apache2 или Nginx*

  // Готовый образ, например httpd или nginx. Зафиксировать, какой выбран.

+ *Dockerfile*

  // Порт 8080.
  // «Рабочий каталог на хосте /home/www/html» — каталог машины, который монтируется в контейнер.
  // WORKDIR в Dockerfile задаёт каталог внутри образа, это другая настройка.
  // В образ добавляется HTML-страница со сведениями об Анкудинове К. К.
  // CMD или ENTRYPOINT при старте поднимает сервер и отдаёт эту страницу.
  // Файл — scripts/Dockerfile, в отчёт через #source("scripts/Dockerfile", "dockerfile").

== MariaDB
+ *Запуск сервера базы*

  // Образ MariaDB.
  // Каталог данных на хосте: /home/DB.
  // Порт по умолчанию у MariaDB — 3306, его и публиковать.

+ *Подключение и база с фамилией*

  // Вход из терминала, например docker exec -it <контейнер> mariadb -u ...
  // CREATE DATABASE с фамилией. Кириллицу в имени базы лучше не использовать: ankudinov.

== Nextcloud
+ *Образ с Docker Hub*

  // Официальный образ nextcloud. Порт хоста 8088.
  // Каталог на хосте: /home/www/NextCloud.

+ *Пользователи*

  // Двое: Анкудинов К. К. и преподаватель Белозубов А. В.
  // Скриншот списка пользователей или экрана после входа.

== phpVirtualBox
+ *Запуск контейнера*

  // Образ phpVirtualBox с Docker Hub. В отчёте указать фактическое имя образа.
  // phpVirtualBox — веб-интерфейс к VirtualBox, ему нужен vboxwebsrv на той машине,
  // где установлен VirtualBox. В этой серии работ VirtualBox стоит на Fedora-хосте.
  // Если контейнеры запускаются в гостевой Ubuntu, зафиксировать, как интерфейс
  // добирается до VirtualBox хоста, либо что VirtualBox поднят отдельно в госте.

== Docker Compose
+ *Nextcloud, веб-сервер и MariaDB*

  // Один compose-файл: сервис Nextcloud, сервис Apache2 или Nginx и сервис MariaDB.
  // Сервисы одной сети Compose видят друг друга по имени.
  // Доступ к Nextcloud с хоста — порт 2022.
  // Файл — scripts/compose.yaml, в отчёт через #source("scripts/compose.yaml", "yaml").
  // Подъём: docker compose up -d. В отчёте — ps и открытый интерфейс Nextcloud.

== Docker Hub
+ *Регистрация*

  // Учётная запись на https://hub.docker.com. Скриншот профиля.
  // Логин в клиенте: docker login.

+ *Публикация проекта*

  // Свой образ (веб-страница из Dockerfile или собранный проект) отправляется в реестр:
  // docker tag и docker push. Имя репозитория — учётная запись на Hub.

+ *Чужое приложение с Hub*

  // Скачать и запустить игру 2048 или Mine. Показать, что контейнер пришёл из реестра, а не из локальной сборки.

== Команды Docker
+ *Команды, использованные в работе*

  // Не справочник целиком, а те команды, которые реально встретились.
  // В задании отдельно перечислены группы docker container и docker image:
  // create, start, run, ls, inspect, logs, stop, kill, rm;
  // build, push, pull, ls, history, inspect, rm, images.
  // К каждой использованной — что она сделала в этой работе.

== Portainer
+ *Сервис в проекте Compose*

  // Добавить Portainer в тот же compose-файл.
  // Установка сервера описана здесь:
  // https://docs.portainer.io/start/install-ce/server/docker/linux#docker-run
  // В отчёте — что видно в интерфейсе: контейнеры, образы, тома, сети, журналы.
  // Отдельным абзацем: чем веб-интерфейс удобнее одной командной строки
  // для мониторинга и администрирования.

= Заключение
// Пишется после выполнения: какие контейнеры запущены, что собрано в Compose,
// что опубликовано на Docker Hub и чем Portainer дополняет командную строку.
// Цель из введения пересказать как достигнутую.
