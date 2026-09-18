"""Derive the DFDL property index from the built semantic XML.

The specification carries a Property Index in its front matter.  In the
MS-Word source that index was maintained by hand: an author who added a
property was expected to remember to add a bookmark to it and a link to that
bookmark in the index.  Seven properties are listed there; the property tables
define a hundred and six.

This tool derives the same index mechanically instead.  The built semantic
XML already knows everything the index needs:

  * every property is a row of a table whose first heading column is
    "Property Name", so the set of properties is exactly the set of those
    first-column cells;
  * the table sits inside a clause, and the clause's position in the section
    hierarchy gives the clause number the index should point at;
  * a property that was bookmarked in Word survives as a ``<bookmark>`` with
    an anchor, which is a link target the index can use directly;
  * every ``dfdl:``-qualified name in the running text is a reference, and the
    clause it sits in is where a reader would find that property discussed.

Two artefacts come out of that.  The generated AsciiDoc index is written to a
file, in the same three-column shape the front matter uses, so it can be
compared with - or eventually substituted for - the hand-maintained one.  The
report on standard output is the part that is interesting today: which
properties the hand-maintained index omits, which of its entries no longer
correspond to a property table, and which ``dfdl:`` names in the prose are
near-misses for a real property name and are therefore probably misspellings.

Nothing here writes to ``spec/``.  The converted AsciiDoc is held to a
character-for-character fidelity comparison against the Word source, so the
front-matter index has to keep saying exactly what Word said; whether the
generated index replaces it is a decision for the working group, not a side
effect of running this tool.

Usage::

    python3 tools/property-index.py build/iso/dfdl.xml
    python3 tools/property-index.py build/iso/dfdl.xml -o /tmp/index.adoc
"""

import argparse
import difflib
import re
import sys
import xml.etree.ElementTree as ET
from dataclasses import dataclass, field
from pathlib import Path

NS = "{https://www.metanorma.org/ns/standoc}"

# Elements that open a numbered section of the document.
SECTION_TAGS = frozenset(
    NS + name for name in ("clause", "terms", "definitions", "annex", "appendix")
)

# Subtrees that are Metanorma's own metadata and boilerplate rather than
# converted specification text.  Neither properties nor references live here.
SKIPPED_TAGS = frozenset(
    NS + name
    for name in ("bibdata", "metanorma-extension", "boilerplate", "bibliography")
)

# The first column heading that marks a table as defining properties.  Two of
# the thirty-one tables spell it "Property name".
PROPERTY_HEADING = "property name"

# A qualified reference to a property in the running text.
REFERENCE_RE = re.compile(r"\bdfdl:([A-Za-z][A-Za-z0-9]*)\b")

# The front-matter clause whose contents this tool reproduces.
INDEX_TITLE = "Property Index"

# The column bands the front-matter index uses.
BANDS = (("A-K", "a", "k"), ("L-Q", "l", "q"), ("R-Z", "r", "z"))


@dataclass(frozen=True)
class Section:
    """A numbered clause or annex, or one of the unnumbered front sections."""

    number: str
    title: str
    anchor: str | None = None

    def __str__(self) -> str:
        return f"{self.number} {self.title}".strip()


@dataclass
class Property:
    """A property, the table rows that define it and the clauses using it."""

    name: str
    sites: list[tuple[Section, str]] = field(default_factory=list)
    anchor: str | None = None
    references: list[Section] = field(default_factory=list)

    @property
    def definition(self) -> Section | None:
        return self.sites[0][0] if self.sites else None

    def target(self) -> str | None:
        """The best link target available: the property, else its clause."""
        if self.anchor:
            return self.anchor
        section = self.definition
        return section.anchor if section else None


@dataclass
class Document:
    """Everything the index needs, read out of the semantic XML in one pass."""

    tables: list[tuple[Section, ET.Element]] = field(default_factory=list)
    text: list[tuple[Section, str]] = field(default_factory=list)
    index_clause: ET.Element | None = None


def flatten(element: ET.Element) -> str:
    """The visible text of an element, with whitespace collapsed."""
    return " ".join("".join(element.itertext()).split())


def title_of(element: ET.Element) -> str:
    title = element.find(NS + "title")
    return flatten(title) if title is not None else ""


def annex_letter(position: int) -> str:
    """A, B, ... Z, then AA, AB, ... - annexes are lettered, not numbered."""
    letters = ""
    position += 1
    while position:
        position, remainder = divmod(position - 1, 26)
        letters = chr(ord("A") + remainder) + letters
    return letters


def read(root: ET.Element) -> Document:
    """Walk the document once, recording sections, tables and text."""
    document = Document()

    def collect(element: ET.Element, section: Section) -> None:
        if element.tag in SKIPPED_TAGS:
            return
        if element.tag == NS + "table":
            document.tables.append((section, element))
        if element.text:
            document.text.append((section, element.text))
        counter = 0
        for child in element:
            if child.tag in SECTION_TAGS:
                counter += 1
                number = f"{section.number}.{counter}"
                enter(
                    child,
                    Section(number, title_of(child), child.get("anchor")),
                )
            else:
                collect(child, section)
            if child.tail:
                document.text.append((section, child.tail))

    def enter(element: ET.Element, section: Section) -> None:
        if section.title == INDEX_TITLE and document.index_clause is None:
            document.index_clause = element
        collect(element, section)

    front = root.find(NS + "preface")
    if front is not None:
        for child in front:
            if child.tag in SECTION_TAGS or child.tag == NS + "abstract":
                enter(child, Section("front", title_of(child), child.get("anchor")))

    body = root.find(NS + "sections")
    if body is not None:
        counter = 0
        for child in body:
            if child.tag in SECTION_TAGS:
                counter += 1
                enter(
                    child,
                    Section(str(counter), title_of(child), child.get("anchor")),
                )

    for position, annex in enumerate(root.findall(NS + "annex")):
        enter(
            annex,
            Section(annex_letter(position), title_of(annex), annex.get("anchor")),
        )

    return document


def is_property_table(table: ET.Element) -> bool:
    head = table.find(NS + "thead")
    if head is None:
        return False
    headings = [flatten(cell) for cell in head.iter(NS + "th")]
    return bool(headings) and headings[0].lower().startswith(PROPERTY_HEADING)


def collect_properties(document: Document) -> dict[str, Property]:
    """One entry per property, in the order the tables define them."""
    properties: dict[str, Property] = {}
    for section, table in document.tables:
        if not is_property_table(table):
            continue
        caption = table.find(NS + "name")
        label = flatten(caption) if caption is not None else ""
        body = table.find(NS + "tbody")
        if body is None:
            continue
        for row in body.findall(NS + "tr"):
            cells = row.findall(NS + "td")
            if not cells:
                continue
            name = flatten(cells[0])
            if not name:
                continue
            entry = properties.setdefault(name, Property(name))
            entry.sites.append((section, label))
            bookmark = cells[0].find(NS + "bookmark")
            if bookmark is not None and entry.anchor is None:
                entry.anchor = bookmark.get("anchor")
    return properties


def collect_references(
    document: Document, properties: dict[str, Property]
) -> dict[str, list[Section]]:
    """Clauses that mention each ``dfdl:`` name, defined here or not."""
    mentions: dict[str, list[Section]] = {}
    for section, text in document.text:
        for name in REFERENCE_RE.findall(text):
            sections = mentions.setdefault(name, [])
            if section not in sections:
                sections.append(section)
    for name, sections in mentions.items():
        if name in properties:
            properties[name].references = sections
    return mentions


def front_matter_index(document: Document) -> list[str]:
    """The entries of the hand-maintained index, as converted."""
    if document.index_clause is None:
        return []
    entries = []
    for table in document.index_clause.iter(NS + "table"):
        body = table.find(NS + "tbody")
        if body is None:
            continue
        for cell in body.iter(NS + "td"):
            for paragraph in cell.iter(NS + "p"):
                text = flatten(paragraph)
                if text:
                    entries.append(text)
    return entries


def near_misses(
    mentions: dict[str, list[Section]], properties: dict[str, Property]
) -> list[tuple[str, str]]:
    """``dfdl:`` names that resemble a property but match none.

    Most unmatched names are annotation elements, functions or simple types,
    which are not properties and must not be reported.  A name that differs
    from a real property only in case, or by a couple of characters, is
    something else: a misspelling carried over from the Word source.
    """
    by_lowercase = {name.lower(): name for name in properties}
    suspects = []
    for name in sorted(mentions):
        if name in properties:
            continue
        exact = by_lowercase.get(name.lower())
        if exact:
            suspects.append((name, exact))
            continue
        close = difflib.get_close_matches(name, list(properties), n=1, cutoff=0.9)
        if close:
            suspects.append((name, close[0]))
    return suspects


def band_of(name: str) -> int:
    initial = name[:1].lower()
    for position, (_, low, high) in enumerate(BANDS):
        if low <= initial <= high:
            return position
    return len(BANDS) - 1


def render(properties: dict[str, Property], source: Path) -> str:
    """The generated index, in the shape the front matter already uses."""
    columns: list[list[str]] = [[] for _ in BANDS]
    for name in sorted(properties, key=str.lower):
        target = properties[name].target()
        entry = f"<<{target},{name}>>" if target else name
        columns[band_of(name)].append(entry)

    lines = [
        f"// Generated from {source} by tools/property-index.py.  Do not edit.",
        "",
        f'[cols="{",".join("1" for _ in BANDS)}",options="header"]',
        "|===",
        "",
    ]
    lines += [f"| {label}" for label, _, _ in BANDS]
    for column in columns:
        lines.append("")
        if not column:
            lines.append("|")
            continue
        lines.append(f"a| {column[0]}")
        for entry in column[1:]:
            lines += ["", entry]
    lines += ["|===", ""]
    return "\n".join(lines)


def report(
    properties: dict[str, Property],
    mentions: dict[str, list[Section]],
    existing: list[str],
    source: Path,
    destination: Path,
    stream,
) -> None:
    print(f"Property index derived from {source}", file=stream)
    print(f"Generated index written to {destination}", file=stream)
    print(file=stream)

    print(f"{len(properties)} properties:", file=stream)
    for name in sorted(properties, key=str.lower):
        entry = properties[name]
        where = ", ".join(section.number for section, _ in entry.sites)
        used = [section.number for section in entry.references]
        shown = ", ".join(used[:12]) + (
            f" (+{len(used) - 12})" if len(used) > 12 else ""
        )
        print(
            f"  {name:<32} defined {where:<10} "
            f"referenced in {len(used):>3} clause(s){': ' + shown if used else ''}",
            file=stream,
        )

    anchored = sum(1 for entry in properties.values() if entry.anchor)
    clause_only = sum(
        1 for entry in properties.values() if not entry.anchor and entry.target()
    )
    print(file=stream)
    print(
        f"Link targets: {anchored} property bookmark(s), {clause_only} entry(s) "
        f"falling back to the\n              defining clause, "
        f"{len(properties) - anchored - clause_only} with no target at all.",
        file=stream,
    )

    print(file=stream)
    print(
        f"Against the front-matter index ({len(existing)} entry(s)):",
        file=stream,
    )
    generated = set(properties)
    listed = set(existing)
    missing = sorted(generated - listed, key=str.lower)
    unknown = sorted(listed - generated, key=str.lower)
    if missing:
        print(
            f"  {len(missing)} property(s) defined by a property table that the "
            "front-matter index\n  does not list:",
            file=stream,
        )
        for name in missing:
            print(f"    {name}", file=stream)
    if unknown:
        print(
            f"  {len(unknown)} front-matter entry(s) that no property table "
            "defines:",
            file=stream,
        )
        for name in unknown:
            print(f"    {name}", file=stream)
    if not missing and not unknown:
        print("  The two agree.", file=stream)

    suspects = near_misses(mentions, properties)
    print(file=stream)
    if suspects:
        print(
            f"{len(suspects)} dfdl: name(s) in the text resemble a property but "
            "match none;\nlikely misspellings carried over from the source:",
            file=stream,
        )
        for name, closest in suspects:
            print(f"    dfdl:{name:<30} did you mean dfdl:{closest}?", file=stream)
    else:
        print(
            "Every dfdl: name in the text that resembles a property is one.",
            file=stream,
        )


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("xml", type=Path, help="built semantic XML (build/*/dfdl.xml)")
    parser.add_argument(
        "-o",
        "--output",
        type=Path,
        help="where to write the generated index "
        "(default: property-index.adoc beside the XML)",
    )
    args = parser.parse_args(argv)

    destination = args.output or args.xml.parent / "property-index.adoc"

    root = ET.parse(args.xml).getroot()
    document = read(root)
    properties = collect_properties(document)
    mentions = collect_references(document, properties)

    destination.parent.mkdir(parents=True, exist_ok=True)
    destination.write_text(render(properties, args.xml), encoding="utf-8")

    report(
        properties,
        mentions,
        front_matter_index(document),
        args.xml,
        destination,
        sys.stdout,
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
