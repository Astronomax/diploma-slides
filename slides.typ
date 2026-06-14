#import "@preview/polylux:0.4.0": *
#import "@preview/cetz:0.3.4": canvas, draw

#set page(
  paper: "presentation-16-9",
  margin: (x: 1.3cm, y: 0.9cm),
  fill: none,
  background: image("background.jpg", width: 120%, height: 120%, fit: "cover"),
)
#set text(font: "Ubuntu Sans", size: 16pt, lang: "ru")
#set par(justify: true, leading: 0.58em)
#set list(indent: 0.7em, spacing: 0.45em)

#let slide-logo(pos) = {
  place(
    pos,
    dx: if pos == bottom + left { -0.7cm } else { 0.35cm },
    dy: if pos == bottom + left { -0.45cm } else { -0.25cm },
    image("mkn.png", height: 1.0cm),
  )
}

#let content-slide(title, logo-pos: top + right, body) = slide[
  #slide-logo(logo-pos)
  #text(size: 24pt, weight: "bold")[#title]
  #v(0.35cm)
  #body
]

#let diagram-slide(title, svg-path) = slide[
  #slide-logo(top + right)
  #text(size: 24pt, weight: "bold")[#title]
  #v(0.15cm)
  #box(height: 12.5cm)[
    #align(center + horizon)[
      #image(svg-path, width: 100%, height: 100%, fit: "contain")
    ]
  ]
]

#let graph-cell(label, path) = block(height: 100%, width: 100%)[
  #grid(
    rows: (1fr, auto),
    row-gutter: 0.05cm,
    rect(fill: white, inset: 0pt, width: 100%, height: 100%)[
      #align(center + horizon)[
        #image(path, width: 100%, height: 100%, fit: "contain")
      ]
    ],
    align(center)[#text(size: 12pt, weight: "bold")[Workload #label]],
  )
]

#let multi-graph-slide(title, graphs, body: none, layout: "row") = {
  let graphs-block = if layout == "2x2" {
    block(height: 100%, width: 100%)[
      #grid(
        columns: (1fr, 1fr),
        rows: (1fr, 1fr),
        column-gutter: 0.25cm,
        row-gutter: 0.25cm,
        ..({
          let cells = graphs.map(((label, path)) => graph-cell(label, path))
          let empty = graphs.len()
          cells + (range(4 - empty).map(_ => []))
        }),
      )
    ]
  } else {
    block(height: 100%, width: 100%)[
      #grid(
        columns: (1fr,) * graphs.len(),
        column-gutter: 0.25cm,
        ..graphs.map(((label, path)) => graph-cell(label, path)),
      )
    ]
  }
  slide[
    #slide-logo(top + right)
    #block(height: 100%, width: 100%)[
      #if body != none {
        grid(
          rows: (auto, 1fr, auto),
          row-gutter: 0.1cm,
          [#text(size: 24pt, weight: "bold")[#title]],
          graphs-block,
          {
            set text(size: 13pt)
            set par(leading: 0.48em)
            body
          },
        )
      } else {
        grid(
          rows: (auto, 1fr),
          row-gutter: 0.1cm,
          [#text(size: 24pt, weight: "bold")[#title]],
          graphs-block,
        )
      }
    ]
  ]
}

#let graph-slide(title, path, body: none) = slide[
  #slide-logo(top + right)
  #block(height: 100%, width: 100%)[
    #if body != none {
      grid(
        rows: (auto, 1fr, auto),
        row-gutter: 0.1cm,
        [#text(size: 24pt, weight: "bold")[#title]],
        rect(fill: white, inset: 0pt, width: 100%, height: 100%)[
          #align(center + horizon)[
            #image(path, width: 100%, height: 100%, fit: "contain")
          ]
        ],
        {
          set text(size: 13pt)
          set par(leading: 0.48em)
          body
        },
      )
    } else {
      grid(
        rows: (auto, 1fr),
        row-gutter: 0.1cm,
        [#text(size: 24pt, weight: "bold")[#title]],
        rect(fill: white, inset: 0pt, width: 100%, height: 100%)[
          #align(center + horizon)[
            #image(path, width: 100%, height: 100%, fit: "contain")
          ]
        ],
      )
    }
  ]
]

// #let amp-triangle = canvas(length: 1cm, {
//   import draw: *
//   let a = (0, 0)
//   let b = (9.5, 0)
//   let c = (4.75, 8.2)
//   line(a, b, c, close: true, stroke: 1.2pt + rgb("#666666"))
//   content((-0.2, -0.55), text(size: 8pt, fill: rgb("#d97706"))[Write Amp], anchor: "north")
//   content((9.7, -0.55), text(size: 8pt, fill: rgb("#16a34a"))[Space Amp], anchor: "north")
//   content((4.75, 8.75), text(size: 8pt, fill: rgb("#2563eb"))[Read Amp], anchor: "south")
//   content((1.8, 3.8), text(size: 8pt, fill: rgb("#2563eb"))[LCS], anchor: "center")
//   content((4.75, 4.2), text(size: 8pt, fill: rgb("#7c3aed"))[Vinyl], anchor: "center")
//   content((6.8, 2.0), text(size: 8pt, fill: rgb("#d97706"))[STCS], anchor: "center")
//   circle((1.5, 3.2), radius: 0.35, stroke: 1pt + rgb("#2563eb"))
//   circle((4.75, 3.7), radius: 0.35, stroke: 1pt + rgb("#7c3aed"))
//   circle((6.5, 1.7), radius: 0.35, stroke: 1pt + rgb("#d97706"))
//   content((2.0, 2.0), text(size: 7pt, fill: rgb("#dc2626"))[меньше слияний ->\ дешевле запись,\ дороже чтение], anchor: "center")
//   content((7.2, 3.4), text(size: 7pt, fill: rgb("#16a34a"))[+ больше слияний\ дешевле чтение,\ больше мусора], anchor: "center")
//   content((4.75, -1.0), text(size: 7pt, fill: rgb("#d97706"))[+ чаще GC = меньше мусора,\ дороже запись +], anchor: "north")
// })

#slide[
  #slide-logo(bottom + left)
  #v(0.8cm)
  #text(size: 26pt, weight: "bold")[
    Разработка механизма кэширования постраничного индекса LSM-дерева на основе B-деревьев
  ]
  #v(1fr)
  #align(right)[
    #grid(
      columns: (auto, auto),
      column-gutter: 1.2em,
      row-gutter: 0.35em,
      align: (left, right),
      [студент:], [Антон Кузнец],
      [руководитель:], [Константин Осипов],
    )
  ]
]

#content-slide([LSM], logo-pos: bottom + left)[
  #strong[LSM-tree] как идея был предложен в середине 1990-х.

  Опубликован в статье #emph[Patrick O'Neil, Edward Cheng, Dieter Gawlick, Elizabeth O'Neil, "The Log-Structured Merge-Tree (LSM-Tree)", 1996, Acta Informatica].

  Первое широкое промышленное распространение LSM-подход получил позже, в системах типа Google Bigtable (2000-е), а затем HBase, Cassandra, LevelDB, RocksDB и т.д.
]

#diagram-slide([LSM (Vinyl)], "images-transparent/lsm-1.svg")

#diagram-slide([LSM (Vinyl) .run файл], "images-transparent/lsm-2.svg")

#content-slide([LSM], logo-pos: bottom + left)[
  Зачем нужен compaction:
  - новые записи дешево писать в память и периодически сбрасывать в новые маленькие run'ы
  - но если просто накапливать много run'ов, чтение станет дорогим, потому что придётся проверять слишком много run'ов

  Поэтому LSM, и в частности Vinyl, балансирует между тем чтобы:
  - сделать запись дешевой
  - не дать чтению деградировать из-за большого числа run'ов

  Для этого периодически несколько старых run'ов сливаются в один новый, чтобы уменьшить read amplification.
]

#content-slide([LSM])[
  #set text(size: 15pt)
  #set par(leading: 0.52em)
  Стратегия compaction в LSM балансирует между несколькими свойствами:
  - #strong[Write amplification] \
    Чем более агрессивно происходит compaction, тем больше одни и те же данные перезаписываются. Было бы плохо переписывать большие объёмы данных слишком часто.
  - #strong[Read amplification] \
    Если не compact-ить совсем, то становится много слоёв из данных runs, в том числе уже не актуальных, и чтению приходится проверять много источников.
  - #strong[Space amplification] \
    Пока старые версии ключей и tombstones не схлопнуты, на диске лежит много "мёртвых" данных.
  - #strong[предсказуемость фоновой нагрузки]
]

// #slide[
//   #slide-logo(top + right)
//   #text(size: 24pt, weight: "bold")[LSM]
//   #v(0.1cm)
//   #align(center)[#box(width: 76%, amp-triangle)]
// ]

#diagram-slide([Page index в оперативной памяти], "images-transparent/page-index-0.svg")

#content-slide([Page index в оперативной памяти])[
  #set text(size: 15pt)
  page_size в Vinyl по умолчанию 8 КБ.

  Одна struct vy_page_info без учёта min_key занимает примерно 40 Б.

  40 / 8192 ~= 0.0048 (~0.5% от объёма данных)

  Если добавить, что у каждой страницы ещё отдельно хранится min_key по указателю, то реалистичнее считать не 40 B, а примерно 56–72 B на страницу для коротких/средних ключей. Тогда overhead получается уже порядка 0.68%–0.88%, а с длинными ключами может уйти и к ~1%+.

  #strong[Проблема:] Для терабайтного набора данных это сотни мегабайт – гигабайты одних только метаданных в оперативной памяти.
]

#content-slide([Задачи])[
  #set text(size: 14.5pt)
  #set par(leading: 0.5em)
  - проанализировать устройство LSM-деревьев и особенности реализации Vinyl в Tarantool
  - исследовать существующий постраничный индекс Vinyl и определить ограничения его масштабирования по памяти
  - сформулировать требования к новому механизму постраничного индекса
  - разработать структуру постраничного индекса с размещением основной части метаданных на диске и ограниченным рабочим набором в памяти
  - реализовать предложенный подход в кодовой базе Tarantool
  - сравнить разработанное решение с in-memory подходом
  - провести экспериментальную оценку по памяти и производительности
]

#diagram-slide([Индекс страницы по ключу], "images-transparent/page-index-1.svg")

#diagram-slide([Страница по индексу], "images-transparent/page-index-2.svg")

#diagram-slide([B-дерево], "images-transparent/page-index-3.svg")

#content-slide([Бенчмаркинг: методика])[
  #set text(size: 13.5pt)
  #set par(leading: 0.48em)
  #set list(spacing: 0.35em)
  YCSB (Yahoo! Cloud Serving Benchmark)-подобные нагрузки на наборе данных ~200 МБ (~2 млн ключей).

  #strong[Workload A, B и C:]
  - #strong[A] (read-heavy) — 50% чтений и 50% обновлений уже существующих ключей. Обращения сконцентрированы на небольшом «горячем» подмножестве.
  - #strong[B] (write-heavy) — 50% последовательных вставок новых ключей и 50% чтений. В отличие от A, чтения идут не к давно популярным ключам, а преимущественно к только что вставленным в этом же потоке операций.
  - #strong[C] — смесь удалений, вставок, сканирования диапазонов и точечных чтений.

  Сравнивались две реализации постраничного индекса:
  - #strong[old] — метаданные страницы в RAM
  - #strong[new] — описанная выше структура (B-дерево на диске, кэши в RAM)

  Для новой реализации варьировался бюджет двух кэшей: кэш ключей
и кэш метаданных. Во всех точках сохранялось соотношение 1:4 (ключи :
метаданные), суммарная квота менялась от 0 до 2 МБ. Резидентная верхняя часть B-дерева была отключена.
]

#content-slide([Бенчмаркинг: метрики])[
  #set text(size: 13.5pt)
  #set par(leading: 0.48em)
  #set list(spacing: 0.35em)
  В качестве основных метрик использовались:

  - #strong[throughput (пропускная способность)] — число операций в секунду
  - #strong[memory.page_index] — объем памяти, занимаемой структурами постраничного индекса (фильтр Блума учитывался отдельно)
  - #strong[read amplification] — отношение объёма чтения с диска к объёму полезных данных, возвращённых в ответах

  Дополнительно для новой реализации собирались hit rate и статистика вытеснений по двум кэшам постраничного индекса.
]

#graph-slide(
  [Пропускная способность],
  "01_ops_by_workload_scale1.png",
  body: [
    При нулевых квотах пропускная способность ниже, чем у предыдущего подхода: A −33%, B −25%, C −58%.
    С ростом квоты новая реализация приближается к предыдущей in-memory.
  ],
)

#multi-graph-slide(
  [Просадка пропускной способности при снижении квоты памяти],
  (
    ("A", "02_memory_vs_ops_A_scale1.png"),
    ("B", "02_memory_vs_ops_B_scale1.png"),
    ("C", "02_memory_vs_ops_C_scale1.png"),
  ),
  layout: "2x2",
)

#content-slide([Просадка пропускной способности при снижении квоты памяти])[
  #set text(size: 14pt)
  #table(
    columns: 4,
    align: (left, center, center, center),
    table.header(
      [Память относительно `old`],
      [Workload A],
      [Workload B],
      [Workload C],
    ),
    [в 4 раза меньше], [−20%], [−19%], [−58%],
    [в 3 раза меньше], [−19%], [−18%], [−58%],
    [в 2 раза меньше], [−18%], [−18%], [−57%],
  )

  #v(0.3cm)
  #set text(size: 13.5pt)
  Просадка пропускной способности относительно предыдущего подхода при умень­шении памяти постраничного индекса.
]

#graph-slide(
  [Read amplification],
  "03_read_amp_stacked_scale1.png",
  body: [
    Декомпозиция: чтение данных run и обращения к постраничному индексу.
    При нулевой квоте вклад индекса максимален, с ростом квоты сжимается.
  ],
)

#graph-slide(
  [Hit rate кэшей],
  "06_cache_hit_rate_scale1.png",
  body: [
    Рост hit rate согласуется с ростом пропускной способности: чем больше рабочий набор в кэшах,
    тем реже промахи на критическом пути.
  ],
)

#multi-graph-slide(
  [Сравнение по workload (quota sweep)],
  (
    ("A", "07_quota_sweep_A.png"),
    ("B", "07_quota_sweep_B.png"),
    ("C", "07_quota_sweep_C.png"),
  ),
  layout: "2x2",
)

#content-slide([Вывод])[
  #set text(size: 14.5pt)
  #set par(leading: 0.52em)
  Новая схема постраничного индекса ограничивает обязательное потребление памяти
  за счёт хранения метаданных на диске и кэширования рабочего набора.

  Появляется дополнительный компонент read amplification — чтение блоков `vy_page_info` —
  который заметно влияет на throughput при малых квотах.

  Выбор квоты кэшей — ключевой параметр баланса между памятью и производительностью.
]
