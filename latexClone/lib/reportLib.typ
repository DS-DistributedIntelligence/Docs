#import "common.typ": academicYear, authors, course, date, linkColor, mainColor, prjName, university
#import "@preview/hydra:0.6.2": hydra

#let firstPage(title) = {
  show link: set text(fill: linkColor)
  set document(
    title: [#title - #course - #university],
    author: (
      authors.andrea.name + " " + authors.andrea.surname + " - Student Id " + authors.andrea.stid,
      authors.matteo.name + " " + authors.matteo.surname + " - Student Id " + authors.matteo.stid,
    ),
    description: [Report for the #course course at #university],
  )
}


#let config(
  body,
) = {
  show figure: set block(breakable: true)
  show link: it => underline(text(fill: linkColor)[#it])
  show ref: rf => underline(text(fill: mainColor)[#rf])
  show par: set text(font: "CMU Serif", size: 10pt)
  show list: set text(size: 10pt)
  show heading: set text(weight: "bold")
  show heading: it => block(counter(heading).display(it.numbering) + h(1.5em) + it.body) 

  counter(page).update(1)
  set heading(numbering: "1.1")

  show heading.where(level: 1): h => {
    set text(size: 17pt)
    h
    v(3.5mm)
  }
  show heading.where(level: 2): h => {
    set text(size: 14pt)
    h
    v(2.3mm)
  }
  show heading.where(level: 3): h => {
    set text(size: 12pt)
    h
    v(2.3mm)
  }
  show heading.where(level: 4): set text(size: 10pt)

  set page(
    margin: (left: 2cm, right: 2cm, top: 2cm, bottom: 2cm),

    header: [
      #context {
        if (counter(page).get().at(0) != 1) {
          grid(
            columns: (53%, 14%, 33%),
            align: (x, y) => {
              if (x == 0) {
                left + horizon
              } else if (x == 1) {
                center + horizon
              } else {
                right + horizon
              }
            },
            [#emph(hydra(2, skip-starting: false))], [], [#upper(emph(hydra(1, skip-starting: false)))],
          )
          line(length: 100%)
        }
      }

    ],
    footer: [
      #align(center)[#context [#counter(page).display("1", both: false)]] \
    ],
  )

  body
}

#let firstPage(title) = {
  show par: set text(size: 15.5pt)
  text(weight: "regular")[#align(center)[#title #v(1em)]]

  show par: set text(13pt)
  align(center)[#authors.andrea.surname #authors.andrea.name, #authors.matteo.surname #authors.matteo.name #v(1em)]

  align(center)[#course Project -- #date]

  v(1em)
}
