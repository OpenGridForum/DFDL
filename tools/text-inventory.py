"""Extract a normalised text inventory from the DFDL spec.

The tool reads either

  * the MS-Word source (``*.docx``), or
  * a built Metanorma *semantic* XML file (``build/dfdl.xml``)

and emits the same shape of output for both: one logical unit (paragraph,
heading, table cell, list item, code line, footnote, ...) per line, with the
text normalised so that differences which legitimately arise during the
Word -> AsciiDoc -> Metanorma conversion disappear, and *nothing else* does.

Two normalisation modes are offered, and **strict is the default**.

STRICT (the gate).  Only what genuinely *must* differ between a .docx and
Metanorma XML is normalised; every typographic difference survives to be
reported:

  * Word's escaping of angle brackets is undone (``&amp;lt;`` -> ``&lt;`` -> ``<``)
  * Unicode NFC
  * non-breaking / thin / ideographic spaces, tabs and line breaks -> space
  * zero-width and soft-hyphen characters removed
  * runs of whitespace collapsed to a single space, then stripped

RELAXED (advisory).  Everything strict does, plus the typographic folding
that used to be unconditional:

  * smart quotes  -> straight quotes
  * en/em/figure dashes and non-breaking hyphens -> ``-`` (canonical form)
  * horizontal ellipsis -> ``...``

Relaxed normalisation is genuinely useful - it finds structural loss without
drowning in typographic noise - but it must never be the gate.  Folding both
sides means a target that replaced 2,555 apostrophes, turned ``--`` into an
em dash and ``<=`` into ``⇐`` compares *identical*: the corruption cancels
out against its own normalisation.  Under strict normalisation those units
differ, and ``fidelity-check.py`` classifies and reports them.

``typographic_fold`` applies exactly the relaxed-only step to already-strict
text, so a strict inventory can be reduced to the relaxed one without
re-reading the source.

Content dropped on purpose (and only this):

  * paragraphs styled TOC1/TOC2/TOC3 - Metanorma regenerates the table of
    contents, so the Word one is not source content
  * page headers and footers - these live in ``word/header*.xml`` /
    ``word/footer*.xml`` which are never read
  * Word field *instructions* (``w:instrText``) - these are not visible text
  * text inside ``w:del`` / ``w:moveFrom`` - tracked deletions are not part of
    the final document (``w:ins`` insertions are kept)
  * runs marked ``w:vanish`` - Word hides these, and the specification uses
    them for the editors' notes to each other, so they are not document text
  * the content of an ``<svg>`` on the XML side - a vector image is inlined
    into the semantic XML, and the labels inside a diagram are picture, not
    prose
  * on the XML side: ``<bibdata>`` and Metanorma's internal metadata elements,
    which are generated, not converted prose

Run it as ``python3 tools/text-inventory.py ...``.  It deliberately carries
no shebang and is not executable: ``make check`` runs every executable in
tools/ as a validator against the built semantic XML, and this is an
extraction utility, not a validator.  tools/fidelity-check.py is the
validator, and it imports this module.

Text the reader sees but neither document stores as text is written out so
that it can be compared: a ``<link>`` with no text of its own shows its URL,
an ``<eref>`` shows its citation label in brackets, and a ``<bibitem>`` is
prefixed with the same bracketed label, which is how a built bibliography
entry can be traced back to the Word table row it came from.

Sections are numbered as a reader sees them: clauses from the heading
hierarchy, annexes from their letter, and the unnumbered front-matter
regions as ``front.1``, ``front.2`` and so on, so that the change history,
property index, authors, scope, normative references and terms are locatable
sections rather than one undifferentiated block.  ``front`` itself holds the
cover page, which precedes every heading.

Output is TSV: ``seq <TAB> section <TAB> kind <TAB> text``, preceded by a
``# mode:`` header recording which normalisation produced it.  ``--format
plain`` emits just the text column.  Only the text column takes part in the
fidelity diff; ``section`` and ``kind`` are locators used for reporting.
"""

from __future__ import annotations

import argparse
import contextlib
import re
import sys
import unicodedata
import xml.etree.ElementTree as ET
import zipfile
from dataclasses import dataclass

W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"


def w(tag: str) -> str:
    return W + tag


# --------------------------------------------------------------------------
# Normalisation
# --------------------------------------------------------------------------

# Typographic characters that legitimately change during conversion.  They are
# written as escapes because several of them are invisible in an editor.
# left/right single quote, single low-9, single high-reversed-9
SINGLE_QUOTES = "\u2018\u2019\u201a\u201b"
# left/right double quote, double low-9, double high-reversed-9
DOUBLE_QUOTES = "\u201c\u201d\u201e\u201f"
# hyphen, non-breaking hyphen, figure dash, en dash, em dash, horizontal bar
# and minus sign all collapse to one canonical form
DASHES = "\u2010\u2011\u2012\u2013\u2014\u2015\u2212"
# nbsp, ogham space mark, en/em/thin/hair spaces, line and paragraph
# separators, narrow nbsp, medium mathematical space, ideographic space
SPACES = (
    "\u00a0\u1680\u2000\u2001\u2002\u2003\u2004\u2005\u2006"
    "\u2007\u2008\u2009\u200a\u2028\u2029\u202f\u205f\u3000"
)
# soft hyphen and zero-width characters carry no content
ZERO_WIDTH = "\u00ad\u200b\u200c\u200d\u2060\ufeff"
# horizontal ellipsis
ELLIPSIS = 0x2026

MODES = ("strict", "relaxed")
DEFAULT_MODE = "strict"

# Applied in *both* modes: a .docx and Metanorma XML cannot agree on these
# and no content lives in them.
_BASE_TRANSLATION: dict[int, str | None] = {}
for _c in SPACES:
    _BASE_TRANSLATION[ord(_c)] = " "
for _c in ZERO_WIDTH:
    _BASE_TRANSLATION[ord(_c)] = None

# Applied only in relaxed mode.  This is the table that used to hide quote and
# dash corruption by folding it away on both sides at once.
_TYPOGRAPHIC_TRANSLATION: dict[int, str | None] = {}
for _c in SINGLE_QUOTES:
    _TYPOGRAPHIC_TRANSLATION[ord(_c)] = "'"
for _c in DOUBLE_QUOTES:
    _TYPOGRAPHIC_TRANSLATION[ord(_c)] = '"'
for _c in DASHES:
    _TYPOGRAPHIC_TRANSLATION[ord(_c)] = "-"
_TYPOGRAPHIC_TRANSLATION[ELLIPSIS] = "..."

_RELAXED_TRANSLATION = dict(_BASE_TRANSLATION)
_RELAXED_TRANSLATION.update(_TYPOGRAPHIC_TRANSLATION)

TRANSLATIONS = {"strict": _BASE_TRANSLATION, "relaxed": _RELAXED_TRANSLATION}

# The characters typographic folding touches, for reporting.
TYPOGRAPHIC_CHARS = frozenset(
    chr(code) for code in _TYPOGRAPHIC_TRANSLATION
) | frozenset("'\"-.")

_WS_RUN = re.compile(r"\s+")


def unescape_angle_brackets(text: str) -> str:
    """Undo Word's (sometimes repeated) escaping of ``<``, ``>`` and ``&``.

    Only these three entities are touched.  Numeric character references are
    left alone on purpose: the DFDL spec discusses sequences such as
    ``&#xE000;`` as literal subject matter, and decoding them would destroy
    content rather than normalise it.
    """
    previous = None
    current = text
    # A handful of passes is enough for any real double/triple escaping.
    for _ in range(3):
        if current == previous:
            break
        previous = current
        current = (
            current.replace("&lt;", "<").replace("&gt;", ">").replace("&amp;", "&")
        )
    return current


def normalise(text: str, mode: str = DEFAULT_MODE) -> str:
    """Apply the normalisation pipeline for ``mode`` to a raw text fragment."""
    if not text:
        return ""
    table = TRANSLATIONS[mode]
    text = unescape_angle_brackets(text)
    text = unicodedata.normalize("NFC", text)
    text = text.translate(table)
    text = _WS_RUN.sub(" ", text)
    return text.strip()


def typographic_fold(text: str) -> str:
    """Reduce strict text to its relaxed form.

    Folding is the only difference between the two modes, and none of its
    replacements introduce whitespace, so folding strict text is exactly
    equivalent to having normalised it in relaxed mode.  That lets the
    fidelity checker read a source once and hold both accountings.
    """
    return text.translate(_TYPOGRAPHIC_TRANSLATION)


# A dotted run of digits is one token, so that a clause or version number
# survives intact.  A full stop between letters is sentence punctuation, not
# part of a word: "pattern.at" is two words, "dfdl:assert" and "UTF-8" are one.
WORD_RE = re.compile(r"[0-9]+(?:\.[0-9]+)+|[A-Za-z0-9]+(?:[-_:][A-Za-z0-9]+)*")

# The word rule above sees only letters and digits, so a target that replaced
# every ``#`` in "#,##,##0" with nothing, or ``<=`` with a single ``⇐``, was
# invisible to word accounting: neither side contributed a token.  The token
# rule keeps the same word shapes and adds one token per remaining non-space
# character, so punctuation-only corruption has somewhere to show up.
TOKEN_RE = re.compile(
    r"[0-9]+(?:\.[0-9]+)+|[A-Za-z0-9]+(?:[-_:][A-Za-z0-9]+)*|[^\sA-Za-z0-9]"
)


def words(text: str) -> list[str]:
    """Tokenise normalised text for word-level accounting (letters/digits)."""
    return WORD_RE.findall(text)


def tokens(text: str) -> list[str]:
    """Tokenise for full accounting: words plus every punctuation character.

    Text is typographically folded first, so that a smart quote and a straight
    quote are the same token and pure ISO typesetting nets out to zero, while
    ``--`` -> ``—`` (two dash tokens against one), ``<=`` -> ``⇐``, ``x`` ->
    ``×`` and a dropped ``#`` all remain visible as a token-count difference.
    """
    return TOKEN_RE.findall(typographic_fold(text))


def symbols(text: str) -> list[str]:
    """Just the punctuation tokens of ``text`` (folded, as in ``tokens``)."""
    return [token for token in tokens(text) if not token[0].isalnum()]


# --------------------------------------------------------------------------
# Character census
# --------------------------------------------------------------------------

# Characters whose count carries meaning in this document: DFDL syntax, the
# ASCII forms that get "prettified" away, and the glyphs they get prettified
# into.  A large asymmetry between the two sides is the signal that a purely
# unit-level check misses entirely.
CENSUS_GROUPS: tuple[tuple[str, str], ...] = (
    ("DFDL / regex syntax", "#<>=|\\%/*+?^$[](){}"),
    ("quotes", "'\"‘’“”‚‛„‟`´"),
    ("dashes", "-‐‑‒–—―−"),
    ("hex and multiplication", "xX×"),
    ("arrows and ellipsis", "←→↔⇐⇒⇔…≤≥"),
    ("separators", ",.:;&"),
)

CENSUS_CHARS = "".join(chars for _, chars in CENSUS_GROUPS)

CHAR_NAMES = {
    "‘": "left single quote",
    "’": "right single quote",
    "“": "left double quote",
    "”": "right double quote",
    "‐": "hyphen",
    "‑": "non-breaking hyphen",
    "‒": "figure dash",
    "–": "en dash",
    "—": "em dash",
    "―": "horizontal bar",
    "−": "minus sign",
    "×": "multiplication sign",
    "←": "leftwards arrow",
    "→": "rightwards arrow",
    "↔": "left right arrow",
    "⇐": "leftwards double arrow",
    "⇒": "rightwards double arrow",
    "⇔": "left right double arrow",
    "…": "horizontal ellipsis",
    "≤": "less-than or equal",
    "≥": "greater-than or equal",
    "`": "grave accent",
    "´": "acute accent",
}


def census(texts) -> dict[str, int]:
    """Count every census character across an iterable of texts."""
    counts = dict.fromkeys(CENSUS_CHARS, 0)
    for text in texts:
        for char in text:
            if char in counts:
                counts[char] += 1
    return counts


# --------------------------------------------------------------------------
# Inventory unit
# --------------------------------------------------------------------------


@dataclass
class Unit:
    seq: int
    section: str
    kind: str
    text: str

    def as_tsv(self) -> str:
        return f"{self.seq}\t{self.section}\t{self.kind}\t{self.text}"


MODE_HEADER_RE = re.compile(r"^#\s*mode:\s*(\w+)")


def tsv_mode(path: str) -> str | None:
    """The normalisation mode recorded in a TSV inventory, if it says."""
    with open(path, encoding="utf-8") as handle:
        for line in handle:
            if not line.startswith("#"):
                return None
            header = MODE_HEADER_RE.match(line)
            if header:
                return header.group(1)
    return None


def parse_tsv(path: str, mode: str = DEFAULT_MODE) -> list[Unit]:
    """Read a previously written inventory.

    A TSV holds text that was already normalised, so ``mode`` cannot be
    applied again.  Strict text can still be folded down to relaxed text; the
    reverse is impossible, and asking for it is an error rather than a
    silently wrong comparison.
    """
    recorded = tsv_mode(path)
    if recorded is not None and recorded != mode:
        if recorded == "strict" and mode == "relaxed":
            pass  # folded below
        else:
            raise SystemExit(
                f"{path}: inventory was written with --mode {recorded}; "
                f"it cannot be re-read as {mode} (regenerate it)"
            )
    units: list[Unit] = []
    with open(path, encoding="utf-8") as handle:
        for line in handle:
            line = line.rstrip("\n")
            if not line or line.startswith("#"):
                continue
            parts = line.split("\t", 3)
            if len(parts) != 4:
                continue
            text = parts[3]
            if recorded == "strict" and mode == "relaxed":
                text = typographic_fold(text)
            units.append(Unit(int(parts[0]), parts[1], parts[2], text))
    return units


# --------------------------------------------------------------------------
# Section numbering (shared by both readers)
# --------------------------------------------------------------------------

APPENDIX_RE = re.compile(r"^\s*(?:Appendix|Annex)\s+([A-Z])\b")


class SectionNumberer:
    """Reproduces the clause numbers a reader sees, from structure alone.

    Word auto-numbers headings from ``numbering.xml`` and Metanorma numbers
    clauses from nesting, so neither carries the number as text.  Both are
    reconstructed here so that the two inventories agree on locators and so
    ``--clause`` can select the same material on either side.
    """

    def __init__(self) -> None:
        self.counters = [0] * 10
        self.prefix: str | None = None  # annex letter, once appendices start
        self.front = 0
        self.current = "front"

    def unnumbered(self) -> str:
        """Number a front-matter region, which the reader sees without one.

        The front matter carries headings that neither document numbers, so
        they cannot be located by clause number.  Giving each its own
        ``front.N`` makes it a section like any other, which is what lets the
        change history, property index, authors, scope, normative references
        and terms be compared instead of being dropped wholesale.  Material
        before the first such heading stays in ``front``: it is the Word
        cover page, which has no headings to divide it.
        """
        self.front += 1
        self.current = f"front.{self.front}"
        return self.current

    def heading(self, level: int, title: str) -> str:
        letter = APPENDIX_RE.match(title)
        if level == 1 and letter:
            self.prefix = letter.group(1)
            self.counters = [0] * 10
            self.current = self.prefix
            return self.current
        self.counters[level] += 1
        for deeper in range(level + 1, len(self.counters)):
            self.counters[deeper] = 0
        parts = [str(self.counters[i]) for i in range(1, level + 1)]
        if self.prefix:
            parts = [self.prefix] + parts[1:]
        self.current = ".".join(parts)
        return self.current


def top_level(section: str) -> str:
    return section.split(".", 1)[0]


# --------------------------------------------------------------------------
# .docx reader
# --------------------------------------------------------------------------

TOC_STYLES = {"TOC1", "TOC2", "TOC3", "TOC4", "TOC5", "TOC6", "TOC7", "TOC8", "TOC9"}
CODE_STYLES = {"Codeblock0", "Codeblock", "dataexample"}
CAPTION_STYLES = {"Caption", "TableCaption", "FigureCaption"}
LIST_STYLES = {"ListParagraph", "ListBullet", "ListNumber"}

# Subtrees whose text is never part of the final document.
DOCX_SKIP = {
    w("del"),
    w("moveFrom"),
    w("instrText"),
    w("delInstrText"),
    w("delText"),
    w("pPr"),
    w("rPr"),
    w("tblPr"),
    w("trPr"),
    w("tcPr"),
    w("sectPr"),
    w("numPr"),
    w("tblGrid"),
    w("proofErr"),
    w("bookmarkStart"),
    w("bookmarkEnd"),
    w("commentRangeStart"),
    w("commentRangeEnd"),
    w("footnotePr"),
    w("endnotePr"),
}

HEADING_RE = re.compile(r"^Heading([1-9])$")


def _docx_para_style(para: ET.Element) -> str | None:
    ppr = para.find(w("pPr"))
    if ppr is None:
        return None
    style = ppr.find(w("pStyle"))
    if style is None:
        return None
    return style.get(w("val"))


def _docx_numbered(para: ET.Element) -> bool:
    """True unless the paragraph explicitly turns its style's numbering off."""
    ppr = para.find(w("pPr"))
    if ppr is None:
        return True
    numpr = ppr.find(w("numPr"))
    if numpr is None:
        return True
    numid = numpr.find(w("numId"))
    return not (numid is not None and numid.get(w("val")) == "0")


def _docx_hidden(run: ET.Element) -> bool:
    """True for a run Word hides, which the reader never sees."""
    rpr = run.find(w("rPr"))
    if rpr is None:
        return False
    vanish = rpr.find(w("vanish"))
    return vanish is not None and vanish.get(w("val")) not in {"0", "false"}


def _docx_collect(element: ET.Element, out: list[str], footnotes: list[str]) -> None:
    """Depth-first collection of visible text from a Word element."""
    for child in element:
        tag = child.tag
        if tag in DOCX_SKIP:
            continue
        if tag == w("r") and _docx_hidden(child):
            continue
        if tag == w("t"):
            out.append(child.text or "")
        elif tag == w("tab"):
            out.append(" ")
        elif tag == w("br"):
            out.append("\n")
        elif tag == w("noBreakHyphen"):
            out.append("-")
        elif tag == w("softHyphen"):
            pass
        elif tag == w("footnoteReference"):
            ident = child.get(w("id"))
            if ident is not None:
                footnotes.append(ident)
        elif tag == w("sym"):
            char = child.get(w("char"))
            if char:
                try:
                    out.append(chr(int(char, 16)))
                except ValueError:
                    pass
        else:
            _docx_collect(child, out, footnotes)


def _read_docx_footnotes(
    archive: zipfile.ZipFile, mode: str = DEFAULT_MODE
) -> dict[str, list[str]]:
    """Map footnote id -> list of normalised paragraph texts."""
    try:
        blob = archive.read("word/footnotes.xml")
    except KeyError:
        return {}
    root = ET.fromstring(blob)
    result: dict[str, list[str]] = {}
    for note in root.findall(w("footnote")):
        if note.get(w("type")) in {"separator", "continuationSeparator"}:
            continue
        ident = note.get(w("id"))
        texts: list[str] = []
        for para in note.iter(w("p")):
            chunks: list[str] = []
            _docx_collect(para, chunks, [])
            text = normalise("".join(chunks), mode)
            if text:
                texts.append(text)
        if ident is not None and texts:
            result[ident] = texts
    return result


def _table_caption(children: list[ET.Element], index: int) -> ET.Element | None:
    """The caption paragraph Word places after a table, if there is one."""
    while index < len(children) and children[index].tag == w("p"):
        para = children[index]
        if _docx_para_style(para) in CAPTION_STYLES:
            return para
        chunks: list[str] = []
        _docx_collect(para, chunks, [])
        if "".join(chunks).strip():
            return None
        index += 1
    return None


def read_docx(path: str, mode: str = DEFAULT_MODE) -> list[Unit]:
    with zipfile.ZipFile(path) as archive:
        document = ET.fromstring(archive.read("word/document.xml"))
        footnote_text = _read_docx_footnotes(archive, mode)

    body = document.find(w("body"))
    if body is None:
        raise SystemExit(f"{path}: no <w:body> found")

    units: list[Unit] = []
    numberer = SectionNumberer()
    seq = 0

    def emit(kind: str, text: str) -> None:
        nonlocal seq
        if not text:
            return
        seq += 1
        units.append(Unit(seq, numberer.current, kind, text))

    def handle_paragraph(para: ET.Element, in_table: bool) -> None:
        style = _docx_para_style(para)
        if style in TOC_STYLES:
            return
        chunks: list[str] = []
        refs: list[str] = []
        _docx_collect(para, chunks, refs)
        raw = "".join(chunks)

        heading = HEADING_RE.match(style or "")
        if heading and not in_table:
            level = int(heading.group(1))
            text = normalise(raw, mode)
            if _docx_numbered(para):
                numberer.heading(level, text)
            elif top_level(numberer.current) == "front":
                numberer.unnumbered()
            emit(f"heading{level}", text)
        elif style in CODE_STYLES:
            # One unit per code line so that a Word code paragraph lines up
            # with a line of a Metanorma <sourcecode> block.
            for line in raw.split("\n"):
                emit("code", normalise(line, mode))
        else:
            if in_table:
                kind = "cell"
            elif style in CAPTION_STYLES:
                kind = "caption"
            elif style in LIST_STYLES:
                kind = "list"
            else:
                kind = "para"
            for line in raw.split("\n"):
                emit(kind, normalise(line, mode))

        for ident in refs:
            for text in footnote_text.get(ident, []):
                emit("footnote", text)

    def walk(container: ET.Element, in_table: bool) -> None:
        children = list(container)
        moved: set[int] = set()
        for index, element in enumerate(children):
            if element.tag == w("p"):
                if id(element) not in moved:
                    handle_paragraph(element, in_table)
            elif element.tag == w("tbl"):
                # Word puts a table's caption after the table; a renderer
                # puts the name with the table it names, so the caption is
                # inventoried where the reader meets it.
                caption = _table_caption(children, index + 1)
                if caption is not None:
                    moved.add(id(caption))
                    handle_paragraph(caption, False)
                walk_table(element)
            elif element.tag in (w("sdt"), w("sdtContent")):
                walk(element, in_table)
            elif element.tag == w("sectPr"):
                continue

    def walk_table(table: ET.Element) -> None:
        for row in table.findall(w("tr")):
            for cell in row.findall(w("tc")):
                walk(cell, True)

    walk(body, False)
    return units


# --------------------------------------------------------------------------
# Metanorma semantic XML reader
# --------------------------------------------------------------------------

# Generated metadata, not converted prose.  Everything else is accounted for.
XML_SKIP = {
    "svg",
    "bibdata",
    "bibdata-extension",
    "metanorma-extension",
    "localized-strings",
    "misc-container",
    "presentation-metadata",
    "semantic-metadata",
}

# The ISO copyright/licence boilerplate is generated by Metanorma from the
# document template, not converted from the Word source, so by default it is
# not compared.  --include-boilerplate puts it back.
BOILERPLATE = "boilerplate"

# Elements that start a numbered section.
XML_SECTION = {"clause", "terms", "definitions", "references", "annex", "appendix"}

# Elements that are their own logical unit.
XML_BLOCK = {
    "p",
    "title",
    "name",
    "li",
    "dt",
    "dd",
    "td",
    "th",
    "sourcecode",
    "pre",
    "formula",
    "stem",
    "quote",
    "attribution",
    "author",
    "source",
    "figure-title",
    "fn",
    "floating-title",
    "variant-title",
    "bibitem",
}

# A <bibitem> is a structured bibliographic record: title, docidentifier,
# contributors, dates, language, script.  Only the parts a reader sees are
# inventoried, as one unit, matching the single Word paragraph/cell they came
# from.  The rest is generated metadata.
BIBITEM_VISIBLE = ("formattedref", "title", "docidentifier")

# Word writes a bibliography entry as a "[label]" cell followed by a cell of
# text; Metanorma holds the label in <docidentifier> and renders it in
# brackets.  Writing it back in brackets keeps the unit self-describing, so
# an entry can be matched to its Word original by label alone.
CITATION_LABEL = "[{}]"

# Inline elements that stand for text the renderer supplies: a citation
# label, the number of the clause a cross-reference points at, or, for a bare
# hyperlink, the URL itself.
XML_REFERENCE = {"eref", "link", "origin", "xref"}

# Clause numbers, as Word resolves a cross-reference to them: "12", "12.3.7".
# Annexes are left out: Word numbers them on from the last clause and
# Metanorma letters them, so the two never agree and neither is carried text.
CLAUSE_NUMBER_RE = re.compile(r"[0-9]+(?:\.[0-9]+)*$")

# Blocks that may legitimately contain other blocks; their own loose text is
# emitted first, then the children are visited in order.
XML_KIND = {
    "td": "cell",
    "th": "cell",
    "li": "list",
    "dt": "list",
    "dd": "list",
    "name": "caption",
    "sourcecode": "code",
    "pre": "code",
    "fn": "footnote",
}


def _local(tag: str) -> str:
    return tag.split("}", 1)[-1]


def _rendered_reference(element: ET.Element, numbers: dict[str, str]) -> str:
    """The text a reference element renders as when it carries none itself.

    An ``<eref>`` to a bibliography entry is written out as its ``citeas``
    label in brackets, exactly as Word holds it, a ``<xref>`` as the number
    of the clause it points at, and a bare ``<link>`` shows its own URL.
    Without this the target loses text the reader sees, and the Word original
    that still spells it out looks like an addition.
    """
    citeas = element.get("citeas")
    if citeas:
        return CITATION_LABEL.format(citeas)
    target = element.get("target") or ""
    if _local(element.tag) == "xref":
        return numbers.get(target, "")
    return target


def _xml_inline_text(element: ET.Element, numbers: dict[str, str]) -> str:
    """Text of an element, excluding nested block-level descendants."""
    parts: list[str] = [element.text or ""]
    for child in element:
        name = _local(child.tag)
        if name == "br":
            parts.append(" ")
            parts.append(child.tail or "")
            continue
        if name in XML_SKIP or name in XML_BLOCK or name in XML_SECTION:
            parts.append(child.tail or "")
            continue
        inner = _xml_inline_text(child, numbers)
        if not inner.strip() and name in XML_REFERENCE:
            inner = _rendered_reference(child, numbers)
        parts.append(inner)
        parts.append(child.tail or "")
    return "".join(parts)


def _xml_nested_blocks(element: ET.Element) -> list[ET.Element]:
    found: list[ET.Element] = []
    for child in element:
        name = _local(child.tag)
        if name in XML_SKIP:
            continue
        if name in XML_BLOCK or name in XML_SECTION:
            found.append(child)
        else:
            found.extend(_xml_nested_blocks(child))
    return found


def read_metanorma_xml(
    path: str, include_boilerplate: bool = False, mode: str = DEFAULT_MODE
) -> list[Unit]:
    """Inventory a Metanorma semantic XML file.

    The document is walked twice: a cross-reference renders as the number of
    the clause it points at, and that number is only known once the whole
    clause hierarchy has been numbered.
    """
    root = ET.parse(path).getroot()
    numbers: dict[str, str] = {}
    _read_metanorma(root, include_boilerplate, mode, numbers)
    return _read_metanorma(root, include_boilerplate, mode, numbers)


def _read_metanorma(
    root: ET.Element,
    include_boilerplate: bool,
    mode: str,
    numbers: dict[str, str],
) -> list[Unit]:
    units: list[Unit] = []
    numberer = SectionNumberer()
    seq = 0
    state = {"depth": 0, "in_bibliography": False, "in_preface": False}
    skip = set(XML_SKIP)
    if not include_boilerplate:
        skip.add(BOILERPLATE)

    def emit(kind: str, text: str) -> None:
        nonlocal seq
        if not text:
            return
        seq += 1
        units.append(Unit(seq, numberer.current, kind, text))

    def emit_block(element: ET.Element) -> None:
        name = _local(element.tag)
        kind = XML_KIND.get(name, "para" if name == "p" else name)
        text = _xml_inline_text(element, numbers)
        if name in ("sourcecode", "pre"):
            for line in text.split("\n"):
                emit("code", normalise(line, mode))
        else:
            emit(kind, normalise(text, mode))
        for child in _xml_nested_blocks(element):
            walk(child)

    def emit_bibitem(element: ET.Element) -> None:
        chunks: list[str] = []
        for wanted in BIBITEM_VISIBLE:
            for child in element:
                if _local(child.tag) == wanted:
                    text = normalise(_xml_inline_text(child, numbers), mode)
                    if text and text not in chunks:
                        chunks.append(text)
            if wanted == "formattedref" and chunks:
                break  # a formatted reference already carries the whole entry
        label = ""
        for child in element:
            if _local(child.tag) == "docidentifier":
                label = normalise(_xml_inline_text(child, numbers), mode)
                break
        if label:
            chunks.insert(0, CITATION_LABEL.format(label))
        emit("bibitem", " ".join(chunks))

    def walk(element: ET.Element) -> None:
        name = _local(element.tag)
        if name in skip:
            return
        if name == "bibitem":
            emit_bibitem(element)
            return
        if name in XML_SECTION:
            enter_section(element)
            return
        if name == "preface":
            # Preface clauses (foreword, introduction, abstract) are not
            # numbered, so they must not consume a clause number.
            state["in_preface"] = True
            numberer.current = "front"
            for child in element:
                walk(child)
            state["in_preface"] = False
            return
        if name == "bibliography":
            previous_section = numberer.current
            state["in_bibliography"] = True
            numberer.current = "bib"
            for child in element:
                walk(child)
            state["in_bibliography"] = False
            numberer.current = previous_section
            return
        if name in XML_BLOCK:
            emit_block(element)
            return
        if element.text and element.text.strip():
            emit("stray", normalise(element.text, mode))
        for child in element:
            walk(child)
            if child.tail and child.tail.strip():
                emit("stray", normalise(child.tail, mode))

    def next_annex_letter() -> str:
        if numberer.prefix is None:
            return "A"
        return chr(ord(numberer.prefix) + 1)

    def enter_section(element: ET.Element) -> None:
        name = _local(element.tag)
        state["depth"] += 1
        level = state["depth"]
        title_element = None
        for child in element:
            if _local(child.tag) == "title":
                title_element = child
                break
        title = ""
        if title_element is not None:
            title = normalise(_xml_inline_text(title_element, numbers), mode)
        # Metanorma annexes carry no letter in the semantic XML; synthesise one
        # for numbering only, never for the compared text.
        numbering_title = title
        if (
            name in ("annex", "appendix")
            and level == 1
            and not APPENDIX_RE.match(title)
        ):
            numbering_title = f"Annex {next_annex_letter()}"
        if state["in_preface"]:
            numberer.unnumbered()
        elif state["in_bibliography"]:
            numberer.current = "bib"
        else:
            numberer.heading(level, numbering_title)
            # A cross-reference to this clause renders as its number, so
            # record what that number is for the second pass.
            for ident in (element.get("anchor"), element.get("id")):
                if ident and CLAUSE_NUMBER_RE.fullmatch(numberer.current):
                    numbers.setdefault(ident, numberer.current)
        if title_element is not None:
            emit(f"heading{level}", title)
        for child in element:
            if child is title_element:
                continue
            walk(child)
        state["depth"] -= 1

    for child in root:
        walk(child)
    return units


# --------------------------------------------------------------------------
# Entry point
# --------------------------------------------------------------------------

SANITY_PHRASES = [
    "It is a Schema Definition Error",
    "Schema Definition Error",
    "It is a Processing Error",
    "Processing Error",
    "must",
    "shall",
]


def read_any(
    path: str, include_boilerplate: bool = False, mode: str = DEFAULT_MODE
) -> list[Unit]:
    if mode not in TRANSLATIONS:
        raise SystemExit(f"unknown normalisation mode {mode!r}")
    lowered = path.lower()
    if lowered.endswith(".docx"):
        return read_docx(path, mode)
    if lowered.endswith(".xml"):
        return read_metanorma_xml(path, include_boilerplate, mode)
    if lowered.endswith((".tsv", ".txt", ".inv")):
        return parse_tsv(path, mode)
    with open(path, "rb") as handle:
        magic = handle.read(4)
    if magic[:2] == b"PK":
        return read_docx(path, mode)
    return read_metanorma_xml(path, include_boilerplate, mode)


def filter_clauses(units: list[Unit], wanted: str) -> list[Unit]:
    keys = {part.strip() for part in wanted.split(",") if part.strip()}
    return [unit for unit in units if top_level(unit.section) in keys]


def print_census(units: list[Unit], stream, prefix: str = "# ") -> None:
    """Per-character counts of the syntax-significant characters."""
    counts = census(unit.text for unit in units)
    print(f"{prefix}character census:", file=stream)
    for label, chars in CENSUS_GROUPS:
        present = [(c, counts[c]) for c in dict.fromkeys(chars) if counts[c]]
        if not present:
            continue
        print(f"{prefix}  {label}:", file=stream)
        for char, count in present:
            name = CHAR_NAMES.get(char, "")
            suffix = f"  ({name})" if name else ""
            print(f"{prefix}    {char!r:>8} {count:>7}{suffix}", file=stream)


def print_stats(units: list[Unit], path: str, stream, mode: str = DEFAULT_MODE) -> None:
    body = "\n".join(unit.text for unit in units)
    total_words = sum(len(words(unit.text)) for unit in units)
    total_tokens = sum(len(tokens(unit.text)) for unit in units)
    print(f"# source: {path}", file=stream)
    print(f"# mode: {mode}", file=stream)
    print(f"# units: {len(units)}", file=stream)
    print(f"# words: {total_words}", file=stream)
    print(f"# tokens (words + punctuation): {total_tokens}", file=stream)
    print(f"# characters: {sum(len(u.text) for u in units)}", file=stream)
    kinds: dict[str, int] = {}
    for unit in units:
        kinds[unit.kind] = kinds.get(unit.kind, 0) + 1
    for kind in sorted(kinds):
        print(f"#   kind {kind}: {kinds[kind]}", file=stream)
    print(
        "# phrase counts, substring / whole-word "
        "(sanity aid only - NOT the fidelity check):",
        file=stream,
    )
    for phrase in SANITY_PHRASES:
        pattern = re.compile(r"\b" + re.escape(phrase) + r"\b")
        substring = body.count(phrase)
        whole = len(pattern.findall(body))
        print(f"#   {phrase!r}: {substring} / {whole}", file=stream)


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Emit a normalised text inventory of the DFDL spec.",
    )
    parser.add_argument("input", help=".docx source or Metanorma semantic .xml")
    parser.add_argument("-o", "--output", help="write inventory here (default stdout)")
    parser.add_argument(
        "--format",
        choices=("tsv", "plain"),
        default="tsv",
        help="tsv: seq/section/kind/text; plain: text only",
    )
    parser.add_argument(
        "--clause",
        help="restrict output to these top-level clauses (comma separated)",
    )
    parser.add_argument(
        "--mode",
        choices=MODES,
        default=DEFAULT_MODE,
        help=(
            "strict (default): normalise only what must differ between .docx "
            "and Metanorma XML.  relaxed: also fold smart quotes, dashes and "
            "ellipses - advisory only, it hides typographic corruption."
        ),
    )
    parser.add_argument(
        "--stats",
        action="store_true",
        help="print counts to stderr as well",
    )
    parser.add_argument(
        "--census",
        action="store_true",
        help="print the syntax-character census to stderr as well",
    )
    parser.add_argument(
        "--include-boilerplate",
        action="store_true",
        help="XML input: also inventory Metanorma's generated ISO boilerplate",
    )
    args = parser.parse_args(argv)

    units = read_any(args.input, args.include_boilerplate, args.mode)
    if args.clause:
        units = filter_clauses(units, args.clause)

    if args.stats:
        print_stats(units, args.input, sys.stderr, args.mode)
    if args.census:
        print_census(units, sys.stderr)

    with contextlib.ExitStack() as stack:
        stream = sys.stdout
        if args.output:
            stream = stack.enter_context(open(args.output, "w", encoding="utf-8"))
        if args.format == "tsv":
            print(f"# mode: {args.mode}", file=stream)
        for unit in units:
            if args.format == "plain":
                print(unit.text, file=stream)
            else:
                print(unit.as_tsv(), file=stream)
    return 0


if __name__ == "__main__":
    sys.exit(main())
