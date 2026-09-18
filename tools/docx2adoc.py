"""Convert the DFDL specification MS-Word source into AsciiDoc for Metanorma.

The specification is authored in Word.  This script reads the .docx package
directly (it is a zip of XML parts) and emits AsciiDoc suitable for Metanorma's
ISO backend, one file per top-level clause.

Clauses are addressed by the specification's own numbering, which the tool
reconstructs from Word's heading numbering: ``front`` for the ten unnumbered
front-matter headings, ``1``..``29`` for the numbered clauses, and ``A``..``G``
for the appendices.

Usage:

    python3 tools/docx2adoc.py --list
    python3 tools/docx2adoc.py --clause 13 --out spec/clauses/13-simple-types.adoc
    python3 tools/docx2adoc.py --clause C --out spec/clauses/C-string-literals.adoc
    python3 tools/docx2adoc.py --all --outdir spec/clauses/

Only the Python standard library is used.

The script deliberately carries no shebang and is not executable: ``make
check`` runs every executable in tools/ as a validator against the built
semantic XML, and this is a conversion utility, not a validator.
"""

from __future__ import annotations

import argparse
import re
import sys
import unicodedata
import xml.etree.ElementTree as ET
import zipfile
from dataclasses import dataclass, field
from pathlib import Path

# --------------------------------------------------------------------------
# OOXML namespaces
# --------------------------------------------------------------------------

NS = {
    "w": "http://schemas.openxmlformats.org/wordprocessingml/2006/main",
    "r": "http://schemas.openxmlformats.org/officeDocument/2006/relationships",
    "a": "http://schemas.openxmlformats.org/drawingml/2006/main",
    "asvg": "http://schemas.microsoft.com/office/drawing/2016/SVG/main",
}


def q(prefix: str, tag: str) -> str:
    """Return a Clark-notation qualified name, e.g. q("w", "p")."""
    return f"{{{NS[prefix]}}}{tag}"


W_P = q("w", "p")
W_TBL = q("w", "tbl")
W_TR = q("w", "tr")
W_TC = q("w", "tc")
W_VAL = q("w", "val")

# --------------------------------------------------------------------------
# Style tables
# --------------------------------------------------------------------------

#: Paragraph styles dropped outright; Metanorma builds its own table of contents.
DROP_STYLES = {
    "TOC1",
    "TOC2",
    "TOC3",
    "TOC4",
    "TOC5",
    "TOC6",
    "TOC7",
    "TOC8",
    "TOC9",
    "TOCHeading",
    "TableofFigures",
    "Index1",
    "Index2",
    "Index3",
}

#: Paragraph styles rendered as verbatim listing blocks, mapped to a language.
CODE_STYLES = {
    "Codeblock0": "xml",
    "CodeBlock": "xml",
    "Code": "xml",
    "XMLexample": "xml",
    "XMLExcerpt": "xml",
    "HTMLPreformatted": "",
    "dataexample": "",
}

#: Paragraph styles that mark a list item even without explicit numbering.
LIST_STYLES = {"ListParagraph", "ListBullet", "ListNumber", "List", "BulletList"}

#: Paragraph styles that carry the caption of the table or figure beside them.
CAPTION_STYLES = {"Caption", "TableCaption", "FigureCaption", "TableTitle"}

#: Run styles rendered as inline monospace.
CODE_RUN_STYLES = {"CodeCharacter", "SourceText", "CodeblockChar0", "HTMLCode"}

#: Run styles rendered as italic / bold.
ITALIC_RUN_STYLES = {"Emphasis", "XMLExcerptEmphasis"}
BOLD_RUN_STYLES = {"Strong"}

#: Word numbering formats that mean "ordered list".
ORDERED_FORMATS = {
    "decimal",
    "lowerLetter",
    "upperLetter",
    "lowerRoman",
    "upperRoman",
    "ordinal",
}

# --------------------------------------------------------------------------
# Text normalisation
# --------------------------------------------------------------------------

#: Word's typographic characters, mapped to something unambiguous in AsciiDoc.
CHAR_MAP = {
    "\u2018": "'",
    "\u2019": "'",
    "\u201a": "'",
    "\u201b": "'",
    "\u201c": '"',
    "\u201d": '"',
    "\u201e": '"',
    "\u00a0": " ",  # non-breaking space
    "\u202f": " ",  # narrow no-break space
    "\u2011": "-",  # non-breaking hyphen
    "\u00ad": "",  # soft hyphen
    "\ufeff": "",
    "\u2028": " ",
    "\u2029": " ",
}

#: Line-initial markers that would otherwise be read as AsciiDoc block syntax.
BLOCK_START_RE = re.compile(
    r"""^(
          \.[^\s.]      # block title
        | [*.-]\ +      # list item
        | =+\ +         # section title
        | //            # comment
        | \|            # table cell
        | \[(?!\[)      # block attribute list
        | :\S+:         # attribute entry
        | \+$           # list continuation
        | ={4,}$|-{4,}$|\.{4,}$|_{4,}$|\*{4,}$   # block delimiter
    )""",
    re.VERBOSE,
)

#: `{word}` looks like an AsciiDoc attribute reference and must be escaped.
ATTR_REF_RE = re.compile(r"\{([A-Za-z0-9_][A-Za-z0-9_-]*)\}")

#: A plus sign on its own, which pairs with the next one into a passthrough
#: and takes the text between them with it.
LONE_PLUS_RE = re.compile(r"(?<![\w+])\+(?![\w+])")

#: Constrained inline formatting pairs that we want rendered literally.
CONSTRAINED_PAIRS = [
    re.compile(r"(?<![\w\\])(\*)(\S(?:[^*\n]*\S)?)(\*)(?!\w)"),
    re.compile(r"(?<![\w\\])(_)(\S(?:[^_\n]*\S)?)(_)(?!\w)"),
]

PRIVATE_USE_RE = re.compile(r"[\ue000-\uf8ff]")

# --------------------------------------------------------------------------
# Protecting technical text
#
# Prose reaches the reader through two rewriting passes, and normative text
# has to survive both.  AsciiDoc reads `#` as highlight markup, `(((` as an
# index term and `*`/`_` as formatting; Metanorma then "smart formats" the
# resulting XML, turning `0x55` into 0\u00d755, ` - ` into an em dash, `<=` into
# \u21d0, `...` into \u2026 and decoding `&apos;` to a bare quote.
#
# Only two contexts escape both passes: Metanorma's straightquotes
# passthrough, which leaves the text plain, and a monospace span whose body
# is an AsciiDoc passthrough, since `tt` is exempt from the smart formatter.
# Neither can be applied wholesale without disabling legitimate formatting,
# so the individual hazardous sequences are found and wrapped one by one.
# --------------------------------------------------------------------------

#: Sequences that one of the two passes would rewrite if left unprotected.
HAZARD_RE = re.compile(
    r"""
      (?P<entity> &(?:[A-Za-z][A-Za-z0-9]{1,9}|\#[0-9]{1,6}|\#[xX][0-9A-Fa-f]{1,5}); )
    | (?P<hash> [^\s"'()\[\]]*\#[^\s"'()\[\]]* )   # AsciiDoc highlight markup
    | (?P<hex> \b0[xX][0-9A-Fa-f]+ )               # 0x55 -> 0\u00d755
    | (?P<arrow> <-{1,2}|<={1,2}|-{1,2}>|={1,2}> )  # -> => <- <= and doubles
    | (?P<ellipsis> \.{3,} )                       # ... -> \u2026
    | (?P<emdash> -{2,} )                          # -- -> \u2014, ---- -> \u2014\u2014
    | (?P<index> \({3}|\){3} )                     # (((term))) index macro
    | (?P<symbol> \w*\((?:[CcRr]|TM|tm)\) )        # (C) -> \u00a9, ICU(R) -> ICU\u00ae
    """,
    re.VERBOSE,
)

#: A URL, where a `#` is a fragment marker that AsciiDoc already respects.
URL_RE = re.compile(r"\b(?:https?|ftp|mailto):[^\s\[\]]+")

#: A link or image macro that has just been emitted, and whose closing
#: bracket the next span would run into.
MACRO_END_RE = re.compile(r"\b(?:link|mailto|image):\S*\[[^\]]*\]$")

#: A spaced hyphen, plus the brackets needed to tell an operator from prose.
ARITH_DASH_RE = re.compile(r"""[()\[\]]|(?<=[\w)\]'"]) (-{1,2}) (?=[\w(\['"])""")

#: The wrappers emitted below, so that later passes can leave them alone.
PROTECTED_RE = re.compile(
    r"pass-format:straightquotes\[(?:\\.|[^\]])*\]" r"|`{1,2}\+{2,3}.*?\+{2,3}`{1,2}"
)


def xml_escape(text: str) -> str:
    """Escape the three characters that may not appear raw in Metanorma XML."""
    return text.replace("&", "&amp;").replace("<", "&lt;").replace(">", "&gt;")


#: The curly pair Metanorma would have made of each straight quote.
QUOTE_PAIRS = {"'": ("\u2018", "\u2019"), '"': ("\u201c", "\u201d")}


def needs_monospace(token: str) -> bool:
    """True for text a straightquotes passthrough cannot carry intact."""
    return "&" in token or "|" in token


def protect(token: str) -> str:
    """Wrap one hazardous sequence so that neither pass can rewrite it.

    Entity notation has to survive Metanorma decoding ``&apos;`` back to a
    quote, which only a monospace span does; the same span is the safest
    home for anything holding a cell separator.  Everything else keeps its
    ordinary prose appearance inside a straightquotes passthrough.
    """
    if needs_monospace(token):
        return code_passthrough(token)
    escaped = token.replace("]", "\\]")
    return f"pass-format:straightquotes[{escaped}]"


def code_passthrough(text: str, tight: bool = True) -> str:
    """Render text verbatim as monospace, immune to both rewriting passes."""
    mark = "``" if tight else "`"
    # An entity has to be escaped by hand and passed through untouched:
    # AsciiDoc's own escaping rewrites `&apos;` as a numeric character
    # reference, which is the very notation the text is talking about.
    plussed = text.startswith("+") or text.endswith("+") or "++" in text
    if "&" not in text and not plussed:
        return f"{mark}++{text}++{mark}"
    # Nothing is substituted inside a raw passthrough, so a plus sign that
    # would otherwise run into the delimiter is written as a reference.
    body = xml_escape(text).replace("+", "&#43;")
    return f"{mark}+++{body}+++{mark}"


def hazard_spans(text: str) -> list:
    """Locate every sequence in ``text`` that has to be protected."""
    spans = [match.span() for match in HAZARD_RE.finditer(text) if match.group()]
    spans.extend(arith_dash_spans(text))
    for pattern in CONSTRAINED_PAIRS:
        for match in pattern.finditer(text):
            spans.append(match.span(1))
            spans.append(match.span(3))
    spans.sort()
    urls = [match.span() for match in URL_RE.finditer(text)]
    out = []
    for start, end in spans:
        if out and start < out[-1][1]:
            continue
        # A link macro carries its own quoting; protecting part of one only
        # breaks the macro apart.
        if any(low < end and start < high for low, high in urls):
            continue
        out.append((start, end))
    return out


def arith_dash_spans(text: str) -> list:
    """Spaced hyphens that are subtraction rather than an em dash.

    Metanorma rewrites every ``a - b`` to an em dash, which is right for the
    glossary's "term - definition" lines and wrong inside a formula.  A
    bracketed context, two numeric operands, or an operand that no English
    sentence could hold mark out the arithmetic ones.
    """
    spans = []
    depth = 0
    for match in ARITH_DASH_RE.finditer(text):
        token = match.group()
        if token in "([":
            depth += 1
        elif token in ")]":
            depth = max(0, depth - 1)
        elif depth or is_operator_context(text, match.start(), match.end()):
            spans.append(match.span(1))
    return spans


def is_operator_context(text: str, start: int, end: int) -> bool:
    """True if the operands either side of a spaced hyphen are not prose."""
    before = text[:start].rsplit(" ", 1)[-1]
    after = text[end:].split(" ", 1)[0]
    if before[-1:].isdigit() and after[:1].isdigit():
        return True
    return any(mark in before + after for mark in ("\\", ".."))


#: Heading 1 titles that open an appendix, e.g. "Appendix C: ...".
APPENDIX_RE = re.compile(r"^\s*(?:Appendix|Annex)\s+([A-Z])\b[.:]?")

#: Key used for the Heading 1 clauses that carry no clause number.
FRONT_MATTER = "front"


def normalise_text(text: str) -> str:
    """Apply the character substitutions that are safe everywhere."""
    for src, dst in CHAR_MAP.items():
        text = text.replace(src, dst)
    return PRIVATE_USE_RE.sub("", text)


def escape_plain(text: str) -> str:
    """Neutralise the inline markup that a backslash is enough to disarm."""
    text = text.replace("`", "\\`")
    text = ATTR_REF_RE.sub(r"\\{\1}", text)
    text = LONE_PLUS_RE.sub("{plus}", text)
    return text.replace("<<", "\\<<")


def escape_inline(text: str) -> str:
    """Escape AsciiDoc inline syntax in text that came from plain Word runs.

    Sequences that survive a backslash, or that Metanorma rewrites after
    AsciiDoc has finished, are wrapped in a passthrough instead; the rest of
    the run is left alone so that legitimate formatting still applies.
    """
    out = []
    position = 0
    for start, end in hazard_spans(text):
        quote = text[start - 1 : start]
        # A literal in quotation marks loses the pairing of those marks to
        # the passthrough that now sits between them, so the pair is taken
        # inside it and curled here instead.
        if (
            start > position
            and quote in QUOTE_PAIRS
            and text[end : end + 1] == quote
            and not needs_monospace(text[start:end])
        ):
            opening, closing = QUOTE_PAIRS[quote]
            out.append(escape_plain(text[position : start - 1]))
            out.append(protect(opening + text[start:end] + closing))
            position = end + 1
            continue
        out.append(escape_plain(text[position:start]))
        out.append(protect(text[start:end]))
        position = end
    out.append(escape_plain(text[position:]))
    return "".join(out)


def protect_line_start(line: str) -> str:
    """Stop a paragraph's first characters being read as block syntax."""
    if BLOCK_START_RE.match(line):
        return "{empty}" + line
    return line


def code_span(text: str) -> str:
    """Render text as an inline monospace span.

    Monospace is not verbatim in AsciiDoc: the body is still substituted, so
    a regular expression inside one loses to the index-term macro and a hex
    literal to Metanorma's multiplication sign.  The body therefore always
    goes through a passthrough.
    """
    if not text:
        return ""
    # The unconstrained delimiter fires everywhere, including next to the
    # quotation marks that surround most of the literals in this document.
    return code_passthrough(text)


def unspaced(text: str) -> str:
    """Escape a super/subscript body, whose delimiters cannot span a space."""
    return escape_inline(text).replace(" ", "{nbsp}")


def emphasis(text: str, mark: str, tight: bool = False) -> str:
    """Wrap text in an italic or bold pair, doubled when it abuts a word."""
    pair = mark * 2 if tight else mark
    return f"{pair}{escape_inline(text)}{pair}"


def slugify(text: str, fallback: str = "id") -> str:
    """Turn arbitrary text into a valid, readable AsciiDoc identifier."""
    text = normalise_text(text)
    text = unicodedata.normalize("NFKD", text)
    text = text.encode("ascii", "ignore").decode("ascii")
    text = re.sub(r"[^A-Za-z0-9]+", "-", text).strip("-").lower()
    text = re.sub(r"-{2,}", "-", text)
    if len(text) > 60:
        text = text[:60].rstrip("-")
    if not text:
        text = fallback
    if not text[0].isalpha():
        text = "x-" + text
    return text


# --------------------------------------------------------------------------
# Package access
# --------------------------------------------------------------------------


class Package:
    """Read-only view of the parts of a .docx that this converter needs."""

    def __init__(self, path: Path):
        self.path = path
        self.zip = zipfile.ZipFile(path)
        self.document = self._parse("word/document.xml")
        self.styles = self._parse("word/styles.xml")
        self.numbering = self._parse_optional("word/numbering.xml")
        self.footnotes = self._parse_optional("word/footnotes.xml")
        self.rels = self._read_rels("word/_rels/document.xml.rels")

    def _parse(self, name: str) -> ET.Element:
        with self.zip.open(name) as handle:
            return ET.parse(handle).getroot()

    def _parse_optional(self, name: str):
        try:
            return self._parse(name)
        except KeyError:
            return None

    def _read_rels(self, name: str) -> dict:
        root = self._parse(name)
        rels = {}
        for rel in root:
            rels[rel.get("Id")] = (rel.get("Target"), rel.get("TargetMode", "Internal"))
        return rels

    def media(self, target: str) -> bytes:
        return self.zip.read("word/" + target.lstrip("/"))

    def table_styles_with_header(self) -> set:
        """Style ids whose definition formats the first row differently."""
        result = set()
        for style in self.styles.findall(q("w", "style")):
            if style.get(q("w", "type")) != "table":
                continue
            for spr in style.findall(q("w", "tblStylePr")):
                if spr.get(q("w", "type")) == "firstRow":
                    result.add(style.get(q("w", "styleId")))
        return result


class Numbering:
    """Resolve a (numId, ilvl) pair to 'ordered' or 'bullet'."""

    def __init__(self, root):
        self.levels = {}
        self.num_to_abstract = {}
        if root is None:
            return
        for abstract in root.findall(q("w", "abstractNum")):
            aid = abstract.get(q("w", "abstractNumId"))
            for lvl in abstract.findall(q("w", "lvl")):
                fmt = lvl.find(q("w", "numFmt"))
                self.levels[(aid, lvl.get(q("w", "ilvl")))] = (
                    fmt.get(W_VAL) if fmt is not None else None
                )
        for num in root.findall(q("w", "num")):
            abstract = num.find(q("w", "abstractNumId"))
            if abstract is not None:
                self.num_to_abstract[num.get(q("w", "numId"))] = abstract.get(W_VAL)

    def kind(self, num_id: str, ilvl: str) -> str:
        aid = self.num_to_abstract.get(num_id)
        fmt = self.levels.get((aid, ilvl))
        return "ordered" if fmt in ORDERED_FORMATS else "bullet"


# --------------------------------------------------------------------------
# Document model helpers
# --------------------------------------------------------------------------


def para_style(para) -> str:
    pPr = para.find(q("w", "pPr"))
    if pPr is None:
        return ""
    style = pPr.find(q("w", "pStyle"))
    return style.get(W_VAL) if style is not None else ""


def heading_level(style: str):
    """Return the AsciiDoc nesting level for a Word heading style, else None."""
    match = re.fullmatch(r"Heading([1-9])", style)
    if match:
        return int(match.group(1))
    if style == "AppendixH1":
        return 1
    return None


def word_numbered(para) -> bool:
    """True unless the paragraph explicitly switches its style numbering off.

    The front matter uses the Heading 1 style with ``numId`` 0, which is how
    Word suppresses the clause number.
    """
    pPr = para.find(q("w", "pPr"))
    if pPr is None:
        return True
    numPr = pPr.find(q("w", "numPr"))
    if numPr is None:
        return True
    num_id = numPr.find(q("w", "numId"))
    return not (num_id is not None and num_id.get(W_VAL) == "0")


def numbering_of(para):
    """Return (numId, ilvl) for a numbered paragraph, else None."""
    pPr = para.find(q("w", "pPr"))
    if pPr is None:
        return None
    numPr = pPr.find(q("w", "numPr"))
    if numPr is None:
        return None
    num_id = numPr.find(q("w", "numId"))
    ilvl = numPr.find(q("w", "ilvl"))
    if num_id is None or num_id.get(W_VAL) == "0":
        return None
    return (num_id.get(W_VAL), ilvl.get(W_VAL) if ilvl is not None else "0")


def is_list_para(para) -> bool:
    return numbering_of(para) is not None or para_style(para) in LIST_STYLES


def is_hidden(run) -> bool:
    """True for a run Word hides.

    The specification is written with the editors' notes to each other in
    hidden text, so that the working copy carries them and the published
    document does not.
    """
    rPr = run.find(q("w", "rPr"))
    if rPr is None:
        return False
    vanish = rPr.find(q("w", "vanish"))
    return vanish is not None and vanish.get(W_VAL) not in ("0", "false")


def run_text(run) -> str:
    """The literal text of one run, ignoring deletions."""
    parts = []
    for node in run:
        if node.tag == q("w", "t"):
            parts.append(node.text or "")
        elif node.tag == q("w", "tab"):
            parts.append(" ")
    return "".join(parts)


def raw_text(elem) -> str:
    """All visible literal text under an element, ignoring deletions."""
    parts = [run_text(run) for run in elem.iter(q("w", "r")) if not is_hidden(run)]
    return normalise_text("".join(parts))


def hidden_comment(para) -> list:
    """The hidden text of a paragraph, as AsciiDoc comment lines."""
    parts = [run_text(run) for run in para.iter(q("w", "r")) if is_hidden(run)]
    text = " ".join(normalise_text("".join(parts)).split())
    return [f"// {text}"] if text else []


# --------------------------------------------------------------------------
# Anchors
# --------------------------------------------------------------------------


@dataclass
class Anchor:
    """A Word bookmark that survives into the AsciiDoc output."""

    name: str
    ident: str
    clause: int
    block_level: bool  # sits on a heading or caption, so it becomes a block id
    level: int = 0  # heading level, when it sits on a heading


class AnchorIndex:
    """Assign readable AsciiDoc ids to the Word bookmarks worth keeping."""

    def __init__(self, body, clause_of_block):
        self.by_name = {}
        self.referenced = set()
        self._collect_references(body)
        self._assign(body, clause_of_block)

    def _collect_references(self, body):
        for node in body.iter():
            if node.tag == q("w", "instrText"):
                match = re.search(r"\bREF\s+(\S+)", node.text or "")
                if match:
                    self.referenced.add(match.group(1))
            elif node.tag == q("w", "hyperlink"):
                anchor = node.get(q("w", "anchor"))
                if anchor:
                    self.referenced.add(anchor)

    def _wanted(self, name: str) -> bool:
        if name.startswith("_Toc"):
            return False
        return name in self.referenced or not name.startswith("_")

    def _assign(self, body, clause_of_block):
        used = set()
        pending = []  # bookmarks seen between blocks, attached to the next one
        for index, block in enumerate(body):
            clause = clause_of_block.get(index, 0)
            if block.tag == q("w", "bookmarkStart"):
                pending.append(block.get(q("w", "name")))
                continue
            if block.tag not in (W_P, W_TBL):
                continue
            for para in [block] if block.tag == W_P else block.iter(W_P):
                style = para_style(para)
                level = heading_level(style)
                block_level = level is not None or style in CAPTION_STYLES
                names = pending + [
                    b.get(q("w", "name")) for b in para.iter(q("w", "bookmarkStart"))
                ]
                pending = []
                shared = None
                for name in names:
                    if not name or not self._wanted(name):
                        continue
                    if block_level and shared is not None:
                        self.by_name[name] = self.by_name[shared]
                        continue
                    base = (
                        slugify(strip_caption_number(raw_text(para).strip()))
                        if block_level
                        else slugify(name.lstrip("_"))
                    )
                    ident = base
                    suffix = 2
                    while ident in used:
                        ident = f"{base}-{suffix}"
                        suffix += 1
                    used.add(ident)
                    self.by_name[name] = Anchor(
                        name, ident, clause, block_level, level or 0
                    )
                    if block_level:
                        shared = name

    def lookup(self, name: str):
        return self.by_name.get(name)


# --------------------------------------------------------------------------
# Conversion
# --------------------------------------------------------------------------


@dataclass
class Caption:
    """The caption paragraph Word places after the block it names."""

    title: str = ""
    anchors: tuple = ()
    comments: list = field(default_factory=list)
    consumed: int = 0


@dataclass
class Clause:
    """One top-level (Heading 1) clause of the specification.

    ``key`` is the specification's own identifier for the clause: ``front``
    for the unnumbered front matter, ``"1"``..``"29"`` for the numbered
    clauses, and ``"A"``..``"G"`` for the appendices.
    """

    key: str
    ordinal: int  # position within its group, used only for file names
    title: str
    start: int
    end: int = 0
    blocks: list = field(default_factory=list)

    @property
    def is_front(self) -> bool:
        return self.key == FRONT_MATTER

    @property
    def is_annex(self) -> bool:
        return len(self.key) == 1 and self.key.isalpha()


class Converter:
    def __init__(self, package: Package, image_dir: Path, image_prefix: str = "images"):
        self.pkg = package
        self.body = package.document[0]
        self.numbering = Numbering(package.numbering)
        self.header_styles = package.table_styles_with_header()
        self.image_dir = image_dir
        self.image_prefix = image_prefix
        self.footnote_text = self._load_footnotes()
        self.clauses = self._split_clauses()
        clause_of_block = {}
        for clause in self.clauses:
            for index in range(clause.start, clause.end):
                clause_of_block[index] = clause.key
        self.anchors = AnchorIndex(self.body, clause_of_block)
        self.self_labelling = {
            anchor.ident
            for anchor in self.anchors.by_name.values()
            if anchor.level == 1
        }
        self.emitted_clauses = set()
        self.current = None
        self.cell_depth = 0
        self.pending_footnotes = []
        self.extracted_images = []

    # -- setup ------------------------------------------------------------

    def _load_footnotes(self) -> dict:
        notes = {}
        if self.pkg.footnotes is None:
            return notes
        for note in self.pkg.footnotes:
            note_id = note.get(q("w", "id"))
            if note.get(q("w", "type")) in ("separator", "continuationSeparator"):
                continue
            notes[note_id] = note
        return notes

    def _split_clauses(self) -> list:
        """Cut the body at every Heading 1 and label each piece.

        Word numbers the headings itself, and turns numbering off for the
        front matter, so the specification's own clause numbers have to be
        reconstructed: front matter, then 1..n, then the lettered appendices.
        """
        clauses = []
        counter = 0
        front = 0
        first = next(
            (
                index
                for index, block in enumerate(self.body)
                if block.tag == W_P and heading_level(para_style(block)) == 1
            ),
            0,
        )
        if first:
            # Title page, copyright and abstract sit before the first heading.
            front += 1
            clauses.append(Clause(FRONT_MATTER, front, "Preamble", 0))
        for index, block in enumerate(self.body):
            if block.tag != W_P or heading_level(para_style(block)) != 1:
                continue
            title = raw_text(block).strip()
            letter = APPENDIX_RE.match(title)
            if letter:
                key, ordinal = letter.group(1), 0
            elif not word_numbered(block):
                front += 1
                key, ordinal = FRONT_MATTER, front
            else:
                counter += 1
                key, ordinal = str(counter), counter
            clauses.append(Clause(key, ordinal, title, index))
        blocks = list(self.body)
        for position, clause in enumerate(clauses):
            clause.end = (
                clauses[position + 1].start
                if position + 1 < len(clauses)
                else len(blocks)
            )
            clause.blocks = blocks[clause.start : clause.end]
        return clauses

    def find(self, key: str):
        """All clauses selected by a key: one clause, or the front matter."""
        wanted = key.strip().upper() if len(key.strip()) == 1 else key.strip().lower()
        return [
            clause for clause in self.clauses if clause.key.lower() == wanted.lower()
        ]

    # -- inline rendering -------------------------------------------------

    def render_inline(self, container) -> str:
        """Render the runs of a paragraph (or hyperlink) to AsciiDoc text."""
        segments = []
        self._render_children(container, segments, [])
        text = collapse_duplicate_xrefs(self._join_segments(segments))
        return self._drop_doubled_labels(text)

    def _drop_doubled_labels(self, text: str) -> str:
        """Drop the word Word puts in front of a reference that labels itself.

        Metanorma writes a reference to a top-level clause as "Clause 11" and
        one to a subclause as "12.1.2", so Word's own "Section" is said twice
        in front of the first and not at all in front of the second.
        """

        def drop(match):
            return "" if match.group("id") in self.self_labelling else match.group()

        return SECTION_LABEL_RE.sub(drop, text)

    def _join_segments(self, segments, plain=False) -> str:
        """Merge adjacent same-format segments, then apply inline markup."""
        if plain:
            segments = [
                (kind if kind == "raw" else "plain", text) for kind, text in segments
            ]
        merged = []
        for kind, text in segments:
            if merged and merged[-1][0] == kind and kind != "raw":
                merged[-1] = (kind, merged[-1][1] + text)
            else:
                merged.append((kind, text))
        out = []
        for position, (kind, text) in enumerate(merged):
            before = "".join(out)
            after = merged[position + 1][1] if position + 1 < len(merged) else ""
            # Constrained formatting only fires at word boundaries, so a span
            # that starts or ends mid-word needs the doubled delimiter.
            tight = (
                text[:1].strip() != ""
                and (before[-1:].isalnum() or before.endswith(">>"))
            ) or (
                text[-1:].strip() != "" and (after[:1].isalnum() or after[:2] == "<<")
            )
            if kind == "raw" or not text.strip():
                out.append(text)
                continue
            # Padding has to sit outside the delimiters, or the constrained
            # form does not fire at all.
            body = text.strip()
            lead = text[: len(text) - len(text.lstrip())]
            trail = text[len(text.rstrip()) :]
            if kind == "code":
                marked = code_span(body)
            elif kind == "italic":
                marked = emphasis(body, "_", tight)
            elif kind == "bold":
                marked = emphasis(body, "*", tight)
            elif kind == "superscript":
                marked = f"^{unspaced(body)}^"
            elif kind == "subscript":
                marked = f"~{unspaced(body)}~"
            else:
                out.append(escape_inline(text))
                continue
            # A link's closing bracket runs into the delimiter that follows
            # it and AsciiDoc then reads neither; {empty} parts them without
            # putting anything between them.
            if not lead and MACRO_END_RE.search(before):
                lead = "{empty}"
            out.append(lead + marked + trail)
        return "".join(out)

    def _render_children(self, container, segments, field_stack):
        for child in container:
            tag = child.tag
            if tag == q("w", "r"):
                self._render_run(child, segments, field_stack)
            elif tag == q("w", "hyperlink"):
                self._render_hyperlink(child, segments, field_stack)
            elif tag == q("w", "ins"):
                self._render_children(child, segments, field_stack)
            elif tag == q("w", "del"):
                continue
            elif tag in (q("w", "smartTag"), q("w", "sdtContent"), q("w", "sdt")):
                self._render_children(child, segments, field_stack)
            elif tag == q("w", "fldSimple"):
                inner = []
                self._render_children(child, inner, field_stack)
                self._emit(
                    segments,
                    field_stack,
                    self._resolve_field(child.get(q("w", "instr")) or "", inner),
                    raw=True,
                )
            elif tag == q("w", "bookmarkStart"):
                self._render_bookmark(child, segments, field_stack)

    def _render_bookmark(self, node, segments, field_stack):
        anchor = self.anchors.lookup(node.get(q("w", "name")) or "")
        if anchor and not anchor.block_level and anchor.clause in self.emitted_clauses:
            self._emit(segments, field_stack, f"[[{anchor.ident}]]", raw=True)

    def _emit(self, segments, field_stack, text, raw=False, kind="plain"):
        if not text:
            return
        if field_stack:
            top = field_stack[-1]
            if top["state"] == "result":
                top["result"].append(("raw" if raw else kind, text))
            return
        segments.append(("raw" if raw else kind, text))

    def _render_run(self, run, segments, field_stack):
        if is_hidden(run):
            return
        rPr = run.find(q("w", "rPr"))
        kind = "plain"
        if rPr is not None:
            rstyle = rPr.find(q("w", "rStyle"))
            style = rstyle.get(W_VAL) if rstyle is not None else ""
            vert = rPr.find(q("w", "vertAlign"))
            vert = vert.get(W_VAL) if vert is not None else None
            if vert in ("superscript", "subscript"):
                kind = vert
            elif style in CODE_RUN_STYLES:
                kind = "code"
            elif style in BOLD_RUN_STYLES or rPr.find(q("w", "b")) is not None:
                kind = "bold"
            elif style in ITALIC_RUN_STYLES or rPr.find(q("w", "i")) is not None:
                kind = "italic"
        for node in run:
            tag = node.tag
            if tag == q("w", "t"):
                self._emit(
                    segments, field_stack, normalise_text(node.text or ""), kind=kind
                )
            elif tag == q("w", "tab") or tag in (q("w", "br"), q("w", "cr")):
                self._emit(segments, field_stack, " ", kind=kind)
            elif tag == q("w", "noBreakHyphen"):
                self._emit(segments, field_stack, "-", kind=kind)
            elif tag == q("w", "footnoteReference"):
                self._emit(segments, field_stack, self._render_footnote(node), raw=True)
            elif tag == q("w", "drawing"):
                self._emit(segments, field_stack, self._render_drawing(node), raw=True)
            elif tag == q("w", "fldChar"):
                self._handle_fld_char(node, segments, field_stack)
            elif tag == q("w", "instrText") and field_stack:
                field_stack[-1]["instr"].append(node.text or "")

    def _handle_fld_char(self, node, segments, field_stack):
        kind = node.get(q("w", "fldCharType"))
        if kind == "begin":
            field_stack.append({"instr": [], "state": "instr", "result": []})
        elif kind == "separate":
            if field_stack:
                field_stack[-1]["state"] = "result"
        elif kind == "end" and field_stack:
            done = field_stack.pop()
            text = self._resolve_field("".join(done["instr"]), done["result"])
            self._emit(segments, field_stack, text, raw=True)

    def _resolve_field(self, instr: str, result_segments) -> str:
        """Render one Word field: a cross-reference, a link, or its cached text."""
        words = instr.strip().split()
        if not words:
            return self._join_segments(result_segments)
        name = words[0].upper()
        if name in ("TOC", "INDEX", "XE"):
            return ""
        if name in ("REF", "PAGEREF") and len(words) > 1:
            # Word's cached result, without the field's decorative italics or
            # bolding, is the text the reader saw.
            text = self._join_segments(result_segments, plain=True)
            anchor = self.anchors.lookup(words[1])
            if name == "REF" and anchor and anchor.clause in self.emitted_clauses:
                return xref(anchor, text)
            return text
        if name == "HYPERLINK" and len(words) > 1:
            url = words[1].strip('"')
            return external_link(url, self._join_segments(result_segments))
        return self._join_segments(result_segments)

    def _render_hyperlink(self, node, segments, field_stack):
        inner = []
        self._render_children(node, inner, [])
        text = self._join_segments(inner)
        rel_id = node.get(q("r", "id"))
        anchor_name = node.get(q("w", "anchor"))
        if rel_id and rel_id in self.pkg.rels:
            target, mode = self.pkg.rels[rel_id]
            if mode == "External":
                self._emit(segments, field_stack, external_link(target, text), raw=True)
                return
        if anchor_name:
            anchor = self.anchors.lookup(anchor_name)
            if anchor and anchor.clause in self.emitted_clauses:
                self._emit(segments, field_stack, xref(anchor, text), raw=True)
                return
        self._emit(segments, field_stack, text, raw=True)

    def _render_footnote(self, node) -> str:
        note = self.footnote_text.get(node.get(q("w", "id")))
        if note is None:
            return ""
        parts = [self.render_inline(para).strip() for para in note.iter(W_P)]
        text = " ".join(part for part in parts if part).strip()
        return f"footnote:[{escape_macro_body(text)}]"

    def _render_drawing(self, node) -> str:
        blip = node.find(".//" + q("a", "blip"))
        if blip is None:
            return ""
        rel_id = None
        svg = node.find(".//" + q("asvg", "svgBlip"))
        if svg is not None:
            rel_id = svg.get(q("r", "embed"))
        if rel_id is None:
            rel_id = blip.get(q("r", "embed"))
        if rel_id not in self.pkg.rels:
            return ""
        target = self.pkg.rels[rel_id][0]
        name = self.extract_image(target)
        return f"image:{self.image_prefix}/{name}[]"

    def extract_image(self, target: str) -> str:
        name = Path(target).name
        self.image_dir.mkdir(parents=True, exist_ok=True)
        destination = self.image_dir / name
        data = self.pkg.media(target)
        if not destination.exists() or destination.read_bytes() != data:
            destination.write_bytes(data)
        if name not in self.extracted_images:
            self.extracted_images.append(name)
        return name

    # -- block rendering --------------------------------------------------

    def render_blocks(self, blocks, depth=0) -> list:
        """Render a sequence of body-level elements to AsciiDoc lines.

        ``depth`` is the table nesting level, which decides the cell separator.
        """
        lines = []
        index = 0
        while index < len(blocks):
            block = blocks[index]
            if block.tag == W_TBL:
                caption = self._lookahead_caption(blocks, index + 1)
                if is_bibliography_table(block):
                    lines.extend(self._render_bibliography_table(block))
                else:
                    lines.extend(self.render_table(block, caption, depth))
                lines.append("")
                index += 1 + caption.consumed
                continue
            if block.tag != W_P:
                index += 1
                continue
            style = para_style(block)
            if style in DROP_STYLES:
                index += 1
                continue
            if style in CODE_STYLES:
                block_lines, index = self._render_code_run(blocks, index)
                lines.extend(block_lines)
                continue
            if style == "Bibliography":
                block_lines, index = self._render_bibliography(blocks, index)
                lines.extend(block_lines)
                continue
            if is_list_para(block):
                block_lines, index = self._render_list(blocks, index)
                lines.extend(block_lines)
                continue
            if is_xml_example(block):
                block_lines, index = self._render_xml_example(blocks, index)
                lines.extend(block_lines)
                continue
            level = heading_level(style)
            if level is not None:
                lines.extend(
                    self._render_heading(
                        block, level, opens_bibliography(blocks, index)
                    )
                )
                index += 1
                continue
            if (
                block.find(".//" + q("w", "drawing")) is not None
                and not raw_text(block).strip()
            ):
                caption = self._lookahead_caption(blocks, index + 1)
                lines.extend(self._render_figure(block, caption))
                index += 1 + caption.consumed
                continue
            lines.extend(self._render_paragraph(block, style))
            index += 1
        return trim_blank_lines(lines)

    def _render_heading(self, para, level, bibliography=False) -> list:
        lines = [""] + hidden_comment(para)
        annex = level == 1 and self.current is not None and self.current.is_annex
        if bibliography:
            lines.append("[bibliography]")
        elif annex:
            lines.append("[appendix]")
        lines.extend(f"[[{ident}]]" for ident in self._block_anchors(para))
        title = self.render_inline(para).strip()
        # A heading's footnote is not carried into the rendered title, so it
        # goes to the text the heading introduces instead.
        self.pending_footnotes.extend(FOOTNOTE_MACRO_RE.findall(title))
        title = FOOTNOTE_MACRO_RE.sub("", title).strip()
        marker = "=" * (level + 1)
        lines.append(f"{marker} {title or 'Untitled'}")
        lines.append("")
        return lines

    def _block_anchors(self, para) -> tuple:
        """Ids for the bookmarks on a heading or caption paragraph."""
        idents = []
        for bookmark in para.iter(q("w", "bookmarkStart")):
            anchor = self.anchors.lookup(bookmark.get(q("w", "name")) or "")
            if (
                anchor
                and anchor.block_level
                and anchor.clause in self.emitted_clauses
                and anchor.ident not in idents
            ):
                idents.append(anchor.ident)
        return tuple(idents)

    def _render_paragraph(self, para, style) -> list:
        comments = hidden_comment(para)
        text = self.render_inline(para).strip()
        if not text:
            return comments + [""] if comments else []
        if self.pending_footnotes and style not in CAPTION_STYLES:
            text += "".join(self.pending_footnotes)
            self.pending_footnotes = []
        text = escape_cell(text, self.cell_depth)
        if style in CAPTION_STYLES:
            # A block title has to be attached to the block it names; on its
            # own it is a stray line that AsciiDoc silently drops, so an
            # unattached caption is kept as ordinary text instead.
            title = strip_caption_number(split_anchors(text)[0])
            return (
                comments
                + [f"[[{ident}]]" for ident in self._block_anchors(para)]
                + [protect_line_start(title)]
                + [""]
            )
        return comments + [protect_line_start(text), ""]

    def _lookahead_caption(self, blocks, index) -> Caption:
        """Consume a caption paragraph that follows a table or figure.

        Word puts the caption after the object it describes; AsciiDoc wants a
        block title in front of it.
        """
        start = index
        comments = []
        while index < len(blocks):
            block = blocks[index]
            if block.tag != W_P:
                break
            comments.extend(hidden_comment(block))
            if para_style(block) in CAPTION_STYLES:
                title = split_anchors(self.render_inline(block).strip())[0]
                return Caption(
                    strip_caption_number(title),
                    self._block_anchors(block),
                    comments,
                    index - start + 1,
                )
            if raw_text(block).strip():
                break
            index += 1
        return Caption()

    def _row_caption(self, rows) -> Caption:
        """Take a caption that Word laid out as a row of the table itself.

        Left in place it becomes a block title inside a cell, where AsciiDoc
        reads the leading dot as markup and deletes the cell.
        """
        for row in list(rows):
            paragraphs = [para for para in row.iter(W_P) if raw_text(para).strip()]
            if not paragraphs:
                continue
            if not all(para_style(para) in CAPTION_STYLES for para in paragraphs):
                continue
            title = split_anchors(self.render_inline(paragraphs[0]).strip())[0]
            rows.remove(row)
            return Caption(
                strip_caption_number(title),
                self._block_anchors(paragraphs[0]),
                hidden_comment(paragraphs[0]),
            )
        return Caption()

    def _render_figure(self, para, caption: Caption) -> list:
        lines = [""] + caption.comments
        lines.extend(f"[[{ident}]]" for ident in caption.anchors)
        if caption.title:
            lines.append("." + caption.title)
        image = self.render_inline(para).strip()
        # A block image is the inline macro with a doubled colon.
        image = image.replace("image:", "image::", 1)
        lines.append(image)
        lines.append("")
        return lines

    def _render_xml_example(self, blocks, index) -> tuple:
        """Emit schema fragments that Word styled as body text as a listing.

        Left as prose their quotes are curled, their comment delimiters turn
        into dashes and their tags are read as AsciiDoc markup.
        """
        text_lines = []
        while index < len(blocks):
            block = blocks[index]
            if block.tag != W_P:
                break
            if is_xml_example(block):
                text_lines.append(escape_cell(raw_text(block).strip(), self.cell_depth))
            elif raw_text(block).strip():
                break
            index += 1
        lines = ["", listing_attributes("xml", False), "----"]
        lines.extend(text_lines)
        lines.extend(["----", ""])
        return lines, index

    def _render_code_run(self, blocks, index) -> tuple:
        style = para_style(blocks[index])
        language = CODE_STYLES[style]
        text_lines = []
        while index < len(blocks):
            block = blocks[index]
            if block.tag != W_P or para_style(block) != style:
                break
            text_lines.extend(
                escape_cell(line, self.cell_depth) for line in code_lines(block)
            )
            index += 1
        while text_lines and not text_lines[0].strip():
            text_lines.pop(0)
        while text_lines and not text_lines[-1].strip():
            text_lines.pop()
        if not text_lines:
            return [], index
        # Word puts a listing's caption after it; AsciiDoc wants it in front,
        # and drops it altogether if it is left standing on its own.
        caption = self._lookahead_caption(blocks, index)
        index += caption.consumed
        fence = "-" * 4
        while any(line.strip() == fence for line in text_lines):
            fence += "-"
        lines = [""] + caption.comments
        lines.extend(f"[[{ident}]]" for ident in caption.anchors)
        if caption.title:
            lines.append("." + caption.title)
        attrs = listing_attributes(language, bool(caption.title))
        if attrs:
            lines.append(attrs)
        lines.append(fence)
        lines.extend(text_lines)
        lines.append(fence)
        lines.append("")
        return lines, index

    def _render_list(self, blocks, index) -> tuple:
        items = []
        while index < len(blocks):
            block = blocks[index]
            if block.tag != W_P or not is_list_para(block):
                break
            if para_style(block) in DROP_STYLES:
                break
            numbering = numbering_of(block)
            if numbering is None:
                num_id, ilvl, kind = None, "0", "bullet"
            else:
                num_id, ilvl = numbering
                kind = self.numbering.kind(num_id, ilvl)
            text = escape_cell(self.render_inline(block).strip(), self.cell_depth)
            comments = hidden_comment(block)
            if text or comments:
                items.append((int(ilvl), kind, text, comments))
            index += 1
        if not items:
            return [], index
        # Word indents lists with arbitrary ilvl values; compress them so that
        # the shallowest level in this run becomes depth 1.
        depths = {
            value: rank + 1 for rank, value in enumerate(sorted({i[0] for i in items}))
        }
        lines = [""]
        for ilvl, kind, text, comments in items:
            lines.extend(comments)
            if not text:
                continue
            marker = ("." if kind == "ordered" else "*") * depths[ilvl]
            lines.append(f"{marker} {text}")
        lines.append("")
        return lines, index

    def _render_bibliography(self, blocks, index) -> tuple:
        entries = []
        while index < len(blocks):
            block = blocks[index]
            if block.tag != W_P or para_style(block) != "Bibliography":
                break
            text = escape_cell(self.render_inline(block).strip(), self.cell_depth)
            label = re.fullmatch(r"\\?\[([^\]]+)\]", text)
            if label:
                ident = None
                for bookmark in block.iter(q("w", "bookmarkStart")):
                    anchor = self.anchors.lookup(bookmark.get(q("w", "name")) or "")
                    if anchor:
                        ident = anchor.ident
                        break
                entries.append(
                    {
                        "label": label.group(1),
                        "ident": ident or slugify(label.group(1)),
                        "body": [],
                    }
                )
            elif text and entries:
                entries[-1]["body"].append(text)
            elif text:
                entries.append({"label": None, "ident": None, "body": [text]})
            index += 1
        if not entries:
            return [], index
        lines = [""]
        for entry in entries:
            body = " ".join(entry["body"]).strip()
            if entry["label"]:
                lines.append(
                    "* [[[{},{}]]] {}".format(entry["ident"], entry["label"], body)
                )
            else:
                lines.append(f"* {body}")
        lines.append("")
        return lines, index

    def _render_bibliography_table(self, tbl) -> list:
        """Render the reference list, which Word lays out as a two-column table.

        The left column holds the citation label and its bookmark, the right
        column the reference text; AsciiDoc wants one bibliography entry per
        list item.
        """
        lines = [""]
        for row in tbl.findall(W_TR):
            cells = row.findall(W_TC)
            if not cells:
                continue
            head, idents = split_anchors(self._cell_text(cells[0]))
            body = " ".join(self._cell_text(cell) for cell in cells[1:]).strip()
            label = re.fullmatch(r"\\?\[(.+)\]", head.strip())
            if label and idents:
                extra = "".join(f"[[{ident}]]" for ident in idents[1:])
                lines.append(f"* [[[{idents[0]},{label.group(1)}]]] {extra}{body}")
            elif label:
                lines.append(f"* [{label.group(1)}] {body}")
            else:
                lines.append(f"* {head} {body}".strip())
        lines.append("")
        return lines

    def _cell_text(self, cell) -> str:
        parts = [self.render_inline(para).strip() for para in cell.iter(W_P)]
        return " ".join(part for part in parts if part)

    # -- tables -----------------------------------------------------------

    def render_table(self, tbl, caption: Caption, depth=0) -> list:
        separator = "|" if depth == 0 else "!"
        rows = tbl.findall(W_TR)
        if not rows:
            return []
        if not caption.title:
            row = self._row_caption(rows)
            caption = Caption(
                row.title,
                caption.anchors or row.anchors,
                caption.comments + row.comments,
                caption.consumed,
            )
        layout = self._table_layout(rows)
        columns = self._grid_columns(tbl) or max(
            (
                row["covered"] + sum(cell["span"] for cell in row["cells"])
                for row in layout
            ),
            default=1,
        )
        for row in layout:
            fit_row_to_grid(row, columns)
        # A rowspan may not start in the header row: Metanorma rejects a merge
        # that crosses out of the head, so such a table is emitted headerless.
        header = self._has_header_row(tbl, rows) and not any(
            cell["rows"] > 1 for cell in layout[0]["cells"]
        )
        lines = [""] + caption.comments
        lines.extend(f"[[{ident}]]" for ident in caption.anchors)
        if caption.title:
            lines.append("." + caption.title)
        attrs = [f'cols="{self._cols_spec(tbl, columns)}"']
        if header:
            attrs.append('options="header"')
        lines.append("[" + ",".join(attrs) + "]")
        lines.append(separator + "===")
        for index, row in enumerate(layout):
            lines.append("")
            for cell in row["cells"]:
                lines.extend(
                    self._render_cell(cell, header and index == 0, depth, separator)
                )
            lines.extend([separator] * row["pad"])
        lines.append(separator + "===")
        return lines

    def _grid_columns(self, tbl) -> int:
        grid = tbl.find(q("w", "tblGrid"))
        return 0 if grid is None else len(grid.findall(q("w", "gridCol")))

    def _table_layout(self, rows) -> list:
        """Flatten rows into cells, resolving Word's horizontal/vertical merges.

        Returns one dict per row: the cells that AsciiDoc has to emit, and how
        many grid columns are already taken by a rowspan from further up.
        """
        layout = []
        for row in rows:
            cells = []
            column = 0
            for tc in row.findall(W_TC):
                tcPr = tc.find(q("w", "tcPr"))
                span = 1
                merge = None
                if tcPr is not None:
                    grid_span = tcPr.find(q("w", "gridSpan"))
                    if grid_span is not None:
                        span = max(1, int(grid_span.get(W_VAL) or 1))
                    vmerge = tcPr.find(q("w", "vMerge"))
                    if vmerge is not None:
                        merge = vmerge.get(W_VAL) or "continue"
                cells.append(
                    {
                        "tc": tc,
                        "span": span,
                        "merge": merge,
                        "column": column,
                        "rows": 1,
                    }
                )
                column += span
            layout.append(cells)
        # Fold vertically merged continuation cells into the cell that started
        # the merge, and drop them from the output.
        covered = [0] * len(layout)
        for index, row in enumerate(layout):
            for cell in row:
                if cell["merge"] != "restart":
                    continue
                depth = index + 1
                while depth < len(layout):
                    follower = next(
                        (
                            other
                            for other in layout[depth]
                            if other["column"] == cell["column"]
                            and other["merge"] == "continue"
                        ),
                        None,
                    )
                    if follower is None:
                        break
                    follower["dropped"] = True
                    cell["rows"] += 1
                    covered[depth] += cell["span"]
                    depth += 1
        return [
            {
                "cells": [cell for cell in row if not cell.get("dropped")],
                "covered": covered[index],
            }
            for index, row in enumerate(layout)
        ]

    def _render_cell(self, cell, in_header=False, depth=0, separator="|") -> list:
        sources = [cell["tc"]] + list(cell.get("extra", ()))
        children = [
            child for source in sources for child in source if child.tag in (W_P, W_TBL)
        ]
        nested = any(child.tag == W_TBL for child in children)
        self.cell_depth += 1
        try:
            content = trim_blank_lines(self.render_blocks(children, depth + 1))
        finally:
            self.cell_depth -= 1
        if in_header:
            content = [strip_bold(line) for line in content]
        # AsciiDoc writes a span as {colspan}.{rowspan}+, either part optional.
        spec = ""
        if cell["span"] > 1 and cell["rows"] > 1:
            spec = f"{cell['span']}.{cell['rows']}+"
        elif cell["span"] > 1:
            spec = f"{cell['span']}+"
        elif cell["rows"] > 1:
            spec = f".{cell['rows']}+"
        if not content:
            return [spec + separator]
        simple = (
            len(content) == 1 and not nested and not BLOCK_START_RE.match(content[0])
        )
        if simple:
            return [f"{spec}{separator} {content[0]}"]
        if nested:
            # A nested table has to start on its own line inside an AsciiDoc cell.
            return [f"{spec}a{separator}"] + content
        return [f"{spec}a{separator} {content[0]}"] + content[1:]

    def _cols_spec(self, tbl, columns) -> str:
        grid = tbl.find(q("w", "tblGrid"))
        widths = []
        if grid is not None:
            for col in grid.findall(q("w", "gridCol")):
                try:
                    widths.append(int(col.get(q("w", "w")) or 0))
                except ValueError:
                    widths.append(0)
        widths = [width for width in widths if width > 0]
        if len(widths) != columns:
            return ",".join(["1"] * columns)
        smallest = min(widths)
        return ",".join(
            str(max(1, min(20, round(width / smallest)))) for width in widths
        )

    def _has_header_row(self, tbl, rows) -> bool:
        if len(rows) < 2:
            return False
        tblPr = tbl.find(q("w", "tblPr"))
        if tblPr is not None:
            look = tblPr.find(q("w", "tblLook"))
            style = tblPr.find(q("w", "tblStyle"))
            styled = style is not None and style.get(W_VAL) in self.header_styles
            first_row = look is not None and look.get(q("w", "firstRow")) == "1"
            if styled and first_row:
                return True
        first = rows[0]
        if any(run.find(q("w", "b")) is not None for run in first.iter(q("w", "rPr"))):
            return True
        return any(
            tc.find(q("w", "tcPr") + "/" + q("w", "shd")) is not None
            for tc in first.findall(W_TC)
        )

    # -- entry points -----------------------------------------------------

    def convert(self, clauses, resolvable=None) -> str:
        """Render one or more clauses, resolving xrefs within ``resolvable``."""
        self.emitted_clauses = set(
            resolvable if resolvable else [clause.key for clause in clauses]
        )
        lines = []
        for clause in clauses:
            self.current = clause
            lines.extend(self.render_blocks(clause.blocks))
            lines.append("")
        return "\n".join(trim_blank_lines(lines)).rstrip() + "\n"

    def clause_filename(self, clause: Clause) -> str:
        title = APPENDIX_RE.sub("", clause.title).strip(" :-") or clause.title
        if clause.is_front:
            return f"front-{clause.ordinal:02d}-{slugify(clause.title)}.adoc"
        if clause.ordinal:
            return f"{clause.ordinal:02d}-{slugify(clause.title)}.adoc"
        return f"{clause.key}-{slugify(title)}.adoc"


def escape_macro_body(text: str) -> str:
    """Escape the brackets that would close a macro early.

    The passthroughs that protect technical text carry brackets of their own,
    and escaping those would break the very thing they protect, so only the
    text between them is escaped.
    """
    out = []
    position = 0
    for match in PROTECTED_RE.finditer(text):
        out.append(text[position : match.start()].replace("]", "\\]"))
        out.append(match.group())
        position = match.end()
    out.append(text[position:].replace("]", "\\]"))
    return "".join(out)


def external_link(url: str, text: str) -> str:
    url = url.strip()
    text = (text or "").strip()
    if not url:
        return text
    if url.startswith("mailto:"):
        macro = "mailto:{}".format(url[len("mailto:") :])
    else:
        macro = f"link:{url}"
    if not text or text == url:
        text = url
    return f"{macro}[{escape_macro_body(text)}]"


#: A paragraph that is really a fragment of XML rather than a sentence.
XML_EXAMPLE_RE = re.compile(r"^<[?!/]?[A-Za-z][^<>]*>")


def is_xml_example(para) -> bool:
    """True for a body-text paragraph whose whole content is XML markup."""
    if para.tag != W_P or para_style(para) in CODE_STYLES:
        return False
    if para_style(para) in CAPTION_STYLES or heading_level(para_style(para)):
        return False
    text = raw_text(para).strip()
    return bool(text) and text.endswith(">") and XML_EXAMPLE_RE.match(text) is not None


#: A cross-reference that has already been rendered, as ``<<id>>`` or ``<<id,text>>``.
XREF_RE = re.compile(r"<<[^<>\n]+>>")

#: Word's own "Section" in front of a rendered cross-reference.  Only the
#: singular: a plural introduces a list of references, and the label
#: Metanorma writes belongs to each of them rather than to the list.
SECTION_LABEL_RE = re.compile(
    r"\b(?:Section|Clause)\s+(?=<<(?P<id>[^<>,\s]+)(?:,[^<>]*)?>>)",
    re.IGNORECASE,
)

#: A footnote macro, as this converter writes one.
FOOTNOTE_MACRO_RE = re.compile(r"footnote:\[(?:\\.|[^\]])*\]")

#: The bracketed label Word caches as the visible text of a citation.
CITATION_LABEL_RE = re.compile(r"^\s*\[[^\[\]]*\]")


#: The number Word resolves a cross-reference to, and that Metanorma
#: regenerates: a clause number, or a caption's "Table 7" label.
RESOLVED_NUMBER_RE = re.compile(
    r"^(?:(?:Table|Figure)\s+)?\d+(?:\.\d+)*(?:-[A-Za-z0-9]{1,3})?[.:]?(?=\s|$)"
)


def xref(anchor, text: str) -> str:
    """Render a hyperlink to ``anchor`` whose visible text is ``text``.

    Word nests a REF field inside the hyperlink that carries the same target,
    so the text is often an already-rendered cross-reference: using it as the
    label of a second one produces ``<<id,<<id>>``, which is not a reference
    at all.  A cached citation label is dropped for the same reason, since
    Metanorma renders the label itself and the cached one may be stale.

    Word resolves "Section 13.7 Properties Specific to Number with Binary
    Representation" to a number and the target's title.  Metanorma
    regenerates the number and nothing else, so the number becomes the
    reference and the title stays as the text it is.
    """
    if XREF_RE.search(text):
        return text
    label = CITATION_LABEL_RE.match(text)
    if label and not any(char.isalnum() for char in label.group()):
        # Word cached an empty "[]" for this citation and shows the reader
        # nothing; the reference is still there, and the text after the
        # empty label belongs to the sentence.
        return f"<<{anchor.ident},{label.group().strip()}>>" + text[label.end() :]
    # The space either side of the field is the sentence's, not the label's.
    lead = text[: len(text) - len(text.lstrip())]
    trail = text[len(text.rstrip()) :]
    label = text.strip()
    if not label or label == anchor.ident:
        return f"{lead}<<{anchor.ident}>>{trail}"
    number = RESOLVED_NUMBER_RE.match(label)
    if number:
        title = label[number.end() :].strip()
        return f"{lead}<<{anchor.ident}>> {title}".rstrip() + trail
    return f"{lead}<<{anchor.ident},{label}>>{trail}"


#: The same reference twice in a row, which Word writes as a pair of REF
#: fields, one resolving to the number and one to the target's title.
DUPLICATE_XREF_RE = re.compile(
    r"<<(?P<id>[^<>,\s]+)(?P<label>,[^<>]*)?>>"
    r"(?P<gap>\s*,?\s*)<<(?P=id)(?:,(?P<title>[^<>]*))?>>"
)


def collapse_duplicate_xrefs(text: str) -> str:
    """Fold Word's number-and-title pair of references into one.

    Only the number is Metanorma's to regenerate, so the second reference
    becomes the title it resolved to, as text.
    """

    def fold(match):
        head = "<<{}{}>>".format(match.group("id"), match.group("label") or "")
        title = (match.group("title") or "").strip()
        if match.group("label") or not title:
            return head
        return head + (match.group("gap") or " ") + title

    previous = None
    while previous != text:
        previous = text
        text = DUPLICATE_XREF_RE.sub(fold, text)
    return text


ANCHOR_RE = re.compile(r"\[\[([A-Za-z][\w.:-]*)\]\]")


def split_anchors(text: str) -> tuple:
    """Pull inline anchors out of rendered text so they can become block ids."""
    anchors = ANCHOR_RE.findall(text)
    return ANCHOR_RE.sub("", text).strip(), tuple(anchors)


def strip_bold(line: str) -> str:
    """Remove bold markup; header cells are emphasised by the table style."""
    return re.sub(r"(?<!\\)\*([^*\n]+)\*", r"\1", line)


#: Word's own caption number, including the "33-A" form used where a table
#: was inserted without renumbering the ones after it.
CAPTION_NUMBER_RE = re.compile(r"^(?:Table|Figure)\s*\d*(?:-[A-Za-z0-9]{1,3})?[.:]?\s+")


def strip_caption_number(text: str) -> str:
    """Drop Word's "Table 6 " / "Table 33-A " prefix; Metanorma renumbers."""
    stripped = CAPTION_NUMBER_RE.sub("", text).strip()
    # A caption that is nothing but its number still has to keep some text,
    # or the block title it becomes would swallow the block itself.
    return stripped or text.strip()


def listing_attributes(language: str, titled: bool) -> str:
    """The attribute line for a listing block.

    Metanorma draws listings from the same numbering sequence as figures, so
    an example the source neither numbers nor names would take a figure
    number away from the diagrams that do carry one.
    """
    style = f"source,{language}" if language else ""
    if titled:
        return f"[{style}]" if style else ""
    style = style.replace("source,", "source%unnumbered,") if style else "%unnumbered"
    return f"[{style}]"


def code_lines(para) -> list:
    """Verbatim lines for one listing paragraph, honouring line breaks."""
    parts = []
    for run in para.iter(q("w", "r")):
        for node in run:
            if node.tag == q("w", "t"):
                parts.append(node.text or "")
            elif node.tag == q("w", "tab"):
                parts.append("    ")
            elif node.tag in (q("w", "br"), q("w", "cr")):
                parts.append("\n")
            elif node.tag == q("w", "noBreakHyphen"):
                parts.append("-")
    text = normalise_text("".join(parts)).replace("\t", "    ")
    return text.split("\n")


def opens_bibliography(blocks, index) -> bool:
    """True if this heading's own content is the reference list."""
    for block in blocks[index + 1 :]:
        if block.tag == W_P and heading_level(para_style(block)) is not None:
            return False
        if block.tag == W_TBL:
            return is_bibliography_table(block)
    return False


def is_bibliography_table(tbl) -> bool:
    """True for a table that is really a list of bibliographic references."""
    paragraphs = [para for para in tbl.iter(W_P) if raw_text(para).strip()]
    if len(paragraphs) < 4:
        return False
    styled = sum(1 for para in paragraphs if para_style(para) == "Bibliography")
    return styled >= 0.8 * len(paragraphs)


def fit_row_to_grid(row, columns: int) -> None:
    """Make a row occupy exactly ``columns`` grid columns.

    Word tolerates a ``gridSpan`` that overruns the table grid, and rows whose
    cells do not add up.  AsciiDoc does not: it silently drops the surplus and
    Metanorma then reports the table as inconsistent.
    """
    cells = row["cells"]
    available = max(0, columns - row["covered"])
    if not cells:
        row["pad"] = available
        return
    if len(cells) > available:
        # Degenerate row: fold the surplus cells into the last one we keep.
        keep = max(1, available)
        cells[keep - 1]["extra"] = cells[keep:]
        row["cells"] = cells = cells[:keep]
    total = 0
    for cell in cells:
        cell["span"] = max(1, cell["span"])
        total += cell["span"]
    for cell in reversed(cells):
        if total <= available:
            break
        shrink = min(cell["span"] - 1, total - available)
        cell["span"] -= shrink
        total -= shrink
    row["pad"] = max(0, available - total)


def escape_cell(line: str, depth: int) -> str:
    """Protect AsciiDoc cell separators inside table cell content.

    ``depth`` is how many cells enclose this line.  The outer table always
    separates on ``|``; a table nested one level down separates on ``!``, so
    both have to be neutralised once we are inside one.
    """
    if depth < 1:
        return line
    line = line.replace("|", "\\|")
    if depth > 1:
        line = line.replace("!", "\\!")
    return line


def trim_blank_lines(lines) -> list:
    """Collapse runs of blank lines and strip leading/trailing ones."""
    out = []
    for line in lines:
        if not line.strip():
            if not out or not out[-1]:
                continue
            out.append("")
        else:
            out.append(line.rstrip())
    while out and not out[-1]:
        out.pop()
    return out


# --------------------------------------------------------------------------
# Command line
# --------------------------------------------------------------------------

DEFAULT_DOCX = "docs/current/draft-gwdrp-dfdl-v1.2.2-GFD-R-P.240-ISO-23415.docx"


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=__doc__.splitlines()[0],
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "Clauses are named as the specification names them: 1..29 for the\n"
            "numbered clauses, A..G for the appendices, and 'front' for the\n"
            "unnumbered front matter."
        ),
    )
    parser.add_argument("--docx", default=DEFAULT_DOCX, help="source .docx")
    parser.add_argument(
        "--clause",
        metavar="KEY",
        help="convert one clause: a number (13), an appendix letter (C), " "or 'front'",
    )
    parser.add_argument("--out", help="output file for --clause")
    parser.add_argument("--all", action="store_true", help="convert every clause")
    parser.add_argument("--outdir", help="output directory for --all")
    parser.add_argument(
        "--imagedir",
        default="spec/images",
        help="directory that extracted images are written to",
    )
    parser.add_argument(
        "--list", action="store_true", help="list the top-level clauses and exit"
    )
    return parser


def main(argv=None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)
    docx = Path(args.docx)
    if not docx.exists():
        print(f"no such file: {docx}", file=sys.stderr)
        return 2
    converter = Converter(Package(docx), Path(args.imagedir))

    if args.list:
        for clause in converter.clauses:
            print(f"{clause.key:>5}  {clause.title}")
        return 0

    if args.all:
        outdir = Path(args.outdir or "spec/clauses")
        outdir.mkdir(parents=True, exist_ok=True)
        every = [clause.key for clause in converter.clauses]
        for clause in converter.clauses:
            text = converter.convert([clause], resolvable=every)
            path = outdir / converter.clause_filename(clause)
            path.write_text(text, encoding="utf-8")
            print(f"{path} ({text.count(chr(10))} lines)")
        return 0

    if args.clause:
        selected = converter.find(args.clause)
        if not selected:
            known = ", ".join(dict.fromkeys(c.key for c in converter.clauses))
            print(f"unknown clause {args.clause!r}; known: {known}", file=sys.stderr)
            return 2
        text = converter.convert(selected)
        if args.out:
            path = Path(args.out)
            path.parent.mkdir(parents=True, exist_ok=True)
            path.write_text(text, encoding="utf-8")
            print(f"{path} ({text.count(chr(10))} lines)")
        else:
            sys.stdout.write(text)
        return 0

    parser.print_help()
    return 1


if __name__ == "__main__":
    sys.exit(main())
