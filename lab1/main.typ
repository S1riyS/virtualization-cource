// Шаблон отчёта по лабораторной работе (ИТМО).
// Скопируйте файл в папку лабы и заполните поля ниже.

// ---------------------------------------------------------------------------
// Данные отчёта
// ---------------------------------------------------------------------------
#let lab-number = 1
#let lab-title = [Установка гостевой ОС]
#let variant = none // например: 3  или  none, если варианта нет
#let group = [P3418]
#let student = [Анкудинов К. К.]
#let teacher-degree = [к.т.н.]
#let teacher-position = [преподаватель]
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

Федеральное государственное автономное образовательное
учреждение высшего образования \
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
В этой лабораторной работе рассматриваются основы виртуализации на примере установки и настройки гостевых операционных систем. Для выполнения работы используется гипервизор Oracle VM VirtualBox, позволяющий создать на одном физическом компьютере несколько изолированных виртуальных машин. Чтобы раскрыть возможности платформы, дополнительно применяется VirtualBox Extension Pack — пакет расширений, открывающий доступ к таким функциям, как работа с USB-устройствами и удалённый доступ.

Практическая задача состоит в развёртывании двух операционных систем: Microsoft Windows 10 и одного из дистрибутивов Linux (Ubuntu). Сначала выполняется конфигурация виртуального «железа»: задаются объём оперативной памяти, размер жёсткого диска и другие параметры. Затем устанавливаются компоненты интеграции Guest Additions, которые делают работу с виртуальными машинами удобнее за счёт общего буфера обмена и динамического разрешения экрана.

Особое внимание уделяется сетевым настройкам: рассматриваются различные режимы подключения (NAT, внутренняя сеть, виртуальный адаптер хоста), назначение IP-адресов и проверка связи между виртуальными машинами. Также используется одна из ключевых возможностей виртуализации — создание снимков системы (snapshots) для быстрого сохранения и восстановления состояний. В завершение настраиваются общие папки для обмена данными и изучается управление виртуальными средами через командную строку с помощью утилиты VBoxManage.

== Цель работы
Приобрести практические навыки установки, настройки и администрирования виртуальных машин в среде Oracle VM VirtualBox. В ходе работы предстоит изучить принципы построения виртуальных сетей и механизмы взаимодействия между хостовой и гостевыми операционными системами.

== Задачи работы
+ Установить и настроить гипервизор VirtualBox, а также пакет его расширений (Extension Pack).
+ Выполнить установку гостевых ОС: Windows 10 и одного из дистрибутивов Linux.
+ Произвести настройку аппаратных параметров виртуальных машин: объём оперативной памяти (RAM), количество ядер процессора (CPU), размер виртуального жёсткого диска (HDD) и конфигурацию сети.
+ Установить «Дополнения гостевой ОС» (Guest Additions) для расширения базового функционала.
+ Настроить сетевые интерфейсы, проверить сетевое взаимодействие между виртуальными машинами и доступ к внешним ресурсам (Интернету).
+ Изучить работу различных типов сетевых подключений в VirtualBox: внутренняя сеть, виртуальный адаптер хоста, NAT, NAT Network.
+ Освоить создание и применение снимков системы (snapshots) для сохранения и быстрого восстановления состояния виртуальной машины.
+ Настроить общие папки и организовать совместное использование буфера обмена между хост-системой и гостевыми ОС.
+ Ознакомиться с основами управления виртуальными машинами через утилиту командной строки VBoxManage.

= Выполнение
+ *Установка гипервизора VirtualBox*

  С официального сайта https://www.virtualbox.org был загружен и установлен Oracle VM VirtualBox.

+ *Установка VirtualBox Extension Pack*

  Был установлен пакет расширений VirtualBox Extension Pack, обеспечивающий поддержку USB, динамическое изменение размера окна виртуальной машины, двунаправленное перетаскивание и многое другое.

+ *Загрузка дистрибутивов ОС*

  Были загружены дистрибутивы: Windows 10 и Ubuntu 26.04.

+ *Создание виртуальных машин*

  В VirtualBox были созданы две виртуальные машины:
  - `WS_AKK_win` — с Windows 10;
  - `WS_AKK_ubuntu` — с выбранной Linux-системой (Ubuntu).

  Заданы минимальные характеристики:
  - CPU — 1 ядро;
  - RAM — 2048 MB;
  - жёсткий диск — 20 GB;
  - сетевой интерфейс — внутренняя сеть;
  - аудио — выключено.

  #figure(
    image("images/1_windows_image.png", width: 95%),
    caption: [Установленный образ Windows],
  ) <fig-win>

  #figure(
    image("images/2_ubuntu_image.png", width: 95%),
    caption: [Установленный образ Ubuntu],
  ) <fig-ubuntu>

  На рисунке @fig-win приведены параметры виртуальной машины `WS_AKK_win`, на рисунке @fig-ubuntu — параметры машины `WS_AKK_ubuntu`.

+ *Установка дополнений гостевой ОС*

  После установки ОС был подключён образ диска Guest Additions и выполнена его установка.

+ *Настройка сетевых интерфейсов гостевых ОС*

  Для проверки работы сети гостевым ОС были назначены статические IP-адреса:
  - Windows 10 — 192.168.99.1 (рис. @fig-ip-win);
  - Ubuntu — 192.168.99.2 (рис. @fig-ip-ubuntu).

  #figure(
    image("images/3_ip_settings_windows.png", width: 95%),
    caption: [IP-адрес Windows],
  ) <fig-ip-win>

  #figure(
    image("images/4_ip_settings_ubuntu.png", width: 95%),
    caption: [IP-адрес Ubuntu],
  ) <fig-ip-ubuntu>

  Сетевое соединение между гостевыми ОС и доступ к внешним ресурсам проверены командой `ping` (рис. @fig-ping-win, @fig-ping-ubuntu).

  #figure(
    image("images/5_ping_windows.png", width: 95%),
    caption: [Команда ping в Windows],
  ) <fig-ping-win>

  #figure(
    image("images/6_ping_ubuntu.png", width: 95%),
    caption: [Команда ping в Ubuntu],
  ) <fig-ping-ubuntu>

  Связь между виртуальными машинами внутри одной сети есть, однако связь с внешними ресурсами отсутствует: имя `www.itmo.ru` не разрешается в DNS. Причина — выбранный в настройках VirtualBox тип подключения «Внутренняя сеть»: машины видят только друг друга и не имеют выхода в интернет и к хосту.

  Далее был настроен менеджер сетей хоста: для интерфейса `vboxnet0` включён DHCP-сервер, чтобы гостевые сетевые интерфейсы автоматически получали адреса (рис. @fig-hostnet). Адрес адаптера хоста — 192.168.56.1/24, диапазон выдачи DHCP — 192.168.56.100–192.168.56.254.

  #figure(
    image("images/7_host_network_manager.png", width: 95%),
    caption: [Настроенный менеджер сетей хоста],
  ) <fig-hostnet>

  В настройках обеих виртуальных машин тип подключения изменён на «Виртуальный адаптер», в качестве имени указан `vboxnet0` (рис. @fig-adapter-win, @fig-adapter-ubuntu).

  #figure(
    image("images/8_adapter_windows.png", width: 95%),
    caption: [Настройка адаптера для Windows],
  ) <fig-adapter-win>

  #figure(
    image("images/9_adapter_ubuntu.png", width: 95%),
    caption: [Настройка адаптера для Ubuntu],
  ) <fig-adapter-ubuntu>

  На гостевых ОС параметры сетевых интерфейсов обновлены: включено автоматическое получение IP-адреса по DHCP (рис. @fig-dhcp-win, @fig-dhcp-ubuntu).

  #figure(
    image("images/10_address_auto_windows.png", width: 95%),
    caption: [Настройка автоматического получения адресов в Windows],
  ) <fig-dhcp-win>

  #figure(
    image("images/11_address_auto_ubuntu.png", width: 95%),
    caption: [Настройка автоматического получения адресов в Ubuntu],
  ) <fig-dhcp-ubuntu>

  #figure(
    image("images/12_ip_settings_windows_and_ubuntu.png", width: 95%),
    caption: [Адреса, выданные DHCP, на Windows и Ubuntu],
  ) <fig-dhcp-lease>

  Создан второй виртуальный адаптер хоста `vboxnet1` с адресом 192.168.99.1. Включён DHCP с диапазоном 192.168.99.10–77 (рис. @fig-vboxnet1).

  #figure(
    image("images/13_second_virtual_adapter.png", width: 95%),
    caption: [Второй виртуальный адаптер хоста и DHCP 192.168.99.10–77],
  ) <fig-vboxnet1>

  После переключения обеих машин на `vboxnet1` получены адреса из нового диапазона (рис. @fig-ips-99).

  #figure(
    image("images/14_updated_ips_windows_and_ubuntu.png", width: 95%),
    caption: [Обновлённые адреса Windows и Ubuntu],
  ) <fig-ips-99>

  Связь между машинами есть, доступа в интернет нет (рис. @fig-ping-99). Если машины подключены к разным адаптерам хоста, ping между ними не проходит.

  #figure(
    image("images/15_mutual_pings_and_www.png", width: 95%),
    caption: [Ping между гостевыми ОС и проверка www.itmo.ru],
  ) <fig-ping-99>

+ *Создание NAT и сети NAT*

  Тип подключения изменён на NAT. Обе машины получили адрес 10.0.2.15 (рис. @fig-nat-ip). Доступ к www.itmo.ru появился (рис. @fig-nat-www).

  #figure(
    image("images/16_nat_ips_windows_and_ubuntu.png", width: 95%),
    caption: [Адреса Windows и Ubuntu в режиме NAT],
  ) <fig-nat-ip>

  #figure(
    image("images/17_www_ping_windows_and_ubuntu.png", width: 95%),
    caption: [Проверка доступа к www.itmo.ru в режиме NAT],
  ) <fig-nat-www>

  Одинаковый адрес 10.0.2.15 нормален: VirtualBox создаёт для каждой ВМ свой NAT-роутер. Гости находятся в изолированных сетях и друг друга не видят; ping 10.0.2.15 проверяет собственный интерфейс.

  Создана сеть NatNetwork с адресом 10.45.33.0/24 (рис. @fig-natnet). Windows получила 10.45.33.4, Ubuntu — 10.45.33.5 (рис. @fig-natnet-win, @fig-natnet-ubuntu). Связь между машинами и доступ в интернет есть (рис. @fig-natnet-ping).

  #figure(
    image("images/18_nat_network.png", width: 95%),
    caption: [Создание сети NatNetwork],
  ) <fig-natnet>

  #figure(
    image("images/19_nat_network_ip_windows.png", width: 95%),
    caption: [Адрес Windows в NatNetwork],
  ) <fig-natnet-win>

  #figure(
    image("images/20_nat_network_ip_ubuntu.png", width: 95%),
    caption: [Адрес Ubuntu в NatNetwork],
  ) <fig-natnet-ubuntu>

  #figure(
    image("images/21_nat_netwotk_pings_win_and_ubuntu.png", width: 95%),
    caption: [Ping между гостевыми ОС и проверка www.itmo.ru в NatNetwork],
  ) <fig-natnet-ping>

  Создана сеть NatNetwork1 с адресом 10.22.77.0/24 (рис. @fig-natnet1). Ubuntu переведена в неё (10.22.77.4), Windows осталась в NatNetwork (10.45.33.4) (рис. @fig-diff-ip). Интернет у обеих машин есть (рис. @fig-diff-www).

  #figure(
    image("images/22_second_nat_network.png", width: 95%),
    caption: [Создание сети NatNetwork1],
  ) <fig-natnet1>

  #figure(
    image("images/23_diff_nat_net_ip_win_and_ubunru.png", width: 95%),
    caption: [Адреса Windows и Ubuntu в разных сетях NAT],
  ) <fig-diff-ip>

  #figure(
    image("images/24_diff_nat_net_www_ping_both.png", width: 95%),
    caption: [Проверка www.itmo.ru из разных сетей NAT],
  ) <fig-diff-www>

  Ping с Windows до 10.22.77.4 получает ответы с TTL=128, на интерфейсе Ubuntu ICMP-пакеты не появляются (рис. @fig-no-link). Отвечает гипервизор хоста, связи между гостевыми ОС нет.

  #figure(
    image("images/25_diff_nat_no_interconnection.png", width: 95%),
    caption: [Ping с Windows и tcpdump на Ubuntu: пакеты до гостя не доходят],
  ) <fig-no-link>

= Заключение
+ Цель работы достигнута.
+ Кратко перечислите полученные результаты.

= Литература
+ ГОСТ 7.32—2001. Отчёт о научно-исследовательской работе. Структура и правила оформления.
+ ГОСТ 7.1—2003. Библиографическая запись. Библиографическое описание.
