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

  Одинаковый адрес 10.0.2.15 ожидаем: VirtualBox создаёт для каждой ВМ свой NAT-роутер. Гости находятся в изолированных сетях и друг друга не видят; ping 10.0.2.15 проверяет собственный интерфейс.

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

+ *Создание снимка системы*

  Созданы снимки состояния Windows:
  - «Новая OC Windows» — исходное состояние (рис. @fig-snap-new);
  - «OC Windows+Yandex» — после установки Яндекс Браузера (рис. @fig-snap-yandex, @fig-snap-tree-yandex);
  - «OC Windows+МойОфис» — после установки МойОфис и изменения параметров (RAM — 4096 MB, CPU — 2) (рис. @fig-snap-office, @fig-snap-hw, @fig-snap-tree-office).

  #figure(
    image("images/26_win_snapshot_new.png", width: 95%),
    caption: [Создание снимка «Новая OC Windows»],
  ) <fig-snap-new>

  #figure(
    image("images/27_win_snapshot_yandex.png", width: 95%),
    caption: [Создание снимка «OC Windows+Yandex»],
  ) <fig-snap-yandex>

  #figure(
    image("images/28_all_snapshots_after_yandex.png", width: 95%),
    caption: [Снимки после установки Яндекс Браузера],
  ) <fig-snap-tree-yandex>

  Восстановление снимка «Новая OC Windows»: Яндекс Браузер отсутствует (рис. @fig-snap-no-yandex).

  #figure(
    image("images/29_no_yandex.png", width: 95%),
    caption: [Состояние системы после восстановления «Новая OC Windows»],
  ) <fig-snap-no-yandex>

  #figure(
    image("images/30_win_snapshot_myoffice.png", width: 95%),
    caption: [Установленный МойОфис],
  ) <fig-snap-office>

  #figure(
    image("images/31_win_more_resources.png", width: 95%),
    caption: [Параметры ВМ: 4096 MB RAM и 2 CPU],
  ) <fig-snap-hw>

  #figure(
    image("images/32_all_shapshots_after_myoffice.png", width: 95%),
    caption: [Снимки после создания «OC Windows+МойОфис»],
  ) <fig-snap-tree-office>

  Восстановлен снимок «OC Windows+Yandex»: Яндекс Браузер на месте, МойОфис отсутствует (рис. @fig-snap-restored, @fig-snap-tree-final).

  #figure(
    image("images/33_yandex_snapshot_restore.png", width: 95%),
    caption: [Состояние системы после восстановления «OC Windows+Yandex»],
  ) <fig-snap-restored>

  #figure(
    image("images/34_all_snapshots_after_restore.png", width: 95%),
    caption: [Итоговое дерево снимков],
  ) <fig-snap-tree-final>

+ *Общая папка и буфер обмена*

  На хосте создана папка `~/Public`. Она подключена как общая к обеим гостевым ОС (рис. @fig-share-win, @fig-share-ubuntu). Включён двунаправленный буфер обмена и Drag-and-Drop (рис. @fig-dnd-win, @fig-dnd-ubuntu).

  #figure(
    image("images/35_common_dir_windows.png", width: 95%),
    caption: [Общая папка Public для Windows],
  ) <fig-share-win>

  #figure(
    image("images/36_common_dir_ubuntu.png", width: 95%),
    caption: [Общая папка Public для Ubuntu],
  ) <fig-share-ubuntu>

  #figure(
    image("images/37_both_directions_windows.png", width: 95%),
    caption: [Двунаправленный буфер обмена и Drag-and-Drop на Windows],
  ) <fig-dnd-win>

  #figure(
    image("images/38_both_directions_ubuntu.png", width: 95%),
    caption: [Двунаправленный буфер обмена и Drag-and-Drop на Ubuntu],
  ) <fig-dnd-ubuntu>

  Файл `test.txt` виден в Windows, Ubuntu и на хосте (рис. @fig-share-both, @fig-share-host). Буфер обмена синхронизирован (рис. @fig-clip).

  #figure(
    image("images/39_both_os_see_shared_dir.png", width: 95%),
    caption: [Общий файл test.txt в гостевых ОС],
  ) <fig-share-both>

  #figure(
    image("images/40_host_os_see_shared_dir.png", width: 95%),
    caption: [Содержимое Public на хосте],
  ) <fig-share-host>

  #figure(
    image("images/41_shared_clipboard.png", width: 95%),
    caption: [Проверка общего буфера обмена],
  ) <fig-clip>

+ *Управление виртуальными машинами через командную строку*

  Для управления ВМ использовалась утилита VBoxManage.

  #figure(
    image("images/42_vbox_list_vms.png", width: 95%),
    caption: [Просмотр списка машин],
  ) <fig-vbox-list>

  #figure(
    image("images/43_vbox_startvm.png", width: 95%),
    caption: [Запуск виртуальной машины по имени],
  ) <fig-vbox-start>

  #figure(
    image("images/44_vbox_list_running_vms.png", width: 95%),
    caption: [Просмотр работающих ВМ],
  ) <fig-vbox-running>

  #figure(
    image("images/45_vbox_showvminfo.png", width: 95%),
    caption: [Просмотр информации о ВМ],
  ) <fig-vbox-info>

  Запуск по UUID выполняется командой `VBoxManage startvm {UUID}`. Скрипт запуска ВМ:

  #source("scripts/vms.sh", "bash")

  Результат работы скрипта: запуск ВМ по отдельности и повторный запуск уже работающих машин (рис. @fig-vbox-script).

  #figure(
    image("images/46_vbox_script_demo.png", width: 95%),
    caption: [Запуск виртуальных машин скриптом vms.sh],
  ) <fig-vbox-script>

= Заключение
В ходе выполнения лабораторной работы была установлена и настроена среда виртуализации Oracle VM VirtualBox с установкой пакета расширений Extension Pack. В качестве гостевых систем были развёрнуты две виртуальные машины — `WS_AKK_win` на базе Windows 10 и `WS_AKK_ubuntu` с дистрибутивом Ubuntu 26.04.

В процессе работы были последовательно реализованы следующие этапы:
+ Конфигурация аппаратных ресурсов виртуальных машин (процессор, оперативная память, диск и сетевые адаптеры).
+ Инсталляция компонентов Guest Additions для расширенной интеграции между гостевыми и хостовой операционными системами.
+ Настройка различных типов сетевых подключений (внутренняя сеть, виртуальный адаптер хоста, NAT, сеть NAT) и анализ их особенностей.
+ Тестирование сетевого взаимодействия между виртуальными системами и проверка доступности внешних сетевых ресурсов.
+ Изучение механизма снимков состояния (создание, восстановление и управление конфигурациями ОС).
+ Организация общих папок и настройка двунаправленного буфера обмена между хостом и гостевыми ОС.
+ Применение консольной утилиты VBoxManage для управления виртуальной инфраструктурой и автоматизации запуска машин.

По итогам выполненной работы были приобретены практические компетенции:
+ Развёртывание и конфигурирование гостевых операционных систем в среде гипервизора.
+ Проектирование виртуальных сетевых топологий и диагностика межсетевого взаимодействия.
+ Применение технологии снимков для управления состояниями виртуальных машин.
+ Настройка механизмов обмена данными между физической и виртуальными системами.
+ Автоматизация процессов управления виртуальной инфраструктурой посредством командного интерфейса.

Таким образом, поставленная цель лабораторной работы — приобретение практических навыков установки, настройки и администрирования виртуальных машин, изучение принципов построения виртуальных сетей и освоение дополнительных возможностей платформы VirtualBox — была полностью достигнута.
