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

== Цель работы

== Задачи работы

= Выполнение
// Скриншоты — в каталог images/. Вставка:
// #figure(
//   image("images/имя.png", width: 95%),
//   caption: [Подпись],
// ) <fig-id>
// Команды давать блоком ```bash ... ``` или через #source("scripts/файл.sh", "bash").

= Заключение
