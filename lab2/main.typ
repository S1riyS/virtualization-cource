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

  // SATA, 30 ГБ, настройки носителей ВМ Ubuntu в VirtualBox.

+ *Проверка конфигурации процессора и ускорения*

  // Вкладки «Процессор» и «Ускорение». Для KVM внутри гостя нужна вложенная виртуализация.

+ *Общая папка Soft*

  // Папка Soft, общая для хоста и гостевой Ubuntu. Показать, что файл проходит в обе стороны.

+ *Загрузка дистрибутива*

  // Образ с http://mirror.yandex.ru. В задании для первого шага подходит любая ОС, предпочтительно Live.
  // Образцы команд QEMU и virt-install ниже рассчитаны на Fedora.

== Работа с GNOME Boxes
+ *Установка GNOME Boxes*

  // sudo apt install gnome-boxes

+ *Создание виртуальной машины и запуск LiveCD*

  // Выбор ISO и загрузка без установки.

+ *Свойства виртуальной машины*

  // Какие параметры можно менять и что видно в оперативном режиме.
  // Конфигурация Boxes совместима с libvirt, подробный мониторинг — в Virtual Machine Manager.

+ *Подключение к серверу Helios*

  // Пример из задания: ssh://belozubov@helios.cs.ifmo.ru:2222
  // Подставить свой логин. Если helios.cs.ifmo.ru недоступен, проверить актуальный адрес (se.ifmo.ru, порт 2222).

+ *Сетевой мост*

  // У гостевой Ubuntu в VirtualBox должен быть тип подключения «Сетевой мост».

+ *Удалённый рабочий стол*

  // RDP к машине соседа: IP, логин и пароль. Если соседа нет — к своему хосту.
  // Клиент ставится в той системе, откуда выполняется подключение.

== Работа с QEMU
+ *Установка QEMU и проверка KVM*

  // Поддержка KVM до создания диска: kvm-ok или проверка /dev/kvm.

+ *Создание виртуального диска и запуск машины*

  // mkdir VM
  // qemu-img create -f qcow2 ./VM/Fedora-36.img 10G
  // qemu-system-x86_64 ./VM/Fedora-36.img

+ *Установка гостевой ОС*

  // qemu-system-x86_64 -m 2048 -enable-kvm Fedora-36.img -cdrom fedora.iso
  // Путь к ISO указать полностью. Образ можно переименовать в fedora.iso.

+ *Команда запуска с полноэкранным режимом и MAC-адресом*

  // Параметры задания: полноэкранный режим и MAC 17:10:20:22:20:09.
  // Адрес 17:10:20:22:20:09 — multicast (младший бит первого октета равен 1), QEMU его не примет.
  // Рабочий unicast-адрес отличается первым октетом, например 16:10:20:22:20:09. В тексте объяснить замену.

== Virtual Machine Manager
+ *Установка пакетов и настройка libvirt*

  // sudo apt install qemu qemu-kvm libvirt-daemon libvirt-clients bridge-utils virt-manager
  // sudo gpasswd -a $USER libvirt
  // sudo systemctl status libvirtd
  // Перезапуск гостя, затем kvm-ok.
  // На Ubuntu пакет демона может называться libvirt-daemon-system.

+ *Создание виртуальной машины*

  // Имя: ФИО-группа, например AKK-P3418. Скриншот мастера и работающей системы.
  // Проверить настройки созданной машины.

+ *Дополнительный жёсткий диск*

  // Второй диск объёмом 10 МиБ.

+ *Настройки и оперативный мониторинг*

  // Что можно задать в VMM (CPU, память, диски, сеть, видео, консоль) и что видно на лету
  // (загрузка CPU, память, дисковый ввод-вывод, трафик).

+ *Снимки состояния*

  // Снимок, установка Яндекс Браузера, восстановление исходного снимка, проверка, что браузера нет.

+ *Сетевые настройки гостевой машины*

  // Режимы, которые реально предлагает virt-manager: NAT (сеть default), мост, macvtap, изолированная сеть.
  // Описать по интерфейсу, а не общим списком.

== Управление из командной строки
+ *Команды virsh*

  // virsh list и virsh list --all
  // virsh reboot, stop, destroy, start, shutdown, autostart — с именем созданной машины.
  // destroy — принудительное выключение, shutdown — штатное.

+ *Клонирование виртуальной машины*

  // virt-clone --help и само клонирование системы, чтобы копию можно было использовать как основу.

== Утилита virt-install
+ *Установка пакетов и список ОС*

  // sudo apt install virt-install libosinfo-bin
  // osinfo-query os
  // Списки Windows и Fedora сохранить, например:
  // osinfo-query os | grep -i windows | sort > windows_list.txt
  // osinfo-query os | grep -i fedora | sort > fedora_list.txt

+ *Создание виртуальной машины*

  // Команда из задания. Имя и вариант ОС подставить свои, если образ не Fedora:
  // virt-install \
  //   --name FIO_Group \
  //   --virt-type=kvm \
  //   --memory 2048 \
  //   --vcpus=2 \
  //   --os-variant=fedora31 \
  //   --hvm \
  //   --cdrom=fedora.iso \
  //   --network default,model=virtio \
  //   --disk path=~/VM/fedora31.qcow2,size=8,bus=virtio,format=qcow2 \
  //   --graphics vnc \
  //   --noautoconsole

+ *Параметры команды*

  // Кратко по каждому флагу: имя, тип гипервизора, память, vCPU, вариант ОС, HVM,
  // ISO, сеть, диск, графика, отказ от автооткрытия консоли.

+ *Запуск, фоновый режим и подключение по SSH*

  // Проверить запуск через virsh. Фоновый режим: virt-install уже вызван с --noautoconsole,
  // сама машина поднимается virsh start и не открывает окно.
  // Для SSH: в госте установить openssh-server, узнать адрес (virsh domifaddr) и подключиться с Ubuntu.

= Заключение
// Пишется после выполнения: что установлено, какие машины созданы, чем инструменты отличаются,
// какие навыки получены. Цель из введения пересказать как достигнутую.
