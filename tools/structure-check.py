#!/usr/bin/env python3
"""Check that the structure of the DFDL spec agrees with what its prose claims.

``tools/fidelity-check.py`` proves that no *text* was lost in the conversion
from MS-Word.  It cannot prove that the text still means what it did, because
the meaning here is carried by structure: a caption belongs to the table below
it, a cross-reference resolves to a numbered thing of a particular kind, and a
sentence that says "Figure 2" is a claim about what the second figure is.  Word
kept those relations in fields and bookmarks; AsciiDoc keeps them in block
nesting and anchors, and Metanorma renumbers everything from scratch.  Every
one of those relations can break while every word survives, so a token-level
check passes over a document that reads wrongly.

This is the structural gate, and it reads the **rendered HTML**.

    Why the HTML and not the semantic XML.  An earlier version of this tool
    worked on ``build/*/dfdl.xml``, which holds the structure but not the
    resolved labels, so it *reconstructed* Metanorma's numbering: it replayed
    the counter rules to work out that a given block would print as "Figure 2".
    That model was calibrated against a build in which untitled code listings
    still consumed figure numbers.  The document was then fixed - the listings
    carry ``unnumbered`` and no longer count - and the model, still counting
    them, went on insisting that "Figure 2" named a code listing when the page
    plainly reads "Figure 2 - DFDL Schema UML diagram".  Two of the tool's
    findings were pure arithmetic error, and the arithmetic had no way to know.

    The HTML has the answer written on it.  ``<caption>Table 15 - Properties
    Common to both Content and Framing</caption>`` *is* the label; a link's
    text *is* what the reader sees where the cross-reference sits; a heading
    *is* its clause number.  Reading them removes the model, and with it the
    entire class of defect the model produced.  It is also the artifact these
    checks are actually about: what a reader sees.  Nothing here counts
    anything, so nothing here can count wrongly.

The checks, and the failure each one exists to catch:

``captions``
    A numbered table or figure that prints only its number - "Table 1" with no
    title - *and* is referred to somewhere by that number.  In Word the caption
    was a separate paragraph tied to the table by a field; a caption that
    failed to become the block's title is a table nobody can cite.  A block
    that carries no title and that nothing cites is not reported: an untitled
    table is a legitimate thing to write, and several in this document are
    untitled in the Word source too.  The defect is a *dangling* reference, and
    it takes a reference to have one.

``orphans``
    The other half of the same failure, seen from the text: a short, unpunctu-
    ated, title-cased paragraph sitting against an untitled block, or any
    paragraph opening "Table 6 - ..." next to one.  The caption text survived -
    so the fidelity check is satisfied - but it is now body prose.

``double-numbering``
    A caption that already spells a number of its own.  Metanorma prefixes one
    too, so the reader sees "Table D.1 - Table 76: ...": two numbers for one
    table, of which only the first is real.

``block-references``
    Literal prose of the form "Figure N" / "Table N" / "Section N" / "Clause N"
    / "Annex X", checked against whatever actually bears that number on the
    page.  Two ways it can be wrong: the number names nothing, or the prose
    spells a title beside the number and that title belongs to something else.
    The second is the sharpest test, because a trailing phrase that is exactly
    some other clause's title is proof that a title was meant and that the
    number beside it is stale.

``xref-kind``
    A cross-reference whose *text* disagrees with what it points at.  This is
    read off the page: the anchor text is what the reader sees, and the target
    is what they land on.  Reported when the text spells a label ("Table 15")
    that the target does not carry, and when the word before the reference
    names a different kind from the one the text spells.  A reference that
    renders as a name rather than as a label - the property index's "bitOrder",
    a citation's "[ITA2]" - is making no claim about numbering and is left
    alone.

``numbering``
    No two blocks print the same label.  Two things both called "Table 40"
    make every reference to Table 40 ambiguous.

``markup``
    AsciiDoc syntax surviving into rendered text - ``link:``, ``<<``, ``pass:``,
    ``++``, ``[[``, an unclosed bracket.  Markup that failed to parse is text
    that reads as noise, and it usually swallows a word as it fails.

``degenerate``
    Text showing a field or reference that resolved to nothing: "on page .",
    an empty ``[]`` or ``()``, a space before a full stop, a doubled delimiter,
    a bare "Section" with no number after it.  Only where the Word source does
    *not* read the same way: this specification writes ``[]`` for the empty
    representation and inherited several broken Word fields, and reproducing
    the source faithfully is this conversion's job, not its failure.  Without
    the Word source the check still runs, and says so.

``source-visibility`` (needs the .docx)
    Every run marked ``w:vanish`` in the Word source is extracted and looked
    for in the built text.  Text that was hidden and is now published is a
    defect of the conversion.  Text that *also* occurs unhidden somewhere in
    the source is not: "(MANUALLY SET TABLE NUMBER TO PRESERVE TABLE
    NUMBERING)" appears twice in this document's Word source, once hidden and
    once as visible blue text, and only the visible one was published.  So the
    check compares counts - published occurrences against visible occurrences -
    rather than asking whether the phrase appears at all.

    This replaces an earlier ``editorial`` check that pattern-matched for
    "MANUALLY SET", "Note to Editors", "TBD" and the like on the premise that
    such text had been hidden in Word.  For the one marker that check ever
    fired on, the premise was false.  Whether a phrase is editor-facing is a
    property of the source's content; whether it was *hidden* is a property
    this tool can establish, and only from the source.  The heuristic form
    could not tell a leak from a faithful copy, so it is gone rather than
    exception-listed.

Usage::

    python3 tools/structure-check.py build/iso/dfdl.html
    python3 tools/structure-check.py build/iso/dfdl.html docs/current/spec.docx
"""

from __future__ import annotations

import argparse
import re
import sys
import unicodedata
import xml.etree.ElementTree as ET
import zipfile
from collections import Counter, defaultdict
from html.parser import HTMLParser
from pathlib import Path

W = "{http://schemas.openxmlformats.org/wordprocessingml/2006/main}"

# The label a caption opens with.  "Table D.1", "Figure 4".
LABEL = re.compile(r"^(?P<kind>Table|Figure)\s+(?P<num>[A-Z]\.\d+|\d+)\s*$")

# A clause heading: "1.2.1  Simple Example", "A.1  Escape Character ...".
HEADING = re.compile(r"^(?P<num>[A-Z]\.\d+(?:\.\d+)*|\d+(?:\.\d+)*)\s+(?P<title>\S.*)$")

# "Table 17-6" is a reference into someone else's book, not into this document,
# so a word character, digit or hyphen after the number rules the match out.  A
# full stop does not: a reference often ends a sentence.
LITERAL_REF = re.compile(
    r"\b(?P<kind>Section|Clause|Annex|Appendix|Figure|Table)\s+"
    r"(?P<num>[A-Z]\.\d+(?:\.\d+)*|\d+(?:\.\d+)*|[A-Z])"
    r"(?![\w\-])"
)

# A paragraph that is unmistakably a caption: it opens with a block label.
CAPTION_START = re.compile(
    r"^(?:Figure|Table)\s+(?:[A-Z]\.)?\d+[A-Za-z\-]*\s*[-–—:.]?\s+\S"
)

# A caption that spells a number of its own on top of the one Metanorma adds.
CAPTION_NUMBER = re.compile(r"\b(?:Figure|Table)\s+(?:[A-Z]\.)?\d+")

# Words that carry no capitalisation signal when deciding whether a stray
# paragraph is title-cased, and so was once a caption.
STOPWORDS = frozenset(
    (
        "a",
        "an",
        "and",
        "as",
        "at",
        "but",
        "by",
        "for",
        "from",
        "in",
        "into",
        "of",
        "on",
        "or",
        "the",
        "to",
        "with",
        "without",
    )
)

# AsciiDoc constructs only ever seen in rendered text when the source failed
# to parse.
LEAKED_MARKUP = (
    ("link: macro", re.compile(r"\blink:\S")),
    ("image: macro", re.compile(r"\bimage::?\S")),
    ("<<xref>>", re.compile(r"<<\w[^<>]*>>|<<\w")),
    ("pass: macro", re.compile(r"\bpass:\w*\[")),
    ("++passthrough++", re.compile(r"\+{2,}")),
    ("[[anchor]]", re.compile(r"\[\[\w")),
    ("^superscript^", re.compile(r"\^\(?[A-Za-z]+\)?\^")),
    ("{attribute}", re.compile(r"\{[a-z][a-z0-9_-]*\}")),
)

# Text that shows a Word field or a reference that resolved to nothing.  The
# third field says whether the pattern is only meaningful in running prose:
# a table cell holding escape-scheme data legitimately contains "[ ]".
DEGENERATE = (
    ("dangling page reference", re.compile(r"\bon page\s*[.,;]"), False),
    ("empty bracket pair", re.compile(r"(?<=\s)\[\s*\]"), True),
    # This specification is full of "fn:true()" and "'()'", so only a pair
    # standing alone where a word belongs is a resolved-to-nothing field.
    ("empty parenthesis pair", re.compile(r"(?<=\s)\(\s*\)"), True),
    ("space before full stop", re.compile(r"\w \.(?:\s|$)"), False),
    # "e.g.," and "etc.," are ordinary; a delimiter with space before the next
    # one is a sentence that lost its middle.
    ("doubled sentence delimiter", re.compile(r"[.;]\s+[,;]"), False),
    # Only where a reference is being made: "in this section." is English and
    # "Property Table, which" is a noun, but "described in Section." is a
    # cross-reference whose number went missing.
    (
        "reference with no number",
        re.compile(
            r"\b(?:in|In|see|See|per|from|of)\s+"
            r"(?:Section|Clause|Figure|Table)\s*[.,;)]"
        ),
        False,
    ),
)

# The word before a cross-reference says what kind of thing the author thought
# they were pointing at.
KIND_WORDS = {
    "section": "Clause",
    "sections": "Clause",
    "clause": "Clause",
    "clauses": "Clause",
    "subclause": "Clause",
    "annex": "Annex",
    "appendix": "Annex",
    "table": "Table",
    "tables": "Table",
    "figure": "Figure",
    "figures": "Figure",
}

# Shortest hidden phrase worth looking for: below this, a Word fragment such
# as " . " matches everywhere and says nothing.
MIN_HIDDEN_PHRASE = 10

# A stranded caption is short and has no sentence punctuation.
MAX_CAPTION_WORDS = 15

# How much of a degenerate snippet has to be found in the Word source before
# the built text counts as reproducing it.
CONTEXT_WINDOW = 40


def normalize(text: str) -> str:
    """Fold the typographic variation Word left behind, and collapse space."""
    text = unicodedata.normalize("NFKC", text)
    for fancy, plain in (
        ("‘", "'"),
        ("’", "'"),
        ("“", '"'),
        ("”", '"'),
        ("–", "-"),
        ("—", "-"),
        (" ", " "),
    ):
        text = text.replace(fancy, plain)
    return " ".join(text.split())


def title_key(text: str) -> str:
    """A title reduced to what any reference to it would have to share."""
    return re.sub(r"[^a-z0-9]+", " ", normalize(text).lower()).strip()


def title_cased(text: str) -> bool:
    """Does this read like a caption rather than like a sentence?"""
    words = [
        w for w in re.findall(r"[A-Za-z][\w:.-]*", text) if w.lower() not in STOPWORDS
    ]
    if len(words) < 2:
        return False
    capitals = sum(1 for w in words if w[0].isupper())
    return capitals * 5 >= len(words) * 3


# -- the rendered page ------------------------------------------------------

VOID = frozenset(
    [
        "area",
        "base",
        "br",
        "col",
        "embed",
        "hr",
        "img",
        "input",
        "link",
        "meta",
        "param",
        "source",
        "track",
        "wbr",
    ]
)

# Elements that implicitly close an open element of the same kind.
CLOSES = {
    "p": {"p"},
    "li": {"li", "p"},
    "td": {"td", "th", "p"},
    "th": {"td", "th", "p"},
    "tr": {"tr", "td", "th", "p"},
    "dt": {"dt", "dd", "p"},
    "dd": {"dt", "dd", "p"},
}

# Blocks of rendered prose.  A container is only reported through its
# innermost text-bearing block, so a table cell holding a <p> is skipped in
# favour of the <p>.
PROSE_TAGS = frozenset(
    [
        "p",
        "li",
        "td",
        "th",
        "dt",
        "dd",
        "caption",
        "figcaption",
        "h1",
        "h2",
        "h3",
        "h4",
        "h5",
        "h6",
    ]
)
NESTED_TAGS = frozenset(
    ["p", "ul", "ol", "dl", "table", "figure", "div", "blockquote", "pre"]
)

# Chrome that is not part of the sentence a reader reads: the heading's own
# self-link, and the superscript marker that stands for a footnote whose body
# is printed elsewhere.
DROP_CLASSES = frozenset(
    ("anchor", "FootnoteRef", "TableFootnoteRef", "AdmonitionTitle")
)

# Whole regions of the page that are not the document's prose.
SKIP_IDS = frozenset(("toc",))
SKIP_CLASSES = frozenset(("title-section", "coverpage", "document-stage-band"))
SKIP_TAGS = frozenset(("script", "style", "head", "nav", "svg"))


def is_skipped(node: Node) -> bool:
    """Is this region something other than the document's own prose?"""
    return (
        node.tag in SKIP_TAGS
        or node.attrs.get("id") in SKIP_IDS
        or bool(node.classes() & SKIP_CLASSES)
    )


class Node:
    """One element of the rendered page."""

    __slots__ = ("attrs", "children", "parent", "tag")

    def __init__(self, tag: str, attrs: dict[str, str]) -> None:
        self.tag = tag
        self.attrs = attrs
        self.children: list[Node | str] = []
        self.parent: Node | None = None

    def classes(self) -> frozenset[str]:
        return frozenset((self.attrs.get("class") or "").split())

    def elements(self):
        return [c for c in self.children if isinstance(c, Node)]

    def iter(self):
        yield self
        for child in self.children:
            if isinstance(child, Node):
                yield from child.iter()

    def find(self, tag: str) -> Node | None:
        for node in self.iter():
            if node is not self and node.tag == tag:
                return node
        return None


class PageParser(HTMLParser):
    """A forgiving tree builder.  Metanorma's HTML is close to well formed."""

    def __init__(self) -> None:
        super().__init__(convert_charrefs=True)
        self.root = Node("#document", {})
        self.stack = [self.root]

    def _open(self, tag: str, attrs: list[tuple[str, str | None]]) -> Node:
        for candidate in CLOSES.get(tag, ()):
            for depth in range(len(self.stack) - 1, 0, -1):
                if self.stack[depth].tag == candidate:
                    del self.stack[depth:]
                    break
                if self.stack[depth].tag in ("table", "ul", "ol", "dl", "tr"):
                    break
        node = Node(tag, {k: (v or "") for k, v in attrs})
        node.parent = self.stack[-1]
        self.stack[-1].children.append(node)
        return node

    def handle_starttag(self, tag, attrs):
        node = self._open(tag, attrs)
        if tag not in VOID:
            self.stack.append(node)

    def handle_startendtag(self, tag, attrs):
        self._open(tag, attrs)

    def handle_endtag(self, tag):
        if tag in VOID:
            return
        for depth in range(len(self.stack) - 1, 0, -1):
            if self.stack[depth].tag == tag:
                del self.stack[depth:]
                return

    def handle_data(self, data):
        self.stack[-1].children.append(data)


class Block:
    """A numbered table or figure, as the page prints it."""

    __slots__ = ("is_listing", "kind", "label", "node", "title")

    def __init__(self, node: Node, kind: str, label: str, title: str) -> None:
        self.node = node
        self.kind = kind
        self.label = label
        self.title = title
        self.is_listing = "sourcecode" in node.classes()

    def describe(self) -> str:
        if self.kind == "Table":
            return "table"
        return "code listing" if self.is_listing else "figure"


class Page:
    """The built HTML, read for the labels and the text it prints."""

    def __init__(self, html: str) -> None:
        parser = PageParser()
        parser.feed(html)
        self.root = parser.root

        self.blocks: list[Block] = []
        self.by_label: dict[str, Block] = {}
        self.clause_title: dict[str, str] = {}
        self.label_of_node: dict[int, str] = {}
        self.anchor_label: dict[str, str] = {}
        self.where_of: dict[int, str] = {}

        self._read_blocks()
        self._read_clauses()
        self._index_anchors()

        # Which numbered thing owns each title, so a title written beside a
        # number can be judged against the number that really carries it.
        self.title_owner: dict[str, list[str]] = defaultdict(list)
        for number, title in self.clause_title.items():
            key = title_key(title)
            if key:
                label = f"Annex {number}" if number[0].isalpha() else f"Clause {number}"
                self.title_owner[key].append(label)
        for block in self.blocks:
            key = title_key(block.title)
            if key:
                self.title_owner[key].append(block.label)

    # -- reading the page ---------------------------------------------------

    def text_of(self, node: Node, drop_listings: bool = True) -> str:
        """What a reader sees inside this element."""
        pieces: list[str] = []

        def walk(current: Node) -> None:
            for child in current.children:
                if isinstance(child, str):
                    pieces.append(child)
                    continue
                if child.classes() & DROP_CLASSES:
                    continue
                if drop_listings and child.tag == "pre":
                    continue
                if child.tag == "aside":
                    continue  # the footnote body is printed at the foot
                walk(child)

        walk(node)
        return normalize("".join(pieces))

    def _read_blocks(self) -> None:
        for node in self.root.iter():
            if is_skipped(node):
                continue
            if node.tag == "table":
                caption = next((c for c in node.elements() if c.tag == "caption"), None)
            elif node.tag == "figure":
                caption = next(
                    (c for c in node.elements() if c.tag == "figcaption"), None
                )
            else:
                continue
            if caption is None:
                continue  # unnumbered: the page gives it no label at all
            text = self.text_of(caption)
            head, _, tail = text.partition(" - ") if " - " in text else (text, "", "")
            match = LABEL.match(head)
            if not match:
                continue
            block = Block(node, match.group("kind"), head.strip(), tail.strip())
            self.blocks.append(block)
            self.label_of_node[id(node)] = block.label
            self.by_label.setdefault(block.label, block)

    def _read_clauses(self) -> None:
        """Every heading, and the number the page prints in front of it."""
        for node in self.root.iter():
            if is_skipped(node) or node.tag not in (
                "h1",
                "h2",
                "h3",
                "h4",
                "h5",
                "h6",
            ):
                continue
            header = next(
                (c for c in node.iter() if c is not node and "header" in c.classes()),
                None,
            )
            source = header if header is not None else node

            # An annex prints "Annex A", a rule, then its title, in separate
            # bold runs; a clause prints "1.2.1  Title" as one string.
            bolds = [self.text_of(b) for b in source.iter() if b.tag == "b"]
            annex = next((b for b in bolds if re.fullmatch(r"Annex [A-Z]", b)), None)
            if annex is not None:
                number = annex.split()[1]
                rest = [b for b in bolds if b != annex]
                title = rest[-1] if rest else ""
            else:
                match = HEADING.match(self.text_of(source))
                if not match:
                    continue
                number, title = match.group("num"), match.group("title")

            self.clause_title.setdefault(number, title)
            owner = node.parent if node.parent is not None else node
            self.label_of_node.setdefault(
                id(owner),
                f"Annex {number}" if number[0].isalpha() else f"Clause {number}",
            )
            self.where_of[id(owner)] = number

    def _index_anchors(self) -> None:
        """Every ``id`` on the page, and the label a reader lands inside."""

        def walk(node: Node, label: str | None, where: str | None) -> None:
            if is_skipped(node):
                return
            label = self.label_of_node.get(id(node), label)
            where = self.where_of.get(id(node), where)
            name = node.attrs.get("id")
            if name and label is not None:
                self.anchor_label.setdefault(name, label)
            self._node_where[id(node)] = where
            for child in node.elements():
                walk(child, label, where)

        self._node_where: dict[int, str | None] = {}
        walk(self.root, None, None)

    # -- lookup -------------------------------------------------------------

    def where(self, node: Node) -> str:
        return self._node_where.get(id(node)) or "front matter"

    def prose(self):
        """Every innermost block of rendered prose, as (node, text)."""
        for node in self.root.iter():
            if is_skipped(node) or node.tag not in PROSE_TAGS:
                continue
            if any(c.tag in NESTED_TAGS for c in node.elements()):
                continue
            text = self.text_of(node)
            if text:
                yield node, text

    def in_table(self, node: Node) -> bool:
        current: Node | None = node
        while current is not None:
            if current.tag == "table":
                return True
            current = current.parent
        return False

    def enclosing_block(self, node: Node) -> Block | None:
        current: Node | None = node
        while current is not None:
            label = self.label_of_node.get(id(current))
            if label and current.tag in ("table", "figure"):
                return self.by_label.get(label)
            current = current.parent
        return None

    def links(self):
        """Every cross-reference, as (node, target anchor, rendered text)."""
        for node in self.root.iter():
            if is_skipped(node) or node.tag != "a":
                continue
            if node.classes() & DROP_CLASSES:
                continue
            href = node.attrs.get("href") or ""
            if not href.startswith("#"):
                continue
            yield node, href[1:], self.text_of(node)

    def referenced_labels(self) -> dict[str, list[str]]:
        """Every label a reader is sent to, and how."""
        found: dict[str, list[str]] = defaultdict(list)
        for node, text in self.prose():
            if node.tag in ("caption", "figcaption"):
                continue
            for match in LITERAL_REF.finditer(text):
                kind, number = match.group("kind"), match.group("num")
                if kind in ("Figure", "Table"):
                    found[f"{kind} {number}"].append(f"prose in {self.where(node)}")
        for node, _, text in self.links():
            if LABEL.match(text.strip()):
                found[text.strip()].append(f"a link in {self.where(node)}")
        return found


class Report:
    """Findings, grouped by check."""

    def __init__(self) -> None:
        self.findings: dict[str, list[tuple[str, str]]] = defaultdict(list)
        self.notes: list[str] = []

    def add(self, check: str, where: str, message: str) -> None:
        self.findings[check].append((where, message))

    def note(self, message: str) -> None:
        self.notes.append(message)

    def total(self) -> int:
        return sum(len(v) for v in self.findings.values())


def excerpt(text: str, start: int, end: int, before: int = 60, after: int = 50) -> str:
    left = max(0, start - before)
    right = min(len(text), end + after)
    return (
        ("..." if left else "")
        + text[left:right]
        + ("..." if right < len(text) else "")
    )


# -- the Word source -------------------------------------------------------

DOCX_PARTS = re.compile(r"word/(document|footnotes|endnotes|header\d*|footer\d*)\.xml")


class Source:
    """The Word source, read for what it hides and what it shows.

    Two texts are kept.  ``visible`` is everything a reader of the .docx would
    see; ``hidden`` is the phrases marked ``w:vanish``.  A phrase can be in
    both - the same editorial note appears twice in this document, hidden in
    one caption and visible in another - and telling them apart is the whole
    point of keeping the two separately.
    """

    def __init__(self, docx: Path) -> None:
        visible: list[str] = []
        hidden: list[str] = []
        with zipfile.ZipFile(docx) as archive:
            for part in archive.namelist():
                if not DOCX_PARTS.fullmatch(part):
                    continue
                root = ET.fromstring(archive.read(part))
                for paragraph in root.iter(W + "p"):
                    self._read_paragraph(paragraph, visible, hidden)
        self.visible = "\n".join(normalize(p) for p in visible)
        self.hidden_phrases = sorted(
            {p for p in map(normalize, hidden) if len(p) >= MIN_HIDDEN_PHRASE},
            key=len,
            reverse=True,
        )

    @staticmethod
    def _read_paragraph(
        paragraph: ET.Element, visible: list[str], hidden: list[str]
    ) -> None:
        """Split one Word paragraph into its visible text and its hidden runs.

        Word splits a sentence across runs whenever formatting changes, so a
        hidden note arrives as a dozen fragments.  Consecutive hidden runs are
        joined back into the phrase the editor typed; a visible run between
        them ends the phrase.  Runs nested in a hyperlink or a tracked
        insertion count too, which is why this walks the paragraph rather than
        looking only at its direct children.
        """
        shown: list[str] = []
        run: list[str] = []
        for element in paragraph.iter(W + "r"):
            properties = element.find(W + "rPr")
            vanish = properties.find(W + "vanish") if properties is not None else None
            is_hidden = vanish is not None and vanish.get(W + "val") not in (
                "0",
                "false",
            )
            text = "".join(node.text or "" for node in element.iter(W + "t"))
            if element.find(W + "tab") is not None:
                text = " " + text
            if is_hidden:
                run.append(text)
            else:
                shown.append(text)
                if run:
                    hidden.append("".join(run))
                    run = []
        if run:
            hidden.append("".join(run))
        if shown:
            visible.append("".join(shown))

    def shows(self, phrase: str) -> bool:
        return normalize(phrase) in self.visible

    def count_visible(self, phrase: str) -> int:
        return self.visible.count(normalize(phrase))


# -- checks ----------------------------------------------------------------


def check_captions(page: Page, report: Report) -> None:
    """A numbered block that prints no title, and that something cites.

    An untitled block harms nobody until a sentence points at it by number: it
    is then a reference to a thing the reader cannot identify.  Several tables
    in this document carry no caption in the Word source either, and are not
    reported, because nothing refers to them.
    """
    referenced = page.referenced_labels()
    for block in page.blocks:
        if block.title:
            continue
        citations = referenced.get(block.label)
        if not citations:
            continue
        rows = sum(1 for n in block.node.iter() if n.tag == "tr")
        report.add(
            "captions",
            page.where(block.node),
            f"{block.label} prints no title ({block.describe()}, {rows} row(s)) "
            f"but is referred to by number from "
            f"{', '.join(sorted(set(citations))[:3])}: a reader is sent to a "
            f"block they cannot identify",
        )


def check_orphan_captions(page: Page, report: Report) -> None:
    """A caption that became body text instead of the block's title."""
    for parent in page.root.iter():
        if is_skipped(parent):
            continue
        children = parent.elements()
        for position, child in enumerate(children):
            if child.tag != "p":
                continue
            text = page.text_of(child)
            if not text:
                continue
            neighbours = [
                children[index]
                for index in (position - 1, position + 1)
                if 0 <= index < len(children)
            ]
            blocks = [n for n in neighbours if n.tag in ("table", "figure")]
            if not blocks:
                continue
            target = blocks[0]
            label = page.label_of_node.get(id(target))
            block = page.by_label.get(label) if label else None
            titled = bool(block and block.title)
            labelled = CAPTION_START.match(text)
            # A block the page never numbers cannot be missing its caption:
            # nothing can refer to it, so nothing is dangling.
            stranded = (
                block is not None
                and not titled
                and len(text.split()) <= MAX_CAPTION_WORDS
                and not re.search(r"[.:;]$", text)
                and title_cased(text)
            )
            if not labelled and not stranded:
                continue
            kind = block.describe() if block else "unnumbered block"
            why = (
                "it spells its own block label"
                if labelled
                else "it is a short title-cased fragment, not a sentence"
            )
            report.add(
                "orphans",
                page.where(child),
                f"{text[:70]!r} is a body paragraph beside {label or kind} "
                f"({kind}, {'already titled' if titled else 'with no title'}); "
                f"{why}",
            )


def check_double_numbering(page: Page, report: Report) -> None:
    for block in page.blocks:
        match = CAPTION_NUMBER.search(block.title)
        if not match:
            continue
        report.add(
            "double-numbering",
            page.where(block.node),
            f"caption prints as {block.label!r} - {block.title[:70]!r}: it "
            f"spells its own {match.group(0)!r} on top of the number "
            f"Metanorma adds, so the block shows two different numbers",
        )


def check_numbering(page: Page, report: Report) -> None:
    """No two blocks may print the same label."""
    counts = Counter(b.label for b in page.blocks)
    for label, count in sorted(counts.items()):
        if count == 1:
            continue
        owners = [b for b in page.blocks if b.label == label]
        detail = "; ".join(
            f"{b.title[:40] or '(no title)'} in {page.where(b.node)}" for b in owners
        )
        report.add(
            "numbering",
            "whole document",
            f"{count} blocks all print as {label!r}, so every reference to it "
            f"is ambiguous: {detail}",
        )


# Metanorma marks every entry of the reference list with this class.  A
# bibliography entry is a description of somebody else's document, so a
# clause number inside one belongs to that document, not to this one.
BIBLIOGRAPHY_CLASS = "Biblio"


def cites_other_work(node: Node, text: str) -> bool:
    """Does this block cite somebody else's document?

    "Section 5.1" inside "XML Schema Specification Part 1, Section 5.1
    [XSDLV1]" is not a reference into this document and must not be judged
    against this document's numbering.  A reference-list entry, a bracketed
    citation label, an ISBN, or another specification named in the same block
    is the signal.
    """
    current: Node | None = node
    while current is not None:
        if BIBLIOGRAPHY_CLASS in current.classes():
            return True
        current = current.parent
    if re.search(r"\[[A-Z][A-Za-z0-9_.]{1,30}\]", text):
        return True
    if "ISBN" in text:
        return True
    return bool(
        re.search(
            r"\b(?:XML Schema|XPath|XQuery|XSLT|Unicode|IEEE|RFC \d|W3C|ICU)\b", text
        )
    )


def check_block_references(page: Page, report: Report, source: Source | None) -> None:
    numeric = [n for n in page.clause_title if n.replace(".", "").isdigit()]
    max_clause = max((int(n.split(".")[0]) for n in numeric), default=0)
    seen: set[tuple[str, str, str]] = set()
    for node, text in page.prose():
        if node.tag in ("caption", "figcaption"):
            continue  # captions are double-numbering's business
        external = cites_other_work(node, text)
        where = page.where(node)
        for match in LITERAL_REF.finditer(text):
            kind, number = match.group("kind"), match.group("num")
            phrase = match.group(0)
            trailing = text[match.end() : match.end() + 160].lstrip(" ,:.-")
            key = (phrase, where, trailing[:40])
            if key in seen:
                continue
            seen.add(key)
            here = excerpt(text, match.start(), match.end())

            if kind in ("Figure", "Table"):
                if f"{kind} {number}" in page.by_label:
                    _check_trailing_title(
                        page, report, where, phrase, trailing, f"{kind} {number}"
                    )
                elif not external and not _source_says(source, text, match):
                    report.add(
                        "block-references",
                        where,
                        f"prose says {phrase!r} but the page prints no "
                        f"{kind.lower()} with that number: {here}",
                    )
                continue

            if kind in ("Annex", "Appendix"):
                if number not in page.clause_title or not number.isalpha():
                    if not external and not _source_says(source, text, match):
                        report.add(
                            "block-references",
                            where,
                            f"prose says {phrase!r} but the document has no "
                            f"annex {number}: {here}",
                        )
                    continue
                label = f"Annex {number}"
            else:
                if number not in page.clause_title:
                    if external or _source_says(source, text, match):
                        continue
                    top = number.split(".")[0]
                    detail = (
                        f"the document's clauses stop at {max_clause}"
                        if top.isdigit() and int(top) > max_clause
                        else "no clause carries that number"
                    )
                    report.add(
                        "block-references",
                        where,
                        f"prose says {phrase!r} but {detail}: {here}",
                    )
                    continue
                label = f"Clause {number}"
            _check_trailing_title(page, report, where, phrase, trailing, label)


def _source_says(source: Source | None, text: str, match: re.Match) -> bool:
    """Did the Word source write this same reference, in this same sentence?

    A change history that records the clause numbers of *earlier* editions is
    not making a claim about this document's numbering, and neither is any
    other sentence the conversion copied faithfully.  Renumbering is
    Metanorma's business; reproducing the source is this document's.  So a
    reference the source spells identically, in identical surroundings, is the
    source's statement and not a conversion defect.
    """
    if source is None:
        return False
    window = normalize(
        text[max(0, match.start() - CONTEXT_WINDOW) : match.end() + CONTEXT_WINDOW]
    )
    return source.shows(window)


def _check_trailing_title(
    page: Page,
    report: Report,
    where: str,
    phrase: str,
    trailing: str,
    label: str,
) -> None:
    """Judge a title written beside a number against the title's real owner.

    Only a trailing phrase that is *exactly* some real title in this document
    is judged, which is what makes the check safe: an exact match proves the
    author wrote a title there, and a title belonging to a different number
    proves the number is stale.  A sentence merely continuing, a citation, or a
    title the conversion reworded is left alone.
    """
    if not trailing or not trailing[0].isalnum():
        return  # ") Choice Groups" continues a sentence; it is not a title
    words = title_key(trailing).split()
    for length in range(min(len(words), 20), 1, -1):
        owners = page.title_owner.get(" ".join(words[:length]))
        if not owners:
            continue
        if label in owners:
            return
        spelled = " ".join(normalize(trailing).split()[:length])
        report.add(
            "block-references",
            where,
            f"prose says {phrase!r} followed by the title {spelled!r}, "
            f"but that title belongs to {' and '.join(sorted(set(owners)))}",
        )
        return


def check_xref_kind(page: Page, report: Report) -> None:
    """A cross-reference whose text disagrees with what it points at.

    The old form of this check asked where the target *sat* and predicted the
    label a reference to it would render as.  That prediction was wrong
    whenever the reference carried its own text: the property index links the
    word "bitOrder" to a row of Table 15, and the old check called it a
    reference that "renders as 'Table 15'" when the page has always shown the
    word "bitOrder".  The text is right there on the page, so read it.

    A reference that prints a name is making no claim about numbering.  Only
    one that prints a label - "Table 15", "Figure 3" - claims anything this
    check can test, and what it claims is that the reader lands on that block.
    """
    for node, target, text in page.links():
        spelled = text.strip()
        match = LABEL.match(spelled)
        if match is None:
            continue

        landing = page.anchor_label.get(target)
        if landing is None:
            continue  # a dangling href belongs to link-check.py
        if landing != spelled:
            holder = node.parent if node.parent is not None else node
            report.add(
                "xref-kind",
                page.where(node),
                f"a reference printed as {spelled!r} sends the reader to "
                f"{landing!r}: {page.text_of(holder)[:120]!r}",
            )
            continue

        before = re.search(r"([A-Za-z]+)\W*$", _text_before(page, node))
        if not before:
            continue
        claimed = KIND_WORDS.get(before.group(1).lower())
        printed = match.group("kind")
        if claimed is None or claimed == printed:
            continue
        if claimed == "Clause" and printed == "Annex":
            continue  # an annex is a clause of the document
        holder = node.parent if node.parent is not None else node
        report.add(
            "xref-kind",
            page.where(node),
            f"prose says {before.group(1)!r} before a reference printed as "
            f"{spelled!r}: {page.text_of(holder)[:120]!r}",
        )


def _text_before(page: Page, link: Node) -> str:
    """The rendered text of the enclosing block up to this cross-reference."""
    holder = link.parent
    if holder is None:
        return ""
    pieces: list[str] = []
    found = False

    def walk(current: Node) -> None:
        nonlocal found
        for child in current.children:
            if found:
                return
            if isinstance(child, str):
                pieces.append(child)
                continue
            if child is link:
                found = True
                return
            if child.classes() & DROP_CLASSES or child.tag in ("pre", "aside"):
                continue
            walk(child)

    walk(holder)
    return normalize("".join(pieces))


INTERVAL = re.compile(r"[\d\s.,+-]*")


def unclosed_bracket(text: str) -> int | None:
    """Where a bracket has no partner, ignoring half-open intervals.

    "[0.0, 1.0)" is mathematics, not markup, so a ``[`` closed by ``)`` over
    nothing but digits and separators counts as balanced.
    """
    stack: list[int] = []
    for position, character in enumerate(text):
        if character == "[":
            stack.append(position)
        elif character == "]":
            if stack:
                stack.pop()
            else:
                return position
        elif (
            character == ")"
            and stack
            and INTERVAL.fullmatch(text[stack[-1] + 1 : position])
        ):
            stack.pop()
    return stack[0] if stack else None


def check_markup(page: Page, report: Report, source: Source | None) -> None:
    for node, text in page.prose():
        for name, pattern in LEAKED_MARKUP:
            match = pattern.search(text)
            if match:
                report.add(
                    "markup",
                    page.where(node),
                    f"unparsed AsciiDoc {name} in rendered text: "
                    f"{excerpt(text, match.start(), match.end())}",
                )
        # Bracket balance is only meaningful in prose: the escape-scheme tables
        # use [ and ] as data, and sample data is not markup.
        if node.tag not in ("p", "li") or page.in_table(node):
            continue
        position = unclosed_bracket(text)
        if position is None:
            continue
        if _source_wrote(source, text, position, position + 1):
            continue
        report.add(
            "markup",
            page.where(node),
            f"bracket {text[position]!r} with no partner: "
            f"{excerpt(text, position, position + 1, 60, 30)}",
        )


def _source_wrote(source: Source | None, text: str, start: int, end: int) -> bool:
    """Does the Word source read the same way here?

    This conversion's contract is faithfulness.  A sentence that reads oddly
    in the built document but reads identically in the .docx is reproducing a
    defect of the source, not creating one, and failing the build over it
    would ask the conversion to silently edit the specification.  Such a
    finding belongs in an editorial pass over the Word document, not in a gate
    on the conversion.
    """
    if source is None:
        return False
    window = normalize(text[max(0, start - CONTEXT_WINDOW) : end + CONTEXT_WINDOW])
    return source.shows(window)


def check_degenerate(page: Page, report: Report, source: Source | None) -> None:
    for node, text in page.prose():
        in_table = page.in_table(node)
        for name, pattern, prose_only in DEGENERATE:
            if prose_only and in_table:
                continue
            for match in pattern.finditer(text):
                if _source_wrote(source, text, match.start(), match.end()):
                    continue
                report.add(
                    "degenerate",
                    page.where(node),
                    f"{name}: {excerpt(text, match.start(), match.end(), 60, 40)}",
                )


def check_source_visibility(page: Page, report: Report, source: Source) -> None:
    """Text hidden in Word that is now published.

    A phrase is only reported where the built document prints it *more* often
    than the source shows it.  The same editorial note can be hidden in one
    place and visible in another; publishing the visible one is faithful, and
    an earlier version of this check - which asked only whether the phrase
    occurred anywhere - reported exactly that as a defect.
    """
    printed: dict[str, list[tuple[Node, str]]] = {}
    blocks = list(page.prose())
    for phrase in source.hidden_phrases:
        hits = [(node, text) for node, text in blocks if phrase in text]
        if not hits:
            continue
        occurrences = sum(text.count(phrase) for _, text in hits)
        if occurrences <= source.count_visible(phrase):
            continue  # the source shows this text too; publishing it is faithful
        printed[phrase] = hits

    reported: set[int] = set()
    for phrase, hits in printed.items():
        fresh = [(n, t) for n, t in hits if id(n) not in reported]
        if not fresh:
            continue
        node = fresh[0][0]
        for other, _ in fresh:
            reported.add(id(other))
        kind = "a heading" if node.tag.startswith("h") else "body text"
        elsewhere = (
            f" (and in {len(fresh) - 1} other block(s))" if len(fresh) > 1 else ""
        )
        report.add(
            "source-visibility",
            page.where(node),
            f"{len(phrase.split())} word(s) hidden in the Word source "
            f"(w:vanish) are published as {kind}{elsewhere}: {phrase[:100]!r}",
        )


# -- driver ----------------------------------------------------------------

CHECKS = (
    ("captions", "every cited block prints a title", check_captions),
    ("orphans", "no caption is stranded as a body paragraph", check_orphan_captions),
    ("double-numbering", "no caption carries two numbers", check_double_numbering),
    ("numbering", "no two blocks print the same label", check_numbering),
    ("xref-kind", "cross-references land where their text says", check_xref_kind),
)

SOURCE_CHECKS = (
    (
        "block-references",
        "'Figure N' and friends name what they claim",
        check_block_references,
    ),
    ("markup", "no AsciiDoc survives into rendered text", check_markup),
    ("degenerate", "no field or reference resolved to nothing", check_degenerate),
)

VISIBILITY = (
    "source-visibility",
    "no text hidden in the Word source is published",
)


DEFAULT_SOURCE = "docs/current/draft-gwdrp-dfdl-v1.2.2-GFD-R-P.240-ISO-23415.docx"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument(
        "html", type=Path, help="the rendered document (build/*/dfdl.html)"
    )
    parser.add_argument(
        "docx",
        type=Path,
        nargs="?",
        help="the Word source, to tell a faithful copy from a conversion defect",
    )
    parser.add_argument(
        "--limit",
        type=int,
        default=10,
        help="findings shown per check before the rest are counted (0 for all)",
    )
    args = parser.parse_args(argv)

    # The Makefile hands every validator the semantic XML; the rendered page
    # sits beside it and is what this tool reads.
    if args.html.suffix == ".xml":
        args.html = args.html.with_suffix(".html")
    if args.docx is None:
        default = Path(DEFAULT_SOURCE)
        if default.exists():
            args.docx = default

    if not args.html.exists():
        print(f"ERROR: {args.html} does not exist.", file=sys.stderr)
        return 2
    if args.docx is not None and not args.docx.exists():
        print(f"ERROR: {args.docx} does not exist.", file=sys.stderr)
        return 2

    page = Page(args.html.read_text(encoding="utf-8", errors="replace"))
    source = Source(args.docx) if args.docx else None
    report = Report()

    tables = sum(1 for b in page.blocks if b.kind == "Table")
    figures = [b for b in page.blocks if b.kind == "Figure"]
    listings = sum(1 for n in page.root.iter() if "sourcecode" in n.classes())
    print(f"Structure check of {args.html}")
    print(
        f"{len(page.clause_title)} numbered clause(s), "
        f"{tables} numbered table(s), "
        f"{len(figures)} numbered figure(s), "
        f"{listings} code listing(s) of which "
        f"{sum(1 for b in figures if b.is_listing)} are numbered."
    )

    for _, _, function in CHECKS:
        function(page, report)
    for _, _, function in SOURCE_CHECKS:
        function(page, report, source)

    if source is None:
        report.note(
            "No Word source was given.  'source-visibility' did not run, and "
            "'degenerate', 'markup' and 'block-references' could not tell a "
            "sentence this conversion broke from one the .docx reads the same "
            "way; pass the .docx as a second argument to make them exact."
        )
    else:
        check_source_visibility(page, report, source)

    titles = {name: title for name, title, _ in CHECKS + SOURCE_CHECKS}
    titles[VISIBILITY[0]] = VISIBILITY[1]
    order = [name for name, _, _ in CHECKS + SOURCE_CHECKS] + [VISIBILITY[0]]

    for name in order:
        findings = report.findings.get(name)
        if not findings:
            continue
        print(f"\n{name}: {len(findings)} finding(s) - {titles[name]}")
        shown = findings if args.limit == 0 else findings[: args.limit]
        for where, message in shown:
            print(f"  {where:<14} {message}")
        if len(findings) > len(shown):
            print(f"  {'':<14} ... and {len(findings) - len(shown)} more")

    for note in report.notes:
        print(f"\nNOTE: {note}")

    print()
    total = report.total()
    if total:
        clean = [n for n in order if not report.findings.get(n)]
        if clean:
            print(f"Clean: {', '.join(clean)}.")
        print(
            f"RESULT: FAIL - {total} structural defect(s) "
            f"across {len(report.findings)} check(s)."
        )
        return 1
    print("RESULT: PASS - every structural invariant holds.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
