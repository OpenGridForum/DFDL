"""Find text that AsciiDoc would silently rewrite.

Smart quotes are off for this document, so quotes, hex values and spaced
hyphens are written as typed.  A few sequences are still rewritten by
AsciiDoc itself, in prose and table cells alike:

    =>  <=  ->  <-     become arrows
    ...                becomes an ellipsis
    --                 becomes an em dash
    (C) (R) (TM)       become symbols
    #text#             becomes highlighted text

None of these fails the build; the specification just ends up saying
something else.  This tool reads the clause sources and reports each one
that isn't protected by a passthrough, with the line and the fix, so that
nobody has to remember the list.  Listings and other verbatim blocks are
left alone, since AsciiDoc doesn't rewrite them.

Usage::

    python3 tools/check-rewrites.py

``make check`` runs it, passing the built XML, which it ignores.
"""

import re
import sys
from pathlib import Path

CLAUSES = Path(__file__).resolve().parent.parent / "spec" / "clauses"

# Delimited blocks whose content is verbatim.
VERBATIM = re.compile(r"^(----+|\.\.\.\.+|\+\+\+\++|////+)$")

# Spans already protected, or not prose at all, removed before scanning.
PROTECTED = re.compile(
    r"pass:[a-z,]*\[[^\]]*\]"  # pass:[...]
    r"|\+\+\+.+?\+\+\+"  # +++...+++
    r"|\+\+.+?\+\+"  # ++...++
    r"|(?<![\w+])\+(?=\S).*?(?<=\S)\+(?![\w+])"  # +...+
    r"|<<[^>]*>>"  # cross-references
    r"|\[\[[^\]]*\]\]"  # anchors
    r"|\b(?:https?|ftp|mailto):\S+"  # URLs
    r"|\[[^\]]*\]#[^#]*#"  # roles, as in [.underline]#text#
    r"|\[css [^\]]*\]"  # css roles
)

HAZARDS = [
    (re.compile(r"=>|<=|->|<-"), "arrow"),
    (re.compile(r"\.\.\."), "ellipsis"),
    (re.compile(r"(?<!-)--(?!-)"), "em dash"),
    (re.compile(r"\((?:C|R|TM)\)"), "symbol"),
    (re.compile(r"(?<![\w#])#(?=\S)[^#]*?(?<=\S)#(?![\w#])|##.+?##"), "highlight"),
]


def scan(path):
    findings = []
    in_block = None
    for number, line in enumerate(path.read_text().split("\n"), 1):
        stripped = line.strip()
        if in_block:
            if stripped == in_block:
                in_block = None
            continue
        if VERBATIM.match(stripped):
            in_block = stripped
            continue
        if (
            stripped.startswith("//")
            or stripped in ("--", "|===", "!===")
            or re.match(r"^:[\w-]+:", stripped)
            or re.match(r"^\[[^\]]*\]$", stripped)
        ):
            continue
        prose = PROTECTED.sub(" ", line)
        for pattern, name in HAZARDS:
            for match in pattern.finditer(prose):
                findings.append((path.name, number, name, match.group(0)))
    return findings


def main():
    findings = []
    for path in sorted(CLAUSES.glob("*.adoc")):
        findings.extend(scan(path))
    for name, number, kind, text in findings:
        article = "an" if kind[0] in "aeiou" else "a"
        print(f"{name}:{number}: {text!r} would become {article} {kind}")
    if findings:
        print(
            f"\n{len(findings)} sequence(s) AsciiDoc will rewrite. Wrap each in a"
            " passthrough, +...+, or type the character you mean; see"
            ' "Technical text" in spec/EDITING.md.',
            file=sys.stderr,
        )
        sys.exit(1)
    print("No text that AsciiDoc would rewrite.")


if __name__ == "__main__":
    main()
