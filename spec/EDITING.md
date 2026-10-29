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

Refer to one with `<<dfdl-expression-language>>`, which renders as "Section 18"
with the whole phrase as the link; don't type the word "Section" yourself. Use
`<<dfdl-expression-language,DFDL Expression Language>>` to show the title
instead.
`make check` fails on a reference that resolves to nothing.

## Tables, figures and listings

A title goes on the line above the block, and the number is generated:

    .Properties Specific to String
    [cols="1,4",options="header"]
    |===

A column whose cells hold lists or several paragraphs is marked once in `cols`,
as in `cols="1,3a"`, so its cells need no `a|` of their own.

Grammar tables separate their cells with `!` instead of `|`, so the grammar's
own `|` is written as it reads:

    [cols="3,1,18",class="bnf",separator=!]
    |===
    ! Sign
    ! ::=
    ! '+' | '-'
    |===

Listings are unnumbered examples by default:

    [source,xml]
    ----
    <dfdl:assert test="{ ../x eq 0 }"/>
    ----

A listing that is a numbered figure says so with an anchor, which is also what
lets the text refer to it:

    [[little-endian-bit-position-and-value]]
    .Little Endian bit position and value
    [source,xml]
    ----

Bit diagrams colour each run of bits to match the element or character it
belongs to. Write the diagram as it reads, and put a mask line starting with
`~` under each line that has colour. Each letter in the mask colours the
character above it, and the block says what each letter means:

    [bits,R=red,L=lime]
    ----
         01010101 01100111
    ~    R        LLRRRRRR
    Char NUUUUUUU IINNNNNN
    ~    R        LLRRRRRR
    ----

Mask lines don't appear in the output. The colour names are the shades the
specification has always used: blue, cyan, darkred, green, lime, ochre, purple,
red and yellow. A hex value such as `#FF0000` works too. A mask letter the block
doesn't declare stops the build. `[bits]` comes from `tools/bits.rb`, which the
Makefile loads.

An example that colours whole lines instead takes `subs="+quotes"`, with each
line wrapped in a role:

    [source,subs="+quotes"]
    ----
    [css color:#FF0000]##<element name="B" type="xs:int" dfdl:length="7"/>##
    ----

`make check` catches captions that fail to attach and markup that leaks into
the rendered text.

Two tables carry numbers set by hand, 33-A and 67-A, so that the tables after
them keep the numbers readers know from earlier editions. The table after each
one has `number=` set too, so the count resumes. Adding or removing a table
before either means updating those numbers. `make check` catches an added table,
because two tables then print the same number, but not a removed one.

The two separator suppression tables in clause 14 are generated. Their merged,
shaded cells are kept as data files in `tables/`, one line per cell, and
`make tables` writes them into the clause. Edit the data file, not the table;
`make check` fails if the two disagree. `tools/tables.py` describes the format.

## Technical text

Quotes, hex values like `0x55` and spaced hyphens are left as typed, because
the document turns Metanorma's smart formatting off with `:smartquotes: false`.

A few sequences AsciiDoc still rewrites. `=>` and `<=` become arrows, `...` an
ellipsis, `--` an em dash and `(C)` a copyright sign, and a pair of `#` turns
the text between them into highlight. Wrap them in a passthrough:

    +#,##0.0#+

The single plus signs don't open straight after a quote mark, so take a quoted
literal's quote marks inside, `+'#'+`, and double the plus signs after a letter
or digit: `E++#++`. Entity notation like `&apos;` is decoded even inside a
passthrough, so it goes in monospace: ``` ``+++&amp;apos;+++`` ```.

A `+` is typed as it is, except that two in one paragraph can pair up into a
passthrough and vanish. When that happens, write one of them as `{plus}`.

Code blocks are already safe; this applies to prose and table cells.

You don't have to remember any of this: `make check` reports every sequence
AsciiDoc would rewrite, with its file, line and the fix.

## Revision marks

`add:[text]` and `del:[text]` produce them. The role form `[.add]#text#` is
silently ignored and renders as plain text.

## The conversion check

`make check-conversion` compares the build against the MS-Word source. It is
not part of `make check` and not a check your edits have to satisfy.
