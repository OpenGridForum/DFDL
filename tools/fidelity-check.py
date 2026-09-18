"""Fidelity differential for the DFDL spec conversion.

Compares the normalised text inventory of the MS-Word source against the
inventory of the converted Metanorma output and reports *everything* that does
not account for.  This is deliberately a differential, not a search for a
handful of normative phrases: counting occurrences of, say, "It is a Schema
Definition Error" passes happily while an entire property table is dropped.

Scope
-----

The conversion lands one clause at a time, so a whole-document comparison
would drown the real signal in clauses nobody has converted yet.  The built
semantic XML is the authority on what has been converted: a source clause is
compared when the build has a clause with the same title in the same place in
the clause hierarchy.  Sibling clauses may share a title - 25 to 28 are all
"Removed" - and are then paired in document order.

That is the *only* excuse for not comparing something.  A clause the build
has is compared whether or not it carries body text, because a clause that
holds only its subclauses in the build must hold only its subclauses in Word
too, and any Word body text under it is loss.  A clause the build does not
have at all is not yet converted: it is listed, with its word count, and
counted against coverage.  A clause the *build* has and Word does not is an
error - it is content nobody can trace to the source.

Two regions are not clauses and are accounted for on their own terms:

  * the **bibliography**, which Metanorma holds as a set of <bibitem>
    records rather than a run of paragraphs.  It is matched record by record
    against Word's references table: every label, every entry token and
    every URL has to survive.  Aligning it as prose reports the whole clause
    as rewritten and tells nobody anything.

  * the **preamble**, the Word cover page before the first heading.  It has
    no title to pair on and Metanorma generates its own from the document
    metadata, so neither side can be matched to the other.  Both sides are
    printed with their word counts and the Word side counts against
    coverage; this is the one region the check cannot compare, and it says
    so with a number attached.

The coverage figure is accounted-for words over *every* word of the Word
document, so it cannot be improved by narrowing what is looked at.

Three accountings are produced over the compared clauses, because they fail
in different ways:

  1. **Unit alignment** - the two inventories are aligned with
     ``difflib.SequenceMatcher``; unmatched runs are reported as MISSING (in
     source, not in target), ADDED (in target, not in source) or CHANGED (a
     run that was rewritten), each with its clause, the heading it sits under
     and its neighbouring units, so it can be found in either document.

     Alignment runs over typographically folded text, because that is what
     finds the *correspondence* between the two documents reliably.  The
     verdict on each aligned pair is then taken on the strict text, so a pair
     the alignment calls equal is still compared character by character.

  2. **Token accounting** - a multiset difference over every token of every
     converted clause: words *and* punctuation.  This is immune to alignment
     noise: if a table is dropped, its tokens show up here even when the
     surrounding alignment is confused, and material that merely *moved* nets
     out to zero here while showing up as a MISSING/ADDED pair above.

  3. **Character census** - per-character counts of the syntax-significant
     characters on both sides, with deltas.  Unit and token accounting are
     both local; a systematic substitution applied document-wide shows up
     here as a single large asymmetry (``#`` 210 -> 98, ``'`` 2704 -> 149)
     even when no individual difference looks alarming.

Every difference is classified so a reviewer can triage it:

  TYPOGRAPHIC  quote or dash *style* only - ``'`` -> ``’``, ``-`` -> ``–``.
               Correct ISO typesetting.  Warns, never fails.
  REFLOW       the same characters, re-split across a different number of
               units.  Advisory.
  SUBSTITUTION content-bearing characters replaced: ``<=`` -> ``⇐``,
               ``0x55`` -> ``0×55``, ``--`` -> ``—``, a ``#`` dropped out of
               a dfdl:textNumberPattern, a regex left with unbalanced
               parentheses.  Fails.
  STRUCTURAL   text present on one side and absent on the other.  Fails.
  CODE         any difference inside a source block, where the text is the
               normative artefact and nothing about it is cosmetic.  Fails.

Exit status is non-zero on SUBSTITUTION, STRUCTURAL and CODE, on any clause
whose token accounting does not balance, on any build clause that pairs with
nothing in Word, and on any bibliography reference whose label, text or URLs
do not survive.  TYPOGRAPHIC and REFLOW differences are reported and warned
about, but pass.

**Normalisation modes.**  The gate runs strict: only Unicode NFC, whitespace
collapse and zero-width removal, because those are the only things that
genuinely must differ between a .docx and Metanorma XML.  ``--relaxed``
restores the older behaviour, which additionally folds smart quotes, dash
variants and ellipses on *both* sides before comparing.  Relaxed is useful
for finding structural loss without typographic noise, and that is all it is
for: folding both sides means a target that replaced 2,555 apostrophes,
turned every ``--`` into an em dash and every ``<=`` into ``⇐`` compares
identical to its source.  The count of units that relaxed normalisation would
have called identical, and strict does not, is printed either way.

Text the renderer generates rather than carries is removed from both sides
before comparing: Word's caption paragraphs carry the "Table 7" that
Metanorma numbers for itself, a reference to a table or a figure carries the
same number in the sentence around it, and Word resolves "on page ii"
against a pagination Metanorma does over again.  A reference to a *clause*
is compared, not removed: both documents number the clauses the same way,
and the inventory writes an ``<xref>`` out as the number of the clause it
points at.

Exit status: 0 only when every converted clause and every reference accounts
for its source text, 1 when anything is unaccounted for, 2 on usage errors.

Usage:
    tools/fidelity-check.py TARGET.xml                 # source defaults to the
                                                       # .docx below
    tools/fidelity-check.py SOURCE.docx TARGET.xml
    tools/fidelity-check.py SOURCE.docx TARGET.xml --clause 7
    tools/fidelity-check.py SOURCE.docx TARGET.xml --summary
    tools/fidelity-check.py SOURCE.docx TARGET.xml --relaxed   # advisory only

The one-argument form exists so that ``make check``, which runs every
executable in tools/ with the semantic XML as its only argument, invokes this
as a validator.

SOURCE/TARGET may also be inventory .tsv files previously written by
tools/text-inventory.py, which is useful for large runs.
"""

from __future__ import annotations

import argparse
import collections
import contextlib
import difflib
import importlib.util
import re
import sys
from dataclasses import dataclass, field
from pathlib import Path

MAX_LINE = 160

# The source of truth for the conversion.
DEFAULT_SOURCE = (
    Path(__file__).resolve().parent.parent
    / "docs"
    / "current"
    / "draft-gwdrp-dfdl-v1.2.2-GFD-R-P.240-ISO-23415.docx"
)


def load_inventory_module():
    """Import the sibling text-inventory.py (its name is not importable)."""
    path = Path(__file__).resolve().with_name("text-inventory.py")
    if not path.exists():
        raise SystemExit(f"cannot find {path}")
    spec = importlib.util.spec_from_file_location("dfdl_text_inventory", path)
    if spec is None or spec.loader is None:
        raise SystemExit(f"cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    sys.modules[spec.name] = module
    # Do not leave a tools/__pycache__ behind in the checkout.
    previous = sys.dont_write_bytecode
    sys.dont_write_bytecode = True
    try:
        spec.loader.exec_module(module)
    finally:
        sys.dont_write_bytecode = previous
    return module


INV = load_inventory_module()

# Regions that are not clauses and so are accounted for on their own terms:
# the Word cover page, which precedes the first heading and therefore has no
# title to pair on, and the bibliography, which is a set of records rather
# than a run of paragraphs.  Everything else, the numbered front-matter
# regions included, is a clause and goes through the clause machinery.
PREAMBLE = "front"
BIBLIOGRAPHY = "bib"
PSEUDO_SECTIONS = {PREAMBLE, BIBLIOGRAPHY}


def clip(text: str, width: int = MAX_LINE) -> str:
    if len(text) <= width:
        return text
    return text[: width - 3] + "..."


# --------------------------------------------------------------------------
# Clause structure
# --------------------------------------------------------------------------


@dataclass
class Section:
    """One numbered clause of either document, with its own body text."""

    number: str
    title: str
    level: int
    heading: object
    parent: str | None = None
    children: list[str] = field(default_factory=list)
    body: list = field(default_factory=list)

    @property
    def units(self) -> list:
        return [self.heading] + self.body

    def words(self) -> int:
        return sum(len(INV.words(unit.text)) for unit in self.units)


def build_sections(units) -> dict[str, Section]:
    """Group an inventory into its clauses, keeping document order."""
    sections: dict[str, Section] = {}
    for unit in units:
        number = unit.section
        if number in PSEUDO_SECTIONS:
            continue
        if unit.kind.startswith("heading") and number not in sections:
            sections[number] = Section(
                number=number,
                title=unit.text,
                level=int(unit.kind[-1]),
                heading=unit,
            )
        elif number in sections:
            sections[number].body.append(unit)
    for number, section in sections.items():
        parent = number
        while "." in parent:
            parent = parent.rsplit(".", 1)[0]
            if parent in sections:
                section.parent = parent
                sections[parent].children.append(number)
                break
    return sections


def roots(sections: dict[str, Section]) -> list[str]:
    return [n for n, s in sections.items() if s.parent is None]


def title_key(title: str) -> str:
    """Match clause titles across the two documents.

    Titles are folded typographically here on purpose: a heading whose
    apostrophe was restyled is still the same heading, and refusing to pair it
    would drop the whole clause out of scope - which would hide far more than
    the restyling does.  The pairing is a locator, not the verdict; the units
    underneath are still compared strictly.
    """
    return " ".join(INV.typographic_fold(title).casefold().split())


def match_sections(source: dict[str, Section], target: dict[str, Section]):
    """Pair target clauses with source clauses by title, level by level.

    A clause is matched only underneath a matched parent, so the same title
    appearing in two unrelated parts of the spec cannot cross-match.  Among
    siblings, titles need not be unique: repeats are paired in document
    order, the n-th target clause of a given title to the n-th source clause
    of that title.  Clauses 25 to 28 are four siblings all titled "Removed"
    with identical bodies, and refusing to pair them would put 44 words of
    the spec beyond the reach of the check.
    """
    pairs: list[tuple[str | None, str]] = []

    def descend(src_children: list[str], tgt_children: list[str]) -> None:
        by_title: dict[str, collections.deque[str]] = {}
        for number in src_children:
            key = title_key(source[number].title)
            by_title.setdefault(key, collections.deque()).append(number)
        for number in tgt_children:
            candidates = by_title.get(title_key(target[number].title))
            if not candidates:
                pairs.append((None, number))
                continue
            match = candidates.popleft()
            pairs.append((match, number))
            descend(source[match].children, target[number].children)

    descend(roots(source), roots(target))
    return pairs


def scope(source: dict[str, Section], target: dict[str, Section]):
    """Split the two documents into what is compared and what is not.

    Every pair is compared, including a pair whose build clause carries only
    a heading.  A clause that holds nothing but its subclauses in Word must
    hold nothing but its subclauses in the build, and if Word has body text
    the build has dropped, that is loss and has to be reported as loss.
    Treating an empty build clause as "not converted yet" is how seven
    annexes went unchecked while the gate passed.

    Returns the compared pairs, the source clauses that have no build clause
    at all - the conversion has not reached them - and the build's own
    clauses that answer to no source clause.
    """
    pairs = match_sections(source, target)
    compared = [(src, tgt) for src, tgt in pairs if src is not None]
    unmatched_target = [tgt for src, tgt in pairs if src is None]
    done = {src for src, _ in compared}
    skipped = [number for number in source if number not in done]
    return compared, skipped, unmatched_target


# --------------------------------------------------------------------------
# Bibliography
# --------------------------------------------------------------------------

# Word writes a reference as a two-cell table row: "[ASN1]" and the entry.
# Metanorma holds a <bibitem> whose <docidentifier> the inventory writes back
# in brackets, so both sides carry the label in front of the entry.
LABEL_RE = re.compile(r"^\[([^\[\]\s]+)\]\s*(.*)$")
URL_RE = re.compile(r"\b(?:https?|ftp)://[^\s<>\"“”\[\]]+")
URL_TRAILING = ".,;:)”\"'"


@dataclass
class Reference:
    label: str
    text: str

    def tokens(self) -> collections.Counter:
        return collections.Counter(INV.tokens(INV.typographic_fold(self.text)))

    def urls(self) -> set[str]:
        return {url.rstrip(URL_TRAILING) for url in URL_RE.findall(self.text)}


def target_references(units) -> list[Reference]:
    """The built bibliography, one Reference per <bibitem>."""
    found = []
    for unit in units:
        if unit.section != BIBLIOGRAPHY or unit.kind != "bibitem":
            continue
        match = LABEL_RE.match(unit.text)
        if match:
            found.append(Reference(match.group(1), match.group(2)))
        else:
            found.append(Reference("", unit.text))
    return found


def source_references(section: Section) -> list[Reference]:
    """The Word references clause, one Reference per label cell.

    Word's bibliography is a table, so the entry is whatever follows the
    label cell up to the next label cell.
    """
    found: list[Reference] = []
    for unit in section.body:
        match = LABEL_RE.match(unit.text)
        if match and not match.group(2):
            found.append(Reference(match.group(1), ""))
        elif found:
            found[-1].text = f"{found[-1].text} {unit.text}".strip()
    return found


def find_reference_section(
    source: dict[str, Section], skipped: list[str], labels: set[str]
) -> str | None:
    """Which source clause the build turned into its bibliography.

    The clause is found by its content, not by its number: it is the one
    among the clauses with no build clause of their own that carries the most
    of the build's reference labels as label cells of its own.
    """
    best, best_score = None, 0
    for number in skipped:
        score = sum(
            1
            for reference in source_references(source[number])
            if reference.label in labels
        )
        if score > best_score:
            best, best_score = number, score
    return best


@dataclass
class BibliographyReport:
    section: str | None = None
    matched: int = 0
    missing: list[str] = field(default_factory=list)
    added: list[str] = field(default_factory=list)
    differing: list[tuple[str, collections.Counter, collections.Counter]] = field(
        default_factory=list
    )
    lost_urls: list[tuple[str, list[str]]] = field(default_factory=list)

    @property
    def failures(self) -> int:
        return (
            len(self.missing)
            + len(self.added)
            + len(self.differing)
            + len(self.lost_urls)
        )

    @property
    def accounted(self) -> bool:
        return self.section is not None and not self.failures


def check_bibliography(
    source: dict[str, Section], skipped: list[str], target_units
) -> BibliographyReport:
    """Account for every Word reference in the built <bibitem> set.

    A bibliography is a set of records, not a run of paragraphs: Metanorma
    sorts it, splits each entry into a label and a formatted reference, and
    regenerates the brackets.  Aligning it as prose therefore reports the
    whole clause as rewritten and tells nobody anything.  Matching label to
    label, and then requiring the entry text and every URL in it to survive,
    is the accounting that fits the shape.
    """
    report = BibliographyReport()
    built = target_references(target_units)
    if not built:
        return report
    report.section = find_reference_section(
        source, skipped, {reference.label for reference in built}
    )
    if report.section is None:
        report.missing = sorted(reference.label for reference in built)
        return report

    original = {
        reference.label: reference
        for reference in source_references(source[report.section])
    }
    seen = set()
    for reference in built:
        if reference.label not in original:
            report.added.append(reference.label or "(no label)")
            continue
        seen.add(reference.label)
        want = original[reference.label]
        lost, gained = want.tokens() - reference.tokens(), (
            reference.tokens() - want.tokens()
        )
        if lost or gained:
            report.differing.append((reference.label, lost, gained))
        missing_urls = sorted(want.urls() - reference.urls())
        if missing_urls:
            report.lost_urls.append((reference.label, missing_urls))
        report.matched += 1
    report.missing = sorted(set(original) - seen)
    return report


def print_bibliography(report: BibliographyReport, source, out) -> None:
    print("\nBIBLIOGRAPHY (Word references against the built <bibitem> set):", file=out)
    if report.section is None:
        if report.missing:
            print(
                f"  ERROR: the build has {len(report.missing)} reference(s) that "
                "answer to no source clause",
                file=out,
            )
            print(f"      {clip(' '.join(report.missing), 200)}", file=out)
        else:
            print("  none - the build carries no bibliography yet", file=out)
        return
    title = clip(source[report.section].title, 40)
    print(
        f"  source {report.section:<8} -> build bibliography  "
        f"{report.matched} reference(s) matched by label  {title}",
        file=out,
    )
    for label in report.missing:
        print(f"  ERROR: [{label}] is in Word and not in the build", file=out)
    for label in report.added:
        print(f"  ERROR: [{label}] is in the build and not in Word", file=out)
    for label, lost, gained in report.differing:
        print(f"  ERROR: [{label}] does not account for its Word entry", file=out)
        if lost:
            print(
                f"      lost   ({sum(lost.values())}): "
                f"{clip(' '.join(sorted(lost.elements())), 160)}",
                file=out,
            )
        if gained:
            print(
                f"      gained ({sum(gained.values())}): "
                f"{clip(' '.join(sorted(gained.elements())), 160)}",
                file=out,
            )
    for label, urls in report.lost_urls:
        print(f"  ERROR: [{label}] has lost {len(urls)} URL(s)", file=out)
        for url in urls:
            print(f"      {clip(url)}", file=out)
    if not report.failures:
        print("  every label, entry and URL accounted for", file=out)


# --------------------------------------------------------------------------
# Generated text
# --------------------------------------------------------------------------

# "Section 11.2.1", "Table 7", "Appendix A" and friends.  Word writes the
# label it resolved a cross-reference to and Metanorma writes its own -
# "Section 11" against "Clause 11" - so the label goes from both sides.
REFERENCE_WORDS = "Section|Clause|Subclause|Annex|Appendix|Table|Figure"
REFERENCE_NUMBER = r"(?:[0-9]+|[A-Z])(?:\.[0-9A-Za-z]+)*(?:-[0-9A-Za-z]+)?"
REFERENCE_RE = re.compile(
    rf"\b(?P<word>{REFERENCE_WORDS})s?\s+(?P<number>{REFERENCE_NUMBER})"
    rf"(?![0-9A-Za-z])",
    re.IGNORECASE,
)

# Tables and figures are the two things Word and Metanorma number in
# different sequences, so their numbers go along with the label.  Clause and
# annex numbers are the same in both, and are compared rather than removed.
RENUMBERED_LABELS = {"table", "figure"}

CAPTION_LABEL_RE = re.compile(rf"^(?:Table|Figure)\s+({REFERENCE_NUMBER})[.:]?\s+")

# What is left of "See section 12.1.2." once the number has gone.  An
# AsciiDoc cross-reference may or may not have the word in front of it, so
# the word alone, with nothing after it, is numbering too.
ORPHAN_REFERENCE_RE = re.compile(
    rf"\b({REFERENCE_WORDS}|page)\s*(?=[,.;:)\]]|$)", re.IGNORECASE
)

# Word's page-number fields.  Metanorma paginates for itself, so "on page ii"
# resolves on one side only; the number goes and the orphaned word after it.
PAGE_NUMBER_RE = re.compile(r"\b(page)\s+([0-9]+|[ivxlcdm]+)\b", re.IGNORECASE)

# Headings carry clause titles, not references, and code is compared verbatim.
LITERAL_KINDS = {"code"}


class Generated:
    """Removes renderer-generated numbering and reference text."""

    def __init__(self, sections: dict[str, Section], units) -> None:
        self.titles = {n: title_key(s.title) for n, s in sections.items()}
        self.clause_numbers = set(sections)
        for unit in units:
            if unit.kind != "caption":
                continue
            label = CAPTION_LABEL_RE.match(unit.text)
            if label:
                self.titles[label.group(1)] = title_key(unit.text[label.end() :])

    def strip(self, kind: str, text: str) -> str:
        if kind.startswith("heading") or kind in LITERAL_KINDS:
            return text
        if kind == "caption":
            # The caption keeps its own title; only Word's number goes.
            return CAPTION_LABEL_RE.sub("", text).strip()
        stripped = PAGE_NUMBER_RE.sub(r"\1", REFERENCE_RE.sub(self.strip_label, text))
        return " ".join(ORPHAN_REFERENCE_RE.sub("", stripped).split())

    def strip_label(self, match: re.Match) -> str:
        """What is left of a reference once the renderer's label has gone.

        The number stays where the two documents number the thing the same
        way, so that it is compared rather than taken on trust.  A table or a
        figure is renumbered, and so is a reference Word resolved against its
        own numbering of the annexes, and those numbers go with the label.
        """
        word, number = match.group("word").lower(), match.group("number")
        if word in RENUMBERED_LABELS or number not in self.clause_numbers:
            return ""
        return number


def comparable(units, generated: Generated) -> list[str]:
    return [generated.strip(unit.kind, unit.text) for unit in units]


# --------------------------------------------------------------------------
# Accounting
# --------------------------------------------------------------------------


def word_counter(texts) -> collections.Counter:
    counter: collections.Counter = collections.Counter()
    for text in texts:
        counter.update(INV.words(text))
    return counter


def token_counter(texts) -> collections.Counter:
    """Multiset of every token - words *and* punctuation characters.

    The old accounting counted only ``[A-Za-z0-9]`` runs, so ``#``, ``<``,
    ``>``, ``=``, ``|``, ``\\``, ``%``, ``'`` and ``"`` were invisible to it:
    a target that turned ``"#,##,##0"`` into ``",,0"`` balanced perfectly.
    Tokens are typographically folded, so pure ISO restyling still nets out to
    zero and only content-bearing punctuation moves the needle.
    """
    counter: collections.Counter = collections.Counter()
    for text in texts:
        counter.update(INV.tokens(text))
    return counter


def split_counter(counter: collections.Counter):
    """Split a token multiset into its word part and its punctuation part."""
    words: collections.Counter = collections.Counter()
    symbols: collections.Counter = collections.Counter()
    for token, count in counter.items():
        if token[0].isalnum():
            words[token] = count
        else:
            symbols[token] = count
    return words, symbols


def align(source_texts, target_texts):
    """Return the alignment opcodes between two lists of comparable texts."""
    matcher = difflib.SequenceMatcher(None, source_texts, target_texts, autojunk=False)
    return matcher.get_opcodes()


def clause_ledger(compared, source, target, gen_src, gen_tgt):
    """Per-clause token multiset difference; part of the exit status."""
    ledger = []
    for src, tgt in compared:
        src_tokens = token_counter(comparable(source[src].units, gen_src))
        tgt_tokens = token_counter(comparable(target[tgt].units, gen_tgt))
        ledger.append((src, tgt, src_tokens - tgt_tokens, tgt_tokens - src_tokens))
    return ledger


# --------------------------------------------------------------------------
# Classification
# --------------------------------------------------------------------------

TYPOGRAPHIC = "TYPOGRAPHIC"
REFLOW = "REFLOW"
SUBSTITUTION = "SUBSTITUTION"
STRUCTURAL = "STRUCTURAL"
CODE = "CODE"

# Only these fail the build.  Smart quotes in prose are correct ISO
# typesetting, and a paragraph re-split across two units has lost nothing.
FAILING = (SUBSTITUTION, STRUCTURAL, CODE)
CLASSES = (TYPOGRAPHIC, REFLOW, SUBSTITUTION, STRUCTURAL, CODE)

# Glyphs a "prettifier" leaves behind, mapped back to the ASCII they replaced.
# Undoing these on both sides tells a substitution apart from a rewrite: if
# the two sides agree once the glyphs are expanded, the only thing that
# happened is that ASCII source syntax was turned into typographic symbols -
# which for a spec full of ``<=``, ``->`` and ``0x55`` is corruption.
SUBSTITUTIONS = {
    "⇐": "<=",  # leftwards double arrow
    "⇒": "=>",  # rightwards double arrow
    "⇔": "<=>",  # left right double arrow
    "←": "<-",  # leftwards arrow
    "→": "->",  # rightwards arrow
    "↔": "<->",  # left right arrow
    "≤": "<=",  # less-than or equal
    "≥": ">=",  # greater-than or equal
    "≠": "!=",  # not equal
    "×": "x",  # multiplication sign (0x55 -> 0x55)
    "—": "--",  # em dash (-- -> em dash)
    "–": "-",  # en dash
    "…": "...",  # horizontal ellipsis
    "•": "*",  # bullet
}

_SUBSTITUTION_TABLE = {ord(glyph): ascii_ for glyph, ascii_ in SUBSTITUTIONS.items()}


def unsubstitute(text: str) -> str:
    """Expand typographic symbols back into the ASCII they stand in for."""
    return text.translate(_SUBSTITUTION_TABLE)


def canonical(text: str) -> str:
    """Fully de-prettified text: substitutions expanded, then quotes folded."""
    return INV.typographic_fold(unsubstitute(text))


def classify(source_text: str, target_text: str, is_code: bool) -> tuple[str, str]:
    """Classify one difference.  Returns (class, one-line reason)."""
    if source_text == target_text:
        return "", ""
    detail = _classify_detail(source_text, target_text)
    if is_code:
        return CODE, f"inside a source block; {detail[1]}"
    return detail


def _classify_detail(source_text: str, target_text: str) -> tuple[str, str]:
    if INV.typographic_fold(source_text) == INV.typographic_fold(target_text):
        return TYPOGRAPHIC, "quote/dash style only"
    if canonical(source_text) == canonical(target_text):
        return SUBSTITUTION, "ASCII syntax replaced by a typographic symbol"
    src_words = collections.Counter(INV.words(source_text))
    tgt_words = collections.Counter(INV.words(target_text))
    if src_words == tgt_words:
        return SUBSTITUTION, "punctuation differs, words identical"
    return STRUCTURAL, "text present on one side and absent on the other"


@dataclass
class Difference:
    """One classified difference, with everything needed to find it."""

    kind: str
    reason: str
    section: str
    heading: str
    unit_kind: str
    source_text: str
    target_text: str
    hidden_by_relaxed: bool = False

    @property
    def fails(self) -> bool:
        return self.kind in FAILING


def is_code_unit(*units) -> bool:
    return any(unit is not None and unit.kind == "code" for unit in units)


def char_edits(source_text: str, target_text: str, limit: int = 6) -> list[str]:
    """The differing character runs, with a little context, for triage."""
    matcher = difflib.SequenceMatcher(None, source_text, target_text, autojunk=False)
    edits: list[str] = []
    for tag, i1, i2, j1, j2 in matcher.get_opcodes():
        if tag == "equal":
            continue
        left = source_text[max(0, i1 - 12) : i1]
        right = source_text[i2 : i2 + 12]
        edits.append(
            f"...{left}[{source_text[i1:i2]}]{right}... -> "
            f"...{left}[{target_text[j1:j2]}]{right}..."
        )
        if len(edits) >= limit:
            edits.append("...")
            break
    return edits


# --------------------------------------------------------------------------
# Reporting
# --------------------------------------------------------------------------


def collect_differences(
    opcodes, src_units, tgt_units, src_texts, tgt_texts, src_pairs, tgt_pairs
):
    """Every classified difference between the two aligned inventories.

    ``opcodes`` come from the typographically folded alignment; the texts
    passed in are the *strict* ones, so a run the alignment calls ``equal`` is
    still compared character by character here.  That is where the differences
    the old checker reported as identical units live.

    ``src_pairs``/``tgt_pairs`` give the compared clause each unit belongs to,
    so a unit that merely moved within its own clause - Word puts a table
    caption after the table, Metanorma puts the name first - can be told apart
    from one that vanished.
    """
    differences: list[Difference] = []
    deleted: list[int] = []
    inserted: list[int] = []

    def add(src_index, tgt_index, source_text, target_text, hidden, missing=False):
        src_unit = src_units[src_index] if src_index is not None else None
        tgt_unit = tgt_units[tgt_index] if tgt_index is not None else None
        anchor = src_unit or tgt_unit
        code = is_code_unit(src_unit, tgt_unit)
        if missing:
            # A whole unit present on one side only is structural by
            # definition, whatever its text happens to be made of.
            side = "source" if src_index is not None else "target"
            kind = CODE if code else STRUCTURAL
            reason = f"a whole unit exists only in the {side}"
        else:
            kind, reason = classify(source_text, target_text, code)
        if not kind:
            return
        differences.append(
            Difference(
                kind=kind,
                reason=reason,
                section=anchor.section,
                heading=heading_before(
                    src_units, src_index if src_index is not None else 0
                ),
                unit_kind=anchor.kind,
                source_text=source_text,
                target_text=target_text,
                hidden_by_relaxed=hidden,
            )
        )

    for tag, i1, i2, j1, j2 in opcodes:
        if tag == "equal":
            for offset in range(i2 - i1):
                src_index, tgt_index = i1 + offset, j1 + offset
                if src_texts[src_index] != tgt_texts[tgt_index]:
                    add(
                        src_index,
                        tgt_index,
                        src_texts[src_index],
                        tgt_texts[tgt_index],
                        True,
                    )
        elif tag == "delete":
            deleted.extend(range(i1, i2))
        elif tag == "insert":
            inserted.extend(range(j1, j2))
        elif (i2 - i1) == (j2 - j1):
            for offset in range(i2 - i1):
                add(
                    i1 + offset,
                    j1 + offset,
                    src_texts[i1 + offset],
                    tgt_texts[j1 + offset],
                    False,
                )
        else:
            # A run re-split across a different number of units: judge the
            # joined text, so a pure reflow does not read as lost content.
            joined_src = " ".join(src_texts[i1:i2])
            joined_tgt = " ".join(tgt_texts[j1:j2])
            if joined_src == joined_tgt:
                differences.append(
                    Difference(
                        kind=REFLOW,
                        reason=f"{i2 - i1} source unit(s) re-split as {j2 - j1}",
                        section=src_units[i1].section,
                        heading=heading_before(src_units, i1),
                        unit_kind=src_units[i1].kind,
                        source_text=joined_src,
                        target_text=joined_tgt,
                    )
                )
            else:
                add(i1, j1, joined_src, joined_tgt, False)

    # A unit that left one place and reappeared unchanged in the same clause
    # moved; it did not go missing.  Matching is on the exact strict text and
    # the same compared clause, and the per-clause token accounting still
    # catches anything that migrated between clauses.
    available: dict[tuple[int, str], list[int]] = {}
    for tgt_index in inserted:
        available.setdefault((tgt_pairs[tgt_index], tgt_texts[tgt_index]), []).append(
            tgt_index
        )
    matched_targets: set[int] = set()
    for src_index in deleted:
        key = (src_pairs[src_index], src_texts[src_index])
        candidates = available.get(key)
        if candidates:
            tgt_index = candidates.pop()
            matched_targets.add(tgt_index)
            differences.append(
                Difference(
                    kind=REFLOW,
                    reason="moved within its clause, text unchanged",
                    section=src_units[src_index].section,
                    heading=heading_before(src_units, src_index),
                    unit_kind=src_units[src_index].kind,
                    source_text=src_texts[src_index],
                    target_text=tgt_texts[tgt_index],
                )
            )
            continue
        add(src_index, None, src_texts[src_index], "", False, missing=True)
    for tgt_index in inserted:
        if tgt_index not in matched_targets:
            add(None, tgt_index, "", tgt_texts[tgt_index], False, missing=True)
    return differences


def count_classes(differences) -> collections.Counter:
    counter: collections.Counter = collections.Counter()
    for difference in differences:
        counter[difference.kind] += 1
    return counter


def print_census(src_texts, tgt_texts, opcodes, out) -> int:
    """Per-character counts of the syntax-significant characters, with deltas.

    Unit and token accounting are both local.  A substitution applied across
    the whole document shows up here, and only here, as one large asymmetry.
    Returns the number of characters whose counts do not match.
    """
    src_counts = INV.census(src_texts)
    tgt_counts = INV.census(tgt_texts)
    print("\nCHARACTER CENSUS over the compared clauses:", file=out)
    print(
        f"  {'char':<8} {'source':>8} {'target':>8} {'delta':>8}   name",
        file=out,
    )
    mismatched = 0
    for label, chars in INV.CENSUS_GROUPS:
        rows = []
        for char in dict.fromkeys(chars):
            source, target = src_counts[char], tgt_counts[char]
            if not source and not target:
                continue
            delta = target - source
            if delta:
                mismatched += 1
            name = INV.CHAR_NAMES.get(char, "")
            flag = "  <== asymmetric" if delta else ""
            rows.append(
                f"  {char!r:<8} {source:>8} {target:>8} {delta:>+8}   {name}{flag}"
            )
        if rows:
            print(f"  -- {label}", file=out)
            for row in rows:
                print(row, file=out)
    if not mismatched:
        print("  every census character balances", file=out)
    print_delimiter_balance(src_texts, tgt_texts, opcodes, out)
    return mismatched


DELIMITERS = (("(", ")"), ("[", "]"), ("{", "}"))


def unbalanced(text: str) -> list[str]:
    """Delimiter pairs that do not close in ``text``."""
    return [
        f"{opener}{closer}"
        for opener, closer in DELIMITERS
        if text.count(opener) != text.count(closer)
    ]


def print_delimiter_balance(src_texts, tgt_texts, opcodes, out) -> None:
    """Aligned units whose brackets balance in the source but not the target.

    A normative regex or expression that lost a parenthesis is still made of
    the same words, so only a character-level look finds it.
    """
    broken = []
    for tag, i1, i2, j1, j2 in opcodes:
        if tag not in ("equal", "replace") or (i2 - i1) != (j2 - j1):
            continue
        for offset in range(i2 - i1):
            source_text = src_texts[i1 + offset]
            target_text = tgt_texts[j1 + offset]
            pairs = unbalanced(target_text)
            if pairs and not unbalanced(source_text):
                broken.append((target_text, pairs))
    if not broken:
        print(
            "  delimiters: every aligned unit closes its brackets as the "
            "source does",
            file=out,
        )
        return
    print(
        f"  delimiters: {len(broken)} unit(s) unbalanced in the target only:",
        file=out,
    )
    for target_text, pairs in broken[:10]:
        print(f"    {' '.join(pairs)}  {clip(target_text, 110)}", file=out)


def print_classified(
    differences, out, limit: int, gate_hidden: bool, detail: bool = True
) -> None:
    """The classified differences, worst class first."""
    counts = count_classes(differences)
    print("\nCLASSIFIED DIFFERENCES:", file=out)
    for name in CLASSES:
        verdict = "FAILS" if name in FAILING else "warns"
        print(f"  {name:<13} {counts.get(name, 0):>6}   {verdict}", file=out)
    hidden = [d for d in differences if d.hidden_by_relaxed]
    if hidden:
        note = "advisory under --relaxed" if gate_hidden else "counted above"
        print(
            f"\n  {len(hidden)} of these sit in units the *relaxed* alignment "
            f"calls identical\n  ({note}): "
            f"{dict(count_classes(hidden))}",
            file=out,
        )

    if not detail:
        return
    # Worst first, so a truncated report still shows what actually fails.
    rank = {CODE: 0, STRUCTURAL: 1, SUBSTITUTION: 2, TYPOGRAPHIC: 3, REFLOW: 4}
    ranked = sorted(differences, key=lambda d: rank.get(d.kind, 99))
    for shown, difference in enumerate(ranked, start=1):
        if limit and shown > limit:
            print(
                f"\n  ... {len(ranked) - shown + 1} further classified "
                f"difference(s) suppressed (--max-report {limit})",
                file=out,
            )
            break
        advisory = " [relaxed-identical]" if difference.hidden_by_relaxed else ""
        print(
            f"\n  {difference.kind}{advisory} - clause {difference.section} "
            f"({difference.unit_kind}) - {difference.reason}",
            file=out,
        )
        print(f"      under: {clip(difference.heading, 100)}", file=out)
        if difference.kind in (TYPOGRAPHIC, SUBSTITUTION, CODE) or (
            difference.source_text and difference.target_text
        ):
            for edit in char_edits(difference.source_text, difference.target_text):
                print(f"      {clip(edit, 150)}", file=out)
        else:
            print(f"    - {clip(difference.source_text, 150)}", file=out)
            print(f"    + {clip(difference.target_text, 150)}", file=out)


def heading_before(units, index: int) -> str:
    for probe in range(min(index, len(units) - 1), -1, -1):
        unit = units[probe]
        if unit.kind.startswith("heading"):
            return f"{unit.section} {unit.text}"
    return "(front matter)"


def context_lines(units, start: int, stop: int, count: int) -> tuple[list, list]:
    before = units[max(0, start - count) : start]
    after = units[stop : min(len(units), stop + count)]
    return before, after


def span(start: int, stop: int) -> str:
    """Human-readable inventory range; an empty range names the insert point."""
    if stop <= start:
        return f"units none (position {start})"
    if stop - start == 1:
        return f"unit {start}"
    return f"units {start}..{stop - 1}"


def describe_block(units, start, stop, indent="      ") -> list[str]:
    lines = []
    for unit in units[start:stop]:
        lines.append(f"{indent}[{unit.section} {unit.kind}] {clip(unit.text)}")
    return lines


def report_difference(
    number, tag, source, target, i1, i2, j1, j2, context, out
) -> None:
    if tag in ("delete", "replace"):
        anchor_units, anchor_start, anchor_stop = source, i1, i2
    else:
        anchor_units, anchor_start, anchor_stop = target, j1, j2
    label = {
        "delete": "MISSING  (in source, absent from target)",
        "insert": "ADDED    (in target, absent from source)",
        "replace": "CHANGED  (rewritten between source and target)",
    }[tag]
    if anchor_start < len(anchor_units):
        section = anchor_units[anchor_start].section
    else:
        section = "?"
    print(f"\n[{number}] {label}", file=out)
    print(f"      clause {section} | under: {heading_before(source, i1)}", file=out)
    print(
        f"      source {span(i1, i2)} | target {span(j1, j2)}",
        file=out,
    )

    before, after = context_lines(anchor_units, anchor_start, anchor_stop, context)
    for unit in before:
        print(f"    . {clip(unit.text, 110)}", file=out)
    if tag in ("delete", "replace"):
        for line in describe_block(source, i1, i2, indent=""):
            print(f"    - {clip(line, 150)}", file=out)
    if tag in ("insert", "replace"):
        for line in describe_block(target, j1, j2, indent=""):
            print(f"    + {clip(line, 150)}", file=out)
    for unit in after:
        print(f"    . {clip(unit.text, 110)}", file=out)

    if tag == "replace":
        # Tokens, not words: a run whose only change was "#,##,##0" -> ",,0"
        # used to print "same words - reflowed only" and be waved through.
        src_tokens = INV.tokens(" ".join(u.text for u in source[i1:i2]))
        tgt_tokens = INV.tokens(" ".join(u.text for u in target[j1:j2]))
        lost = collections.Counter(src_tokens) - collections.Counter(tgt_tokens)
        gained = collections.Counter(tgt_tokens) - collections.Counter(src_tokens)
        if lost:
            print(
                f"      tokens only in source ({sum(lost.values())}): "
                f"{clip(' '.join(sorted(lost.elements())), 200)}",
                file=out,
            )
        if gained:
            print(
                f"      tokens only in target ({sum(gained.values())}): "
                f"{clip(' '.join(sorted(gained.elements())), 200)}",
                file=out,
            )
        if not lost and not gained:
            print(
                "      (same tokens - reflowed, re-split or restyled only)",
                file=out,
            )


def print_scope(compared, skipped, unmatched, source, target, out):
    """Say exactly which clauses were and were not put through the gate."""
    print("\nIN SCOPE (converted, compared against the Word source):", file=out)
    if not compared:
        print("  none - the build carries no converted clause body yet", file=out)
    for src, tgt in compared:
        print(
            f"  source {src:<8} -> build {tgt:<8} "
            f"{source[src].words():>6} words  {clip(source[src].title, 60)}",
            file=out,
        )

    print(
        "\nSKIPPED - NOT YET CONVERTED (present in Word, absent from the build):",
        file=out,
    )
    partial = {INV.top_level(src) for src, _ in compared}
    grouped: dict[str, list[str]] = {}
    for number in skipped:
        grouped.setdefault(INV.top_level(number), []).append(number)
    for clause in sorted(grouped, key=clause_order):
        members = grouped[clause]
        words = sum(source[n].words() for n in members)
        title = source[clause].title if clause in source else ""
        if clause in partial:
            print(f"  clause {clause:<6} {words:>6} words  {clip(title, 60)}", file=out)
            for number in members:
                print(
                    f"      {number:<10} {source[number].words():>6} words  "
                    f"{clip(source[number].title, 56)}",
                    file=out,
                )
        else:
            print(
                f"  clause {clause:<6} {words:>6} words  {clip(title, 60)} "
                f"({len(members)} subclauses)",
                file=out,
            )

    if not skipped:
        print("  none - every clause of the Word source is in the build", file=out)

    if unmatched:
        print(
            "\nUNACCOUNTED FOR (in the build, answering to no source clause):",
            file=out,
        )
        for number in unmatched:
            print(
                f"  ERROR: build {number:<8} pairs with nothing in Word  "
                f"{clip(target[number].title, 50)}",
                file=out,
            )


def print_preamble(source_units, target_units, out) -> int:
    """Account for the material in front of the first heading.

    Word's cover page - the title, the notes to editors, the status,
    copyright and abstract - precedes every heading, so it has no title to
    pair on and cannot be a clause.  Metanorma builds its own from the
    document metadata.  Neither side can be matched to the other, so both
    are counted and printed rather than dropped: this is the one region the
    check cannot compare, and it says so with a number attached.
    """
    src = [unit for unit in source_units if unit.section == PREAMBLE]
    tgt = [unit for unit in target_units if unit.section == PREAMBLE]
    src_words = sum(len(INV.words(unit.text)) for unit in src)
    tgt_words = sum(len(INV.words(unit.text)) for unit in tgt)
    print(
        "\nPREAMBLE (before the first heading, so outside the clause tree):", file=out
    )
    print(
        f"  Word cover page        {src_words:>6} words in {len(src)} unit(s)"
        "  - not converted; the title,\n"
        "                                                 "
        "notes to editors, status and\n"
        "                                                 "
        "copyright live in the metadata",
        file=out,
    )
    print(
        f"  build front matter     {tgt_words:>6} words in {len(tgt)} unit(s)"
        "  - generated from that metadata",
        file=out,
    )
    return src_words


def clause_order(clause: str):
    return (clause != PREAMBLE, clause.isalpha(), clause.zfill(3))


def print_coverage(compared, source, bibliography, unbalanced, preamble_words, out):
    """Every source word, and whether the check accounted for it.

    The denominator is the whole Word document, cover page and references
    included, so the figure cannot be improved by narrowing what is looked
    at.  Words count as accounted for only when their clause balanced token
    for token, or when the bibliography check matched every label, entry and
    URL.  A clause that was compared and did not balance is a shortfall like
    any other: reaching a clause is not the same as accounting for it.
    """
    accounted: collections.Counter = collections.Counter()
    total: collections.Counter = collections.Counter()
    for number, section in source.items():
        total[INV.top_level(number)] += section.words()
    total[PREAMBLE] += preamble_words
    for src, _ in compared:
        if src not in unbalanced:
            accounted[INV.top_level(src)] += source[src].words()
    if bibliography.accounted:
        section = bibliography.section
        accounted[INV.top_level(section)] += source[section].words()

    print("\nCoverage by source clause (accounted-for words / total):", file=out)
    for clause in sorted(total, key=clause_order):
        share = 100.0 * accounted[clause] / total[clause] if total[clause] else 0.0
        name = "preamble" if clause == PREAMBLE else clause
        note = "" if share == 100.0 else "  <== not accounted for in full"
        print(
            f"  clause {name:<6} {accounted[clause]:>7} / {total[clause]:>7}"
            f"  {share:5.1f}%{note}",
            file=out,
        )
    grand_accounted = sum(accounted.values())
    grand_total = sum(total.values())
    share = 100.0 * grand_accounted / grand_total if grand_total else 0.0
    print(
        f"  {'TOTAL':<13} {grand_accounted:>7} / {grand_total:>7}  {share:5.1f}%"
        "   of the whole Word document",
        file=out,
    )
    return grand_accounted, grand_total


def print_summary(
    src_units, tgt_units, src_texts, tgt_texts, opcodes, out, paths, mode
):
    src_tokens = token_counter(src_texts)
    tgt_tokens = token_counter(tgt_texts)
    lost_words, lost_symbols = split_counter(src_tokens - tgt_tokens)
    gained_words, gained_symbols = split_counter(tgt_tokens - src_tokens)
    src_words, _ = split_counter(src_tokens)
    tgt_words, _ = split_counter(tgt_tokens)

    missing_units = sum(i2 - i1 for tag, i1, i2, _, _ in opcodes if tag == "delete")
    added_units = sum(j2 - j1 for tag, _, _, j1, j2 in opcodes if tag == "insert")
    changed_src = sum(i2 - i1 for tag, i1, i2, _, _ in opcodes if tag == "replace")
    changed_tgt = sum(j2 - j1 for tag, _, _, j1, j2 in opcodes if tag == "replace")
    relaxed_equal = sum(i2 - i1 for tag, i1, i2, _, _ in opcodes if tag == "equal")
    strict_equal = 0
    for tag, i1, i2, j1, _ in opcodes:
        if tag != "equal":
            continue
        for offset in range(i2 - i1):
            if src_texts[i1 + offset] == tgt_texts[j1 + offset]:
                strict_equal += 1

    print("=" * 72, file=out)
    print(f"DFDL conversion fidelity summary  [{mode} normalisation]", file=out)
    print("=" * 72, file=out)
    print(f"  source              : {paths[0]}", file=out)
    print(f"  target              : {paths[1]}", file=out)
    print(f"  source units        : {len(src_units)}", file=out)
    print(f"  target units        : {len(tgt_units)}", file=out)
    print(
        f"  identical (strict)  : {strict_equal}"
        f"{share_of(strict_equal, len(src_units))}  <- the honest number",
        file=out,
    )
    print(
        f"  identical (relaxed) : {relaxed_equal}"
        f"{share_of(relaxed_equal, len(src_units))}  <- typography folded away",
        file=out,
    )
    print(
        f"  hidden by relaxed   : {relaxed_equal - strict_equal} "
        "unit(s) that differ character by character but that relaxed\n"
        "                        normalisation calls identical",
        file=out,
    )
    print(f"  missing units       : {missing_units}", file=out)
    print(f"  added units         : {added_units}", file=out)
    print(
        f"  changed units       : {changed_src} source / {changed_tgt} target",
        file=out,
    )
    print(f"  source words        : {sum(src_words.values())}", file=out)
    print(f"  target words        : {sum(tgt_words.values())}", file=out)
    print(
        f"  words only in src   : {sum(lost_words.values())} "
        f"({len(lost_words)} distinct)  <- content actually lost",
        file=out,
    )
    print(
        f"  words only in tgt   : {sum(gained_words.values())} "
        f"({len(gained_words)} distinct)  <- content actually added",
        file=out,
    )
    print(
        f"  punctuation only src: {sum(lost_symbols.values())} "
        f"({len(lost_symbols)} distinct)  <- syntax characters dropped",
        file=out,
    )
    print(
        f"  punctuation only tgt: {sum(gained_symbols.values())} "
        f"({len(gained_symbols)} distinct)  <- syntax characters introduced",
        file=out,
    )
    print(
        "  note                : punctuation counts are typographically folded, "
        "so a smart\n                        quote costs nothing here and "
        "'--' -> em dash costs one '-'.",
        file=out,
    )
    return {
        "lost": lost_words + lost_symbols,
        "gained": gained_words + gained_symbols,
        "strict_equal": strict_equal,
        "relaxed_equal": relaxed_equal,
    }


def share_of(part: int, whole: int) -> str:
    if not whole:
        return ""
    return f"  ({100.0 * part / whole:5.1f}% of source units)"


def print_ledger(ledger, out) -> int:
    """Print the per-clause verdict and return the number of failing clauses."""
    failures = 0
    print("\nPer-clause token accounting over the converted clauses:", file=out)
    for src, tgt, lost, gained in ledger:
        if not lost and not gained:
            print(f"  clause {src:<8} -> {tgt:<8} accounted for", file=out)
            continue
        failures += 1
        print(f"  clause {src:<8} -> {tgt:<8} UNACCOUNTED FOR", file=out)
        if lost:
            print(
                f"      lost   ({sum(lost.values())}): "
                f"{clip(' '.join(sorted(lost.elements())), 200)}",
                file=out,
            )
        if gained:
            print(
                f"      gained ({sum(gained.values())}): "
                f"{clip(' '.join(sorted(gained.elements())), 200)}",
                file=out,
            )
    return failures


# --------------------------------------------------------------------------
# Entry point
# --------------------------------------------------------------------------


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Fidelity differential for the DFDL spec conversion.",
    )
    parser.add_argument(
        "paths",
        nargs="+",
        metavar="[SOURCE] TARGET",
        help=(
            "TARGET alone (source defaults to the .docx under docs/current/), "
            "or SOURCE TARGET. Either may be a .tsv inventory."
        ),
    )
    parser.add_argument(
        "--clause",
        help="only check these top-level source clauses, e.g. --clause 7 or 7,12",
    )
    parser.add_argument(
        "--summary",
        action="store_true",
        help="print counts only, no per-difference detail",
    )
    parser.add_argument(
        "--max-report",
        type=int,
        default=40,
        help="maximum number of differences to detail (default 40, 0 = all)",
    )
    parser.add_argument(
        "--context",
        type=int,
        default=1,
        help="units of surrounding context per difference (default 1)",
    )
    parser.add_argument(
        "--no-changed",
        action="store_true",
        help="only detail MISSING/ADDED runs, skip CHANGED ones",
    )
    parser.add_argument(
        "--top-words",
        type=int,
        default=25,
        help="how many unaccounted-for tokens to list (default 25)",
    )
    parser.add_argument(
        "--relaxed",
        action="store_true",
        help=(
            "advisory mode: fold smart quotes, dash variants and ellipses on "
            "both sides before judging a unit, so only structural loss is "
            "gated.  Useful, but it cannot see typographic corruption - do "
            "not use it as the gate."
        ),
    )
    parser.add_argument(
        "--no-census",
        action="store_true",
        help="skip the per-character census",
    )
    parser.add_argument("-o", "--output", help="write the report here")
    args = parser.parse_args(argv)
    mode = "relaxed" if args.relaxed else "strict"

    if len(args.paths) == 1:
        source_path, target_path = str(DEFAULT_SOURCE), args.paths[0]
        if not DEFAULT_SOURCE.exists():
            print(f"error: default source {DEFAULT_SOURCE} not found", file=sys.stderr)
            return 2
    elif len(args.paths) == 2:
        source_path, target_path = args.paths
    else:
        parser.error("give TARGET, or SOURCE and TARGET")

    # Always read strictly.  Relaxed text is strict text with the typographic
    # fold applied, so one read carries both accountings and the two inventories
    # are guaranteed to be unit-for-unit the same.
    try:
        source_units = INV.read_any(source_path, mode="strict")
        target_units = INV.read_any(target_path, mode="strict")
    except FileNotFoundError as error:
        print(f"error: {error}", file=sys.stderr)
        return 2

    source = build_sections(source_units)
    target = build_sections(target_units)
    compared, skipped, unmatched = scope(source, target)
    bibliography = check_bibliography(source, skipped, target_units)
    if bibliography.section is not None:
        skipped = [number for number in skipped if number != bibliography.section]
    if args.clause:
        wanted = {part.strip() for part in args.clause.split(",") if part.strip()}
        compared = [p for p in compared if INV.top_level(p[0]) in wanted]

    gen_src = Generated(source, source_units)
    gen_tgt = Generated(target, target_units)

    src_units = [unit for src, _ in compared for unit in source[src].units]
    tgt_units = [unit for _, tgt in compared for unit in target[tgt].units]
    # Which compared clause each unit came from, for move detection.
    src_pairs = [
        pair for pair, (src, _) in enumerate(compared) for _ in source[src].units
    ]
    tgt_pairs = [
        pair for pair, (_, tgt) in enumerate(compared) for _ in target[tgt].units
    ]
    src_texts = comparable(src_units, gen_src)
    tgt_texts = comparable(tgt_units, gen_tgt)
    # Alignment runs on folded text - that is what finds the correspondence
    # between the two documents; the verdict below is taken on src_texts.
    src_folded = [INV.typographic_fold(text) for text in src_texts]
    tgt_folded = [INV.typographic_fold(text) for text in tgt_texts]

    # The ledger decides the coverage figure as well as the exit status, so it
    # is settled before anything is printed.
    ledger = clause_ledger(compared, source, target, gen_src, gen_tgt)
    unbalanced = {src for src, _, lost, gained in ledger if lost or gained}

    with contextlib.ExitStack() as stack:
        out = sys.stdout
        if args.output:
            out = stack.enter_context(open(args.output, "w", encoding="utf-8"))
        opcodes = align(src_folded, tgt_folded)
        stats = print_summary(
            src_units,
            tgt_units,
            src_texts,
            tgt_texts,
            opcodes,
            out,
            (source_path, target_path),
            mode,
        )
        print_scope(compared, skipped, unmatched, source, target, out)
        print_bibliography(bibliography, source, out)
        preamble_words = print_preamble(source_units, target_units, out)
        accounted, source_words = print_coverage(
            compared, source, bibliography, unbalanced, preamble_words, out
        )

        census_delta = 0
        if not args.no_census:
            census_delta = print_census(src_texts, tgt_texts, opcodes, out)

        differences = collect_differences(
            opcodes, src_units, tgt_units, src_texts, tgt_texts, src_pairs, tgt_pairs
        )
        gated = [
            difference
            for difference in differences
            if not (args.relaxed and difference.hidden_by_relaxed)
        ]
        classified_failures = [d for d in gated if d.fails]
        print_classified(
            differences,
            out,
            args.max_report,
            gate_hidden=args.relaxed,
            detail=not args.summary,
        )

        failures = print_ledger(ledger, out)

        if not args.summary:
            shown = 0
            for tag, i1, i2, j1, j2 in opcodes:
                if tag == "equal":
                    continue
                if tag == "replace" and args.no_changed:
                    continue
                shown += 1
                if args.max_report and shown > args.max_report:
                    print(
                        f"\n... further differences suppressed "
                        f"(--max-report {args.max_report}); rerun with "
                        f"--max-report 0 or --clause N",
                        file=out,
                    )
                    break
                report_difference(
                    shown, tag, src_units, tgt_units, i1, i2, j1, j2, args.context, out
                )

            if args.top_words:
                for title, counter in (
                    ("Tokens present in source but not in target", stats["lost"]),
                    ("Tokens present in target but not in source", stats["gained"]),
                ):
                    if not counter:
                        continue
                    print(f"\n{title} (top {args.top_words}):", file=out)
                    for word, count in counter.most_common(args.top_words):
                        print(f"  {count:>5}  {word!r}", file=out)

        counts = count_classes(gated)
        warnings = counts.get(TYPOGRAPHIC, 0) + counts.get(REFLOW, 0)
        print(file=out)
        if warnings:
            print(
                f"WARNING: {counts.get(TYPOGRAPHIC, 0)} typographic and "
                f"{counts.get(REFLOW, 0)} reflow difference(s).  Smart quotes in "
                "prose are\n         correct ISO typesetting; these do not fail "
                "the check.",
                file=out,
            )
        if census_delta:
            print(
                f"WARNING: {census_delta} syntax character(s) do not balance "
                "across the two sides;\n         see the character census above.",
                file=out,
            )
        reasons = []
        if classified_failures:
            detail = ", ".join(
                f"{counts[name]} {name}" for name in FAILING if counts.get(name)
            )
            reasons.append(f"{len(classified_failures)} difference(s) - {detail}")
        if failures:
            reasons.append(
                f"{failures} clause(s) whose token accounting does not balance"
            )
        if unmatched:
            reasons.append(
                f"{len(unmatched)} build clause(s) that pair with nothing in Word: "
                + ", ".join(unmatched)
            )
        if bibliography.failures:
            reasons.append(
                f"{bibliography.failures} bibliography reference(s) unaccounted for"
            )
        if reasons:
            print(f"RESULT: FAIL - {'; '.join(reasons)}.", file=out)
            if args.relaxed:
                print(
                    "        (--relaxed is advisory; the gate is the default "
                    "strict mode.)",
                    file=out,
                )
        else:
            unconverted = source_words - accounted
            print(
                f"RESULT: PASS - {len(compared)} clause(s) and "
                f"{bibliography.matched} reference(s) account for\n"
                f"        {accounted} of {source_words} source words: "
                "everything the build converts,\n"
                f"        to the character.  {unconverted} word(s) are not "
                "converted yet and are\n        listed above"
                f"{'; --relaxed is advisory' if args.relaxed else ''}.",
                file=out,
            )

    return 1 if reasons else 0


if __name__ == "__main__":
    sys.exit(main())
