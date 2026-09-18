# Specification source toolchain

The source is AsciiDoc, built with Metanorma into ISO-formatted PDF, HTML and
semantic XML. `BUILD.md` covers how to run it.

## Constraints from JTC 1 SD-9

The DFDL specification is an ISO Publicly Available Specification, so the rules
for transposing one bound what the toolchain has to do. From JTC 1 Standing
Document 9, *Guide to the Transposition of Publicly Available Specifications
into International Standards*, 6th Edition 2021 [1].

**§6.2.2 — ISO/IEC Directives Part 2 conformance is optional.** PAS submissions
"are not required to comply"; a style close to the ISO template is encouraged.
Metanorma reports Directives violations, and they are advisory here.

**§6.2.5.1 — there is no amendment process.** Maintenance resubmits the whole
document: "there is no provision for minor editing or amendments". ISO-style
margin change bars are therefore not required. Metanorma renders inline
`add:[]` and `del:[]` marks, which serve working group and National Body review.

**§6.2.5.2 — systematic review falls no more than five years after
publication.** ISO/IEC 23415:2024 was published in April 2024, so April 2029.

**§7.3.1 — JTC 1 intends no divergence** between the transposed PAS and the
version published by the originator. Both editions are built from one body for
this reason; see `BUILD.md`.

[1]: https://jtc1info.org/wp-content/uploads/2022/01/SD-9-Guide-to-the-Transposition-of-PAS-2021.pdf
