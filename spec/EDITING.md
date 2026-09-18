# Editing the specification

The source is one file per clause under `clauses/`, pulled together by
`body.adoc`. `BUILD.md` covers rendering; this covers changing the text.

Before pushing, run:

    make check

which lints the tools, builds the document and runs the validators against it.

## How the source is written

One sentence per line, wrapped at 80 columns. Line breaks never reach the page,
and a diff then names the sentence that changed rather than the whole paragraph.

Because each sentence starts its own line, wrapping only moves breaks within the
sentence being edited, never through the paragraph around it. Some lines still
run past 80, where there is nowhere safe to break: inside a cross-reference, a
footnote, a table row, or a listing block, where a line break is content rather
than whitespace. Leave those long.

Don't reflow a paragraph you aren't otherwise changing. It rewrites every line
and buries the edit.

The converted text doesn't follow the sentence rule everywhere; about one prose
line in twenty still holds more than one. Split those as you touch them rather
than sweeping the document.

## Changing existing text

Edit the clause file. The names carry the clause number the specification gives
itself, so Clause 13 is `clauses/13-simple-types.adoc` and Annex E is
`clauses/E-glossary-of-terms.adoc`. Numbers in the rendered document are
generated, so nothing has to be renumbered by hand.

## Adding a clause

Create the file and add it to `body.adoc` in reading order. A new clause takes
the next free number at the end of the numbered sequence, before the annexes,
and the file is named for it. Inserting one in the middle renumbers every
clause after it and every reference the document makes to them, so that is a
working group decision rather than an editing one.

## Cross-references

Anchors come from the heading text:

    [[dfdl-expression-language]]
    == DFDL Expression Language

Refer to one with `<<dfdl-expression-language>>` for a bare number, or
`<<dfdl-expression-language,DFDL Expression Language>>` to carry the title.
`make check` fails on a reference that resolves to nothing.

## Tables, figures and listings

A title goes on the line above the block, and the number is generated:

    .Properties Specific to String
    [cols="1,4",options="header"]
    |===

A listing that is an example rather than a figure must say so:

    [source%unnumbered,xml]
    ----
    <dfdl:assert test="{ ../x eq 0 }"/>
    ----

Without `%unnumbered` the listing takes a figure number, and every sentence
that names a figure after it points at the wrong thing. `make check` catches
this, along with captions that fail to attach and markup that leaks into the
rendered text.

## Technical text

Sequences that AsciiDoc or Metanorma would rewrite need protecting. `0x55`
becomes `0×55`, `<=` becomes an arrow, `#` disappears into highlight syntax,
and `&apos;` is decoded. Wrap them:

    pass-format:straightquotes[0x55]

Code blocks are already safe; this applies to prose and table cells.

## Revision marks

`add:[text]` and `del:[text]` produce them. The role form `[.add]#text#` is
silently ignored and renders as plain text.

## The conversion check

`make check-conversion` compares the build against the MS-Word source. It is
not part of `make check` and not a check your edits have to satisfy.
