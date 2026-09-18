# Building the specification

Everything is driven from the `Makefile` at the repository root. `TOOLCHAIN.md`
records the ISO constraints the toolchain has to meet; this records how to run
it.

## What you need

Docker, and nothing else, to render the specification: Metanorma runs inside a
container. `make lint` and `make check` additionally use `ruff`, `black` and
Python 3 on the host, because the validators in `tools/` are not part of the
Metanorma image.

## Why the image is pinned

`IMAGE := metanorma/metanorma:alpine-1.17.0`

Metanorma bundles the ISO stylesheets, the XSL-FO renderer and the Relaton
bibliography stack, and their output moves between releases: page breaks shift,
generated numbering changes, and new style warnings appear. Pinning the tag
means a contributor, a reviewer and CI all render the same bytes from the same
source. The same tag is repeated in `.github/workflows/spec.yml`; change both
together.

## Targets

| Target | What it does |
| --- | --- |
| `make xml` | semantic XML only — the fast path, and what the validators read |
| `make html` | XML + HTML |
| `make pdf` | XML + HTML + PDF (slow) |
| `make all` | the same as `make pdf` — one pass emits all three |
| `make editions` | `make all` for every edition |
| `make lint` | `ruff` and `black` over `tools/` |
| `make check` | `lint`, then every validator in `tools/` against the semantic XML |
| `make release VERSION=x.y.z` | versioned deliverables for both editions |
| `make clean` | remove the build output |

`EDITION` selects a single edition, for example `make EDITION=ogf pdf`. It
defaults to `iso`.

## The validators

`make check` runs everything in `tools/` against the build.

| | |
|---|---|
| `link-check.py` | every cross-reference and citation resolves to exactly one target |
| `structure-check.py` | the rendered page says what it means: no sentence naming the wrong figure, no caption stranded, no markup leaking, nothing published that the Word source hides |
| `fidelity-check.py` | the converted text matches the Word source, character for character |

The first two answer questions that stay live for as long as the document is
edited: an erratum can strand a caption or break a reference, and neither shows
up in a diff a reviewer would notice.

`fidelity-check.py` is not one of them, and is not run by `make check`. It
compares the build against the Word source character for character, which proves
the conversion but fails on any deliberate change to the specification: an
erratum is *supposed* to differ from GFD.240. Run it on its own:

    make check-conversion

Never teach it to ignore differences. A fidelity check that has been relaxed is
worse than none, because it still reports PASS.

It keeps a second use. "What has changed since GFD.240?" is a question an ISO
submission has to answer, and this answers it clause by clause.

## The two editions

The specification is published twice: as ISO/IEC 23415 and as OGF GFD.240. The
normative text is identical, so `spec/body.adoc` holds all of it and is included
by both masters — `spec/dfdl-iso.adoc` and `spec/dfdl-ogf.adoc` — which differ only
in document metadata and the front matter they pull in. Editing the body edits
both editions.

Metanorma names its output after its input, and the Makefile renames the
artifacts to a common stem, so the two editions produce identically named files.
They are written to `build/iso/` and `build/ogf/` so neither can silently
overwrite the other. `make editions` renders both in one invocation, which also
guarantees they came from the same source state.

Each build directory holds `dfdl.xml` (semantic XML), `dfdl.presentation.xml`,
`dfdl.html`, `dfdl.pdf`, and the diagnostics: `dfdl.err.html` lists Metanorma's
style and structure warnings and is worth reading when output looks wrong.

## Releases

`build/` is gitignored, because a rendered PDF in every commit would bury the
source changes. Versioned deliverables are committed instead, under
`docs/releases/<VERSION>/`, the same way `docs/current/` holds the Word-era
`.docx`, `.pdf` and `.htm`.

    make release VERSION=1.2.3

The target refuses to run without `VERSION`, cleans, builds both editions from
scratch rather than publishing whatever is left in `build/`, and copies the
deliverables out under names that carry the edition:

    docs/releases/1.2.3/dfdl-iso.pdf   dfdl-iso.html   dfdl-iso.xml
    docs/releases/1.2.3/dfdl-ogf.pdf   dfdl-ogf.html   dfdl-ogf.xml

## Known toolchain issues

**Cambria is proprietary.** ISO's house font cannot be redistributed, so the
build passes `--no-install-fonts --continue-without-fonts` and falls back to
Noto Sans. Font warnings in the log are expected, and line and page breaks in
the local PDF will not match ISO's own typesetting.

**Revision marks need the macro form.** The AsciiDoc role syntax `[.add]#text#`
is silently ignored — no error, no mark, the text just renders plain. Only
`add:[text]` and `del:[text]` produce revision marks.

**The bibliography cache is kept.** Builds write a `relaton/` cache at the
repository root. It is gitignored and reused, so references resolve without
network access after the first build; delete it if a reference looks stale.
