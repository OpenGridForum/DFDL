<?xml version="1.0" encoding="UTF-8"?>
<!--
  PDF style overrides, layered over the ISO stylesheet.  mn2pdf accepts a
  single override file, so everything we change lives here.

  Ragged right.  GFD.240 sets its body text ragged right, not justified.  The ISO stylesheet
  justifies it, which stretches the spaces around DFDL's long property names
  until they are hard to read, and is worst in the deeply nested lists of
  Appendix F and Appendix G where the measure is already narrow.

  mn2pdf merges this file over the base stylesheet, so each attribute set has
  to repeat the attributes it is not changing or they would be dropped.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:mn="https://www.metanorma.org/ns/standoc">

  <xsl:attribute-set name="p-style">
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="line-height">1.13</xsl:attribute>
    <!--
      List items sit closer together than paragraphs do.  GFD.240 gives a
      bulleted item 3pt above and below where a paragraph gets 6pt after, so
      its lists read as a group rather than as a run of separate paragraphs.
    -->
    <xsl:attribute name="margin-bottom">
      <xsl:choose>
        <xsl:when test="ancestor::*[local-name()='li']">3pt</xsl:when>
        <xsl:otherwise>8pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <!--
      A table row may break across pages, but not straight after the first
      paragraph of a cell: a row that showed only "Enum" before the break
      read as if that were the whole entry.  The keep is a soft one, so a
      cell whose first two paragraphs are taller than a page still breaks.
    -->
    <xsl:attribute name="keep-with-next.within-page">
      <xsl:choose>
        <xsl:when test="parent::*[local-name()='td' or local-name()='th']
                    and not(preceding-sibling::*) and following-sibling::*">5</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="note-style">
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="role">Note</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="margin-top">8pt</xsl:attribute>
    <xsl:attribute name="margin-bottom">12pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="termnote-style">
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="role">Note</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="margin-top">8pt</xsl:attribute>
    <xsl:attribute name="margin-bottom">8pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="example-p-style">
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="margin-top">8pt</xsl:attribute>
    <xsl:attribute name="margin-bottom">8pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="termexample-style">
    <xsl:attribute name="text-align">left</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="margin-top">8pt</xsl:attribute>
    <xsl:attribute name="margin-bottom">8pt</xsl:attribute>
  </xsl:attribute-set>

  <!--
    Keeping a table whole.  Metanorma's keep-lines-together attribute reaches
    the semantic XML, but the ISO stylesheet never reads it on a table, so a
    table splits across pages whatever the source asks for.  The two separator
    suppression matrices in Section 14.2 must not split: their meaning is
    carried by merged regions that span rows, and a page break cuts them in
    half.  This makes the attribute do what it says on a table, and leaves
    every table without it free to break as before.

    The keep is a soft one (a number rather than "always").  FOP honours it
    whenever the table fits on a page; a table that grows taller than a page
    breaks instead of running off the bottom of it, which FOP does with an
    "always" keep it cannot satisfy, dropping the text without failing.

    The separator suppression matrices, which tools/tables.py writes with
    class="never-break", take an "always" keep instead, as a broken matrix
    cannot be read.  One that grows taller than a page runs off it, and make
    pdf fails on that, so it is either whole or the build stops.
  -->
  <xsl:attribute-set name="table-style">
    <xsl:attribute name="keep-together.within-column">
      <xsl:choose>
        <xsl:when test="@class = 'never-break'">always</xsl:when>
        <xsl:when test="@keep-lines-together = 'true'">5</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="table-omit-footer-at-break">true</xsl:attribute>
    <xsl:attribute name="table-layout">fixed</xsl:attribute>
    <xsl:attribute name="border"><xsl:value-of select="$table-border"/></xsl:attribute>
  </xsl:attribute-set>

  <!--
    Keeping a row span whole.  Table 43 is taller than a page, so it has to
    break somewhere, and the break was landing inside a row span: the
    continuation page opened with rows whose Symbol, Presentation and Meaning
    cells were blank, because the cell that carries them had been cut.

    A row that does not cover every column is one such continuation, so it is
    tied to the row above and the break falls between groups instead.  This is
    opt-in per table, with class="keep-row-groups", because the translation
    table in Appendix D has a 23-row span that would not fit on a page at all.
    Like keep-lines-together, the keep is a soft one, so a group that outgrows
    a page breaks rather than overflowing it.

    Every table also keeps its header with its first row, so a table never
    starts at the foot of a page with only its header.

    Every row is kept whole when it fits on a page, so a table breaks between
    rows, where the repeated header and caption read naturally.  A row taller
    than a page still breaks; its cells have no rule at the break, which marks
    the row as continuing on the next page.
  -->
  <xsl:attribute-set name="table-body-row-style" use-attribute-sets="table-row-style">
    <xsl:attribute name="keep-together.within-page">5</xsl:attribute>
    <xsl:attribute name="keep-with-previous.within-page">
      <xsl:choose>
        <xsl:when test="ancestor::*[local-name()='table'][1]/@class = 'keep-row-groups'
                    and (count(*[local-name()='td'][not(@colspan)]) + sum(*[local-name()='td']/@colspan))
                        &lt; count(ancestor::*[local-name()='table'][1]/*[local-name()='colgroup']/*[local-name()='col'])">5</xsl:when>
        <xsl:when test="parent::*[local-name()='tbody'] and not(preceding-sibling::*[local-name()='tr'])">5</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

  <!--
    Closing a table at a page break.  A table that breaks repeats its caption
    row, "Table N (continued)", on the next page.  Metanorma gives that row no
    bottom border, so a table without a header row, or with borderless cells
    like the grammar in Table 3, started the continuation with no top line.
    The caption row now ends with the table's border, which on the first page
    falls on the table's own top line.
  -->
  <!-- upstream: metanorma-iso refine_table-header-title-style sha256:443a1e76c55e2d8cc828d57a9ab93c89e64681ac3297663fb58a72f6e7ccd3fa -->
  <xsl:template name="refine_table-header-title-style">
    <xsl:attribute name="border-left">1pt solid white</xsl:attribute>
    <xsl:attribute name="border-right">1pt solid white</xsl:attribute>
    <xsl:attribute name="border-top">1pt solid white</xsl:attribute>
    <xsl:attribute name="border-bottom"><xsl:value-of select="$table-border"/></xsl:attribute>
  </xsl:template>

  <!--
    Framing code examples.  GFD.240 draws a thin box round its code blocks and
    fills it a light grey: 846 of its 860 code paragraphs carry a half-point
    border on all four sides, and the published PDF renders the inside of the
    box as #F3F3F3 against a white page.  The ISO stylesheet sets neither, so
    the examples ran into the surrounding prose with nothing to mark them off.

    An example that breaks across pages keeps its box: the border and padding
    are retained at the break, so the box closes at the foot of one page and
    reopens at the top of the next.  Each part is given with its length, as
    naming only the conditionality resets the width to FOP's default of 1pt.
    An example with markup inside, such as the coloured bit diagrams, is kept
    whole when it fits on a page; plain examples break between lines (below).
  -->
  <xsl:attribute-set name="sourcecode-style">
    <xsl:attribute name="keep-together.within-column">
      <xsl:choose>
        <xsl:when test="*[not(self::*[local-name()='fmt-name'])]">5</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="border-before-width.length">0.5pt</xsl:attribute>
    <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
    <xsl:attribute name="border-after-width.length">0.5pt</xsl:attribute>
    <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
    <xsl:attribute name="padding-before.length">4pt</xsl:attribute>
    <xsl:attribute name="padding-before.conditionality">retain</xsl:attribute>
    <xsl:attribute name="padding-after.length">4pt</xsl:attribute>
    <xsl:attribute name="padding-after.conditionality">retain</xsl:attribute>
    <xsl:attribute name="background-color">#F3F3F3</xsl:attribute>
    <xsl:attribute name="border">0.5pt solid black</xsl:attribute>
    <xsl:attribute name="padding">4pt</xsl:attribute>
    <xsl:attribute name="white-space">pre</xsl:attribute>
    <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    <xsl:attribute name="role">Code</xsl:attribute>
    <xsl:attribute name="font-family">Courier New, <xsl:value-of select="$font_noto_sans_mono"/></xsl:attribute>
    <xsl:attribute name="margin-bottom">12pt</xsl:attribute>
  </xsl:attribute-set>

  <!--
    Breaking a code example between lines, never leaving a stub.  FOP treats
    each line of a preformatted block as its own paragraph, so widow and
    orphan control does nothing there, and a break could leave one line of an
    example alone at the foot or head of a page.  A plain-text example is
    written one block per line instead, with its first three lines kept
    together and its last three, so an example of up to six lines never
    breaks and a longer one breaks anywhere else.  A blank line becomes a
    no-break space, as an empty block would take no height.

    This replaces metanorma-iso's template for code text and calls its
    add_spaces_to_sourcecode, which inserts the break points for long lines;
    both are fingerprinted.
  -->
  <xsl:variable name="code-min-lines" select="3"/>

  <!-- upstream: metanorma-iso match="mn:sourcecode/text() | mn:sourcecode//mn:span/text()" sha256:be93273d1053d014135f96e0af43f9e9003f7ab2321c7817486ae6d9715c70a3 -->
  <!-- upstream: metanorma-iso add_spaces_to_sourcecode sha256:1b1c03208171f8c52655b5f61c10652921148613b2774e25dd3c756b41743abe -->
  <xsl:template match="mn:sourcecode[not(*[not(self::mn:fmt-name)])]/text()[normalize-space()]" priority="5">
    <xsl:variable name="spaced"><xsl:call-template name="add_spaces_to_sourcecode"/></xsl:variable>
    <xsl:variable name="text">
      <xsl:choose>
        <xsl:when test="substring(string($spaced), string-length(string($spaced))) = '&#10;'">
          <xsl:value-of select="substring(string($spaced), 1, string-length(string($spaced)) - 1)"/>
        </xsl:when>
        <xsl:otherwise><xsl:value-of select="string($spaced)"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:call-template name="code-lines">
      <xsl:with-param name="rest" select="string($text)"/>
      <xsl:with-param name="n" select="1"/>
      <xsl:with-param name="total" select="string-length($text) - string-length(translate($text, '&#10;', '')) + 1"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="code-lines">
    <xsl:param name="rest"/>
    <xsl:param name="n"/>
    <xsl:param name="total"/>
    <xsl:variable name="line">
      <xsl:choose>
        <xsl:when test="contains($rest, '&#10;')"><xsl:value-of select="substring-before($rest, '&#10;')"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$rest"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:block role="SKIP">
      <xsl:if test="$n &lt; $code-min-lines and $n &lt; $total">
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
      </xsl:if>
      <xsl:if test="$n &gt; $total - $code-min-lines + 1 and $n &gt; 1">
        <xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="string-length($line) = 0">&#xA0;</xsl:when>
        <xsl:otherwise><xsl:value-of select="$line"/></xsl:otherwise>
      </xsl:choose>
    </fo:block>
    <xsl:if test="contains($rest, '&#10;')">
      <xsl:call-template name="code-lines">
        <xsl:with-param name="rest" select="substring-after($rest, '&#10;')"/>
        <xsl:with-param name="n" select="$n + 1"/>
        <xsl:with-param name="total" select="$total"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <!--
    Starting each clause on a new page.  GFD.240 sets a page break before 32 of
    its 46 top-level headings; the ones without are front matter and the three
    mandatory clauses that deliberately share a page.  Those three do not sit
    among the numbered clauses here, so every clause at that level takes a break
    except the first.

    Metanorma's own <<< is not usable for this: at the top level it rewrites the
    document into separate page sequences, which collapsed the PDF when tried.
    The break goes on the heading because the clause block is built without an
    attribute set to override, and the test counts clause ancestors rather than
    naming the parent, because by the time this runs the clause has been
    rewrapped and is no longer a child of sections.
  -->
  <xsl:attribute-set name="title-style">
    <xsl:attribute name="font-size">13pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-after">8pt</xsl:attribute>
    <xsl:attribute name="keep-with-next">always</xsl:attribute>
    <xsl:attribute name="break-before">
      <xsl:choose>
        <xsl:when test="count(ancestor::*[local-name()='clause']) = 1
                    and not(ancestor::*[local-name()='preface'])
                    and not(ancestor::*[local-name()='annex'])
                    and parent::*/preceding-sibling::*[local-name()='clause']">page</xsl:when>
        <!--
          GFD.240 also breaks before four headings a level down.  They are named
          rather than matched by rule because nothing distinguishes them from
          their neighbours: the source simply breaks before these four.
        -->
        <xsl:when test="parent::*/@anchor = 'properties-specific-to-number-with-binary-representation'
                     or parent::*/@anchor = 'properties-specific-to-float-double-with-binary-representati'
                     or parent::*/@anchor = 'sequence-groups-with-separators'
                     or parent::*/@anchor = 'encoding-x-dfdl-us-ascii-6-bit-packed'">page</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

  <!--
    Grammar tables without interior rules.  GFD.240 sets its BNF grammars in a
    table that has an outer frame and nothing between the cells, so the
    production rules read as aligned text rather than as a grid.  Marking the
    table class="bnf" drops the cell borders and leaves the frame alone.
  -->
  <xsl:attribute-set name="table-cell-style">
    <xsl:attribute name="display-align">center</xsl:attribute>
    <xsl:attribute name="padding-left">1mm</xsl:attribute>
    <xsl:attribute name="padding-right">1mm</xsl:attribute>
    <xsl:attribute name="padding-top">0.5mm</xsl:attribute>
    <xsl:attribute name="border">
      <xsl:choose>
        <xsl:when test="ancestor::*[local-name()='table'][1]/@class = 'bnf'">none</xsl:when>
        <xsl:otherwise><xsl:value-of select="$table-cell-border"/></xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

  <!--
    Footnotes: one sequence for the whole document, and table footnotes at the
    foot of the page rather than in an extra row at the end of the table.

    GFD.240 numbers every footnote in one run and prints them all at the page
    foot. metanorma-iso letters the ones inside tables, restarts the letters per
    table, and draws them inside the table's own frame.

    Three parts:
      - fn-number renumbers by document order, reusing a number when the same
        footnote is cited twice;
      - the label is rebuilt in update_xml_step1, which is the only pass whose
        output the reference picks up, since the reference is emitted with
        value-of on the label text;
      - the table's own footnote container is dropped so the table stops drawing
        them, and the reference is routed through the page-footnote template
        with footnote_body_from_table, which is the stylesheet's own hook for
        exactly this.
  -->
  <xsl:key name="fn-by-target" match="mn:fn" use="@target"/>

  <xsl:template name="fn-number">
    <xsl:param name="target"/>
    <xsl:variable name="first" select="key('fn-by-target',$target)[1]"/>
    <xsl:value-of select="count($first/preceding::mn:fn[generate-id() = generate-id(key('fn-by-target',@target)[1])]) + 1"/>
  </xsl:template>

  <xsl:template match="mn:fmt-fn-label//mn:sup" mode="update_xml_step1" priority="9">
    <xsl:copy>
      <xsl:call-template name="fn-number">
        <xsl:with-param name="target" select="ancestor::mn:fmt-fn-body/@id | ancestor::mn:fn/@target"/>
      </xsl:call-template>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="mn:fmt-fn-label//mn:span[@class='fmt-label-delim']" mode="update_xml_step1" priority="9"/>


  <!-- render a table footnote as a page footnote; the body is already in $footnotes -->
  <!-- upstream: metanorma-iso fn sha256:cb64b552655189688645a09bdc43ad7fee2b712eeae818701f02c23657082004 -->
  <xsl:template match="mn:fn[ancestor::mn:table][not(ancestor::mn:fmt-name)]" priority="10">
    <xsl:call-template name="fn">
      <xsl:with-param name="footnote_body_from_table" select="'true'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- stop the table drawing them itself -->
  <xsl:template match="mn:table/mn:fmt-footnote-container" mode="update_xml_step1" priority="9"/>


  <!--
    List density.  The 2024 ISO layout sets a 9pt bottom margin on every list
    paragraph followed by another item, inside refine_p-style, after the
    p-style attribute set above has been applied, so the list rule there never
    takes effect.  This is the stylesheet's refine_p-style from metanorma-iso
    3.5.0 (the pinned image), changed at that rule, from 9pt to 3pt, and to
    give the Property Index 3pt between names in place of a table cell's 5pt,
    so the index fits on one page.  make check fails if metanorma-iso's
    original changes.
  -->
  <!-- upstream: metanorma-iso refine_p-style sha256:cf7b88bf4e16df921a40fcbfb63826edfc959434fa76c7ba3fefa21ace7bb554 -->
	<xsl:template name="refine_p-style">
		<xsl:param name="element-name"/>
		<xsl:param name="margin"/>
		<xsl:variable name="layoutVersion">
			<xsl:call-template name="getVariable"><xsl:with-param name="variable">layoutVersion</xsl:with-param></xsl:call-template>
		</xsl:variable>
		<xsl:variable name="revision_date_num">
			<xsl:call-template name="getVariable"><xsl:with-param name="variable">revision_date_num</xsl:with-param></xsl:call-template>
		</xsl:variable>
		<xsl:call-template name="setBlockAttributes">
			<!-- <xsl:with-param name="text_align_default">justify</xsl:with-param> -->
			<xsl:with-param name="skip_text_align_default">true</xsl:with-param>
		</xsl:call-template>

		<xsl:if test="count(ancestor::mn:li) = 1 and not(ancestor::mn:li[1]/following-sibling::mn:li) and not(following-sibling::mn:p)">
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="starts-with(ancestor::mn:table[1]/@type, 'recommend') and not(following-sibling::mn:p)">
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
		</xsl:if>
		<xsl:if test="parent::*[self::mn:td or self::mn:th]">
			<xsl:choose>
				<xsl:when test="not(following-sibling::*)"> <!-- last paragraph in table cell -->
					<xsl:attribute name="margin-bottom">2pt</xsl:attribute>
				</xsl:when>
				<xsl:when test="ancestor::mn:table[1]/@class = 'property-index'"> <!-- DFDL: 3pt, so the Property Index fits on one page -->
					<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="margin-bottom">5pt</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<!-- Special case: if paragraph in 'strong', i.e. it's sub-header, then keeps with next -->
			<xsl:if test="count(node()) = count(mn:strong) and following-sibling::*">
				<xsl:attribute name="keep-with-next">always</xsl:attribute>
			</xsl:if>
		</xsl:if>

		<xsl:copy-of select="@id"/>

		<!-- bookmarks only in paragraph -->
		<xsl:if test="count(mn:bookmark) != 0 and count(*) = count(mn:bookmark) and normalize-space() = ''">
			<xsl:attribute name="font-size">0</xsl:attribute>
			<xsl:attribute name="margin-bottom">0pt</xsl:attribute>
			<xsl:attribute name="line-height">0</xsl:attribute>
		</xsl:if>
		<xsl:if test="$element-name = 'fo:inline'">
			<xsl:attribute name="role">P</xsl:attribute>
		</xsl:if>
		<xsl:if test="ancestor::*[self::mn:li or self::mn:td or self::mn:th or self::mn:dd]">
			<xsl:attribute name="role">SKIP</xsl:attribute>
		</xsl:if>
		<!-- <xsl:apply-templates>
				<xsl:with-param name="split_keep-within-line" select="$split_keep-within-line"/>
			</xsl:apply-templates> -->
		<!-- <xsl:apply-templates select="node()[not(self::mn:note[not(following-sibling::*) or count(following-sibling::*) = count(../mn:note) - 1])]"> -->

		<xsl:if test="$layoutVersion = '1951'">
			<xsl:if test="not(ancestor::*[self::mn:li or self::mn:td or self::mn:th or self::mn:dd])">
				<!-- for paragraphs in the main text -->
				<xsl:choose>
					<xsl:when test="$revision_date_num &lt; 19600101">
						<xsl:attribute name="margin-bottom">14pt</xsl:attribute>
					</xsl:when>
					<xsl:otherwise>
						<xsl:attribute name="margin-bottom">6pt</xsl:attribute>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:if>
			<xsl:if test="(ancestor::mn:preface and parent::mn:clause) or ancestor::mn:foreword">
				<xsl:attribute name="text-indent">7.1mm</xsl:attribute>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$layoutVersion != '2024'">
			<xsl:attribute name="line-height">1.2</xsl:attribute>
			<xsl:if test="ancestor::mn:preface">
				<xsl:attribute name="line-height">1.15</xsl:attribute>
			</xsl:if>
		</xsl:if>

		<xsl:if test="$layoutVersion = '2024'">
			<xsl:if test="parent::mn:li/following-sibling::* or parent::mn:dd">
				<xsl:attribute name="margin-bottom">3pt</xsl:attribute>
			</xsl:if>
		</xsl:if>
		<!-- $namespace = 'iso' -->

	</xsl:template> <!-- refine_p-style -->

</xsl:stylesheet>
