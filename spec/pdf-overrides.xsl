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
  -->
  <xsl:attribute-set name="table-style">
    <xsl:attribute name="keep-together.within-column">
      <xsl:choose>
        <xsl:when test="@keep-lines-together = 'true'">always</xsl:when>
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
  -->
  <xsl:attribute-set name="table-body-row-style" use-attribute-sets="table-row-style">
    <xsl:attribute name="keep-with-previous.within-page">
      <xsl:choose>
        <xsl:when test="ancestor::*[local-name()='table'][1]/@class = 'keep-row-groups'
                    and (count(*[local-name()='td'][not(@colspan)]) + sum(*[local-name()='td']/@colspan))
                        &lt; count(ancestor::*[local-name()='table'][1]/*[local-name()='colgroup']/*[local-name()='col'])">always</xsl:when>
        <xsl:otherwise>auto</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
  </xsl:attribute-set>

  <!--
    Framing code examples.  GFD.240 draws a thin box round its code blocks and
    fills it a light grey: 846 of its 860 code paragraphs carry a half-point
    border on all four sides, and the published PDF renders the inside of the
    box as #F3F3F3 against a white page.  The ISO stylesheet sets neither, so
    the examples ran into the surrounding prose with nothing to mark them off.
  -->
  <xsl:attribute-set name="sourcecode-style">
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
  <xsl:template match="mn:fn[ancestor::mn:table][not(ancestor::mn:fmt-name)]" priority="10">
    <xsl:call-template name="fn">
      <xsl:with-param name="footnote_body_from_table" select="'true'"/>
    </xsl:call-template>
  </xsl:template>

  <!-- stop the table drawing them itself -->
  <xsl:template match="mn:table/mn:fmt-footnote-container" mode="update_xml_step1" priority="9"/>

</xsl:stylesheet>
