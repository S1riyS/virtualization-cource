// Отчёт по лабораторной работе 2.
// Раздел «Выполнение» размечен по заданию: в каждый пункт добавляется ход работы,
// скриншоты из images/ и вывод команд.

// ---------------------------------------------------------------------------
// Данные отчёта
// ---------------------------------------------------------------------------
#let lab-number = 2
#let lab-title = [Использование гипервизоров в Unix]
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
Лабораторная работа содержала три основных блока: работа с Gnome Boxes для освоения базовых принципов, ручное создание VM через QEMU для понимания низкоуровневых механизмов, и использование Virtual Machine Manager с утилитами libvirt для профессионального управления виртуальными машинами.

Работа выполнялась в трехуровневой архитектуре виртуализации: физическая система с гипервизором Oracle VirtualBox, гостевая операционная система Ubuntu, внутри которой разворачивались вложенные виртуальные машины на базе QEMU/KVM.

QEMU (Quick Emulator) — программный эмулятор процессоров и виртуальных устройств. При совместной работе с модулем ядра KVM (Kernel-based Virtual Machine) обеспечивает производительность, близкую к нативной, за счет использования аппаратных расширений виртуализации процессора.

libvirt — унифицированная библиотека управления виртуализацией, предоставляющая единый API для работы с различными гипервизорами. Включает демон libvirtd и набор консольных утилит для автоматизации управления виртуальными системами.

В процессе работы использовались три подхода к созданию виртуальных машин:

+ Gnome Boxes — графический интерфейс для быстрого развертывания VM с минимальной конфигурацией, позволяющий запускать системы в Live-режиме без установки на диск.
+ QEMU в режиме прямого запуска — низкоуровневый подход с ручным указанием всех параметров через командную строку, обеспечивающий детальный контроль над конфигурацией виртуального оборудования.
+ Virtual Machine Manager (virt-manager) — полнофункциональный графический менеджер, предоставляющий доступ ко всем возможностям libvirt: управление виртуальным оборудованием, мониторинг ресурсов в реальном времени, работа со снимками состояния.

Консольные утилиты libvirt включают virsh (управление VM), virt-install (автоматизированное создание), virt-clone (клонирование), osinfo-query (информация о поддерживаемых ОС).

В рамках работы выполнялось конфигурирование вложенной виртуализации с активацией Intel VT-x в BIOS и включением Nested VT-x в настройках VirtualBox. Для размещения образов подключался дополнительный виртуальный диск объемом 30 ГБ.

Изучались механизмы моментальных снимков (snapshots), позволяющие сохранять состояние виртуальной машины с возможностью последующего восстановления, а также процедуры клонирования VM посредством утилиты virt-clone для создания шаблонных систем.

Практическая часть включала настройку удаленных RDP-подключений из вложенных виртуальных машин к физическому компьютеру через проброс портов с использованием утилиты socat для перенаправления трафика между изолированными сетевыми сегментами.

== Цель работы
Целью данной лабораторной работы является освоение технологий виртуализации в Unix-подобных операционных системах, изучение различных подходов к созданию и управлению виртуальными машинами на базе QEMU/KVM и библиотеки libvirt, а также получение практических навыков работы с механизмами вложенной виртуализации.

== Задачи работы
+ Настроить окружение для вложенной виртуализации с активацией Nested VT-x.
+ Сконфигурировать дополнительное дисковое пространство для размещения образов виртуальных машин.
+ Освоить три подхода к созданию VM: Gnome Boxes, прямая работа с QEMU/KVM, Virtual Machine Manager.
+ Изучить механизмы создания снимков состояния и клонирования виртуальных машин.
+ Освоить консольные утилиты управления виртуализацией: virsh, virt-install, virt-clone.
+ Настроить удаленные подключения к виртуальным машинам через протокол RDP.

= Выполнение
// Скриншоты — в каталог images/. Вставка:
// #figure(
//   image("images/имя.png", width: 95%),
//   caption: [Подпись],
// ) <fig-id>
// Команды давать блоком ```bash ... ``` или через #source("scripts/файл.sh", "bash").

== Подготовка окружения
+ *Добавление жёсткого диска*

  К виртуальной машине `WS_AKK_ubuntu` в Oracle VM VirtualBox был добавлен дополнительный жёсткий диск SATA. Создан файл образа VDI объёмом 30 ГБ по пути `/home/s1riys/VM/WS_AKK_ubuntu/WS_AKK_ubuntu_1.vdi` (рис. @fig-sata-disk).

  #figure(
    image("images/1_sata_disk.png", width: 95%),
    caption: [Создание виртуального жёсткого диска SATA объёмом 30 ГБ],
  ) <fig-sata-disk>

  После запуска гостевой ОС Ubuntu новый диск отобразился в утилите «Диски» как устройство `/dev/sdb` размером около 32 ГБ (VBOX HARDDISK). Через «Диски» он отформатирован в Ext4 с меткой `data` и смонтирован в `/run/media/kirill/data` (рис. @fig-disk-mounted).

  #figure(
    image("images/2_disk_mounted.png", width: 95%),
    caption: [Диск `/dev/sdb` с файловой системой Ext4, смонтирован в `/run/media/kirill/data`],
  ) <fig-disk-mounted>

+ *Проверка конфигурации процессора и ускорения*

  В настройках виртуальной машины `WS_AKK_ubuntu` проверена вкладка «Процессор»: выделено 1 ядро ЦПУ, включены функции PAE/NX и Nested VT-x/AMD-V (рис. @fig-cpu). Вложенная виртуализация необходима для работы KVM внутри гостевой Ubuntu.

  #figure(
    image("images/3_cpu.png", width: 95%),
    caption: [Настройки процессора: Nested VT-x/AMD-V включён],
  ) <fig-cpu>

  На вкладке «Ускорение» интерфейс паравиртуализации оставлен «По умолчанию», включён Nested Paging (рис. @fig-accel).

  #figure(
    image("images/4_acceleration.png", width: 95%),
    caption: [Настройки ускорения: Nested Paging включён],
  ) <fig-accel>

+ *Общая папка Soft*

  На хосте создана папка `/home/s1riys/Soft`. В настройках VirtualBox она подключена к гостевой машине как общая папка машины с полным доступом и автоподключением (рис. @fig-share-vbox).

  #figure(
    image("images/5_shared_folder_vbox.png", width: 95%),
    caption: [Общая папка Soft в настройках VirtualBox],
  ) <fig-share-vbox>

  В гостевой ОС папка смонтирована в `/media/sf_Soft`. Файл `test.txt` с содержимым `Hello World` виден и на хосте в `~/Soft`, и в гостевой Ubuntu (рис. @fig-share-file).

  #figure(
    image("images/6_shared_folder_file.png", width: 95%),
    caption: [Файл test.txt в общей папке Soft на хосте и в гостевой ОС],
  ) <fig-share-file>

+ *Загрузка дистрибутива*

  С зеркала http://mirror.yandex.ru загружен Live-образ Fedora Workstation 43:
  `Fedora-Workstation-Live-43-1.6.x86_64.iso` (около 2,7 ГБ). Файл сохранён в каталоге загрузок гостевой Ubuntu (рис. @fig-iso). Для удобства образ также размещён в общей папке Soft.

  #figure(
    image("images/7_iso.png", width: 95%),
    caption: [Загруженный ISO Fedora Workstation Live 43],
  ) <fig-iso>

#pagebreak()

== Работа с GNOME Boxes
+ *Установка GNOME Boxes*

  В гостевой Ubuntu установлен пакет GNOME Boxes:

  ```bash
  sudo apt update
  sudo apt install gnome-boxes
  ```

+ *Создание виртуальной машины и запуск LiveCD*

  В Boxes создана виртуальная машина. В качестве носителя выбран ISO-образ Fedora (рис. @fig-boxes-iso). Система запущена в режиме Live без установки на диск: пользователь сессии — `liveuser`, в `/etc/os-release` указаны Fedora Linux 43 и вариант Xfce (рис. @fig-boxes-live).

  #figure(
    image("images/8_boxes_iso.png", width: 95%),
    caption: [Выбор ISO Fedora при создании ВМ в GNOME Boxes],
  ) <fig-boxes-iso>

  #figure(
    image("images/9_boxes_live.png", width: 95%),
    caption: [Fedora 43 Xfce, запущенная в режиме Live],
  ) <fig-boxes-live>

+ *Свойства виртуальной машины*

  В свойствах машины Boxes задаются имя, число процессоров, объём памяти, предел хранилища, 3D-ускорение и разрешение фонового запуска (рис. @fig-boxes-props). Для созданной машины указаны 4 ЦП, 2 ГиБ памяти и предел диска 9,5 ГиБ. Графиков загрузки в этом окне нет: оперативный мониторинг CPU, памяти и диска в Boxes не выводится, его даёт Virtual Machine Manager. Конфигурация машины хранится в формате libvirt.

  #figure(
    image("images/10_boxes_properties.png", width: 95%),
    caption: [Свойства виртуальной машины в GNOME Boxes],
  ) <fig-boxes-props>

+ *Подключение к серверу Helios*

  Из Live-сессии выполнено подключение к серверу Helios:

  ```bash
  ssh -p 2222 s413732@helios.cs.ifmo.ru
  ```

  После подтверждения ключа открылась оболочка FreeBSD 14.5-STABLE (рис. @fig-helios).

  #figure(
    image("images/11_helios_ssh.png", width: 95%),
    caption: [SSH-сессия на helios.cs.ifmo.ru, порт 2222],
  ) <fig-helios>

+ *Сетевой мост*

  У гостевой Ubuntu в VirtualBox тип подключения адаптера 1 — «Сетевой мост», адаптер хоста — Realtek PCIe GbE (рис. @fig-bridge). Вложенная Fedora при этом получает адрес пользовательского NAT QEMU: `10.0.2.15`, шлюз `10.0.2.2` (рис. @fig-live-route).

  #figure(
    image("images/12_bridge.png", width: 95%),
    caption: [Сетевой мост гостевой Ubuntu в VirtualBox],
  ) <fig-bridge>

  #figure(
    image("images/13_live_route.png", width: 95%),
    caption: [Маршрут по умолчанию во вложенной Fedora],
  ) <fig-live-route>

+ *Удалённый рабочий стол*

  Соседнего компьютера с Windows не было, поэтому с Live-сессии через Remmina открыт рабочий стол хоста — ноутбука с Fedora. Протокол RDP, сервер `192.168.0.14`, пользователь `s1riys` (рис. @fig-rdp-profile). Сессия показывает рабочий стол `s1riys\@fedora` (рис. @fig-rdp-laptop).

  #figure(
    image("images/14_rdp_profile.png", width: 95%),
    caption: [Профиль RDP-подключения к ноутбуку],
  ) <fig-rdp-profile>

  #figure(
    image("images/15_rdp_laptop.png", width: 95%),
    caption: [Рабочий стол Fedora на ноутбуке, открытый по RDP],
  ) <fig-rdp-laptop>

== Работа с QEMU
+ *Установка QEMU и проверка KVM*

  В гостевой Ubuntu установлены `qemu-system-x86`, `qemu-utils` и `cpu-checker`. Команда `kvm-ok` сообщает, что `/dev/kvm` существует и ускорение KVM доступно (рис. @fig-kvm-ok). Модуль `kvm_amd` загружен, поверх него работает `kvm` (рис. @fig-kvm-lsmod).

  #figure(
    image("images/19_kvm_ok.png", width: 95%),
    caption: [Проверка KVM командой kvm-ok],
  ) <fig-kvm-ok>

  #figure(
    image("images/16_kvm_lsmod.png", width: 95%),
    caption: [Загруженные модули kvm и kvm_amd],
  ) <fig-kvm-lsmod>

+ *Создание виртуального диска и запуск машины*

  Создан каталог `~/VM` и диск в формате qcow2 объёмом 10 ГБ:

  ```bash
  mkdir -p ~/VM
  qemu-img create -f qcow2 ~/VM/Fedora-36.img 10G
  ```

  Образ записан в `/home/kirill/VM/Fedora-36.img` (рис. @fig-qemu-img).

  #figure(
    image("images/17_qemu_img.png", width: 95%),
    caption: [Создание диска Fedora-36.img объёмом 10 ГБ],
  ) <fig-qemu-img>

  Запуск машины с пустого диска:

  ```bash
  qemu-system-x86_64 ~/VM/Fedora-36.img
  ```

  Загрузочной ОС на диске нет, поэтому QEMU доходит до iPXE и останавливается с сообщением `No bootable device` (рис. @fig-qemu-empty).

  #figure(
    image("images/18_qemu_empty.png", width: 95%),
    caption: [Запуск QEMU с пустого диска: загружать нечего],
  ) <fig-qemu-empty>

+ *Установка гостевой ОС*

  С того же диска и ISO Fedora запущена установка. В окне QEMU открыт установщик Fedora Linux 43 (Xfce), на шаге конфигурации хранилища (рис. @fig-qemu-install). Имя файла диска оставлено `Fedora-36.img`, как в образце команды; ставится актуальный образ Fedora 43.

  #figure(
    image("images/20_qemu_install.png", width: 95%),
    caption: [Установка Fedora 43 Xfce в QEMU],
  ) <fig-qemu-install>

+ *Команда запуска с полноэкранным режимом и MAC-адресом*

  Гостевую систему запускали в полноэкранном режиме с MAC-адресом из задания `17:10:20:22:20:09`. QEMU отказался назначать этот адрес сетевой карте: младший бит первого октета равен 1, такой адрес считается multicast. Сообщение: `NIC cannot have multicast MAC address (odd 1st byte)` (рис. @fig-qemu-mac-fail).

  #figure(
    image("images/22_qemu_mac_fail.png", width: 95%),
    caption: [Отказ QEMU: MAC-адрес 17:10:20:22:20:09 — multicast],
  ) <fig-qemu-mac-fail>

  Первый октет заменён на `16`, остальные байты те же. Адрес `16:10:20:22:20:09` — unicast, его можно назначить карте. Параметры запуска не менялись: 2 ГБ памяти, KVM, диск virtio, полноэкранный режим и сеть user (рис. @fig-qemu-mac-ok).

  #figure(
    image("images/23_qemu_mac_ok.png", width: 95%),
    caption: [Запуск QEMU с unicast MAC-адресом 16:10:20:22:20:09],
  ) <fig-qemu-mac-ok>

  С этим адресом гостевая система загрузилась в полный экран. В терминале `cat /etc/os-release` показывает Fedora Linux 43, вариант Xfce (рис. @fig-qemu-fedora).

  #figure(
    image("images/21_qemu_fedora.png", width: 95%),
    caption: [Fedora 43 Xfce в полноэкранном режиме],
  ) <fig-qemu-fedora>

== Virtual Machine Manager
+ *Установка пакетов и настройка libvirt*

  Установлены `qemu-system-x86`, `libvirt-daemon-system`, `libvirt-clients`, `bridge-utils`, `virt-manager` и `virt-install`. Пользователь добавлен в группу `libvirt` (рис. @fig-libvirt-install). Повторная проверка `kvm-ok` снова подтверждает доступность KVM (рис. @fig-kvm-ok-2).

  #figure(
    image("images/24_libvirt_install.png", width: 95%),
    caption: [Установка libvirt, virt-manager и virt-install],
  ) <fig-libvirt-install>

  #figure(
    image("images/25_kvm_ok.png", width: 95%),
    caption: [Повторная проверка kvm-ok],
  ) <fig-kvm-ok-2>

  Демон `libvirtd` запущен и включён в автозагрузку: состояние `active (running)`. Вместе с ним работает `dnsmasq` на мосту `virbr0` и раздаёт адреса `192.168.122.2`–`192.168.122.254` (рис. @fig-libvirtd).

  #figure(
    image("images/28_libvirtd.png", width: 95%),
    caption: [Состояние службы libvirtd],
  ) <fig-libvirtd>

+ *Создание виртуальной машины*

  В virt-manager создана машина `AKK-P3418`. Она запущена, статус `Running (Booted)`. Гипервизор — KVM, архитектура x86_64, эмулятор `/usr/bin/qemu-system-x86_64`, чипсет Q35, прошивка BIOS (рис. @fig-vmm-vm).

  #figure(
    image("images/29_vmm_vm.png", width: 95%),
    caption: [Машина AKK-P3418 в virt-manager],
  ) <fig-vmm-vm>

+ *Дополнительный жёсткий диск*

  К машине добавлен второй диск. В мастере указан объём 0,01 ГиБ, тип устройства — диск, шина VirtIO (рис. @fig-disk-add). После добавления это VirtIO Disk 2: файл `/var/lib/libvirt/images/AKK-P3418-1.qcow2`, размер 10,24 МиБ (рис. @fig-disk-added).

  #figure(
    image("images/30_disk_add.png", width: 95%),
    caption: [Добавление диска объёмом 0,01 ГиБ],
  ) <fig-disk-add>

  #figure(
    image("images/31_disk_added.png", width: 95%),
    caption: [Второй диск VirtIO Disk 2 объёмом 10,24 МиБ],
  ) <fig-disk-added>

+ *Настройки и оперативный мониторинг*

  В окне машины слева собраны параметры, которые задаёт virt-manager: процессоры, память, порядок загрузки, диски, сетевой адаптер, видео VirtIO, консоль SPICE, звук и USB (рис. @fig-vmm-vm). Пока гость работал, загрузку смотрели утилитой `btop`: у машины около 1,9 ГиБ памяти, процессор почти свободен, на интерфейсе `enp1s0` виден входящий и исходящий трафик (рис. @fig-btop).

+ *Снимки состояния*

  У работающей `AKK-P3418` создан снимок `Before` в режиме external (рис. @fig-snapshot-before). Затем в гостевой Fedora поставлен пакет `btop`: повторный `dnf install` сообщает, что `btop-1.4.7-1.fc43` уже установлен (рис. @fig-btop-install). Утилита запускается и показывает нагрузку (рис. @fig-btop).

  #figure(
    image("images/32_snapshot_before.png", width: 95%),
    caption: [Снимок Before работающей машины],
  ) <fig-snapshot-before>

  #figure(
    image("images/33_btop_install.png", width: 95%),
    caption: [Пакет btop в гостевой Fedora],
  ) <fig-btop-install>

  #figure(
    image("images/34_btop.png", width: 95%),
    caption: [Загрузка гостевой системы в btop],
  ) <fig-btop>

  Состояние с установленным `btop` сохранено снимком `With btop`, тоже external, вместе с памятью (рис. @fig-snapshot-btop). После этого машина возвращена к снимку `Before` (рис. @fig-snapshot-restore). В восстановленной системе `which btop` не находит программу, команда `btop` отвечает `command not found` (рис. @fig-btop-gone).

  #figure(
    image("images/35_snapshot_btop.png", width: 95%),
    caption: [Создание снимка With btop],
  ) <fig-snapshot-btop>

  #figure(
    image("images/36_snapshot_restore.png", width: 95%),
    caption: [Возврат к снимку Before],
  ) <fig-snapshot-restore>

  #figure(
    image("images/37_btop_gone.png", width: 95%),
    caption: [После отката пакета btop в системе нет],
  ) <fig-btop-gone>

+ *Сетевые настройки гостевой машины*

  У сетевого адаптера машины virt-manager предлагает четыре источника: виртуальная сеть `default` в режиме NAT, мост (Bridge device), Macvtap и vDPA. Канал адаптера включён, состояние link — active (рис. @fig-vmm-net).

  #figure(
    image("images/38_vmm_network.png", width: 95%),
    caption: [Источники сети сетевого адаптера в virt-manager],
  ) <fig-vmm-net>

== Управление из командной строки
+ *Команды virsh*

  `virsh list` показывает только запущенные домены: на снимке список пуст. `virsh list --all` выводит и выключенные: машина `AKK-P3418` находится в состоянии `shut off` (рис. @fig-virsh-list). Запуск домена командой `virsh start` показан ниже, на машине `AKK_P3418`.

  #figure(
    image("images/39_virsh_list.png", width: 95%),
    caption: [virsh list и virsh list --all],
  ) <fig-virsh-list>

  Остальные команды управления тем же именем домена: `reboot` перезагружает гостя, `shutdown` просит систему завершиться штатно, `destroy` выключает её сразу, как снятие питания, `autostart` включает запуск вместе с libvirt.

+ *Клонирование виртуальной машины*

  // TODO: virt-clone --help и клон машины, который можно использовать как основу.

== Утилита virt-install
+ *Установка пакетов и список ОС*

  Пакет `virt-install` установлен вместе со стеком libvirt. Повторная установка подтверждает, что `virt-install` 5.1.0-1 и `libosinfo-bin` 1.12.0-3build1 уже стоят в системе (рис. @fig-virt-install-apt). Список ОС из репозитория osinfo отфильтрован и сохранён в файлы. Для Windows в списке есть, в частности, Windows 10, 11 и серверные выпуски (рис. @fig-os-win). Для Fedora в списке есть выпуски вплоть до Fedora Linux 42 (рис. @fig-os-fedora).

  ```bash
  osinfo-query os | grep -i windows | sort > windows_list.txt
  osinfo-query os | grep -i fedora | sort > fedora_list.txt
  ```

  #figure(
    image("images/26_windows_list.png", width: 95%),
    caption: [Отсортированный список ОС Windows из osinfo-query],
  ) <fig-os-win>

  #figure(
    image("images/27_fedora_list.png", width: 95%),
    caption: [Отсортированный список ОС Fedora из osinfo-query],
  ) <fig-os-fedora>

  #figure(
    image("images/40_virt_install_apt.png", width: 95%),
    caption: [Пакеты virt-install и libosinfo-bin уже установлены],
  ) <fig-virt-install-apt>

+ *Создание виртуальной машины*

  Второй домен, `AKK_P3418`, создан утилитой `virt-install` с ISO Fedora Xfce Live 43. Пул хранения меньше запрошенных 8 ГБ (доступно около 5321 МБ), поэтому проверка размера диска отключена флагом `--check disk_size=off`. Домен создан и остался запущенным, в окне virt-manager у него состояние Running, гость загрузил Live-систему (рис. @fig-virt-install).

  #figure(
    image("images/41_virt_install.png", width: 95%),
    caption: [Создание машины AKK_P3418 командой virt-install],
  ) <fig-virt-install>

+ *Параметры команды*

  `--name` задаёт имя домена `AKK_P3418`. `--virt-type kvm` выбирает гипервизор KVM. `--memory 2048` выделяет 2048 МиБ оперативной памяти, `--vcpus 2` — два виртуальных процессора. `--os-variant fedora42` подбирает оборудование под профиль Fedora 42: отдельной записи Fedora 43 в osinfo нет, а ставится образ 43. `--hvm` включает полную аппаратную виртуализацию. `--cdrom` указывает ISO Fedora Xfce Live 43. `--network default,model=virtio` подключает машину к NAT-сети `default` с адаптером virtio. `--disk` создаёт диск qcow2 на 8 ГБ по шине virtio в каталоге образов libvirt. `--graphics vnc` открывает графическую консоль по VNC. `--noautoconsole` не подключает эту консоль сразу, установка идёт в фоне.

+ *Запуск, фоновый режим и подключение по SSH*

  После создания обе машины были выключены. `virsh start AKK_P3418` поднимает домен без отдельного окна установщика: в virt-manager `AKK_P3418` переходит в Running, а `AKK-P3418` остаётся выключенной (рис. @fig-virsh-start).

  #figure(
    image("images/42_virsh_start.png", width: 95%),
    caption: [Фоновый запуск AKK_P3418 командой virsh start],
  ) <fig-virsh-start>

  В гостевой Live-системе пакет `openssh-server` уже был установлен, служба `sshd` включена командой `systemctl enable --now sshd`, пользователю `liveuser` задан пароль. Адрес интерфейса `enp1s0` — `192.168.122.57/24`, он из сети `virbr0`. С Ubuntu выполнено `ssh liveuser@192.168.122.57`: ключ хоста принят и записан в `known_hosts`. В сессии `whoami` возвращает `liveuser`, а `/etc/os-release` подтверждает Fedora Linux 43 (Xfce) (рис. @fig-ssh).

  #figure(
    image("images/43_ssh.png", width: 95%),
    caption: [Подключение по SSH к гостевой Fedora],
  ) <fig-ssh>

= Заключение

В гостевой Ubuntu внутри VirtualBox развёрнута вложенная виртуализация KVM. Через GNOME Boxes запущена Fedora 43 Xfce в режиме Live, проверены свойства машины, выполнен вход по SSH на helios и сеанс удалённого рабочего стола хоста по RDP. Прямым вызовом QEMU создан диск и установлена та же Fedora; адрес `17:10:20:22:20:09` отклонён как multicast, с адресом `16:10:20:22:20:09` система загрузилась в полный экран. В virt-manager собрана машина `AKK-P3418`: к ней добавлен диск около 10 МиБ, сняты снимки до и после установки `btop`, возврат к снимку `Before` убрал пакет из системы. Утилитой `virt-install` создан второй домен `AKK_P3418`, он запущен в фоне через `virsh start`, и с Ubuntu к нему открыта сессия SSH.
