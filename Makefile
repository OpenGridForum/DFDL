# DFDL specification build.
#
# Metanorma runs inside a pinned Docker image, so nothing needs to be
# installed locally and every build is reproducible.
#
#   make xml       semantic XML only (fast)
#   make html      HTML
#   make pdf       ISO-formatted PDF (slow)
#   make all       pdf + html
#   make editions  `all` for every edition, from one source state
#   make lint      ruff + black over tools/ (host tools, not the container)
#   make check     lint, then the validators in tools/ against the semantic XML
#   make clean     remove build output
#
#   make release VERSION=x.y.z
#                  every edition, rendered from scratch into docs/releases/,
#                  which is committed; build/ is not.
#
# EDITION selects which edition to build; output lands in build/$(EDITION)/.
# Both editions render identically-named artifacts, so they need separate
# directories.
#
#   make EDITION=ogf pdf
#
# ISO's house font (Cambria) is proprietary; --continue-without-fonts lets
# the build fall back to Noto Sans instead of prompting for a licence.
#
# The build also writes a relaton/ bibliography cache at the repo root; it is
# gitignored and kept between builds so references resolve offline.

IMAGE := metanorma/metanorma:alpine-1.17.0
STEM  := dfdl

EDITIONS := iso ogf
EDITION  ?= iso
SPEC_iso := spec/dfdl-iso.adoc
SPEC_ogf := spec/dfdl-ogf.adoc
SPEC     := $(SPEC_$(EDITION))
BUILD    := build/$(EDITION)

# Metanorma names its output after the input file; the artifacts are
# renamed to $(STEM) so both editions land under the same names.
SRCSTEM  := $(basename $(notdir $(SPEC)))

DOCKER   := docker run --rm -v "$(CURDIR):/metanorma" $(IMAGE)
MN_FLAGS := --no-install-fonts --continue-without-fonts

RELEASE  := docs/releases/$(VERSION)

.PHONY: all editions release xml html pdf lint check check-conversion clean

# One pdf pass also emits the HTML and the XML, so `all` is just `pdf`.
all: pdf

# Every edition in one invocation, so both come from the same source state.
editions:
	@for e in $(EDITIONS); do \
		echo "==> $$e"; \
		$(MAKE) --no-print-directory EDITION=$$e all || exit 1; \
	done

xml:  FORMATS := xml
html: FORMATS := xml,html
pdf:  FORMATS := xml,html,pdf

# Metanorma writes its output next to the input file, so move the artifacts
# into $(BUILD)/ afterwards.
xml html pdf:
	@mkdir -p $(BUILD)
	$(DOCKER) metanorma compile -t iso -x $(FORMATS) $(MN_FLAGS) $(SPEC)
	@for f in $(dir $(SPEC))$(SRCSTEM).*; do \
		case "$$f" in *.adoc) continue ;; esac; \
		mv -f "$$f" "$(BUILD)/$(STEM)$${f#$(dir $(SPEC))$(SRCSTEM)}"; \
	done
	@echo "Output in $(BUILD)/"

# A release is committed, so it is rendered from scratch rather than
# published from whatever happens to be left in build/. The edition is part
# of the filename because build/ keeps them apart by directory instead.
release:
	@test -n "$(VERSION)" || { echo "usage: make release VERSION=x.y.z" >&2; exit 1; }
	$(MAKE) --no-print-directory clean
	$(MAKE) --no-print-directory editions
	@mkdir -p $(RELEASE)
	@for e in $(EDITIONS); do \
		for x in pdf html xml; do \
			cp build/$$e/$(STEM).$$x $(RELEASE)/$(STEM)-$$e.$$x || exit 1; \
		done; \
	done
	@echo "Release in $(RELEASE)/"

# ruff and black run on the host, not in the Metanorma container.
lint:
	@if ls tools/*.py >/dev/null 2>&1; then \
		ruff check tools/ && black --check tools/; \
	else \
		echo "No Python in tools/ yet; nothing to lint."; \
	fi

# Runs every executable in tools/, plus any tools/check*.py, over the
# build. Tolerant of tools/ being empty or absent.
check: lint html
	@checkers=$$({ find tools -maxdepth 1 -type f -perm -u+x; \
		ls tools/check*.py; } 2>/dev/null | sort -u); \
	if [ -z "$$checkers" ]; then \
		echo "No validators in tools/ yet; nothing to check."; \
	else \
		for c in $$checkers; do \
			echo "==> $$c"; \
			if [ -x "$$c" ]; then "$$c" $(BUILD)/$(STEM).xml; \
			else python3 "$$c" $(BUILD)/$(STEM).xml; fi || exit 1; \
		done; \
	fi

# Compares the build against the Word source, character for character. This
# proves the conversion; it is not part of `make check`, because a deliberate
# change to the specification is supposed to differ from GFD.240 and would
# fail it correctly. See spec/BUILD.md.
check-conversion: xml
	python3 tools/fidelity-check.py $(BUILD)/$(STEM).xml

clean:
	rm -rf build .ruff_cache
