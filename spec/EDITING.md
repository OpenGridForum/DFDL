# Editing the specification

This AsciiDoc is the source of the specification. Every change to the text is
made here, in a pull request the working group reviews. The MS-Word editions in
`docs/archive/Archive-2026/` are a historical record: don't edit them, and don't
try to regenerate the source from them. The converter kept beside them refuses
to write into `spec/` for that reason.

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

## Page breaks

Tables and examples break across pages by themselves, so there is nothing to
mark when adding or changing one. A table breaks between rows and repeats its
caption and header. A row is only split if it is taller than a page, and then
its cells have no rule at the break. A row never breaks straight after the
first paragraph of a cell, and a code example never leaves fewer than three
lines on either side of a break.

A table that should stay whole takes `keep-lines-together=true`; one whose row
spans must not be cut takes `class="keep-row-groups"`. Both still break if the
table grows taller than a page. The separator suppression matrices in clause
14, which `tools/tables.py` writes, never break: they move whole to the next
page, and if one grows taller than a page `make pdf` fails. `make pdf` fails
if anything runs off a page, which FOP otherwise does without an error, and if
the PDF fails to build at all.

## The Property Index

The Property Index in the front matter is generated from the property
tables, so don't edit `clauses/front-07-property-index.adoc`. Each property
is the first cell of a row in a table headed "Property Name", and that cell
carries an anchor named after it, which the index links to:

    | [[p-byteorder]]byteOrder

Give a new property its anchor and run `make index`; `make check` fails if
the index is out of date. A property defined in more than one table is
anchored only at the first.

The index fits on one page, in three columns: A-E, F-Q and R-Z. `make check`
fails if a column grows past what fits, and says which; move the boundaries in
`BANDS` in `tools/property-index.py` to even the columns out.

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

## Editions

The same source builds both editions. `dfdl-ogf.adoc` and `dfdl-iso.adoc`
hold only document metadata, and both include `frontmatter/front.adoc` and
`body.adoc`. Each sets one attribute, `edition-ogf` or `edition-iso`.

The body is the same in both editions: the same pages, page numbers and
section numbers. Only headers, footers, covers and some front matter differ.
Where a front matter section needs different wording in each edition, mark
it with the attribute:

    ifdef::edition-iso[]
    Wording for the ISO edition only.
    endif::[]

The OGF edition prints its preamble, `clauses/front-01-preamble.adoc`, on its
cover page. The preamble's `== Foreword` heading is how the stylesheet finds
it, so keep that heading; it is never printed.

Values that change between releases are set once, as attributes in the
master, never typed into the text or the stylesheets. The OGF edition's
header, footer and cover read `presentation-metadata-ogf-*` attributes in
`dfdl-ogf.adoc`: the document number, the dates, the contact address and
the cover's author lines. Metanorma splits these values at commas, and the
stylesheet joins them again, so a value may contain commas. Copyright years
come from `copyright-year`, which the text reads as `{copyright-year}`.

The OGF edition's HTML cover is `html-cover-ogf.html`, a template that reads
the same attributes as the PDF cover. `dfdl-ogf.adoc` gives its path from
the repository root, `spec/html-cover-ogf.html`, because Metanorma resolves
it from where the build runs rather than from the master file. A wrong path
doesn't stop Metanorma, which falls back to the ISO cover, so
`make EDITION=ogf check` fails if the HTML has no OGF cover.

The OGF edition's HTML uses the fonts of the PDF, Noto Sans and Noto Sans
Mono, named by `body-font`, `header-font` and `monospace-font` in
`dfdl-ogf.adoc`. `html-overrides-ogf.css` loads them from Google Fonts. Its
path is given from `spec/`, like the PDF override, not from the repository
root. Metanorma escapes quotes and ampersands in that file, so keep its URLs
unquoted. With a wrong path Metanorma builds no HTML, and without the
attribute it builds the HTML without the fonts. Neither stops the build, so
`make check` fails if there is no HTML, and `make EDITION=ogf check` fails if
the HTML doesn't load the fonts.

## The conversion check

`make check-conversion` compares the build against the MS-Word source, the
v1.2.2 draft in `docs/archive/Archive-2026/` that the AsciiDoc was converted
from. It is not part of `make check` and not a check your edits have to satisfy.
