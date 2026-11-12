// Отчёт по лабораторной работе 4.
// Раздел «Выполнение» размечен по заданию: в каждый пункт добавляется ход работы,
// скриншоты из images/ и вывод команд.

// ---------------------------------------------------------------------------
// Данные отчёта
// ---------------------------------------------------------------------------
#let lab-number = 4
#let lab-title = [Знакомство с LXC и LXD]
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
Лабораторная работа посвящена системным контейнерам LXC и управлению ими через LXD. Окружение — гостевая Ubuntu, команды выполняются в терминале.

== Цель работы
Освоить установку и инициализацию LXD, создание контейнеров, ограничение ресурсов и развёртывание сервисов.

== Задачи работы
+ Установить LXD и проверить работу клиента.
+ Инициализировать хранилище и сеть.
+ Создать контейнеры Apache, Chrome и MC, запустить часть из них и получить сведения о состоянии, адресах и типе.
+ Создать контейнеры Big, Medium и Small, задать лимиты CPU и памяти, изменить описание и имя.
+ Развернуть Apache и Nextcloud, запустить Midnight Commander и создать контейнер через веб-интерфейс LXD.

= Выполнение

== Основы работы с LXD
+ *Установка и проверка*

  LXD 5.21.9 установлен пакетом snap (@fig-install). Список контейнеров пуст, версия совпадает с установленной (@fig-check).

  #figure(
    image("images/1_install.png", width: 75%),
    caption: [Установка LXD],
  ) <fig-install>

  #figure(
    image("images/2_check.png", width: 76%),
    caption: [Пустой список контейнеров и версия LXD],
  ) <fig-check>

+ *Инициализация*

  Параметры `lxd init` (@fig-init):

  - пул `My_AKK_fs`, драйвер ZFS, 5 ГиБ;
  - мост `lxdbr0`, адреса IPv4 и IPv6 автоматические;
  - кластер и MAAS выключены.

  #figure(
    image("images/3_init.png", width: 100%),
    caption: [Инициализация LXD],
  ) <fig-init>

+ *Контейнеры Apache, Chrome и MC*

  Из образа Ubuntu 24.04 созданы три остановленных контейнера (@fig-create). Запущены Apache и MC (@fig-start):

  - Apache — RUNNING, 10.82.11.63;
  - MC — RUNNING, 10.82.11.58;
  - Chrome — STOPPED.

  #figure(
    image("images/4_create.png", width: 70%),
    caption: [Создание контейнеров Apache, Chrome и MC],
  ) <fig-create>

  #figure(
    image("images/5_start.png", width: 100%),
    caption: [Запуск Apache и MC],
  ) <fig-start>

  Дальше проверены выборки и удаление:

  + имена и адреса IPv4 (@fig-filter);
  + остановленные контейнеры — только Chrome (@fig-filter);
  + контейнер MC удалён (@fig-delete);
  + у оставшихся тип CONTAINER (@fig-type).

  #figure(
    image("images/6_filter.png", width: 70%),
    caption: [Адреса контейнеров и остановленный Chrome],
  ) <fig-filter>

  #figure(
    image("images/7_delete.png", width: 100%),
    caption: [Удаление контейнера MC],
  ) <fig-delete>

  #figure(
    image("images/8_type.png", width: 100%),
    caption: [Тип оставшихся контейнеров],
  ) <fig-type>

== Конфигурация контейнеров
+ *Big, Medium и Small*

  Из образа Ubuntu 24.04 запущены Big, Medium и Small. Apache и Chrome из первой части остались в списке (@fig-launch). Конфигурация каждого получена командой `lxc info` (@fig-info-big, @fig-info-medium, @fig-info-small).

  #figure(
    image("images/9_launch.png", width: 100%),
    caption: [Запуск контейнеров Big, Medium и Small],
  ) <fig-launch>

  #figure(
    image("images/10_info_big.png", width: 100%),
    caption: [Конфигурация контейнера Big],
  ) <fig-info-big>

  #figure(
    image("images/11_info_medium.png", width: 100%),
    caption: [Конфигурация контейнера Medium],
  ) <fig-info-medium>

  #figure(
    image("images/12_info_small.png", width: 100%),
    caption: [Конфигурация контейнера Small],
  ) <fig-info-small>

+ *Лимиты Big*

  Big остановлен. Заданы ограничения (@fig-big-limits):

  - CPU — 2;
  - память — 300 МиБ.

  После запуска `free -h` показывает 300 МиБ (@fig-big-free).

  #figure(
    image("images/13_big_limits.png", width: 100%),
    caption: [Ограничения CPU и памяти контейнера Big],
  ) <fig-big-limits>

  #figure(
    image("images/14_big_free.png", width: 100%),
    caption: [Вывод free в контейнере Big],
  ) <fig-big-free>

+ *Память Medium и Small*

  Лимит менялся у запущенного контейнера, `top` не перезапускался.

  - Medium: было 5408 МиБ, стало 200 МиБ (@fig-medium-before, @fig-medium-set, @fig-medium-after).
  - Small: сначала 150 МиБ, затем 800 МиБ (@fig-small-150, @fig-small-set, @fig-small-800).

  #figure(
    image("images/15_medium_before.png", width: 100%),
    caption: [top в контейнере Medium до ограничения памяти],
  ) <fig-medium-before>

  #figure(
    image("images/16_medium_set.png", width: 100%),
    caption: [Ограничение памяти Medium до 200 МиБ],
  ) <fig-medium-set>

  #figure(
    image("images/17_medium_after.png", width: 100%),
    caption: [top в контейнере Medium после ограничения памяти],
  ) <fig-medium-after>

  #figure(
    image("images/18_small_150.png", width: 100%),
    caption: [top в контейнере Small при лимите 150 МиБ],
  ) <fig-small-150>

  #figure(
    image("images/20_small_set.png", width: 100%),
    caption: [Смена лимита памяти Small с 150 МиБ на 800 МиБ],
  ) <fig-small-set>

  #figure(
    image("images/19_small_800.png", width: 100%),
    caption: [top в контейнере Small при лимите 800 МиБ],
  ) <fig-small-800>

+ *Описание и имя*

  Описание записано в ключ `user.description` (@fig-description). Small остановлен и переименован в BigBig (@fig-rename).

  #figure(
    image("images/21_description.png", width: 100%),
    caption: [Описание контейнера Small],
  ) <fig-description>

  #figure(
    image("images/22_rename.png", width: 100%),
    caption: [Переименование контейнера Small в BigBig],
  ) <fig-rename>

== Практическое применение
+ *Контейнеры Apache, NextCloud и MC*

  Контейнеры первых двух частей удалены (@fig-cleanup). Запущены три новых, каждому задано 500 МиБ памяти (@fig-p3-launch, @fig-p3-ram):

  - Apache;
  - NextCloud;
  - MC.

  #figure(
    image("images/23_cleanup.png", width: 100%),
    caption: [Удаление контейнеров первых двух частей],
  ) <fig-cleanup>

  #figure(
    image("images/24_launch.png", width: 100%),
    caption: [Запуск Apache, NextCloud и MC],
  ) <fig-p3-launch>

  #figure(
    image("images/25_ram.png", width: 80%),
    caption: [Ограничение памяти 500 МиБ],
  ) <fig-p3-ram>

+ *Страница Apache*

  Служба apache2 запущена (@fig-apache-status). Страница с ФИО записана в `/var/www/html/index.html` (@fig-apache-html):

  - Apache — 10.82.11.237;
  - MC — 10.82.11.12;
  - NextCloud — 10.82.11.134.

  Страница открыта по адресу http://10.82.11.237 (@fig-apache-browser).

  #figure(
    image("images/26_apache_status.png", width: 88%),
    caption: [Служба apache2 в контейнере Apache],
  ) <fig-apache-status>

  #figure(
    image("images/27_apache_html.png", width: 88%),
    caption: [Страница index.html и адреса контейнеров],
  ) <fig-apache-html>

  #figure(
    image("images/28_apache_browser.png", width: 100%),
    caption: [Страница Apache в браузере],
  ) <fig-apache-browser>

+ *Nextcloud*

  В контейнере подготовлены пакеты, база и сайт:

  + обновлены индексы пакетов (@fig-nc-update);
  + установлены Apache2, MariaDB и PHP (@fig-nc-install);
  + созданы база и пользователь `nextcloud` (@fig-nc-db);
  + каталог отдан пользователю `www-data` (@fig-nc-chown);
  + сайт указывает на `/var/www/html/nextcloud`, включён модуль rewrite (@fig-nc-vhost, @fig-nc-enable).

  #figure(
    image("images/29_nc_update.png", width: 100%),
    caption: [Обновление пакетов в контейнере NextCloud],
  ) <fig-nc-update>

  #figure(
    image("images/30_nc_install.png", width: 100%),
    caption: [Установка Apache2, MariaDB и PHP],
  ) <fig-nc-install>

  #figure(
    image("images/31_nc_db.png", width: 95%),
    caption: [База и пользователь Nextcloud в MariaDB],
  ) <fig-nc-db>

  #figure(
    image("images/32_nc_chown.png", width: 95%),
    caption: [Права на каталог Nextcloud],
  ) <fig-nc-chown>

  #figure(
    image("images/33_nc_vhost.png", width: 95%),
    caption: [Виртуальный хост Nextcloud],
  ) <fig-nc-vhost>

  #figure(
    image("images/34_nc_enable.png", width: 95%),
    caption: [Включение сайта Nextcloud],
  ) <fig-nc-enable>

  Порт 80 проброшен на `127.0.0.1:8081` (@fig-nc-proxy). Дальше в браузере:

  + мастер установки, администратор `ankudinov` (@fig-nc-setup);
  + страница входа (@fig-nc-login).

  #figure(
    image("images/35_nc_proxy.png", width: 95%),
    caption: [Проброс порта Nextcloud на 127.0.0.1:8081],
  ) <fig-nc-proxy>

  #figure(
    image("images/36_nc_setup.png", width: 100%),
    caption: [Мастер установки Nextcloud],
  ) <fig-nc-setup>

  #figure(
    image("images/37_nc_login.png", width: 100%),
    caption: [Страница аутентификации Nextcloud],
  ) <fig-nc-login>

+ *Midnight Commander*

  В контейнере MC обновлены пакеты и установлен Midnight Commander (@fig-mc-update, @fig-mc-install). Команда `lxc exec MC -- mc` открывает две панели (@fig-mc).

  #figure(
    image("images/38_mc_update.png", width: 100%),
    caption: [Обновление пакетов в контейнере MC],
  ) <fig-mc-update>

  #figure(
    image("images/39_mc_install.png", width: 100%),
    caption: [Установка Midnight Commander],
  ) <fig-mc-install>

  #figure(
    image("images/40_mc.png", width: 100%),
    caption: [Midnight Commander в контейнере MC],
  ) <fig-mc>

+ *Веб-интерфейс LXD*

  Интерфейс открыт по адресу `https://127.0.0.1:8443` (@fig-ui-address). Вход выполнен по токену личности `lxd-ui` (@fig-ui-token).

  Контейнер `FromUI` создан из Ubuntu 24.04 и запущен (@fig-ui-create, @fig-ui-fromui):

  - состояние RUNNING;
  - адрес 10.82.11.138.

  Через интерфейс доступны экземпляры, профили, сети, хранилища, образы, терминал и консоль. Недоступны повторная инициализация LXD и копирование файлов командой `lxc file`.

  #figure(
    image("images/41_ui_address.png", width: 85%),
    caption: [Адрес веб-интерфейса LXD],
  ) <fig-ui-address>

  #figure(
    image("images/42_ui_token.png", width: 100%),
    caption: [Токен доступа к веб-интерфейсу],
  ) <fig-ui-token>

  #figure(
    image("images/43_ui_create.png", width: 100%),
    caption: [Создание контейнера FromUI],
  ) <fig-ui-create>

  #figure(
    image("images/44_ui_fromui.png", width: 100%),
    caption: [Запущенный FromUI и список контейнеров],
  ) <fig-ui-fromui>

= Заключение
- Установлен LXD 5.21.9. Пул `My_AKK_fs` занимает 5 ГиБ, сеть — мост `lxdbr0`.
- Контейнеры Apache и MC были запущены, Chrome оставлен остановленным, MC удалён.
- У Big заданы 2 CPU и 300 МиБ. Память Medium и Small менялась без перезапуска. Small переименован в BigBig.
- Страница Apache открыта по адресу 10.82.11.237, Nextcloud — по `http://127.0.0.1:8081`. В MC запущен Midnight Commander.
- Через веб-интерфейс LXD создан контейнер `FromUI`.
