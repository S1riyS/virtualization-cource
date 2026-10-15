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
Лабораторная работа посвящена гипервизорам в Unix. В гостевой Ubuntu внутри Oracle VirtualBox запускались вложенные машины QEMU/KVM: через GNOME Boxes, прямым вызовом QEMU и в Virtual Machine Manager. Из командной строки использовались virsh, virt-install и virt-clone.

== Цель работы
Освоить создание и управление виртуальными машинами на базе QEMU/KVM и libvirt.

== Задачи работы
+ Настроить окружение для вложенной виртуализации с активацией Nested VT-x.
+ Сконфигурировать дополнительное дисковое пространство для размещения образов виртуальных машин.
+ Освоить три подхода к созданию VM: Gnome Boxes, прямая работа с QEMU/KVM, Virtual Machine Manager.
+ Изучить механизмы создания снимков состояния виртуальных машин.
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

  К машине `WS_AKK_ubuntu` добавлен жёсткий диск SATA объёмом 30 ГБ (рис. @fig-sata-disk).

  #figure(
    image("images/1_sata_disk.png", width: 95%),
    caption: [Создание виртуального жёсткого диска SATA объёмом 30 ГБ],
  ) <fig-sata-disk>

  В Ubuntu диск `/dev/sdb` отформатирован в Ext4 и смонтирован в `/run/media/kirill/data` (рис. @fig-disk-mounted).

  #figure(
    image("images/2_disk_mounted.png", width: 95%),
    caption: [Диск `/dev/sdb` с файловой системой Ext4, смонтирован в `/run/media/kirill/data`],
  ) <fig-disk-mounted>

+ *Проверка конфигурации процессора и ускорения*

  Во вкладке «Процессор» включены PAE/NX и Nested VT-x/AMD-V (рис. @fig-cpu).

  #figure(
    image("images/3_cpu.png", width: 95%),
    caption: [Настройки процессора: Nested VT-x/AMD-V включён],
  ) <fig-cpu>

  Во вкладке «Ускорение» включён Nested Paging (рис. @fig-accel).

  #figure(
    image("images/4_acceleration.png", width: 95%),
    caption: [Настройки ускорения: Nested Paging включён],
  ) <fig-accel>

+ *Общая папка Soft*

  Папка `/home/s1riys/Soft` подключена к гостевой машине с полным доступом и автоподключением (рис. @fig-share-vbox).

  #figure(
    image("images/5_shared_folder_vbox.png", width: 95%),
    caption: [Общая папка Soft в настройках VirtualBox],
  ) <fig-share-vbox>

  В Ubuntu она смонтирована в `/media/sf_Soft`. Файл `test.txt` виден и на хосте, и в гостевой ОС (рис. @fig-share-file).

  #figure(
    image("images/6_shared_folder_file.png", width: 95%),
    caption: [Файл test.txt в общей папке Soft на хосте и в гостевой ОС],
  ) <fig-share-file>

+ *Загрузка дистрибутива*

  С http://mirror.yandex.ru загружен Live-образ `Fedora-Xfce-Live-43-1.6.x86_64.iso` (рис. @fig-iso).

  #figure(
    image("images/7_iso.png", width: 95%),
    caption: [Загруженный ISO Fedora Xfce Live 43],
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

  В Boxes создана виртуальная машина, носитель — ISO Fedora (рис. @fig-boxes-iso). Система запущена в режиме Live (рис. @fig-boxes-live).

  #figure(
    image("images/8_boxes_iso.png", width: 95%),
    caption: [Выбор ISO Fedora при создании ВМ в GNOME Boxes],
  ) <fig-boxes-iso>

  #figure(
    image("images/9_boxes_live.png", width: 95%),
    caption: [Fedora 43 Xfce, запущенная в режиме Live],
  ) <fig-boxes-live>

+ *Свойства виртуальной машины*

  В свойствах задаются имя, число процессоров, память, предел диска, 3D-ускорение и разрешение фонового запуска (рис. @fig-boxes-props). Графиков загрузки нет: оперативный мониторинг Boxes не показывает.

  #figure(
    image("images/10_boxes_properties.png", width: 95%),
    caption: [Свойства виртуальной машины в GNOME Boxes],
  ) <fig-boxes-props>

+ *Подключение к серверу Helios*

  Из Live-сессии выполнено подключение к серверу Helios:

  ```bash
  ssh -p 2222 s413732@helios.cs.ifmo.ru
  ```

  Открылась оболочка FreeBSD 14.5-STABLE (рис. @fig-helios).

  #figure(
    image("images/11_helios_ssh.png", width: 95%),
    caption: [SSH-сессия на helios.cs.ifmo.ru, порт 2222],
  ) <fig-helios>

+ *Сетевой мост*

  У Ubuntu адаптер 1 подключён как «Сетевой мост» (рис. @fig-bridge).

  #figure(
    image("images/12_bridge.png", width: 95%),
    caption: [Сетевой мост гостевой Ubuntu в VirtualBox],
  ) <fig-bridge>

+ *Удалённый рабочий стол*

  Соседнего компьютера с Windows не было, поэтому по RDP открыт рабочий стол хоста: сервер `192.168.0.14`, пользователь `s1riys` (рис. @fig-rdp-profile, рис. @fig-rdp-laptop).

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

  Установлены `qemu-system-x86`, `qemu-utils` и `cpu-checker`. Команда `kvm-ok` подтверждает доступность KVM (рис. @fig-kvm-ok), загружены модули `kvm_amd` и `kvm` (рис. @fig-kvm-lsmod).

  #figure(
    image("images/19_kvm_ok.png", width: 95%),
    caption: [Проверка KVM командой kvm-ok],
  ) <fig-kvm-ok>

  #figure(
    image("images/16_kvm_lsmod.png", width: 95%),
    caption: [Загруженные модули kvm и kvm_amd],
  ) <fig-kvm-lsmod>

+ *Создание виртуального диска и запуск машины*

  Создан диск qcow2 объёмом 10 ГБ:

  ```bash
  mkdir -p ~/VM
  qemu-img create -f qcow2 ~/VM/Fedora-36.img 10G
  ```

  Образ записан в `~/VM/Fedora-36.img` (рис. @fig-qemu-img).

  #figure(
    image("images/17_qemu_img.png", width: 95%),
    caption: [Создание диска Fedora-36.img объёмом 10 ГБ],
  ) <fig-qemu-img>

  Запуск машины с пустого диска:

  ```bash
  qemu-system-x86_64 ~/VM/Fedora-36.img
  ```

  На диске нет ОС, QEMU останавливается с сообщением `No bootable device` (рис. @fig-qemu-empty).

  #figure(
    image("images/18_qemu_empty.png", width: 95%),
    caption: [Запуск QEMU с пустого диска: загружать нечего],
  ) <fig-qemu-empty>

  #colbreak()

+ *Установка гостевой ОС*

  С диска `Fedora-36.img` и ISO Fedora 43 запущена установка (рис. @fig-qemu-install).

  #figure(
    image("images/20_qemu_install.png", width: 95%),
    caption: [Установка Fedora 43 Xfce в QEMU],
  ) <fig-qemu-install>

+ *Команда запуска с полноэкранным режимом и MAC-адресом*

  Запуск в полный экран с MAC-адресом `17:10:20:22:20:09` не удался: адрес multicast, QEMU его не назначает (рис. @fig-qemu-mac-fail).

  #figure(
    image("images/22_qemu_mac_fail.png", width: 95%),
    caption: [Отказ QEMU: MAC-адрес 17:10:20:22:20:09 — multicast],
  ) <fig-qemu-mac-fail>

  С адресом `16:10:20:22:20:09` система загрузилась в полный экран (рис. @fig-qemu-mac-ok, рис. @fig-qemu-fedora).

  #figure(
    image("images/23_qemu_mac_ok.png", width: 95%),
    caption: [Запуск QEMU с unicast MAC-адресом 16:10:20:22:20:09],
  ) <fig-qemu-mac-ok>

  #figure(
    image("images/21_qemu_fedora.png", width: 95%),
    caption: [Fedora 43 Xfce в полноэкранном режиме],
  ) <fig-qemu-fedora>

== Virtual Machine Manager
+ *Установка пакетов и настройка libvirt*

  Установлены пакеты libvirt и virt-manager, пользователь добавлен в группу `libvirt` (рис. @fig-libvirt-install). Гостевая Ubuntu перезапущена, затем `kvm-ok` снова подтверждает KVM (рис. @fig-kvm-ok-2).

  #figure(
    image("images/24_libvirt_install.png", width: 95%),
    caption: [Установка libvirt, virt-manager и virt-install],
  ) <fig-libvirt-install>

  #figure(
    image("images/25_kvm_ok.png", width: 95%),
    caption: [Повторная проверка kvm-ok],
  ) <fig-kvm-ok-2>

  Служба `libvirtd` в состоянии `active (running)` (рис. @fig-libvirtd).

  #figure(
    image("images/28_libvirtd.png", width: 95%),
    caption: [Состояние службы libvirtd],
  ) <fig-libvirtd>

+ *Создание виртуальной машины*

  В мастере virt-manager создана машина `AKK-P3418`: Fedora, локальный ISO, 2048 МиБ, 2 процессора, диск 7 ГиБ (рис. @fig-vmm-new).

  #figure(
    image("images/44_vmm_new.png", width: 95%),
    caption: [Параметры машины AKK-P3418 перед началом установки в virt-manager],
  ) <fig-vmm-new>

  После запуска статус машины — `Running` (рис. @fig-vmm-vm).

  #figure(
    image("images/29_vmm_vm.png", width: 95%),
    caption: [Машина AKK-P3418 в virt-manager],
  ) <fig-vmm-vm>

+ *Дополнительный жёсткий диск*

  Добавлен второй диск объёмом 0,01 ГиБ, шина VirtIO (рис. @fig-disk-add). Это VirtIO Disk 2 размером 10,24 МиБ (рис. @fig-disk-added).

  #figure(
    image("images/30_disk_add.png", width: 95%),
    caption: [Добавление диска объёмом 0,01 ГиБ],
  ) <fig-disk-add>

  #figure(
    image("images/31_disk_added.png", width: 95%),
    caption: [Второй диск VirtIO Disk 2 объёмом 10,24 МиБ],
  ) <fig-disk-added>

+ *Настройки и оперативный мониторинг*

  В окне машины слева задаётся оборудование: число процессоров и объём памяти, порядок загрузки, диски, сетевой адаптер, видео VirtIO, консоль SPICE, звук и USB (рис. @fig-vmm-vm). Оперативный мониторинг открывается на вкладке Performance: графики загрузки процессора и памяти, скорость чтения и записи диска, входящий и исходящий трафик и время работы машины.

+ *Снимки состояния*

  Создан снимок `Before` (рис. @fig-snapshot-before). В гостевой системе установлен `btop` (рис. @fig-btop-install, рис. @fig-btop).

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

  Состояние сохранено снимком `With btop` (рис. @fig-snapshot-btop). После возврата к `Before` (рис. @fig-snapshot-restore) пакета `btop` в системе нет (рис. @fig-btop-gone).

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

  Для адаптера доступны сеть `default` (NAT), мост, Macvtap и vDPA (рис. @fig-vmm-net).

  #figure(
    image("images/38_vmm_network.png", width: 95%),
    caption: [Источники сети сетевого адаптера в virt-manager],
  ) <fig-vmm-net>

== Управление из командной строки
+ *Команды virsh*

  `virsh list` показывает запущенные домены, `virsh list --all` — все. Машина `AKK-P3418` в состоянии `shut off` (рис. @fig-virsh-list). Запуск `virsh start` показан ниже.

  #figure(
    image("images/39_virsh_list.png", width: 95%),
    caption: [virsh list и virsh list --all],
  ) <fig-virsh-list>

  Остальные команды:

  - `reboot` перезагружает гостя.
  - `shutdown` просит систему завершиться штатно.
  - `destroy` выключает её сразу, как снятие питания.
  - `autostart` включает запуск вместе с libvirt.
  - `virt-clone --help` показывает справку утилиты клонирования: копия машины служит основой для других виртуальных ОС.

== Утилита virt-install
+ *Установка пакетов и список ОС*

  Пакеты `virt-install` и `libosinfo-bin` уже установлены (рис. @fig-virt-install-apt). Списки Windows и Fedora сохранены в файлы (рис. @fig-os-win, рис. @fig-os-fedora).

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

  Домен `AKK_P3418` создан командой `virt-install` и запущен (рис. @fig-virt-install). Пул меньше 8 ГБ, поэтому указан `--check disk_size=off`.

  #figure(
    image("images/41_virt_install.png", width: 95%),
    caption: [Создание машины AKK_P3418 командой virt-install],
  ) <fig-virt-install>

+ *Параметры команды*

  - `--name` задаёт имя домена `AKK_P3418`.
  - `--virt-type kvm` выбирает гипервизор KVM.
  - `--memory 2048` выделяет 2048 МиБ оперативной памяти.
  - `--vcpus 2` назначает два виртуальных процессора.
  - `--os-variant fedora42` подбирает оборудование под профиль Fedora 42: отдельной записи Fedora 43 в osinfo нет, а ставится образ 43.
  - `--hvm` включает полную аппаратную виртуализацию.
  - `--cdrom` указывает ISO Fedora Xfce Live 43.
  - `--network default,model=virtio` подключает машину к NAT-сети `default` с адаптером virtio.
  - `--disk` создаёт диск qcow2 на 8 ГБ по шине virtio в каталоге образов libvirt.
  - `--graphics vnc` открывает графическую консоль по VNC.
  - `--noautoconsole` не подключает эту консоль сразу, установка идёт в фоне.

+ *Запуск, фоновый режим и подключение по SSH*

  `virsh start AKK_P3418` запускает домен в фоне (рис. @fig-virsh-start).

  #figure(
    image("images/42_virsh_start.png", width: 95%),
    caption: [Фоновый запуск AKK_P3418 командой virsh start],
  ) <fig-virsh-start>

  На гостевой системе включён `sshd`, пользователю `liveuser` задан пароль. С Ubuntu выполнено `ssh liveuser@192.168.122.57` (рис. @fig-ssh).

  #figure(
    image("images/43_ssh.png", width: 95%),
    caption: [Подключение по SSH к гостевой Fedora],
  ) <fig-ssh>

= Заключение

В гостевой Ubuntu внутри Oracle VirtualBox подготовлено окружение для вложенной виртуализации QEMU/KVM. К машине добавлен диск под образы, включены Nested VT-x/AMD-V и Nested Paging, с хоста подключена общая папка. С зеркала Яндекса загружен Live-образ Fedora Xfce 43.

Образ запускался тремя способами. GNOME Boxes поднимает машину в режиме Live: в свойствах задаются процессоры, память. Из этой сессии открыт SSH на сервер Helios. Адаптер Ubuntu работает как сетевой мост, а по RDP открыт рабочий стол хоста.

В virt-manager после установки libvirt и перезапуска Ubuntu создана машина и добавлен второй диск. В окне настраивается оборудование, вкладка Performance показывает загрузку процессора и памяти, диск, трафик и время работы. Снимок с установленным `btop` проверен откатом к предыдущему состоянию. Для адаптера доступны сеть NAT, мост, Macvtap и vDPA.

Из командной строки `virsh` показывает домены и управляет их запуском, перезагрузкой, выключением и автозапуском. `virt-install` создаёт домен по профилю из osinfo и запускает его в фоне, подключение к гостю проверено по SSH.

Цель работы достигнута: виртуальные машины на базе QEMU/KVM и libvirt создаются и управляются через GNOME Boxes, прямой вызов QEMU, Virtual Machine Manager и утилиты `virsh` и `virt-install`.
