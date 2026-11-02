# The Word-era specification

Until 2026 the DFDL specification was written in MS-Word. It is now written in
AsciiDoc under [`spec/`](https://github.com/OpenGridForum/DFDL/tree/master/spec),
which is the only source to edit. The files here are kept as the record and
are not changed.

Every edition here specifies DFDL v1.0. The numbers in the file names, 1.0.8 to
1.2.2, count revisions of the document, not versions of the language.

| File | What it is |
| ---- | ---------- |
| `gwdrp-dfdl-v1.0.8-GFD-R-P.240.docx`, `.pdf` | GFD.240 dated February 2021. Superseded by v1.0.9. |
| `gwdrp-dfdl-v1.0.9-GFD-R-P.240.docx`, `.pdf` | GFD.240 as updated June 2023, the current published edition. The PDF is identical to the one on [ogf.org](https://www.ogf.org/documents/GFD.240.pdf). |
| `gwdrp-dfdl-v1.1.0-GFD-R-P.240.docx`, `-A4.docx`, `-A4.pdf` | v1.0.9 with its tracked changes accepted, January 2024. The `-A4` files are the same text on A4 paper. |
| `draft-gwdrp-dfdl-v1.2.2-GFD-R-P.240-ISO-23415.docx`, `.pdf`, `.htm` | An update in preparation, January 2026, not published. The AsciiDoc was converted from this file. |
| `Word_template_for_ISO_standards.dotx` | The ISO template for Word editions. The AsciiDoc build applies the ISO format itself. |
| `conversion/docx2adoc.py` | The converter that turned the draft into AsciiDoc. |

The HTML pages of v1.0.8 and v1.0.9 are still in
[`docs/current/`](../../current/), because public links point at them.

## The conversion

The draft was converted once, in
[#90](https://github.com/OpenGridForum/DFDL/pull/90), and the specification has
been edited in AsciiDoc since, including the review in
[#92](https://github.com/OpenGridForum/DFDL/pull/92). The converter refuses to
write into `spec/`, so it can't overwrite those edits; it can still reproduce
its output somewhere else.

`make check-conversion` compares the build against the draft, character for
character. Every change made since the conversion shows up as a difference, so
it fails once the text has been edited, and its report lists what has changed
since the draft.
