#!/usr/bin/env python3
"""Check that every cross-reference in the DFDL spec resolves.

A dangling cross-reference is invisible in the AsciiDoc and nearly invisible
in the rendered document: Metanorma emits the raw anchor name where the clause
number should be, in the middle of a sentence, and the build still succeeds.
The conversion from MS-Word created several thousand anchors mechanically, so
the failure mode is not hypothetical - a renamed clause anchor, or a bookmark
that survived in a link but not in its target, breaks a reference nobody will
notice by reading.

Four things are checked, all of them against the built semantic XML, which is
the only place the whole document exists at once:

  * ``<xref target=...>`` - a reference to a clause, table, figure, footnote
    or bookmark elsewhere in the document.  The target must be declared as an
    ``id`` or ``anchor`` somewhere in the same document.
  * ``<link target="#...">`` - the same thing written as a URL fragment.
  * ``<eref bibitemid=...>`` - a citation of a bibliography entry.  The
    identifier must name a ``<bibitem>``.
  * duplicate declarations - an anchor declared twice is a reference that
    resolves to two different places, which is as broken as one that resolves
    to none.

A fifth check is advisory and never fails the run.  Most of the citations in
this specification are not marked up as citations at all: they are literal
``[LABEL]`` text carried over from Word, so nothing connects them to the
bibliography and nothing notices when the label is wrong.  Bracketed text that
looks like a citation label - opening with a capital, no spaces, no hyphens,
more than one capital - is compared with the bibliography's document identifiers, case-insensitively,
and reported when it matches none.  The infoset member names the specification
also writes in brackets (``[nilled]``, ``[children]``) do not look like
citation labels and are not reported.

Usage::

    python3 tools/link-check.py build/iso/dfdl.xml
"""

import argparse
import re
import sys
import xml.etree.ElementTree as ET
from collections import Counter, defaultdict
from pathlib import Path

NS = "{https://www.metanorma.org/ns/standoc}"

# Elements that open a numbered section of the document.
SECTION_TAGS = frozenset(
    NS + name for name in ("clause", "terms", "definitions", "annex", "appendix")
)

# Bracketed text that could be a citation label: opening with a capital, no
# spaces, no hyphens and more than one capital, which is what every identifier
# in the bibliography looks like and what the infoset member names, written in
# the same brackets, deliberately do not.
CITATION_RE = re.compile(r"\[([A-Z][A-Za-z0-9_.]{1,30})\]")

# The parts of the document that carry no clause number of their own.
UNNUMBERED = ("front matter", "bibliography")


def flatten(element: ET.Element) -> str:
    return " ".join("".join(element.itertext()).split())


def declared(root: ET.Element) -> tuple[set[str], list[str]]:
    """Every anchor the document declares, and those declared more than once."""
    counts: Counter[str] = Counter()
    for element in root.iter():
        for attribute in ("id", "anchor"):
            name = element.get(attribute)
            if name:
                counts[name] += 1
    return set(counts), sorted(name for name, count in counts.items() if count > 1)


def bibliography_anchors(root: ET.Element) -> tuple[set[str], int]:
    """Every name a citation may use, and how many entries there are."""
    anchors = set()
    entries = 0
    for item in root.iter(NS + "bibitem"):
        entries += 1
        for attribute in ("id", "anchor"):
            name = item.get(attribute)
            if name:
                anchors.add(name)
    return anchors, entries


def bibliography_labels(root: ET.Element) -> set[str]:
    """The identifiers a citation in the text would spell, folded to lower."""
    labels = set()
    for item in root.iter(NS + "bibitem"):
        for identifier in item.iter(NS + "docidentifier"):
            text = flatten(identifier)
            if text:
                labels.add(text.lower())
    return labels


def locate(root: ET.Element) -> dict[ET.Element, str]:
    """Where each element sits, as a clause number, for reporting."""
    location: dict[ET.Element, str] = {}

    def walk(element: ET.Element, where: str) -> None:
        location[element] = where
        counter = 0
        for child in element:
            if child.tag in SECTION_TAGS and where not in UNNUMBERED:
                counter += 1
                walk(child, f"{where}.{counter}" if where else str(counter))
            else:
                walk(child, where)

    preface = root.find(NS + "preface")
    if preface is not None:
        walk(preface, "front matter")
    body = root.find(NS + "sections")
    if body is not None:
        counter = 0
        for child in body:
            if child.tag in SECTION_TAGS:
                counter += 1
                walk(child, str(counter))
            else:
                walk(child, "")
    for position, annex in enumerate(root.findall(NS + "annex")):
        walk(annex, chr(ord("A") + position))
    bibliography = root.find(NS + "bibliography")
    if bibliography is not None:
        walk(bibliography, "bibliography")
    return location


def references(root: ET.Element) -> list[tuple[str, str, ET.Element]]:
    """Every internal reference, as (kind, target, element)."""
    found = []
    for element in root.iter(NS + "xref"):
        target = element.get("target")
        if target:
            found.append(("xref", target, element))
    for element in root.iter(NS + "link"):
        target = element.get("target") or ""
        if target.startswith("#"):
            found.append(("link", target[1:], element))
    return found


def citations(root: ET.Element) -> list[tuple[str, ET.Element]]:
    found = []
    for tag in ("eref", "citation"):
        for element in root.iter(NS + tag):
            identifier = element.get("bibitemid")
            if identifier:
                found.append((identifier, element))
    return found


def unmarked_citations(
    root: ET.Element, labels: set[str], location: dict[ET.Element, str]
) -> dict[str, list[str]]:
    """Bracketed labels in the prose that name nothing in the bibliography."""
    unresolved: dict[str, list[str]] = defaultdict(list)

    def scan(element: ET.Element, where: str) -> None:
        for child in element:
            scan(child, location.get(child, where))
            for text in (child.text, child.tail):
                for label in CITATION_RE.findall(text or ""):
                    capitals = sum(1 for character in label if character.isupper())
                    if capitals < 2 or label.lower() in labels:
                        continue
                    if where not in unresolved[label]:
                        unresolved[label].append(where)

    for name in ("preface", "sections"):
        section = root.find(NS + name)
        if section is not None:
            scan(section, location.get(section, ""))
    for annex in root.findall(NS + "annex"):
        scan(annex, location.get(annex, ""))
    return unresolved


def describe(element: ET.Element, location: dict[ET.Element, str]) -> str:
    where = location.get(element, "")
    shown = flatten(element)[:60] or element.get("citeas", "")
    return f"{where or '?':<14} {shown!r}"


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("xml", type=Path, help="built semantic XML (build/*/dfdl.xml)")
    args = parser.parse_args(argv)

    source = args.xml
    root = ET.parse(source).getroot()

    anchors, duplicates = declared(root)
    bibitems, entries = bibliography_anchors(root)
    location = locate(root)

    internal = references(root)
    dangling = [
        (kind, target, element)
        for kind, target, element in internal
        if target not in anchors
    ]

    cited = citations(root)
    uncitable = [
        (identifier, element)
        for identifier, element in cited
        if identifier not in bibitems
    ]

    print(f"Cross-reference check of {source}")
    print(
        f"{len(internal)} internal reference(s) and {len(cited)} citation(s) "
        f"against {len(anchors)} declared anchor(s)\nand {entries} "
        "bibliography entry(s)."
    )

    if dangling:
        print(f"\n{len(dangling)} reference(s) resolve to nothing:")
        for kind, target, element in dangling:
            print(f"  {kind} -> {target}")
            print(f"      at {describe(element, location)}")

    if uncitable:
        print(f"\n{len(uncitable)} citation(s) name no bibliography entry:")
        for identifier, element in uncitable:
            print(f"  {identifier}")
            print(f"      at {describe(element, location)}")

    if duplicates:
        print(f"\n{len(duplicates)} anchor(s) declared more than once:")
        for name in duplicates:
            print(f"  {name}")

    unmarked = unmarked_citations(root, bibliography_labels(root), location)
    if unmarked:
        print(
            f"\nWARNING: {len(unmarked)} bracketed label(s) look like citations "
            "but match no\n         bibliography entry.  These are literal text, "
            "not markup, so they\n         are reported and do not fail the check."
        )
        for label in sorted(unmarked):
            print(f"  [{label}] in {', '.join(unmarked[label])}")

    broken = len(dangling) + len(uncitable) + len(duplicates)
    print()
    if broken:
        print(f"RESULT: FAIL - {broken} unresolved or ambiguous reference(s).")
        return 1
    print(
        f"RESULT: PASS - every one of {len(internal) + len(cited)} reference(s) "
        "resolves to exactly\n        one target."
    )
    return 0


if __name__ == "__main__":
    sys.exit(main())
