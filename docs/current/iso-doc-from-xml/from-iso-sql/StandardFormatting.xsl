<?xml version="1.0" encoding="utf-8"?>
<!--
                                                                                                   1
         1         2         3         4         5         6         7         8         9         0
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
-->

<!--
     Copyright © 1999, 2000, 2002, 2005, 2010, 2028, 2019, 2020, 2021 Jim Melton
     Copyright © 2021, 2022, 2023, 2024 Editors of ISO/IEC JTC 1/SC 32/WG 3:
                 Jim Melton, Stephen Cannan, Jörn Bartels, Stefan Plantikow
                 (Granted by Jim Melton, 2021-10-21)
-->

<!-- 
====================================================================================================
StandardFormatting.xsl
 
  This stylesheet does most of the element formatting for the (parts) of standards, technical
  reports, and technical corrigenda maintained by WG3.
  It is invoked from StandardMaster.xsl for standards and technical reports and 
  from TCMaster for the TCs.
====================================================================================================
-->

<!--
====================================================================================================
      SEE REMARKS ABOUT KNOWN BUGS IN THIS STYLESHEET IN COMMENTS AT THE END OF THIS FILE
====================================================================================================
-->

<!--
====================================================================================================

This stylesheet renders the standard documents into XSL Formatting Objects (XSL-FO), suitable
for rendering into printable formats, such as PDF.
It presumes an XSLT 2.0 processing engine, but does not require XML schema awareness.

XSL FO version taken into account (XSL 1.1):
    http://www.w3.org/TR/2006/REC-xsl11-20061205/
XSLT version required (XSLT 2.0):
    https://www.w3.org/TR/2021/REC-xslt20-20210330/

Author: Jim Melton
© Jim Melton, 2002, 2004, 2006, 2007, 2008, 2009, 2010, 2019, 2020, 2021
© Editors of ISO/IEC JTC 1/SC 32/WG 3, 2021, 2022, 2023, 2024

====================================================================================================

====================================================================================================
CHANGE HISTORY: 
Earliest versions:                                  (lost in history): Jim Melton; 2001-??-??
Up to date with DTD v0.7                                      (v0.7): Jim Melton; 2003-04-19
Fixed various spacing errors                                  (v0.7.1): Jim Melton; 2003-04-21
Generation of Annex A                                         (v0.7.2): Jim Melton; 2003-04-27
Miscellaneous fixes                                           (v0.7.3): Jim Melton; 2003-06-15
Editor Notes (PPs, LOs)                                       (v0.8): Jim Melton; 2003-12-11
Technical Corrigenda                                          (v0.9): S.Cannan/J.Melton; 2004-02-20
Add para references                                           (v0.91): Jim Melton; 2004-05-01
Split standard+TC XSLT                                        (v0.92): J.Melton/S.Cannan; 2004-05-25
Declare V1.0                                                  (v1.0): J.Melton/S.Cannan; 2004-05-28
Do not print tcSource unless WDCOR                            (v1.01): S.Cannan; 2004-06-06
Correct numbering of definitions                              (v1.02): S.Cannan; 2004-06-13
Fix page header/footer                                        (v1.03): Jim Melton; 2004-06-24
Compensate for XEP 4 &nbsp chg                                (v1.04): Jim Melton; 2004-12-20
Support changebars per XSLFO 1.1                              (v1.05): Jim Melton; 2005-03-25
More changebar support in tables                              (v1.06): Jim Melton; 2005-05-27
Fixed mergeInstr for Desc.                                    (v1.07): Jim Melton; 2005-06-29
Fixed id gen for BNFdef/def'n                                 (v1.08): Jim melton; 2005-07-09
Support id attribute for table-row-number element, support 
  specref mode on table-row-number                            (v1.09): Jim Melton; 2005-12-28
Support bibliography+children                                 (v1.10): Jim Melton; 2006-01-05
Support tcSymarg/tcSymparam                                   (v1.11): S. Cannan;  2006-01-09
specref, etc. reports errors                                  (v1.12): Jim Melton; 2006-07-19
Automate "modified by" stuff, de-support modifiedByPart elem,
  No longer redefine variable partno in various templates     (v1.13): Jim Melton; 2006-09-04
Define SCsignature and applySC, inc. symreturn/symresult      (v1.14): Jim Melton; 2006-09-20
Part title on Scope in bold; generate Annex 
  normative/informative indicator in ToC, Indent notes        (v1.15): Jim Melton; 2007-05-04
Modify applySC so it does not output final period             (v1.16): Jim melton; 2007-06-28
Fix SCsignature xform to look for symresult, not symret       (v1.17): Jim Melton; 2007-07-27
Improve indexing: definition, newterm, others                 (v1.18): Jim Melton; 2007-08-09
Use keys for transforming specref elements                    (v1.19): Jim Melton; 2008-06-25
Allow for indented code-type elements & "labeled" lists       (v1.20): Jim Melton; 2008-10-01
Add lblwidth attribute to lbllist lists                       (v1.21): M Ashworth; 2008-10-14
Change <feature> processing so it is an empty element and the
  "name" of the feature is gotten automatically from the 
  table                                                       (v1.22): Jim Melton; 2009-01-09
Fix/enhanced templates for SCsignature, applySC, etc.         (v1.23): Jim Melton; 2009-06-2x
Fix ToC for Annexes to put "(informative)" before title       (v1.24): Jim Melton; 2010-08-30
BNF in clauseHeadings of subclauses referenced by extref and
  tableHeads of tables referenced by extref is now hotlinked. (v1.25): Jim Melton; 2010-09-01
Support alternate copyright page (INCITS) + refs to biblio    (v1.26): Jim Melton; 2011-05-12
Add white-space-treatment="preserve" to fo:block on params    (v1.27): Jim Melton; 2011-07-07
Add bibref, normativeReference[s],normRefTitle, normRefDescr,
  normRefref                                                  (v1.28): Jim Melton; 2011-11-11
Add support for sjkw (SQL/JSON key word)                      (v1.29): Jim Melton; 2014-07-22
Add support for docref                                        (v1.30): Jim Melton; 2014-08-02
Change the spelling of "rational"to "rationale" in the TC     (v1.31): Stephen Cannan; 2018-10-10
Change TCFrontMatterPage to include references,               
  Add support for SCsignature in TC                           (v1.32): Stephen Cannan; 2018-10-10
Replace buildDate in build-type.entities with current-date()  (v1.33): Stephen Cannan; 2018-10-13
Replace handling of normativeReference and normRefRef elements(v1.34): Jim Melton; 2019-01-30
Replace Times as the primary font for documents with Cambria 
  per ISO/CS                                                  (v1.35): Jim Melton; 2019-02-16
In several places, change "[ISO9075-4]" to "ISO/IEC 9075-4"d 
  per ISO/CS                                                  (v1.36): Jim Melton; 2019-02-22
Further enhance handling of normativeReference and normRefRef 
  elements                                                    (v1.37): Jim Melton; 2019-02-23
Add paragraph names                                           (v1.38): Stefan Plantikow; 2019-09-26
Add predicative attribute to BNFdef                           (v1.39): Stefan Plantikow; 2019-09-26
Overhaul biblio-entry for ISO 690 conformance                 (v1.40): Jim Melton; 2020-01-28
Support font-related markup in clauseHeading elements         (v1.41): Jim Melton; 2020-02-05
Add phrase highlighting with new elements                     (v1.42): Stefan Plantikow; 2020-02-17
  phrase, passage, repeatdefn, repeatpassage                
Add repeatdefn param for conditional formatting of defnrefs   (v1.43): Stefan Plantikow; 2021-05-03
Move figures to subdirectory                                  (v1.44): Stefan Plantikow; 2021-08-04
Reorganize order of keys, templates, et al                    (v1.45): Jim Melton; 2021-08-29
Turn off bnf elts listing                                     (v1.46): S.Plantikow; 2022-03-23
Add repeatitem                                                (v1.47): S.Plantikow; 2022-05-25
Add LO status = active | deferred                             (v1.48): S.Plantikow; 2022-06-16
Add since to LOs                                              (v1.49): S.Plantikow; 2022-06-17
Changed mergewith boxes back to black                         (v1.50): J.Bartels; 2022-06-19
Removed mergeinstr                                            (v1.51): J.Bartels; 2022-06-19
Added "called from" to Subclauses with signatures             (v1.52): Jim Melton; 2022-09-08
Avoid double dots in bibliographic references                 (v1.53): S.Plantikow; 2022-09-28
Dont highlight defnrefs outside Clause 3                      (v1.54): S.Plantikow; 2023-02-28
Add padding-before and padding-after to figures               (v1.55): S.Plantikow; 2023-10-14
=================================================================================================== 
-->

<!-- We immediately bring in the entity file containing character entity definitions.           -->
<!-- We also define filenames for four variants of copyright notice page, included later.       -->
<!DOCTYPE xsl:stylesheet [
  <!-- Include the definition of character entities -->
  <!-- This file has no official standing; Jim found it in 2001 by
       searching for a starting point for character entity defs.     -->
  <!ENTITY % winansi SYSTEM "./winansi.entities">
  %winansi;
  <!ENTITY regCopyrightStage2or3 SYSTEM "./copyrightRegularStage2or3.xml">
  <!ENTITY regCopyrightStage4or5 SYSTEM "./copyrightRegularStage4or5.xml">
  <!ENTITY altCopyrightStage2or3 SYSTEM "./copyrightAlternateStage2or3.xml">
  <!ENTITY altCopyrightStage4or5 SYSTEM "./copyrightAlternateStage4or5.xml">
]>

<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:m="http://www.w3.org/1998/Math/MathML">


<!--
===================================================================================================
===================================================================================================
The following variable definitions are used to capture fixed data that might be used at any
place within this stylesheet. 
===================================================================================================
===================================================================================================
-->

<xsl:variable name="space.thinspace.width">
  <xsl:text>0.2em</xsl:text>
</xsl:variable>


<!--
===================================================================================================
===================================================================================================
The following key definitions are used by XSLT to improve performance; they provide the ability to
directly identify the elements/attributes that they match without doing repeated document scans
===================================================================================================
===================================================================================================
-->

<!--
    Define a key for definition so we can easily find all instances of each instance
-->
<xsl:key name="definition-by-name-key" match="//definition/term" use="string()"/>

<!--
    Define a key for BNFdef so we can easily find all instances of each BNF definition
-->
<xsl:key name="BNFdef-by-name-key"
         match="//Format/grammar/BNFdef | //Properties/grammar/BNFdef" use="@name"/>

<!--
    Define a key for BNF so we can easily find all instances of each use of a given BNF definition 
-->
<xsl:key name="BNF-by-name-key" match="//BNF" use="@name"/>

<!--
    Define a key for kw so we can easily find all instances of each keyword
-->
<xsl:key name="kw-by-name-key" match="//kw" use="string()"/>

<!--
    Define a key for sjkw so we can easily find all instances of each keyword
-->
<xsl:key name="sjkw-by-name-key" match="//sjkw" use="string()"/>

<!--
    Define a key for newterm so we can easily find all instances of each unique nerterm
-->
<xsl:key name="newterm-by-name-key" match="//newterm" use="string()"/>

<!--
    Define a key for indexTerm so we can easily find all instances of each instance
-->
<xsl:key name="indexTerm-by-name-key" match="//indexTerm" use="string()"/>

<!--
    Define a key for feature so we can easily find all instances of each feature
-->
<xsl:key name="feature-by-name-key" match="//feature" use="@code"/>

<!--
    Define a key for class so we can easily find all instances of each condition class
-->
<!-- NEW VERSION 2020-06-07 -->
<xsl:key name="class-by-code-key" match="//raise/@class" use="string()"/>

<!--
    Define a key for subclass so we can easily find all instances of each condition subclass
-->
<!-- NEW VERSION 2020-06-07 -->
<xsl:key name="subclass-by-code-key" match="//raise/@subclass" use="string()"/>

<!--
    This key allows us to find <entry> elements by the first letter of their sort keys 
-->
<xsl:key name="entries" match="//entry"
         use="translate(substring(text/@sortby,1,1), 'abcdefghijklmnopqrstuvwxyz', 
             'ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>


<!--
===================================================================================================
===================================================================================================
==  In XSLT, all templates are evaluated in some "mode"; if no mode is specified, then the mode  ==
==  used is the default (or unspecified) mode.                                                   ==
==  WG 3 documents are processed using templates that operate in five modes:                     ==
==  default: normal processing                                                                   ==
==  toc-mode: to produce Table of Contents entries for objects appearing in the ToC              ==
==  specref-mode: to produce references to referencable objects in the document                  ==
==  marker-mode: to create pages hdrs/ftrs from markers generated by certain objects             ==
==  index-mode: to process certain objects for incorporation into the document index             ==
===================================================================================================
===================================================================================================
-->

<!--
===================================================================================================
==  toc-mode templates                                                                           ==
==  Objects that are represented in the ToC are: Foreword, Introduction, all Clauses             ==
==  and Subclauses at all four levels, Annexes, Tables (including condition tables and           ==
==  feature tables), Figures, Examples, Equations, and the Bibliography; for non-balloted        ==
==  documents, BNF definitions also appear in the ToC                                            ==
===================================================================================================
-->

<!-- 
    Process the foreword element in toc mode
-->
<xsl:template match="foreword" mode="toc-mode">
  <fo:block text-align="justify" text-align-last="justify" font-size="{$toc-fwd-size}"
            space-before="{$toc-fwd-spacebefore}">
    <fo:basic-link internal-destination="ForewordBlock">
      <xsl:text>Foreword</xsl:text>
      <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
      <fo:page-number-citation ref-id="ForewordBlock"/>
    </fo:basic-link>
  </fo:block>
</xsl:template>

<!-- 
    Process the intro element in toc mode
-->
<xsl:template match="intro" mode="toc-mode">
  <fo:block text-align="justify" text-align-last="justify" font-size="{$toc-intro-size}"
            space-before="{$toc-intro-spacebefore}">
    <fo:basic-link internal-destination="IntroBlock">
      <xsl:text>Introduction</xsl:text>
      <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
      <fo:page-number-citation ref-id="IntroBlock"/>
    </fo:basic-link>
  </fo:block>
</xsl:template>

<!--
    Let us process clause/annex/subClause[2|3] elements in toc mode
-->
<xsl:template match="clause | annex | subClause | subClause2 | subClause3 | subClause4"
              mode="toc-mode">
  <xsl:variable name="level" select="count(ancestor-or-self::annex |
                                           ancestor-or-self::clause |
                                           ancestor-or-self::subClause |
                                           ancestor-or-self::subClause2 |
                                           ancestor-or-self::subClause3 |
                                           ancestor-or-self::subClause4) "/>
  <fo:block text-align="left" text-align-last="justify" line-height="1.12">
    <xsl:attribute name="space-before">
      <xsl:choose>
        <xsl:when test="$level=1"><xsl:value-of select="$toc-level1-spacebefore"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$toc-otherlevel-spacebefore"/></xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:choose>
        <xsl:when test="$level=1"><xsl:value-of select="$toc-level1-size"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$toc-otherlevel-size"/></xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-weight">
      <xsl:choose>
        <xsl:when test="$level=1"><xsl:value-of select="$toc-level1-weight"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="$toc-otherlevel-weight"/></xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <fo:basic-link internal-destination="'{@id}'">
      <xsl:choose>
        <xsl:when test="$level=1 and self::clause">
          <fo:list-block provisional-distance-between-starts="24pt"
                         provisional-label-separation="6pt">
            <fo:list-item>
              <fo:list-item-label end-indent="label-end()">
                <fo:block text-align="start" text-align-last="start">
                  <xsl:call-template name="head-number"/>
                </fo:block>
              </fo:list-item-label>
              <fo:list-item-body start-indent="body-start()">
                <fo:block text-align="left" text-align-last="justify">
                  <xsl:apply-templates select="clauseHeading"/>
                  <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
                  <fo:page-number-citation ref-id="'{@id}'"/>
                </fo:block>
              </fo:list-item-body>
            </fo:list-item>
          </fo:list-block>
        </xsl:when>
        <xsl:when test="$level=1 and self::annex">
          <fo:list-block provisional-distance-between-starts="110pt"
                         provisional-label-separation="6pt">
            <fo:list-item>
              <fo:list-item-label end-indent="label-end()">
                <fo:block text-align="start" text-align-last="start">
                  <xsl:text>Annex </xsl:text>
                  <xsl:call-template name="head-number"/>
                  <fo:inline font-weight="normal">
                    <xsl:text> (</xsl:text>
                    <xsl:value-of select="./@normative"/>
                    <xsl:text>)</xsl:text>
                  </fo:inline>
                </fo:block>
              </fo:list-item-label>
              <fo:list-item-body start-indent="body-start()">
                <fo:block text-align="left" text-align-last="justify">
                  <xsl:apply-templates select="clauseHeading"/>
                  <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
                  <fo:page-number-citation ref-id="'{@id}'"/>
                </fo:block>
              </fo:list-item-body>
            </fo:list-item>
          </fo:list-block>
        </xsl:when>
        <xsl:when test="$level=2">
          <fo:list-block provisional-distance-between-starts="42pt"
                         provisional-label-separation="6pt">
            <fo:list-item>
              <fo:list-item-label end-indent="label-end()">
                <fo:block text-align="start" text-align-last="start">
                  <xsl:call-template name="head-number"/>
                </fo:block>
              </fo:list-item-label>
              <fo:list-item-body start-indent="body-start()">
                <fo:block text-align="left" text-align-last="justify">
                  <xsl:apply-templates select="clauseHeading"/>
                  <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
                  <fo:page-number-citation ref-id="'{@id}'"/>
                </fo:block>
              </fo:list-item-body>
            </fo:list-item>
          </fo:list-block>
        </xsl:when>
        <xsl:when test="$level=3">
          <fo:list-block provisional-distance-between-starts="42pt"
                         provisional-label-separation="6pt">
            <fo:list-item>
              <fo:list-item-label end-indent="label-end()">
                <fo:block text-align="start" text-align-last="start">
                  <xsl:call-template name="head-number"/>
                </fo:block>
              </fo:list-item-label>
              <fo:list-item-body start-indent="body-start()">
                <fo:block text-align="left" text-align-last="justify">
                  <xsl:apply-templates select="clauseHeading"/>
                  <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
                  <fo:page-number-citation ref-id="'{@id}'"/>
                </fo:block>
              </fo:list-item-body>
            </fo:list-item>
          </fo:list-block>
        </xsl:when>
        <xsl:when test="$level=4">
          <fo:list-block provisional-distance-between-starts="48pt"
                         provisional-label-separation="6pt">
            <fo:list-item>
              <fo:list-item-label end-indent="label-end()">
                <fo:block text-align="start" text-align-last="start">
                  <xsl:call-template name="head-number"/>
                </fo:block>
              </fo:list-item-label>
              <fo:list-item-body start-indent="body-start()">
                <fo:block text-align="left" text-align-last="justify">
                  <xsl:apply-templates select="clauseHeading"/>
                  <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
                  <fo:page-number-citation ref-id="'{@id}'"/>
                </fo:block>
              </fo:list-item-body>
            </fo:list-item>
          </fo:list-block>
        </xsl:when>
        <xsl:when test="$level=5">
          <fo:list-block provisional-distance-between-starts="60pt"
                         provisional-label-separation="6pt">
            <fo:list-item>
              <fo:list-item-label end-indent="label-end()">
                <fo:block text-align="start" text-align-last="start">
                  <xsl:call-template name="head-number"/>
                </fo:block>
              </fo:list-item-label>
              <fo:list-item-body start-indent="body-start()">
                <fo:block text-align="left" text-align-last="justify">
                  <xsl:apply-templates select="clauseHeading"/>

                  <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
                  <fo:page-number-citation ref-id="'{@id}'"/>
                </fo:block>
              </fo:list-item-body>
            </fo:list-item>
          </fo:list-block>
        </xsl:when>
      </xsl:choose>
    </fo:basic-link>
  </fo:block>
</xsl:template>


<!--
    For the TOC, the table element sets the number and title
-->
<xsl:template match="table | conditionsTable | featuresTable" mode="toc-mode">
  <xsl:if test="./tableTitle and
                ( substring-after($formalStage, '-')='20' or
                  not(ancestor::EditorNotes) )">
    <xsl:variable name="ThisTable" select="."/>
    <fo:block text-align="justify" text-align-last="justify" font-size="{$toc-table-size}"
              space-before="{$toc-table-spacebefore}">
      <xsl:variable name="tablenum">
        <xsl:choose>
          <xsl:when test="tableNumber">
            <xsl:value-of select="tableNumber"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="GetTableNumber">
              <xsl:with-param name="TheTable" select="$ThisTable"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <fo:basic-link internal-destination="'{@id}'">
        <fo:list-block provisional-distance-between-starts="24pt"
                       provisional-label-separation="6pt">
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block text-align="start" text-align-last="start">
                <xsl:value-of select="$tablenum"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block text-align="justify" text-align-last="justify">
                <xsl:apply-templates select="tableTitle"/>
                <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
                <fo:page-number-citation ref-id="'{@id}'"/>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </fo:basic-link>
    </fo:block>
  </xsl:if>
</xsl:template>

<!--
    For the TOC, the figure element sets the number and title
-->
<xsl:template match="figure" mode="toc-mode">
  <xsl:if test="substring-after($formalStage, '-')='20' or
                not(ancestor::EditorNotes)">
    <fo:block text-align="justify" text-align-last="justify" font-size="{$toc-figure-size}"
              space-before="{$toc-figure-spacebefore}">
      <xsl:variable name="figurenum">
        <xsl:choose>
          <xsl:when test="figureNumber">
            <xsl:value-of select="figureNumber"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="count(preceding::*[name()='figure'])+1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <fo:basic-link internal-destination="'{@id}'">
        <fo:list-block provisional-distance-between-starts="24pt"
                       provisional-label-separation="6pt">
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block text-align="start" text-align-last="start">
                <xsl:value-of select="$figurenum"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block text-align="justify" text-align-last="justify">
                <xsl:apply-templates select="figureTitle"/>
                <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
                <fo:page-number-citation ref-id="'{@id}'"/>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </fo:basic-link>
    </fo:block>
  </xsl:if>
</xsl:template>

<!--
    For the TOC, the example element sets the number and title
-->
<xsl:template match="example" mode="toc-mode">
  <xsl:if test="substring-after($formalStage, '-')='20' or
                not(ancestor::EditorNotes)">
    <fo:block text-align="justify" text-align-last="justify" font-size="{$toc-example-size}"
              space-before="{$toc-example-spacebefore}">
      <xsl:variable name="examplenum">
        <xsl:choose>
          <xsl:when test="exampleNumber">
            <xsl:value-of select="exampleNumber"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="count(preceding::*[name()='example'])+1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <fo:basic-link internal-destination="'{@id}'">
        <fo:list-block provisional-distance-between-starts="24pt"
                       provisional-label-separation="6pt">
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block text-align="start" text-align-last="start">
                <xsl:value-of select="$examplenum"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block text-align="justify" text-align-last="justify">
                <xsl:apply-templates select="exampleTitle"/>
                <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
                <fo:page-number-citation ref-id="'{@id}'"/>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </fo:basic-link>
    </fo:block>
  </xsl:if>
</xsl:template>

<!--
    For the TOC, the equation element sets the number and title
-->
<xsl:template match="equation" mode="toc-mode">
  <xsl:if test="substring-after($formalStage, '-')='20' or
                not(ancestor::EditorNotes)">
    <fo:block text-align="justify" text-align-last="justify" font-size="{$toc-equation-size}"
              space-before="{$toc-equation-spacebefore}">
      <xsl:variable name="equationnum">
        <xsl:choose>
          <xsl:when test="equationNumber">
            <xsl:value-of select="equationNumber"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="count(preceding::*[name()='equation'])+1"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <fo:basic-link internal-destination="'{@id}'">
        <fo:list-block provisional-distance-between-starts="24pt"
                       provisional-label-separation="6pt">
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block text-align="start" text-align-last="start">
                <xsl:value-of select="$equationnum"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block text-align="justify" text-align-last="justify">
                <xsl:apply-templates select="equationTitle"/>
                <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
                <fo:page-number-citation ref-id="'{@id}'"/>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </fo:basic-link>
    </fo:block>
  </xsl:if>
</xsl:template>

<!--
    Process the bibliography element in toc mode
-->
<xsl:template match="bibliography" mode="toc-mode">
  <fo:block text-align="justify" text-align-last="justify" font-size="{$toc-bibl-size}"
            space-before="{$toc-bibl-spacebefore}">
    <fo:basic-link internal-destination="'{@id}'">
      <fo:inline font-weight="bold">
        <xsl:text>Bibliography</xsl:text>
        <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
        <fo:page-number-citation ref-id="'{@id}'"/>
      </fo:inline>
    </fo:basic-link>
  </fo:block>
</xsl:template>

<!--
    For the TOC, the BNFdef element sets only the non-terminal symbol
-->
<xsl:template match="BNFdef" mode="toc-mode">
  <fo:block text-align="justify" text-align-last="justify" font-size="{$toc-BNFdef-size}"
            space-before="{$toc-BNFdef-spacebefore}">
    <fo:basic-link internal-destination="'BNF_{@name}'">
      <fo:list-block provisional-distance-between-starts="0pt"
                     provisional-label-separation="0pt">
        <fo:list-item>
          <fo:list-item-label end-indent="label-end()">
            <fo:block text-align="start" text-align-last="start">
              <xsl:text></xsl:text>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block text-align="justify" text-align-last="justify">
              <xsl:text>&lt;</xsl:text>
              <xsl:value-of select="@name"/>
              <xsl:text>&gt;</xsl:text>
              <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
              <fo:page-number-citation ref-id="'BNF_{@name}'"/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </fo:basic-link>
  </fo:block>
</xsl:template>



<!--
===================================================================================================
==  specref-mode templates                                                                       ==
==  Objects to which specref/itemref referencess can be made are:                                ==
==  <specref>: all Clauses and Subclauses at all four levels, Annexes, Tables (including         ==
==  condition tables and feature tables), Figures, Examples, Equations, the Bibliography.        ==
==  Notes, and Editor's Notes.                                                                   ==
==  <itemref>: certain other objects that have been given an explicit @id attribute:             ==
==  paragraphs, items in ordered and unordered lists, and properly marked-up rows of tables.     ==
===================================================================================================
-->

<!--
    Let us process clause/annex/subClause[2|3|4] elements in specref mode
-->
<xsl:template name="section-references"
              match="clause | annex | subClause | subClause2 | subClause3 | subClause4"
              mode="specref-mode">
  <xsl:variable name="level" select="count(ancestor-or-self::annex |
                                           ancestor-or-self::clause |
                                           ancestor-or-self::subClause |
                                           ancestor-or-self::subClause2 |
                                           ancestor-or-self::subClause3 |
                                           ancestor-or-self::subClause4)"/>
  <fo:inline keep-together.within-line="always">
    <xsl:choose>
      <xsl:when test="self::clause">
        <xsl:text>Clause </xsl:text>
      </xsl:when>
      <xsl:when test="self::annex">
        <xsl:text>Annex </xsl:text>
      </xsl:when>
      <xsl:when test="self::subClause | self::subClause2 | self::subClause3 | self::subClause4">
        <xsl:text>Subclause </xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:call-template name="head-number"/>
    <xsl:text>,</xsl:text>
  </fo:inline>
  <xsl:text> &ldquo;</xsl:text>
  <xsl:apply-templates select="clauseHeading"/>
  <xsl:text>&rdquo;</xsl:text>
</xsl:template>

<!--
    The table elements in specref-mode output Table n, "title"
-->
<xsl:template match="//table | //conditionsTable | //featuresTable" mode="specref-mode">
  <xsl:variable name="ThisTable" select="."/>
  <xsl:variable name="tablenum">
    <xsl:choose>
      <xsl:when test="tableNumber">
        <xsl:value-of select="tableNumber"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="GetTableNumber">
          <xsl:with-param name="TheTable" select="$ThisTable"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="./tableTitle">
      <fo:inline keep-together.within-line="always">
        <xsl:text>Table </xsl:text>
        <xsl:value-of select="$tablenum"/>
        <xsl:text>,</xsl:text>
      </fo:inline>
      <xsl:text> &ldquo;</xsl:text>
      <xsl:apply-templates select="tableTitle"/>
      <xsl:text>&rdquo;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline font-style="italic" font-weight="bold">
        ERROR: Attempt to reference a table without a title.
      </fo:inline>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    The figure elements in specref-mode output Figure n, "figure"
-->
<xsl:template match="//figure" mode="specref-mode">
  <xsl:variable name="figurenum"
                select="count(preceding::*[name()='figure'])+1"/>
  <fo:inline keep-together.within-line="always">
    <xsl:text>Figure </xsl:text>
    <xsl:value-of select="$figurenum"/>
    <xsl:text>,</xsl:text>
  </fo:inline>
  <xsl:text> &ldquo;</xsl:text>
  <xsl:apply-templates select="figureTitle"/>
  <xsl:text>&rdquo;</xsl:text>
</xsl:template>

<!--
    The example elements in specref-mode output Example n, "title"
-->
<xsl:template match="//example" mode="specref-mode">
  <xsl:variable name="examplenum"
                select="count(preceding::*[name()='example'])+1"/>
  <fo:inline keep-together.within-line="always">
    <xsl:text>Example </xsl:text>
    <xsl:value-of select="$examplenum"/>
    <xsl:text>,</xsl:text>
  </fo:inline>
  <xsl:text> &ldquo;</xsl:text>
  <xsl:apply-templates select="exampleTitle"/>
  <xsl:text>&rdquo;</xsl:text>
</xsl:template>

<!--
    The equation elements in specref-mode output Equation n, "title"
-->
<xsl:template match="//equation" mode="specref-mode">
  <xsl:variable name="equationnum"
                select="count(preceding::*[name()='equation'])+1"/>
  <fo:inline keep-together.within-line="always">
    <xsl:text>Equation </xsl:text>
    <xsl:value-of select="$equationnum"/>
    <xsl:text>,</xsl:text>
  </fo:inline>
  <xsl:text> &ldquo;</xsl:text>
  <xsl:apply-templates select="equationTitle"/>
  <xsl:text>&rdquo;</xsl:text>
</xsl:template>

<!--
    Bibliography (bibliography) in specref mode
-->
<xsl:template match="bibliography" mode="specref-mode">
  <xsl:text>Bibliography</xsl:text>
</xsl:template>

<!--
    Paragraph (para), spec reference mode
-->
<xsl:template match="para" mode="specref-mode">
  <xsl:number level="single" format="1" ordinal="yes" lang="en"/>
</xsl:template>

<!-- =================================================================================== -->
<!-- Unordered list item, spec reference mode                                            -->
<!-- =================================================================================== -->
<xsl:template match="ulist/item" mode="specref-mode">
  <xsl:number level="single" format="1" ordinal="yes" lang="en"/>
</xsl:template>

<!-- =================================================================================== -->
<!-- Ordered list item, spec reference mode                                              -->
<!-- =================================================================================== -->
<xsl:template match="olist/item" mode="specref-mode">
  <xsl:variable name="list-level">
    <xsl:value-of select="count(ancestor-or-self::olist)"/>
  </xsl:variable>
  <xsl:call-template name="olist-item-number-ref">
    <xsl:with-param name="list-level" select="$list-level"/>
  </xsl:call-template>
</xsl:template>

<!-- =================================================================================== -->
<!-- table-row-number, spec reference mode                                               -->
<!-- =================================================================================== -->
<xsl:template match="table-row-number" mode="specref-mode">
  <xsl:value-of
    select="count(ancestor::table-row/preceding-sibling::table-row[table-cell/table-row-number])
            +1"/>
</xsl:template>

<!--
    Numbered notes (note) in specref mode
-->
<xsl:template match="note" mode="specref-mode">
  <xsl:variable name="notenum"
                select="count(preceding::*[name()='note'])+1"/>
  <xsl:text>NOTE </xsl:text><xsl:value-of select="$notenum"/>
</xsl:template>

<!--
    Editor's notes (ednote) in specref mode
-->
<xsl:template match="ednote" mode="specref-mode">
  <xsl:variable name="ednotenum"
                select="count(preceding::*[name()='ednote'])+1"/>
  <xsl:text>Editor&rsquo;s Note number </xsl:text><xsl:value-of select="$ednotenum"/>
</xsl:template>


<!--
===================================================================================================
==  marker-mode templates                                                                        ==
==  Objects that cause page headers and/or footers to be generated are strictly                  ==
==  governed by the ISO Directives, Part 2, and the derogation granted to JTC 1/SC 32/WG 3       ==
==  by ISO Central Secretariat.  These objects include Clauses, Annexes, Subclauses              ==
==  at all four levels, and the Bibliography.                                                    ==
===================================================================================================
-->

<!--
    Marker Mode is used to produce page headers and footers
-->
<xsl:template match="*" mode="marker-mode" priority="-1"/>

<!--
    Get clauseHeading numbers and strings at every level for use in markers
-->
<xsl:template match="clause/clauseHeading" mode="marker-mode">
  <xsl:choose>
    <xsl:when test="../subClause">
      <fo:marker marker-class-name="clauseNum">
        <fo:wrapper font-weight="{$page-hdr-weight}">
          <xsl:call-template name="head-number"/>
        </fo:wrapper>
      </fo:marker>
      <fo:marker marker-class-name="clauseString">
        <fo:wrapper font-weight="{$page-hdr-weight}"><xsl:apply-templates/></fo:wrapper>
      </fo:marker>
    </xsl:when>
    <xsl:otherwise>
      <fo:marker marker-class-name="head1Num">
        <fo:wrapper font-weight="{$page-hdr-weight}">
          <xsl:call-template name="head-number"/>
        </fo:wrapper>
      </fo:marker>
      <fo:marker marker-class-name="head1String">
        <fo:wrapper font-weight="{$page-hdr-weight}"><xsl:apply-templates/></fo:wrapper>
      </fo:marker>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Get clauseHeading numbers and strings at every level for use in markers
-->
<xsl:template match="annex/clauseHeading" mode="marker-mode">
  <xsl:choose>
    <xsl:when test="../subClause">
      <fo:marker marker-class-name="clauseNum">
        <fo:wrapper font-weight="{$page-hdr-weight}">
          <xsl:call-template name="head-number"/>
        </fo:wrapper>
      </fo:marker>
      <fo:marker marker-class-name="clauseString">
        <fo:wrapper font-weight="{$page-hdr-weight}"><xsl:apply-templates/></fo:wrapper>
      </fo:marker>
    </xsl:when>
    <xsl:otherwise>
      <fo:marker marker-class-name="head1Num">
        <fo:wrapper font-weight="{$page-hdr-weight}">
          <xsl:call-template name="head-number"/>
        </fo:wrapper>
      </fo:marker>
      <fo:marker marker-class-name="head1String">
        <fo:wrapper font-weight="{$page-hdr-weight}"><xsl:apply-templates/></fo:wrapper>
      </fo:marker>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="subClause/clauseHeading" mode="marker-mode">
  <fo:marker marker-class-name="head1Num">
    <fo:wrapper font-weight="{$page-hdr-weight}">
      <xsl:call-template name="head-number"/>
    </fo:wrapper>
  </fo:marker>
  <fo:marker marker-class-name="head1String">
    <fo:wrapper font-weight="{$page-hdr-weight}"><xsl:apply-templates/></fo:wrapper>
  </fo:marker>
</xsl:template>

<xsl:template match="subClause2/clauseHeading" mode="marker-mode">
  <fo:marker marker-class-name="head2Num">
    <fo:wrapper font-weight="{$page-hdr-weight}">
      <xsl:call-template name="head-number"/>
    </fo:wrapper>
  </fo:marker>
  <fo:marker marker-class-name="head2String">
    <fo:wrapper font-weight="{$page-hdr-weight}"><xsl:apply-templates/></fo:wrapper>
  </fo:marker>
</xsl:template>

<xsl:template match="subClause3/clauseHeading" mode="marker-mode">
  <fo:marker marker-class-name="head3Num">
    <fo:wrapper font-weight="{$page-hdr-weight}">
      <xsl:call-template name="head-number"/>
    </fo:wrapper>
  </fo:marker>
  <fo:marker marker-class-name="head3String">
    <fo:wrapper font-weight="{$page-hdr-weight}"><xsl:apply-templates/></fo:wrapper>
  </fo:marker>
</xsl:template>

<xsl:template match="subClause4/clauseHeading" mode="marker-mode">
  <fo:marker marker-class-name="head4Num">
    <fo:wrapper font-weight="{$page-hdr-weight}">
      <xsl:call-template name="head-number"/>
    </fo:wrapper>
  </fo:marker>
  <fo:marker marker-class-name="head4String">
    <fo:wrapper font-weight="{$page-hdr-weight}"><xsl:apply-templates/></fo:wrapper>
  </fo:marker>
</xsl:template>

<!--
    Get clauseHeading numbers and strings at every level for use in markers
-->
<xsl:template match="bibliography" mode="marker-mode">
  <fo:marker marker-class-name="clauseNum">
    <fo:wrapper font-weight="{$page-hdr-weight}"></fo:wrapper>
  </fo:marker>
  <fo:marker marker-class-name="clauseString">
    <fo:wrapper font-weight="{$page-hdr-weight}">Bibliography</fo:wrapper>
  </fo:marker>
</xsl:template>

<!--
=================================================================================================== 
===================================================================================================
==  default mode templates                                                                       ==
===================================================================================================
===================================================================================================
-->


<!--
=================================================================================================== 
===================================================================================================
==  Called (named) templates                                                                     ==
==  Certain templates are explicitly called by name instead of being invoked because             ==
==  of the appearance of certain elements or attributes in document markup.                      ==
===================================================================================================
===================================================================================================
-->

<!--
=================================================================================================== 
==  ToC-related templates                                                                        ==
=================================================================================================== 
-->

<!--
    Process the Table of Contents
-->
<xsl:template name="toc">
  <xsl:param name="initial-page-number"/>
  <xsl:param name="format"/>

  <fo:page-sequence master-reference="TOC-sequence"
                    initial-page-number="{$initial-page-number}"
                    format="{$format}">
    <xsl:call-template name="standard-static-contents">
      <xsl:with-param name="page-kind">TOC</xsl:with-param>
      <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
    </xsl:call-template>
    <fo:flow flow-name="contents" font-size="{$body-size}"
             line-height="{$toc-line-height}" text-align="justify">
      <fo:marker marker-class-name="clauseString">
        <fo:wrapper font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
          <xsl:text>Contents</xsl:text>
        </fo:wrapper>
      </fo:marker>
      <fo:block id="TOCgeneral" space-after.optimum="12pt" text-align-last="justify">
        <fo:inline font-weight="{$toc-head-weight}"
                   font-size="{$toc-head-size}">Contents</fo:inline>
        <fo:leader leader-pattern="space"/>
        <fo:inline font-weight="{$toc-head-weight}"
                   font-size="{$toc-head-pagenum-size}">Page</fo:inline>
      </fo:block>
      <xsl:apply-templates select="//foreword | //intro | //clause | //annex | //bibliography
                                | //subClause | //subClause2 | //subClause3 | //subClause4"
                           mode="toc-mode"/>
      <xsl:if test="$parts[@number=$standardNumber]/part[@number=$partno]/@TC = 'false'">
        <fo:block text-align="justify" text-align-last="justify"
                  space-before="6pt" font-size="{$toc-level1-size}"
                  font-weight="{$toc-level1-weight}">
          <fo:basic-link internal-destination="index-start-page">
            <xsl:text>Index</xsl:text>
            <fo:leader leader-pattern="dots" leader-pattern-width="5pt"/>
            <fo:page-number-citation ref-id="index-start-page"/>
          </fo:basic-link>
        </fo:block>
      </xsl:if>
    </fo:flow>
  </fo:page-sequence>

  <xsl:if test="count(//table/tableTitle | //conditionsTable/tableTitle 
                    | //featuresTable/tableTitle )>0">
    <fo:page-sequence master-reference="TOCtables-sequence" format="{$format}">
      <xsl:call-template name="standard-static-contents">
        <xsl:with-param name="page-kind">TOCtables</xsl:with-param>
        <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
      </xsl:call-template>
      <fo:flow flow-name="contents" font-size="{$body-size}" line-height="{$body-line-height}"
               text-align="justify">
        <fo:marker marker-class-name="clauseString">
          <fo:wrapper font-weight="{$page-hdr-weight}">
            <xsl:text>Contents</xsl:text>
          </fo:wrapper>
        </fo:marker>
        <fo:block id="TOCtables" space-after.optimum="12pt" text-align="center">
          <fo:inline font-weight="{$toc-head-weight}"
                     font-size="{$toc-pagehead-size}">Tables</fo:inline>
        </fo:block>
        <fo:block font-weight="{$toc-head-weight}" font-size="{$toc-head-size}"
                  space-after.optimum="12pt" text-align-last="justify">
          Table<fo:leader leader-pattern="space"/><fo:inline
                          font-size="{$toc-head-pagenum-size}">Page</fo:inline>
        </fo:block>
        <xsl:apply-templates select="//table[not(ancestor::EditorNotes)] | //conditionsTable 
                                    | //featuresTable"
                             mode="toc-mode"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:if>

  <xsl:if test="count(//figure)>0">
    <fo:page-sequence master-reference="TOCfigures-sequence" format="{$format}">
      <xsl:call-template name="standard-static-contents">
        <xsl:with-param name="page-kind">TOCfigures</xsl:with-param>
        <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
      </xsl:call-template>
      <fo:flow flow-name="contents" font-size="{$body-size}" line-height="{$body-line-height}"
               text-align="justify">
        <fo:marker marker-class-name="clauseString">
          <fo:wrapper font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
            <xsl:text>Contents</xsl:text>
          </fo:wrapper>
        </fo:marker>
        <fo:block id="TOCfigures" space-after.optimum="12pt" text-align="center">
          <fo:inline font-weight="{$toc-head-weight}"
                     font-size="{$toc-pagehead-size}">Figures</fo:inline>
        </fo:block>
        <fo:block font-weight="{$toc-head-weight}" font-size="{$toc-head-size}"
                  space-after.optimum="12pt" text-align-last="justify">
          Figure<fo:leader leader-pattern="space"/><fo:inline
                           font-size="{$toc-head-pagenum-size}">Page</fo:inline>
        </fo:block>
        <xsl:apply-templates select="//figure[not(ancestor::EditorNotes)]" mode="toc-mode"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:if>

  <xsl:if test="count(//example)>0">
    <fo:page-sequence master-reference="TOCexamples-sequence" format="{$format}">
      <xsl:call-template name="standard-static-contents">
        <xsl:with-param name="page-kind">TOCexamples</xsl:with-param>
        <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
      </xsl:call-template>
      <fo:flow flow-name="contents" font-size="{$body-size}" line-height="{$body-line-height}"
               text-align="justify">
        <fo:marker marker-class-name="clauseString">
          <fo:wrapper font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
            <xsl:text>Contents</xsl:text>
          </fo:wrapper>
        </fo:marker>
        <fo:block id="TOCexamples" space-after.optimum="12pt" text-align="center">
          <fo:inline font-weight="{$toc-head-weight}"
                     font-size="{$toc-pagehead-size}">Examples</fo:inline>
        </fo:block>
        <fo:block font-weight="{$toc-head-weight}" font-size="{$toc-head-size}"
                  space-after.optimum="12pt" text-align-last="justify">
          Example<fo:leader leader-pattern="space"/><fo:inline
                            font-size="{$toc-head-pagenum-size}">Page</fo:inline>
        </fo:block>
        <xsl:apply-templates select="//example[not(ancestor::EditorNotes)]" mode="toc-mode"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:if>

  <xsl:if test="count(//equation)>0">
    <fo:page-sequence master-reference="TOCequations-sequence" format="{$format}">
      <xsl:call-template name="standard-static-contents">
        <xsl:with-param name="page-kind">TOCequations</xsl:with-param>
        <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
      </xsl:call-template>
      <fo:flow flow-name="contents" font-size="{$body-size}" line-height="{$body-line-height}"
               text-align="justify">
        <fo:marker marker-class-name="clauseString">
          <fo:wrapper font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
            <xsl:text>Contents</xsl:text>
          </fo:wrapper>
        </fo:marker>
        <fo:block id="TOCequations" space-after.optimum="12pt" text-align="center">
          <fo:inline font-weight="{$toc-head-weight}"
                     font-size="{$toc-pagehead-size}">Equations</fo:inline>
        </fo:block>
        <fo:block font-weight="{$toc-head-weight}" font-size="{$toc-head-size}"
                  space-after.optimum="12pt" text-align-last="justify">
          Equation<fo:leader leader-pattern="space"/><fo:inline
                             font-size="{$toc-head-pagenum-size}">Page</fo:inline>
        </fo:block>
        <xsl:apply-templates select="//equation[not(ancestor::EditorNotes)]" mode="toc-mode"/>
      </fo:flow>
    </fo:page-sequence>
  </xsl:if>

  <xsl:if test="$list-bnf-elements = 'yes'">
    <xsl:if test="count(//Format/grammar/BNFdef | //Properties/grammar/BNFdef)>0">
      <fo:page-sequence master-reference="TOCnonterminals-sequence" format="{$format}">
        <xsl:call-template name="standard-static-contents">
          <xsl:with-param name="page-kind">TOCnonterminals</xsl:with-param>
          <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
        </xsl:call-template>
        <fo:flow flow-name="contents" font-size="{$body-size}" line-height="{$body-line-height}"
                 text-align="justify">
          <fo:marker marker-class-name="clauseString">
          <fo:wrapper font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
                <xsl:text>Contents</xsl:text>
            </fo:wrapper>
          </fo:marker>
          <fo:block id="TOCnonterminals" space-after.optimum="12pt" text-align="center">
            <fo:inline font-weight="{$toc-head-weight}"
                       font-size="{$toc-pagehead-size}">BNF non-terminal symbols</fo:inline>
          </fo:block>
        <fo:block font-weight="{$toc-head-weight}" font-size="{$toc-head-size}"
                  space-after.optimum="12pt" text-align-last="justify">
            BNF non-terminal symbol<fo:leader leader-pattern="space"/>
            <fo:inline font-size="{$toc-head-pagenum-size}">Page</fo:inline>
          </fo:block>
          <xsl:apply-templates select="//Format/grammar/BNFdef | //Properties/grammar/BNFdef"
                               mode="toc-mode">
            <xsl:sort select="@name"/>
          </xsl:apply-templates>
        </fo:flow>
      </fo:page-sequence>
    </xsl:if>
  </xsl:if>
  
</xsl:template>


<!--
=================================================================================================== 
==  Clause, Annex, and Subclause (all levels)-related templates                                  ==
=================================================================================================== 
-->

<!--
    Headings for Clauses and Subclauses at every level
-->
<xsl:template name="all-headings">
  <xsl:variable name="level" select="count(ancestor-or-self::annex |
                                           ancestor-or-self::clause |
                                           ancestor-or-self::subClause |
                                           ancestor-or-self::subClause2 |
                                           ancestor-or-self::subClause3 |
                                           ancestor-or-self::subClause4) "/>
  <xsl:apply-templates select="clauseHeading" mode="marker-mode"/>
  <xsl:choose>
    <xsl:when test="ancestor-or-self::clause">
      <fo:block keep-with-next.within-page="always" font-weight="bold">
        <xsl:attribute name="font-size">
          <xsl:choose>
            <xsl:when test="$level=1"><xsl:value-of select="$head1-size"/></xsl:when>
            <xsl:when test="$level=2"><xsl:value-of select="$head2-size"/></xsl:when>
            <xsl:when test="$level=3"><xsl:value-of select="$head3-size"/></xsl:when>
            <xsl:when test="$level=4"><xsl:value-of select="$head4-size"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$head5-size"/></xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:call-template name="clause-numbered-head-text">
          <xsl:with-param name="level" select="$level"/>
        </xsl:call-template>
      </fo:block>
    </xsl:when>
    <xsl:when test="ancestor-or-self::annex">
      <fo:block keep-with-next.within-page="always" font-weight="bold">
        <xsl:attribute name="font-size">
          <xsl:choose>
            <xsl:when test="$level=1"><xsl:value-of select="$head1-size"/></xsl:when>
            <xsl:when test="$level=2"><xsl:value-of select="$head2-size"/></xsl:when>
            <xsl:when test="$level=3"><xsl:value-of select="$head3-size"/></xsl:when>
            <xsl:when test="$level=4"><xsl:value-of select="$head4-size"/></xsl:when>
            <xsl:otherwise><xsl:value-of select="$head5-size"/></xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="$level=1">
            <xsl:call-template name="annex-numbered-head-text">
              <xsl:with-param name="level" select="$level"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="clause-numbered-head-text">
              <xsl:with-param name="level" select="$level"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </xsl:when>
  </xsl:choose>
  <xsl:if test="/standard/@standard='9075' and not(/standard/@documentType='Corrigendum')">
    <xsl:call-template name="apply-modifies-part"/>
  </xsl:if>
</xsl:template>

<!--
    Numbered Heading Text for Clauses and Subclauses (but not Annexes)
-->
<xsl:template name="clause-numbered-head-text">
  <xsl:param name="level"/>
  <xsl:variable name="headNum">
    <xsl:call-template name="head-number"/>
  </xsl:variable>
  <xsl:variable name="headTitle">
    <xsl:apply-templates select="clauseHeading"/>
  </xsl:variable>
  <fo:block hyphenate="true">
    <xsl:attribute name="space-before.minimum">
      <xsl:choose>
        <xsl:when test="$level=1">
          <xsl:value-of select="$clause-space-before-minimum"/>
        </xsl:when>
        <xsl:when test="$level=2">
          <xsl:value-of select="$subclause-space-before-minimum"/>
        </xsl:when>
        <xsl:when test="$level=3">
          <xsl:value-of select="$subclause2-space-before-minimum"/>
        </xsl:when>
        <xsl:when test="$level=4">
          <xsl:value-of select="$subclause3-space-before-minimum"/>
        </xsl:when>
        <xsl:when test="$level=5">
          <xsl:value-of select="$subclause4-space-before-minimum"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$subclause4-space-before-minimum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-before.optimum">
      <xsl:choose>
        <xsl:when test="$level=1">
          <xsl:value-of select="$clause-space-before-optimum"/>
        </xsl:when>
        <xsl:when test="$level=2">
          <xsl:value-of select="$subclause-space-before-optimum"/>
        </xsl:when>
        <xsl:when test="$level=3">
          <xsl:value-of select="$subclause2-space-before-optimum"/>
        </xsl:when>
        <xsl:when test="$level=4">
          <xsl:value-of select="$subclause3-space-before-optimum"/>
        </xsl:when>
        <xsl:when test="$level=5">
           <xsl:value-of select="$subclause4-space-before-optimum"/>
       </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$subclause4-space-before-optimum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-before.maximum">
      <xsl:choose>
        <xsl:when test="$level=1">
          <xsl:value-of select="$clause-space-before-maximum"/>
        </xsl:when>
        <xsl:when test="$level=2">
         <xsl:value-of select="$subclause-space-before-maximum"/>
        </xsl:when>
        <xsl:when test="$level=3">
         <xsl:value-of select="$subclause2-space-before-maximum"/>
        </xsl:when>
        <xsl:when test="$level=4">
         <xsl:value-of select="$subclause3-space-before-maximum"/>
        </xsl:when>
        <xsl:when test="$level=5">
         <xsl:value-of select="$subclause4-space-before-maximum"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$subclause4-space-before-maximum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-after.minimum">
      <xsl:choose>
        <xsl:when test="$level=1">
          <xsl:value-of select="$clause-space-after-minimum"/>
        </xsl:when>
        <xsl:when test="$level=2">
          <xsl:value-of select="$subclause-space-after-minimum"/>
        </xsl:when>
        <xsl:when test="$level=3">
          <xsl:value-of select="$subclause2-space-after-minimum"/>
        </xsl:when>
        <xsl:when test="$level=4">
          <xsl:value-of select="$subclause3-space-after-minimum"/>
        </xsl:when>
        <xsl:when test="$level=5">
          <xsl:value-of select="$subclause4-space-after-minimum"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$subclause4-space-after-minimum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-after.optimum">
      <xsl:choose>
        <xsl:when test="$level=1">
          <xsl:value-of select="$clause-space-after-optimum"/>
        </xsl:when>
        <xsl:when test="$level=2">
          <xsl:value-of select="$subclause-space-after-optimum"/>
        </xsl:when>
        <xsl:when test="$level=3">
          <xsl:value-of select="$subclause2-space-after-optimum"/>
        </xsl:when>
        <xsl:when test="$level=4">
          <xsl:value-of select="$subclause3-space-after-optimum"/>
        </xsl:when>
        <xsl:when test="$level=5">
          <xsl:value-of select="$subclause4-space-after-optimum"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$subclause4-space-after-optimum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-after.maximum">
      <xsl:choose>
        <xsl:when test="$level=1">
          <xsl:value-of select="$clause-space-after-maximum"/>
        </xsl:when>
        <xsl:when test="$level=2">
          <xsl:value-of select="$subclause-space-after-maximum"/>
        </xsl:when>
        <xsl:when test="$level=3">
          <xsl:value-of select="$subclause2-space-after-maximum"/>
        </xsl:when>
        <xsl:when test="$level=4">
          <xsl:value-of select="$subclause3-space-after-maximum"/>
        </xsl:when>
        <xsl:when test="$level=5">
          <xsl:value-of select="$subclause4-space-after-maximum"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$subclause4-space-after-maximum"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:choose>
      <xsl:when test="$level=1 and self::clause">
        <fo:list-block provisional-distance-between-starts="24pt"
                       provisional-label-separation="6pt">
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block text-align="start" text-align-last="start">
                <xsl:value-of select="$headNum"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block text-align="left">
                <xsl:apply-templates select="clauseHeading"/>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </xsl:when>
      <xsl:when test="$level=2">
        <fo:list-block provisional-distance-between-starts="42pt"
                       provisional-label-separation="6pt">
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block text-align="start" text-align-last="start">
                <xsl:value-of select="$headNum"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block text-align="left">
                <xsl:apply-templates select="clauseHeading"/>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </xsl:when>
      <xsl:when test="$level=3">
        <fo:list-block provisional-distance-between-starts="48pt"
                       provisional-label-separation="6pt">
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block text-align="start" text-align-last="start">
                <xsl:value-of select="$headNum"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block text-align="left">
                <xsl:apply-templates select="clauseHeading"/>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </xsl:when>
      <xsl:when test="$level=4">
        <fo:list-block provisional-distance-between-starts="60pt"
                       provisional-label-separation="6pt">
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block text-align="start" text-align-last="start">
                <xsl:value-of select="$headNum"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block text-align="left">
                <xsl:apply-templates select="clauseHeading"/>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </xsl:when>
      <xsl:when test="$level=5">
        <fo:list-block provisional-distance-between-starts="66pt"
                       provisional-label-separation="6pt">
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
              <fo:block text-align="start" text-align-last="start">
                <xsl:value-of select="$headNum"/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <fo:block text-align="left">
                <xsl:apply-templates select="clauseHeading"/>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </fo:list-block>
      </xsl:when>
    </xsl:choose>
  </fo:block>
</xsl:template>

<!--
    Numbered Heading Text for Annexes
-->
<xsl:template name="annex-numbered-head-text">
  <xsl:param name="level"/>
  <xsl:variable name="headNum">
    <xsl:call-template name="head-number"/>
  </xsl:variable>
  <fo:block space-before.optimum="{$annex-space-before}"
            space-after.optimum="{$annex-space-after}" hyphenate="true"
            font-weight="bold" text-align="center">
    <xsl:text>Annex </xsl:text><xsl:value-of select="$headNum"/>
  </fo:block>
  <fo:block space-before.optimum="3pt" space-after.optimum="0pt"
            font-weight="normal" text-align="center">
    <xsl:text>(</xsl:text>
    <xsl:value-of select="./@normative"/>
    <xsl:text>)</xsl:text>
  </fo:block>
  <fo:block font-weight="bold" text-align="center">
    <xsl:attribute name="space-before.minimum">
      <xsl:choose>
        <xsl:when test="$level=1">14pt</xsl:when>
        <xsl:when test="$level=2">14pt</xsl:when>
        <xsl:when test="$level=3">14pt</xsl:when>
        <xsl:when test="$level=4">14pt</xsl:when>
        <xsl:otherwise>30pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-before.optimum">
      <xsl:choose>
        <xsl:when test="$level=1">14pt</xsl:when>
        <xsl:when test="$level=2">14pt</xsl:when>
        <xsl:when test="$level=3">14pt</xsl:when>
        <xsl:when test="$level=4">14pt</xsl:when>
        <xsl:otherwise>32pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-before.maximum">
      <xsl:choose>
        <xsl:when test="$level=1">14pt</xsl:when>
        <xsl:when test="$level=2">14pt</xsl:when>
        <xsl:when test="$level=3">14pt</xsl:when>
        <xsl:when test="$level=4">14pt</xsl:when>
        <xsl:otherwise>35pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-after.minimum">
      <xsl:choose>
        <xsl:when test="$level=1">18pt</xsl:when>
        <xsl:when test="$level=2">18pt</xsl:when>
        <xsl:when test="$level=3">18pt</xsl:when>
        <xsl:when test="$level=4">18pt</xsl:when>
        <xsl:otherwise>18pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-after.optimum">
      <xsl:choose>
        <xsl:when test="$level=1">20pt</xsl:when>
        <xsl:when test="$level=2">20pt</xsl:when>
        <xsl:when test="$level=3">20pt</xsl:when>
        <xsl:when test="$level=4">20pt</xsl:when>
        <xsl:otherwise>20pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="space-after.maximum">
      <xsl:choose>
        <xsl:when test="$level=1">22pt</xsl:when>
        <xsl:when test="$level=2">22pt</xsl:when>
        <xsl:when test="$level=3">22pt</xsl:when>
        <xsl:when test="$level=4">22pt</xsl:when>
        <xsl:otherwise>22pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates select="clauseHeading"/>
  </fo:block>
</xsl:template>

<!--
    Numbered Heading Numbers
-->
<xsl:template name="head-number">
  <xsl:choose>
    <xsl:when test="clauseNumber">
      <xsl:value-of select="clauseNumber"/>
    </xsl:when>
    <xsl:when test="../clauseNumber">
      <xsl:value-of select="../clauseNumber"/>
    </xsl:when>
    <xsl:when test="../../clauseNumber">
      <xsl:value-of select="../../clauseNumber"/>
    </xsl:when>
    <xsl:when test="../../../clauseNumber">
      <xsl:value-of select="../../../clauseNumber"/>
    </xsl:when>
    <xsl:when test="../../../../clauseNumber">
      <xsl:value-of select="../../../../clauseNumber"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="body" select="count(ancestor::standardPartBody)"/>
      <xsl:variable name="back" select="count(ancestor::backMatter)"/>
      <xsl:variable name="number-format">
        <xsl:choose>
          <xsl:when test="$body=1">1.1.1.1.1</xsl:when>
          <xsl:otherwise>A.1.1.1.1</xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:number level="multiple"
                  count="annex|clause|subClause|subClause2|subClause3|subClause4"
                  format="{$number-format}"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
    Table Number Computation
-->
<xsl:template name="GetTableNumber">
  <xsl:param name="TheTable"/>
  <xsl:choose>
    <xsl:when test="$TheTable/ancestor::annex">
      <xsl:variable name="TheAnnex" select="$TheTable/ancestor::annex"/>
      <xsl:variable name="AnnexNumber" select="count(preceding::annex)+1"/>
      <xsl:variable name="AnnexLetter">
        <xsl:choose>
          <xsl:when test="$AnnexNumber = 1">
            <xsl:text>A.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 2">
            <xsl:text>B.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 3">
            <xsl:text>C.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 4">
            <xsl:text>D.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 5">
            <xsl:text>E.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 6">
            <xsl:text>F.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 7">
            <xsl:text>G.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 8">
            <xsl:text>H.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 9">
            <xsl:text>I.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 10">
            <xsl:text>J.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 11">
            <xsl:text>K.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 12">
            <xsl:text>L.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 13">
            <xsl:text>M.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 14">
            <xsl:text>N.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 15">
            <xsl:text>O.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 16">
            <xsl:text>P.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 17">
            <xsl:text>Q.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 18">
            <xsl:text>R.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 19">
            <xsl:text>S.</xsl:text>
          </xsl:when>
          <xsl:when test="$AnnexNumber = 20">
            <xsl:text>T.</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>MoreThan20Annexes!!!</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:value-of select="count($TheAnnex/$TheTable/preceding::*
                                      [name()='table' and
                                       ancestor::annex is $TheAnnex][./tableTitle])+
                              count($TheAnnex/$TheTable/preceding::*
                                      [name()='conditionsTable' and
                                       ancestor::annex is $TheAnnex][./tableTitle])+
                              count($TheAnnex/$TheTable/preceding::*
                                      [name()='featuresTable' and
                                       ancestor::annex is $TheAnnex][./tableTitle])+1"/>
      </xsl:variable>
      <xsl:value-of select="$AnnexLetter"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="count(preceding::*[name()='table'][./tableTitle])+
                            count(preceding::*[name()='conditionsTable'][./tableTitle])+
                            count(preceding::*[name()='featuresTable'][./tableTitle])+1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
=================================================================================================== 
==  Definition-related templates                                                                 ==
==  NOTE: These three templates all have new (2021) modes, but these are not separated into      ==
==  mode="xxx" sections because there is only one template per mode and these templates are all  ==
==  strictly related to references to definitions of terms.                                      ==
=================================================================================================== 
-->

<!--
    Let us process definition elements in defnref-single mode
-->
<xsl:template name="term-reference"
              match="definition"
              mode="defnref-single">
  <xsl:param name="repeatdefn" tunnel="yes" select="false()"/>
  <xsl:variable name="term">
    <xsl:apply-templates select="./term[not(@type) or @type='preferred'][1]">
      <xsl:with-param name="ref-invoked" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$repeatdefn">
      <xsl:value-of select="$term"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline font-style="italic"><xsl:value-of select="$term"/></fo:inline>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Let us process definition elements in defnref-plural mode
-->
<xsl:template name="term-references"
              match="definition"
              mode="defnref-plural">
  <xsl:param name="repeatdefn" tunnel="yes" select="false()"/>
  <xsl:variable name="term">
    <xsl:apply-templates select="./term[not(@type) or @type='preferred'][1]">
      <xsl:with-param name="ref-invoked" select="true()"/>
    </xsl:apply-templates>
  </xsl:variable>
  <xsl:variable name="pluralterm">
    <xsl:choose>
      <xsl:when test="ends-with($term, 'ias')">
        <xsl:value-of select="concat($term, 'es')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'ay')">
        <xsl:value-of select="concat($term, 's')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'ex')">
        <xsl:value-of select="concat(substring($term, 1, string-length($term)-2), 'ices')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'xis')">
        <xsl:value-of select="concat(substring($term, 1, string-length($term)-3), 'xes')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'ey')">
        <xsl:value-of select="concat($term, 's')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'iy')">
        <xsl:value-of select="concat($term, 's')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'uy')">
        <xsl:value-of select="concat($term, 's')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'y')">
        <xsl:value-of select="concat(substring($term, 1, string-length($term)-1), 'ies')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'x')">
        <xsl:value-of select="concat($term, 'es')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'ch')">
        <xsl:value-of select="concat($term, 'es')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'o')">
        <xsl:value-of select="concat($term, 'es')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'dg')">
        <xsl:value-of select="concat($term, 'es')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'ss')">
        <xsl:value-of select="concat($term, 'es')"/>
      </xsl:when>
      <xsl:when test="ends-with($term, 'f')">
        <xsl:value-of select="concat(substring($term, 1, string-length($term)-1), 'ves')"/>
      </xsl:when>
      <xsl:otherwise><xsl:value-of select="concat($term, 's')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="$repeatdefn">
      <xsl:value-of select="$pluralterm"/>
    </xsl:when>
    <xsl:otherwise>
      <fo:inline font-style="italic"><xsl:value-of select="$pluralterm"/></fo:inline>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Let us process definition elements in defnref-number mode
-->
<xsl:template name="term-number"
              match="definition"
              mode="defnref-number">
  <xsl:param name="repeatdefn" tunnel="yes" select="false()"/>
  <xsl:if test="not($repeatdefn)">
    <xsl:variable name="level" select="count(ancestor-or-self::definition)"/>
    <xsl:text> (</xsl:text>
    <xsl:call-template name="head-number"/>
    <xsl:text>.</xsl:text>
    <xsl:value-of select="count(preceding-sibling::definition)+1"/>
    <xsl:text>)</xsl:text>
  </xsl:if>    
</xsl:template>


<!--
=================================================================================================== 
==  List-related templates                                                                       ==
=================================================================================================== 
-->

<!-- =================================================================================== -->
<!-- This template selects the appropriate tag for the list item                         -->
<!-- based purely on its list level, following the SQL tradition.                        -->
<!-- =================================================================================== -->
<xsl:template name="olist-item-number">
  <xsl:param name="list-level"/>
  <xsl:param name="item-pos"/>
  <xsl:param name="item-incr"/>
  <xsl:variable name="number-format">
    <xsl:choose>
      <xsl:when test="$list-level=1">1</xsl:when>  <!-- arabic number -->
      <xsl:when test="$list-level=2">a</xsl:when>  <!-- small letter -->
      <xsl:when test="$list-level=3">i</xsl:when>  <!-- small roman numeral -->
      <xsl:when test="$list-level=4">1</xsl:when>  <!-- arabic number -->
      <xsl:when test="$list-level=5">A</xsl:when>  <!-- capital letter -->
      <xsl:when test="$list-level=6">I</xsl:when>  <!-- capital roman numeral -->
      <xsl:when test="$list-level=7">1</xsl:when>  <!-- arabic number -->
      <xsl:when test="$list-level=8">a</xsl:when>  <!-- small letter -->
      <xsl:when test="$list-level=9">i</xsl:when>  <!-- small roman numeral -->
      <xsl:when test="$list-level=10">1</xsl:when> <!-- arabic number -->
      <xsl:when test="$list-level=11">A</xsl:when> <!-- capital letter -->
      <xsl:when test="$list-level=12">I</xsl:when> <!-- capital roman numeral -->
      <xsl:otherwise>1</xsl:otherwise>             <!-- arabic by default -->
    </xsl:choose> 
  </xsl:variable>
  <xsl:number value="$item-pos + $item-incr - 1" format="{$number-format}"/>
</xsl:template>

<xsl:template name="olist-item-number-ref">
  <xsl:param name="list-level"/>
  <xsl:choose>
    <xsl:when test="$list-level=1"> <!-- arabic number -->
      <xsl:number level="multiple" format="1)"/>
    </xsl:when>
    <xsl:when test="$list-level=2"> <!-- small letter -->
      <xsl:number level="multiple" format="1)a)"/>
    </xsl:when>
    <xsl:when test="$list-level=3"> <!-- small roman numeral -->
      <xsl:number level="multiple" format="1)a)i)"/>
    </xsl:when>
    <xsl:when test="$list-level=4"> <!-- arabic number -->
      <xsl:number level="multiple" format="1)a)i)1)"/>
    </xsl:when>
    <xsl:when test="$list-level=5"> <!-- capital letter -->
      <xsl:number level="multiple" format="1)a)i)1)A)"/>
    </xsl:when>
    <xsl:when test="$list-level=6"> <!-- capital roman numeral -->
      <xsl:number level="multiple" format="1)a)i)1)A)I)"/>
    </xsl:when>
    <xsl:when test="$list-level=7"> <!-- arabic number -->
      <xsl:number level="multiple" format="1)a)i)1)A)I)1)"/>
    </xsl:when>
    <xsl:when test="$list-level=8"> <!-- small letter -->
      <xsl:number level="multiple" format="1)a)i)1)A)I)1)a)"/>
    </xsl:when>
    <xsl:when test="$list-level=9"> <!-- small roman numeral -->
      <xsl:number level="multiple" format="1)a)i)1)A)I)1)a)i)"/>
    </xsl:when>
    <xsl:when test="$list-level=10"> <!-- arabic number -->
      <xsl:number level="multiple" format="1)a)i)1)A)I)1)a)i)1)"/>
    </xsl:when>
    <xsl:when test="$list-level=11"> <!-- capital letter -->
      <xsl:number level="multiple" format="1)a)i)1)A)I)1)a)i)1)A)"/>
    </xsl:when>
    <xsl:when test="$list-level=12"> <!-- capital roman numeral -->
      <xsl:number level="multiple" format="1)a)i)1)A)I)1)a)i)1)A)I)"/>
    </xsl:when>
    <xsl:otherwise>  <!-- arabic by default -->
      <xsl:number level="multiple" format="1)a)i)1)A)I)1)a)i)1)A)I)1)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
=================================================================================================== 
==  Index-related templates                                                                      ==
=================================================================================================== 
-->

<!-- ****************************************************************************** -->
<!-- THE FOLLOWING TEMPLATE IS PART OF THE INDEX REDO ATIVITY                       -->
<!-- ****************************************************************************** -->
<xsl:template match="index">
  <!-- The index itself appears in the index-sequence page sequence -->
  <fo:page-sequence master-reference="index-sequence" initial-page-number="auto" format="1">
    <xsl:call-template name="standard-static-contents">
      <xsl:with-param name="page-kind">index</xsl:with-param>
      <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
    </xsl:call-template>
    <!-- And, of course, it is displayed in the main region of the page, xsl-region-body -->
    <fo:flow flow-name="xsl-region-body" font-size="{$body-size}"
             line-height="{$toc-line-height}" text-align="left">
      <fo:marker marker-class-name="clauseString">
        <fo:wrapper font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
          <xsl:text>Index</xsl:text>
        </fo:wrapper>
      </fo:marker>
      <!-- First, we group everything we want to index into an XSLT variable; this
           allows us to slightly change the text generated in the index. -->
      <xsl:variable name="index-buffer">
<!--
        <xsl:for-each
            select="
                    /standard//definition/term |
                    /standard//BNFdef/@name    |
                    /standard//BNF/@name       |
                    /standard//kw              |
                    /standard//sjkw            |
                    /standard//newterm         |
                    /standard//xmlterm         |
                    /standard//indexTerm       |
                    /standard//raise/@class    |
                    /standard//raise/@subclass |
                    /standard//feature/@code
                   ">
-->
        <xsl:for-each
            select="
                    /standard//BNFdef/@name    |
                    /standard//BNF[not(ancestor::EditorNotes)]/@name       |
                    /standard//kw              |
                    /standard//sjkw            |
                    /standard//newterm         |
                    /standard//xmlterm         |
                    /standard//indexTerm       |
                    /standard//raise/@class    |
                    /standard//raise/@subclass |
                    /standard//feature/@code
                   ">
          <xsl:choose>
            <xsl:when test="./parent::definition">
              <xsl:copy-of select="./parent::definition"/>
            </xsl:when>
            <xsl:when test="./parent::BNFdef">
              <xsl:copy-of select="./parent::BNFdef"/>
            </xsl:when>
            <xsl:when test="./parent::BNF">
              <xsl:copy-of select="./parent::BNF"/>
            </xsl:when>
            <xsl:when test="./self::kw">
              <xsl:copy-of select="./self::kw"/>
            </xsl:when>
            <xsl:when test="./self::sjkw">
              <xsl:copy-of select="./self::sjkw"/>
            </xsl:when>
            <xsl:when test="./self::newterm">
              <xsl:copy-of select="./self::newterm"/>
            </xsl:when>
            <xsl:when test="./self::xmlterm">
              <xsl:copy-of select="./self::xmlterm"/>
            </xsl:when>
            <xsl:when test="./self::indexTerm">
              <xsl:choose>
                <xsl:when test="string(.) = 'Implementation-defined'">
                  <xsl:text>implementation-defined</xsl:text>
                </xsl:when>
                <xsl:when test="string(.) = 'Implementation-dependent'">
                  <xsl:text>implementation-dependent</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:copy-of select="string(.)"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:when>
            <xsl:when test="./parent::raise">
              <xsl:if test="./parent::raise/@class">
                <xsl:variable name="class">
                  <xsl:value-of select="./parent::raise/@class"/>
                </xsl:variable>
                <xsl:variable name="classname">
                  <xsl:value-of select="$Conditions/class[@code=$class]/name"/>
                </xsl:variable>
                <xsl:element name="raise">
                  <xsl:attribute name="class">
                    <xsl:value-of select="$classname"/>
                  </xsl:attribute>
                </xsl:element>
                <raise class="{$classname}"/>
                <xsl:if test="./parent::raise/@subclass">
                  <xsl:variable name="subclass">
                    <xsl:value-of select="./parent::raise/@subclass"/>
                  </xsl:variable>
                  <xsl:variable name="subclassname">
                    <xsl:value-of select="$Conditions/class[@code=$class]/
                                            subclass[@code=$subclass]/name"/>
                  </xsl:variable>
                  <raise subclass="{$subclassname}"/>
                </xsl:if>
              </xsl:if>
            </xsl:when>
            <xsl:when test="./parent::feature">
              <xsl:copy-of select="./parent::feature"/>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>
      <!-- Group all things we want to index and process each group -->
      <!-- For this outermost grouping loop, we only want the first character -->
<!--
      <xsl:for-each-group
          select="
                  $index-buffer/definition/term  |
                  $index-buffer//BNFdef/@name    |
                  $index-buffer//BNF/@name       |
                  $index-buffer//kw              |
                  $index-buffer//sjkw            |
                  $index-buffer//newterm         |
                  $index-buffer//xmlterm         |
                  $index-buffer//indexTerm       |
                  $index-buffer//raise/@class    |
                  $index-buffer//raise/@subclass |
                  $index-buffer//feature/@code
                 "
          group-by="upper-case(substring(.,1,1))">
-->
      <xsl:for-each-group
          select="
                  $index-buffer//BNFdef/@name    |
                  $index-buffer//BNF/@name       |
                  $index-buffer//kw              |
                  $index-buffer//sjkw            |
                  $index-buffer//newterm         |
                  $index-buffer//xmlterm         |
                  $index-buffer//indexTerm       |
                  $index-buffer//raise/@class    |
                  $index-buffer//raise/@subclass |
                  $index-buffer//feature/@code
                 "
          group-by="upper-case(substring(.,1,1))">
        <xsl:sort select="upper-case(.)"/>
        <!-- Create a variable to hold the current grouping key value,
             which is the first character of the items being grouped -->
        <xsl:variable name="group-key">
          <xsl:value-of select="current-grouping-key()"/>
        </xsl:variable>
<!--
<xsl:message><xsl:text>DEBUG: Current single-letter group: </xsl:text>
  <xsl:value-of select="$group-key"/><xsl:text>.</xsl:text></xsl:message>
-->
        <!-- For each of these groups, generate a group heading such as -A- -->
        <fo:block space-before="9pt" space-after="3pt" font-family="{$font-name}"
                  font-size="14pt" font-weight="bold" text-align="center"
                  text-align-last="center">
          <fo:inline><xsl:text>&mdash; </xsl:text>
                     <xsl:value-of select="$group-key"/>
                     <xsl:text> &mdash;</xsl:text></fo:inline>
        </fo:block>
        <!-- For each first-character group (e.g., "A"), process all things
             to be indexed whose main value starts with that character;
             sort using the case-mixing rules of English. -->
        <xsl:for-each-group select="current-group()" group-by=".">
          <xsl:sort lang="en" select="upper-case(.)"/>
          <xsl:variable name="idx-key" select="."/>
<!--
<xsl:message><xsl:text>DEBUG: Current group is </xsl:text>
  <xsl:value-of select="normalize-space(.)"/><xsl:text>.</xsl:text></xsl:message>
-->
          <fo:block space-after="2pt" margin-left="0.7em" text-indent="-0.7em">
            <xsl:choose>
              <!-- Process <feature code="xxxx"> instances -->
              <xsl:when test="$idx-key/parent::feature">
                <fo:inline><xsl:value-of select="$idx-key"/></fo:inline>
                <xsl:text>, &ldquo;</xsl:text>
                <xsl:variable name="feature-string">
                  <xsl:apply-templates
                      select="$Features/feature[@code=$idx-key]/name"/>
                </xsl:variable>
                <xsl:value-of select="$feature-string"/>
                <xsl:text>&rdquo;</xsl:text>
              </xsl:when>
              <!-- Process <BNFdef name="xxxx"> instances -->
              <xsl:when test="$idx-key/parent::BNFdef">
                <xsl:text>&lt;</xsl:text>
                <xsl:value-of select="$idx-key"/>
                <xsl:text>&gt;</xsl:text>
              </xsl:when>
              <!-- Process <BNF name="xxxx"> instances -->
              <xsl:when test="$idx-key/parent::BNF">
                <xsl:text>&lt;</xsl:text>
                <xsl:value-of select="$idx-key"/>
                <xsl:text>&gt;</xsl:text>
              </xsl:when>
              <!-- Process <newterm> instances -->
              <xsl:when test="$idx-key/self::newterm">
                <fo:inline><xsl:apply-templates
                              select="$idx-key/self::newterm/(text() | *)"/></fo:inline>
              </xsl:when>
              <!-- Process <xmlterm> instances -->
              <xsl:when test="$idx-key/self::xmlterm">
                <xsl:value-of select="$idx-key"/>
              </xsl:when>
              <!-- Process <indexTerm> instances -->
              <xsl:when test="$idx-key/self::indexTerm">
                <fo:inline><xsl:apply-templates
                              select="$idx-key/self::indexTerm/(text() | *)"/></fo:inline>
              </xsl:when>
              <!-- Process <kw> and <sjkw> instances -->
              <xsl:when test="$idx-key/self::kw | $idx-key/self::sjkw">
                <xsl:value-of select="$idx-key"/>
              </xsl:when>
              <!-- Process <raise class="xxxx"> instances -->
              <xsl:when test="$idx-key/parent::raise/@class">
                <fo:inline font-style="italic">
                  <xsl:value-of select="$idx-key/parent::raise/@class"/>
                </fo:inline>
              </xsl:when>
              <!-- Process <raise subclass="xxxx"> instances -->
              <xsl:when test="$idx-key/parent::raise/@subclass">
                <fo:inline font-style="italic">
                  <xsl:value-of select="$idx-key/parent::raise/@subclass"/>
                </fo:inline>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text>********* ERROR ERROR ERROR </xsl:text><xsl:value-of select="$idx-key"/>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>&nbsp;&nbsp;&bull;&nbsp;</xsl:text>
            <fo:index-page-citation-list merge-sequential-page-numbers="leave-separate">
              <fo:index-key-reference ref-index-key="{$idx-key}" page-number-treatment="link"/>
            </fo:index-page-citation-list>
          </fo:block>
        </xsl:for-each-group>
      </xsl:for-each-group>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>


<!--
=================================================================================================== 
==  Element-application templates                                                                ==
=================================================================================================== 
-->

<xsl:template name="SubClauseSignature">
  <xsl:param name="rules">Context</xsl:param>
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Subclause Signature</xsl:text>
  </fo:block>
  <!-- The expression "..//SCsignature" depends on the fact that the current context is
       <bodyMatter> (or <tcBody>), which is a child element of <[sub]Clause[n]>. 
       Thus, "for each <SCsignature> in the parent <subClause>..." -->
  <xsl:for-each select="..//SCsignature"> <!-- for each SCsignature descendant of bodyMatter -->
  <!-- The first signature in a Subclause has good vertical spacing; subsequent
       signatures need a bit more vertical space. -->
    <xsl:variable name="space-before">
      <xsl:choose>
        <xsl:when test="position() != 1">
          <xsl:value-of select="9"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="0"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Capture the @id of "this" subClause -->
    <xsl:variable name="SCsigSCID" select="ancestor::subClause/@id"/>
    <!-- Capture the code for the subsection with the SCsignature -->
    <xsl:variable name="SCsigSCcontext">
      <xsl:choose>
        <xsl:when test="not($rules = 'Context')">
          <xsl:value-of select="$rules"/>
        </xsl:when>
        <xsl:when test="ancestor::SyntaxRules">
          <xsl:text>SR</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::AccessRules">
          <xsl:text>AR</xsl:text>
        </xsl:when>
        <xsl:when test="ancestor::GeneralRules">
          <xsl:text>GR</xsl:text>
        </xsl:when>
        <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">Error: Subclause signature defined in an invalid subsection in the Subclause with @id value: %s1 </xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$SCsigSCID"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:block space-before="{$space-before}pt" space-after="10pt" font="10pt {$codefont-name}">
      <xsl:text>&ldquo;</xsl:text>
<!-- NOTE: The use of "subClause" means that signatures only work properly for
     subClauses and NOT FOR subClause2, subClause3, or subClause4.  This is a
     known limitation that could be fixed if needed, but is deliberate -->
      <xsl:apply-templates select="ancestor::subClause/clauseHeading"/>
      <xsl:text>&rdquo; </xsl:text>
<!-- NOTE: The SCsignature element is only processed when it appears in the
     context of Syntax Rules, Access Rules, or General Rules.  We have found
     no need to use this capability in other subsections. -->
      <xsl:choose>
        <xsl:when test="not($rules = 'Context')">
          <fo:inline font="{$note-size} {$font-name}">
            <xsl:text>[</xsl:text>
            <xsl:choose>
              <xsl:when test="$rules='SR'">
                <xsl:text>Syntax</xsl:text>
              </xsl:when>
              <xsl:when test="$rules='AR'">
                <xsl:text>Access</xsl:text>
              </xsl:when>
              <xsl:when test="$rules='GR'">
                <xsl:text>General</xsl:text>
              </xsl:when>
            </xsl:choose>
            <xsl:text> Rules]</xsl:text>
          </fo:inline>
        </xsl:when>
        <xsl:when test="ancestor::SyntaxRules">
          <fo:inline font="{$note-size} {$font-name}">[Syntax Rules]</fo:inline>
        </xsl:when>
        <xsl:when test="ancestor::AccessRules">
          <fo:inline font="{$note-size} {$font-name}">[Access Rules]</fo:inline>
        </xsl:when>
        <xsl:when test="ancestor::GeneralRules">
          <fo:inline font="{$note-size} {$font-name}">[General Rules]</fo:inline>
        </xsl:when>
      </xsl:choose>
      <xsl:text> (</xsl:text>
      <xsl:for-each select="symparam">
        <fo:block white-space-treatment="preserve" white-space-collapse="false">
          <xsl:text>  Parameter: </xsl:text>
          <xsl:text>&ldquo;</xsl:text>
          <xsl:value-of select="@name"/>
          <xsl:text>&rdquo;</xsl:text>
          <xsl:if test="not(position() = last())">
              <xsl:text>, </xsl:text>
          </xsl:if>
        </fo:block>
      </xsl:for-each>
      <xsl:text>)</xsl:text>
      <!-- 2016-10-21 and 2017-02-25: allow 0, 1, or more symreturns -->
      <xsl:if test="symreturn">
        <xsl:text> Returns: </xsl:text>
        <xsl:text>&ldquo;</xsl:text>
        <xsl:value-of select="symreturn[1]/@name"/>
        <xsl:text>&rdquo;</xsl:text>
        <xsl:choose>
          <xsl:when test="count(symreturn) = 2">
            <xsl:text> and &ldquo;</xsl:text>
            <xsl:value-of select="symreturn[2]/@name"/>
            <xsl:text>&rdquo;</xsl:text>
          </xsl:when>
          <xsl:when test="count(symreturn) > 2">
            <xsl:for-each select="symreturn[position() >= 2 and position() &lt; last()]">
              <xsl:text>, &ldquo;</xsl:text>
              <xsl:value-of select="./@name"/>
              <xsl:text>&rdquo;</xsl:text>
            </xsl:for-each>
            <xsl:text>, and &ldquo;</xsl:text>
            <xsl:value-of select="symreturn[position() = last()]/@name"/>
            <xsl:text>&rdquo;</xsl:text>
          </xsl:when>
        </xsl:choose>
        <xsl:for-each select="symreturn">
          <xsl:variable name="returnSymbol" select="@name"/>
          <xsl:variable name="returnSubsection">
            <xsl:choose>
              <xsl:when test="ancestor::SyntaxRules">
                <xsl:copy-of select="ancestor::SyntaxRules"/>
              </xsl:when>
              <xsl:when test="ancestor::AccessRules">
                <xsl:copy-of select="ancestor::AccessRules"/>
              </xsl:when>
              <xsl:when test="ancestor::GeneralRules">
                <xsl:copy-of select="ancestor::GeneralRules"/>
              </xsl:when>
              <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
                <xsl:call-template name="ProcessError">
                  <xsl:with-param name="ErrorText">SCsignature outside of SRs, ARs, GRs</xsl:with-param>
                </xsl:call-template>
                <xsl:copy-of select="ancestor::Function"/>
              </xsl:otherwise>
<!-- LINE LENGTH CHECK ON -->
            </xsl:choose>
          </xsl:variable>
          <xsl:if test="not(exists($returnSubsection//SCreturn/SCretval[@name=$returnSymbol])) and
                        not(parent::SCsignature/preceding-sibling::replicateSCsig) and
                        not(ancestor::tcBody)">
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">symreturn with name = %s1 in Subclause with @id = %s2 without corresponding SCretval</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$returnSymbol"/>
              <xsl:with-param name="ErrorValue2" select="$SCsigSCID"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:if>
        </xsl:for-each>
      </xsl:if>
    </fo:block>
    <xsl:if test="documentation">
      <xsl:apply-templates select="documentation/slist"/>
    </xsl:if>

    <!-- Now that the signature has been generated, determine whether this SCsignature
         is referenced from any "other" part of this standard -->
    <xsl:variable name="extApplyExists">
      <xsl:value-of select="0"/>
      <xsl:for-each select="$parts[@number=$standardNumber]/part[@TC = 'false'
                            and @number != '02' and @number != $partno]">
        <!-- Compute the filename of the part -->
        <xsl:variable name="partnum" select="@number"/>
        <xsl:variable name="filename" select="@input"/>
        <xsl:variable name="resultfile" select="@output"/>
        <!-- This is where we need to check whether @active="no" or not.  If @active="no", then
             the variable needs to prefix the $filename with "./published/". -->
        <xsl:variable name="active" select="@active"/>
        <xsl:variable name="dirstring">
          <xsl:choose>
            <xsl:when test="$active='no'">
              <xsl:text>./published/</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text></xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <!-- extroot is the actual source file of the part we're currently checking -->
        <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
        <xsl:if test="exists($extroot//applyExtSC[@part=$partno and
                                                  @ref=$SCsigSCID and
                                                  @rules=$SCsigSCcontext])">
          <xsl:value-of select="1"/>
        </xsl:if>
      </xsl:for-each>
    </xsl:variable>

    <!-- If this is not a ballot document, the "invoked from" indicators are to be included;
         if it is a ballot document, the indicators must be excluded. -->
    <xsl:if test="substring-after($formalStage, '-')='20' and
                  exists(/descendant-or-self::subClause//applySC[@ref=$SCsigSCID] or
                         $extApplyExists != 0)">
      <fo:block font-family="{$font-name}"
                font-size="9pt"
                space-before.optimum="6pt"
                space-after="9pt"
                hyphenate="true">

        <!-- Now that the signature has been generated, the next task is to generate text
             that identifies every location in *this* part where the signature is invoked;
             however, this is done only in non-ballot documents! -->
        <fo:list-block provisional-distance-between-starts="10pt"
                       provisional-label-separation="6pt">
          <!-- First, generate text for every invocation in *this* document -->
          <xsl:for-each select="/descendant::subClause//applySC[@ref=$SCsigSCID]">
            <!-- Save the value of @rules (the place where the SCsignature being invoked is) -->
            <xsl:variable name="applyRules" select="@rules"/>
            <!-- Grab the @id for the rule or para-within-rule that contains <applySC> -->
            <xsl:variable name="referencingRule" select="ancestor::*[name(.)='item' or 
                                                                     name(.)='para'][1]/@id"/>
            <!-- Grab the @id of the subClause that contains <applySC> -->
            <xsl:variable name="SCid" select="ancestor::subClause/@id"/>
            <!-- Get the context/subsection with the referencing rule -->
            <xsl:variable name="referencingContext">
              <xsl:choose>
                <xsl:when test="key('generic-id', $referencingRule)//
                                   ancestor::SyntaxRules">
                  <xsl:text>SR</xsl:text>
                </xsl:when>
                <xsl:when test="key('generic-id', $referencingRule)//
                                   ancestor::AccessRules">
                  <xsl:text>AR</xsl:text>
                </xsl:when>
                <xsl:when test="key('generic-id', $referencingRule)//
                                   ancestor::GeneralRules">
                  <xsl:text>GR</xsl:text>
                </xsl:when>
                <xsl:when test="key('generic-id', $referencingRule)//
                                   ancestor::item">
                  <xsl:text>LI</xsl:text>
                </xsl:when>
                <xsl:when test="key('generic-id', $referencingRule)//
                                   ancestor::para">
                  <xsl:text>Para</xsl:text>
                </xsl:when>
                <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
                  <xsl:call-template name="ProcessError">
                    <xsl:with-param name="ErrorText">Subclause signature referenced from an invalid subsection in the Subclause with @id value: %s1</xsl:with-param>
                    <xsl:with-param name="ErrorValue1" select="$SCid"/>
                  </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
                </xsl:otherwise>
              </xsl:choose>
            </xsl:variable>
            <!-- Emit a reference only if in the correct subsection -->
            <xsl:if test="$applyRules = $SCsigSCcontext">
              <fo:list-item>
                <fo:list-item-label end-indent="label-end()">
                  <fo:block text-align="start"><xsl:text>&mdash;</xsl:text></fo:block>
                </fo:list-item-label>
                <fo:list-item-body start-indent="body-start()">
                  <fo:block>
                    <xsl:text>This signature is invoked from </xsl:text>
                    <!-- Generate the number/name of the invoking Subclause -->
                    <xsl:choose>
                      <xsl:when test="key('generic-id', $SCid)[self::subClause]">
                        <fo:basic-link internal-destination="'{$SCid}'" color="#000070">
                          <xsl:apply-templates select="key('generic-id', $SCid)"
                                               mode="specref-mode"/>
                        </fo:basic-link>
                      </xsl:when>
                      <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
                        <xsl:call-template name="ProcessError">
                          <xsl:with-param name="ErrorText">this applySC has no identifiable target: %s1</xsl:with-param>
                          <xsl:with-param name="ErrorValue1" select="$SCid"/>
                        </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
                      </xsl:otherwise>
                    </xsl:choose>
                    <xsl:text>, </xsl:text>
                    <!-- Generate the rule number that has the <applySC> -->
                    <xsl:choose>
                      <xsl:when test="key('generic-id', $referencingRule)[self::item | self::para]">
                        <fo:basic-link internal-destination="'{$referencingRule}'" color="#000070">
                          <xsl:value-of select="$referencingContext"/><xsl:text>&nbsp;</xsl:text>
                          <xsl:apply-templates select="key('generic-id', $referencingRule)"
                                               mode="specref-mode"/>
                        </fo:basic-link>
                      </xsl:when>
                      <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
                        <xsl:call-template name="ProcessError">
                          <xsl:with-param name="ErrorText">referencingRule is invalid: %s1</xsl:with-param>
                          <xsl:with-param name="ErrorValue1" select="$referencingRule"/>
                        </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
                      </xsl:otherwise>
                    </xsl:choose>
                  </fo:block>
                </fo:list-item-body>
              </fo:list-item>
            </xsl:if>
          </xsl:for-each>

          <!-- Now, generate text for every invocation in some other document -->
          <xsl:if test="$extApplyExists=1">
            <!-- Cycle through every "other" part -->
            <xsl:for-each select="$parts[@number=$standardNumber]/part[@TC = 'false'
                                  and @number != '02' and @number != $partno]">
              <!-- Compute the filename of the part -->
              <xsl:variable name="partnum" select="@number"/>
              <xsl:variable name="filename" select="@input"/>
              <xsl:variable name="resultfile" select="@output"/>
              <!-- This is where we need to check whether @active="no" or not.  If @active="no",
                   then the variable needs to prefix the $filename with "./published/". -->
              <xsl:variable name="active" select="@active"/>
              <xsl:variable name="dirstring">
                <xsl:choose>
                  <xsl:when test="$active='no'">
                    <xsl:text>./published/</xsl:text>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:text></xsl:text>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <!-- extroot is the actual source file of the part we're currently checking -->
              <xsl:variable name="extroot"
                            select="document(concat($dirstring, $filename, '.xml'))"/>
              <!-- Cycle through every matching applyExtSC in the part (subClause/subsection) -->
              <xsl:for-each select="$extroot//applyExtSC[@part=$partno and
                                                         @ref=$SCsigSCID and
                                                         @rules=$SCsigSCcontext]">
                <!-- Get the @id attribute value of the nearest <item> ancestor -->
                <xsl:variable name="referencingRule" select="./ancestor::item[1]/@id"/>
                <xsl:variable name="applyRules" select="@rules"/>
                <xsl:variable name="SCid" select="ancestor::subClause/@id"/>
                <xsl:variable name="linkref">
                  <xsl:text>'</xsl:text>
                  <xsl:value-of select="@SCid"/>
                  <xsl:text>'</xsl:text>
                </xsl:variable>

                <!-- Get the context/subsection with the referencing rule -->
                <xsl:variable name="referencingContext">
                 <xsl:choose>
                    <xsl:when test="key('generic-id', $referencingRule)//
                                       ancestor::SyntaxRules">
                      <xsl:text>SR</xsl:text>
                    </xsl:when>
                    <xsl:when test="key('generic-id', $referencingRule)//
                                       ancestor::AccessRules">
                      <xsl:text>AR</xsl:text>
                    </xsl:when>
                    <xsl:when test="key('generic-id', $referencingRule)//
                                       ancestor::GeneralRules">
                      <xsl:text>GR</xsl:text>
                    </xsl:when>
                    <xsl:when test="key('generic-id', $referencingRule)//
                                       ancestor::item">
                      <xsl:text>LI</xsl:text>
                    </xsl:when>
                    <xsl:when test="key('generic-id', $referencingRule)//
                                       ancestor::para">
                      <xsl:text>Para</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
                      <xsl:call-template name="ProcessError">
                        <xsl:with-param name="ErrorText">Subclause signature referenced from an invalid subsection in the Subclause with @id value: %s1</xsl:with-param>
                        <xsl:with-param name="ErrorValue1" select="$SCid"/>
                      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
                    </xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <!-- Emit a reference only if in the correct subsection -->
                <xsl:if test="$applyRules = $SCsigSCcontext">
                  <fo:list-item>
                    <fo:list-item-label end-indent="label-end()">
                      <fo:block text-align="start"><xsl:text>&mdash;</xsl:text></fo:block>
                    </fo:list-item-label>
                    <fo:list-item-body start-indent="body-start()">
                      <fo:block>
                        <xsl:text>This signature is invoked from </xsl:text>
                        <xsl:choose>
                          <xsl:when test="key('generic-id', $SCid)[self::subClause]">
                            <fo:basic-link
                                external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                                show-destination="new" color="#000070">
                              <!-- Force current context to be the proper subClause -->
                              <xsl:for-each select="$extroot//*[@id=$SCid][self::subClause]">
                                <fo:inline keep-together.within-line="always">
                                  <xsl:text>Subclause </xsl:text>
                                  <xsl:variable name="number-format">1.1.1.1</xsl:variable>
                                  <xsl:number level="multiple"
                                              count="annex|clause|subClause|subClause2|
                                                     subClause3|subClause4"
                                              format="{$number-format}"/>
                                  <xsl:text>,</xsl:text>
                                </fo:inline>
                                <xsl:text> &ldquo;</xsl:text>
                                <xsl:apply-templates select="clauseHeading">
                                  <xsl:with-param name="fromPart" select="$partnum"/>
                                  <xsl:with-param name="fromStandard" select="$standardNumber"/>
                                </xsl:apply-templates>
                                <xsl:text>&rdquo;</xsl:text>
                              </xsl:for-each>
                            </fo:basic-link>
                          </xsl:when>
                          <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
                            <xsl:call-template name="ProcessError">
                              <xsl:with-param name="ErrorText">this applyExtSC has no identifiable target or references invalid object: %s1</xsl:with-param>
                              <xsl:with-param name="ErrorValue1" select="$SCid"/>
                            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
                          </xsl:otherwise>
                       </xsl:choose>
                       <xsl:text>, </xsl:text>
                        <xsl:choose>
                          <xsl:when test="$extroot//*[@id=$referencingRule][self::item]">
                            <fo:basic-link external-destination=
                                             "url('file:{$resultfile}.pdf#{$linkref}')"
                                           show-destination="new" color="#000070">
                              <!-- In the link, every item with a "matching" id is processed
                                   (there should be only one!) -->
                                <xsl:for-each select="$extroot//*[@id=$referencingRule]
                                                                 [self::item]">
                                <xsl:variable name="list-level">
                                  <xsl:value-of select="count(ancestor-or-self::olist)"/>
                                </xsl:variable>
                                <xsl:value-of select="$referencingContext"/>
                                <xsl:text>&nbsp;</xsl:text>
                                <xsl:call-template name="olist-item-number-ref">
                                  <xsl:with-param name="list-level" select="$list-level"/>
                                </xsl:call-template>
                              </xsl:for-each>
                            </fo:basic-link>
                          </xsl:when>
                          <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
                            <xsl:call-template name="ProcessError">
                              <xsl:with-param name="ErrorText">this applyExtSC has no identifiable target: %s1</xsl:with-param>
                              <xsl:with-param name="ErrorValue1" select="$referencingRule"/>
                            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
                          </xsl:otherwise>
                        </xsl:choose>
                        <xsl:text>, in ISO/IEC 9075-</xsl:text>
                        <xsl:value-of select="$partnum"/>
                      </fo:block>
                    </fo:list-item-body>
                  </fo:list-item>
                </xsl:if>
              </xsl:for-each>
            </xsl:for-each>
          </xsl:if>
        </fo:list-block>
      </fo:block>
    </xsl:if>
  </xsl:for-each>
</xsl:template>

<!--
    apply-modifies-part
-->
<xsl:template name="apply-modifies-part">
  <xsl:param name="fromPart" select="'xx'"/>
  <xsl:param name="fromStandard" select="'xx'"/>
  <xsl:variable name="thisClause" select="."/>
  <xsl:variable name="lookingForID"
                select="$thisClause/@id"/>
  <xsl:for-each select="$parts[@number=$standardNumber]/part[@TC = 'false'
                        and @number != '02' and @number != $partno]">
    <xsl:variable name="partnum" select="@number"/>
    <xsl:variable name="filename" select="@input"/>
    <xsl:variable name="resultfile" select="@output"/>
<!-- extroot is the actual source file of the part we're currently checking -->
<!-- This is where we need to check whether @active="no" or not.  If @active="no", then the
     variable needs to prefix the $filename with "./published/". -->
<!--    <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/> -->
    <xsl:variable name="active" select="@active"/>
    <xsl:variable name="dirstring">
      <xsl:choose>
        <xsl:when test="$active='no'">
          <xsl:text>./published/</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text></xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
    <xsl:for-each select="$extroot//modifiesPart[@ref=$lookingForID]">
      <xsl:variable name="thisSection"
                    select="ancestor::*[name(.)='clause' or name(.)='annex' or
                                        name(.)='subClause' or name(.)='subClause2' or
                                        name(.)='subClause3' or name(.)='subClause4'][1]"/>
      <xsl:variable name="ref" select="$thisSection/@id"/>
      <xsl:variable name="linkref">
        <xsl:text>'</xsl:text>
        <xsl:value-of select="$ref"/>
        <xsl:text>'</xsl:text>
      </xsl:variable>
      <fo:block font-style="italic">
        <xsl:text>This </xsl:text>
        <xsl:choose>
          <xsl:when test="string(node-name($thisClause)) = 'clause'">
            <xsl:text>Clause</xsl:text>
          </xsl:when>
          <xsl:when test="string(node-name($thisClause)) = 'annex'">
            <xsl:text>Annex</xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>Subclause</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text> is modified by </xsl:text>
        <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                       show-destination="new" color="#000070">
            <fo:inline keep-together.within-line="always">
              <xsl:choose>
                <xsl:when test="$thisSection/self::clause">
                  <xsl:text>Clause </xsl:text>
                </xsl:when>
                <xsl:when test="$thisSection/self::annex">
                  <xsl:text>Annex </xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>Subclause </xsl:text>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:variable name="body" select="count(ancestor::standardPartBody)"/>
              <xsl:variable name="number-format">
                <xsl:choose>
                  <xsl:when test="$body=1">1.1.1.1</xsl:when>
                  <xsl:otherwise>A.1.1.1</xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <xsl:number level="multiple"
                          count="annex|clause|subClause|subClause2|subClause3|subClause4"
                          format="{$number-format}"/>
              <xsl:text>,</xsl:text>
            </fo:inline>
            <xsl:text> &ldquo;</xsl:text>
            <xsl:apply-templates select="$thisSection/clauseHeading"/>
            <xsl:text>&rdquo;</xsl:text>
        </fo:basic-link>
        <xsl:text>, in ISO/IEC </xsl:text>
        <xsl:value-of select="$standardNumber"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="number($partnum)"/>
        <xsl:text>. </xsl:text>
      </fo:block>
    </xsl:for-each>
  </xsl:for-each>
</xsl:template>


<!--
=================================================================================================== 
==  Utility templates                                                                            ==
=================================================================================================== 
-->

<!--
     This template decides whether or not to render the contents of comment elements, and
     does so if it is decided to do so. 
-->
<xsl:template name="maybePrintComments">
  <xsl:if test="$render-comments = 'yes'">
    <xsl:for-each select="preceding::element(comment) intersect
                          preceding::element()[not(. instance of 
                            element(comment))][1]/following::element(comment)">
      <!-- print comment text -->
      <fo:block color="gray">
        <xsl:text>Source: </xsl:text>
        <xsl:value-of select="."/>
      </fo:block>
    </xsl:for-each>
  </xsl:if>
</xsl:template>

<!--
    The calc.column.width template computes the column width of a column.
    No, I did not figure this out by myself; I "borrowed" it ;^)
-->
<xsl:template name="calc.column.width">
  <!-- **
  * <p>Calculate an XSL FO table column-width specification from a CALS-like table column-width 
    specification.</p>
  *
  * <p>CALS expresses table column-widths in the following basic
  * forms:</p>
  *
  * <ul>
  * <li><b>99.99units</b>, a fixed length-specifier.</li>
  * <li><b>99.99</b>, a fixed length-specifier without any units.</li>
  * <li><b>99.99*</b>, a relative length-specifier.</li>
  * <li><b>99.99*+99.99units</b>, a combination of both.</li>
  * </ul>
  *
  * <p>The CALS units are points (pt), picas (pi), centimeters (cm),
  * millimeters (mm), and inches (in). These are the same units as XSL,
  * except that XSL abbreviates picas "pc" instead of "pi". If a length
  * specifier has no units, the CALS default unit (pt) is assumed.
  * If picas are wanted, we use "pc" and not "pi".</p>
  *
  * <p>Relative length-specifiers are represented in XSL with the
  * proportional-column-width() function.</p>
  *
  * <p>Here are some examples:</p>
  *
  * <ul>
  * <li>"36pt" becomes "36pt"</li>
  * <li>"3pc" becomes "3pc"</li>
  * <li>"36" becomes "36pt"</li>
  * <li>"3*" becomes "proportional-column-width(3)"</li>
  * <li>"3*+2pc" becomes "proportional-column-width(3)+2pc"</li>
  * <li>"1*+2" becomes "proportional-column-width(1)+2pt"</li>
  * </ul>
  *
  * @param colwidth The CALS column width specification.
  *
  * @returns The XSL column width specification.
  * -->
  <xsl:param name="colwidth">1*</xsl:param>
  <!-- Ok, the colwidth could have any one of the following forms:
       1* = proportional width
       1unit = 1.0 units wide
       1 = 1pt wide
       1*+1unit = proportional width + some fixed width
       1*+1 = proportional width + some fixed width
       If it has a proportional width, translate it to XSL -->
  <xsl:if test="contains($colwidth, '*')">
    <xsl:text>proportional-column-width(</xsl:text>
    <xsl:value-of select="substring-before($colwidth, '*')"/>
    <xsl:text>)</xsl:text>
  </xsl:if>
  <!-- Now get the non-proportional part of the specification -->
  <xsl:variable name="width-units">
    <xsl:choose>
      <xsl:when test="contains($colwidth, '*')">
        <xsl:value-of select="normalize-space(substring-after($colwidth, '*'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="normalize-space($colwidth)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- Now the width-units could have any one of the following forms:
       = <empty string>
       1unit = 1.0 units wide
       1 = 1pt wide with an optional leading sign
       Get the width part by blanking out the units part and discarding whitespace. -->
  <xsl:variable name="width"
    select="normalize-space(translate($width-units,
      '+-0123456789.abcdefghijklmnopqrstuvwxyz',
      '+-0123456789.'))"/>
  <!-- Get the units part by blanking out the width part and discarding whitespace. -->
  <xsl:variable name="units"
    select="normalize-space(translate($width-units,
      'abcdefghijklmnopqrstuvwxyz+-0123456789.',
      'abcdefghijklmnopqrstuvwxyz'))"/>
  <!-- Output the width -->
  <xsl:value-of select="$width"/>
  <!-- Output the units, translated appropriately -->
  <xsl:choose>
    <xsl:when test="$units = '' and $width != ''">pt</xsl:when>
    <xsl:otherwise><xsl:value-of select="$units"/></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
     This template is used to "escape" < and > in contents where they are not permitted
-->
<xsl:template name="escape-lt-gt">
  <xsl:param name="input"/>
  <xsl:choose>
    <xsl:when test="substring($input, 1, 1) = '&lt;'">
      <xsl:text>&amp;lt;</xsl:text>
    </xsl:when>
    <xsl:when test="substring($input, 1, 1) = '&gt;'">
      <xsl:text>&amp;gt;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="substring($input, 1, 1)"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:variable name="remainder" select="substring($input, 2)"/>
  <xsl:if test="$remainder">
    <xsl:call-template name="escape-lt-gt">
      <xsl:with-param name="input" select="$remainder"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>


<!-- 
     This template (GenerateLittleRedBoxForMergeWith) generates the "little red box" that
     contains the part number of a part that references the object (e.g., <para>, <item>, etc.)
     being generated by the calling template.
     NOTE: THIS TEMPLATE IS CALLED ONLY WHEN THE REFERENCE IS FROM A mergeWith!!!
-->
<xsl:template name="GenerateLittleRedBoxForMergeWith">
  <xsl:param name="id"/>
  <xsl:variable name="thisNode" select="."/>

  <xsl:for-each select="$parts[@number=$standardNumber]/part[@TC = 'false'
                               and @number != '02' and @number != $partno]">
    <xsl:variable name="partnum" select="@number"/>
    <xsl:variable name="filename" select="@input"/>
    <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
    <xsl:variable name="output" select="@output"/>

    <xsl:choose>
      <xsl:when test="$extroot//mergeWith//node()[@ref = $id] or
                      $extroot//replicateSCsig[@ref = $id]">
        <xsl:variable name="outfilename" select="@output"/>
        <xsl:variable name="TheMergeWith" select="$extroot//node()[@ref = $id][1]"/>
        <xsl:variable name="mergeSection"
                      select="$TheMergeWith/ancestor::*
                                [name(.)='clause' or name(.)='annex' or
                                 name(.)='subClause' or name(.)='subClause2' or
                                 name(.)='subClause3' or name(.)='subClause4'][1]"/>
        <xsl:variable name="backlinkRef" select="$mergeSection/@id"/>
        <xsl:variable name="backlinkID">
          <xsl:text>P</xsl:text>
          <xsl:value-of select="$partnum"/>
          <xsl:text>_GENERATED_</xsl:text>
          <xsl:value-of select="$backlinkRef"/>
          <xsl:text>_</xsl:text>
          <xsl:value-of select="$id"/>
          <xsl:text>_0</xsl:text>
        </xsl:variable>
        <fo:basic-link external-destination="url('file:{$outfilename}.pdf#{$backlinkID}')"
                       show-destination="new" color="#000070">
          <fo:inline border-color="red" padding-before="2pt" border-style="solid"
                     border-width="thin" color="red" font-size="{$redbox-size}">
            &nspace;<xsl:value-of select="$partnum"/>&nspace;
          </fo:inline>
        </fo:basic-link>
      </xsl:when>
<!--
  When "this" node is an <item> that is the last <item> of an <olist> AND
  there is, in the "other" part, a <mergeWith> that has a child <addRule>
  that has a child <last>, such that the <mergeWith>'s parent is an <item>
  with an <olist> parent that has a parent subsection (e.g., SyntaxRules) that is
  the same subsection element as "this" node's subsection element AND
  the "other part" references "this" part in the <mergeWith> AND
  the subClause @id (after the underscore) is the same as "this" node's @id...
-->
      <xsl:when test="($thisNode/local-name(.)='item' and
                       ($thisNode/ancestor::olist/count(item) =
                        count($thisNode/preceding-sibling::item)+1)) or
                       $thisNode/local-name(.)='None'">
        <xsl:variable name="thisContainerID"
                      select="$thisNode/parent::olist/(parent::SyntaxRules | parent::AccessRules |
                              parent::GeneralRules | parent::ConformanceRules |
                              parent::Description | parent::TablePopulation)/
                              ancestor::subClause/@id"/>
        <xsl:variable name="thisComparisonID"
                      select="substring-after($thisContainerID, '_')"/>
        <xsl:variable name="thisSubsection"
                      select="$thisNode/parent::olist/(parent::SyntaxRules | parent::AccessRules |
                              parent::GeneralRules | parent::ConformanceRules |
                              parent:: Description |
                              parent::TablePopulation)/local-name(.)"/>
        <xsl:variable name="thisSubsectionCode">
          <xsl:choose>
            <xsl:when test="$thisSubsection = 'SyntaxRules'">
              <xsl:text>SR</xsl:text>
            </xsl:when>
            <xsl:when test="$thisSubsection = 'AccessRules'">
              <xsl:text>AR</xsl:text>
            </xsl:when>
            <xsl:when test="$thisSubsection = 'GeneralRules'">
              <xsl:text>GR</xsl:text>
            </xsl:when>
            <xsl:when test="$thisSubsection = 'ConformanceRules'">
              <xsl:text>CR</xsl:text>
            </xsl:when>
            <xsl:when test="$thisSubsection = 'Description'">
              <xsl:text>Desc</xsl:text>
            </xsl:when>
            <xsl:when test="$thisSubsection = 'TablePopulation'">
              <xsl:text>TP</xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>UNKNOWN</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:if test="exists($extroot//mergeWith[addRule/last][@part = $partno]
                               [(parent::item/parent::olist/
                                  (parent::SyntaxRules | parent::AccessRules |
                                   parent::GeneralRules | parent::ConformanceRules |
                                   parent::Description | parent::TablePopulation)/local-name(.)
                                 = $thisSubsection)
                            and (substring-after(parent::item/parent::olist/
                                  (parent::SyntaxRules | parent::AccessRules |
                                   parent::GeneralRules | parent::ConformanceRules |
                                   parent::Description | parent::TablePopulation)/
                                   ancestor::subClause/@id, '_')
                                 = $thisComparisonID)])">
          <xsl:variable name="referencingContainerID"
                        select="$extroot//mergeWith[addRule/last][@part = $partno]
                                  [(parent::item/parent::olist/
                                     (parent::SyntaxRules | parent::AccessRules |
                                      parent::GeneralRules | parent::ConformanceRules |
                                      parent::Description | parent::TablePopulation)/local-name(.)
                                    = $thisSubsection)
                               and (substring-after(parent::item/parent::olist/
                                     (parent::SyntaxRules | parent::AccessRules |
                                      parent::GeneralRules | parent::ConformanceRules |
                                      parent::Description | parent::TablePopulation)/
                                      ancestor::subClause/@id, '_')
                                    = $thisComparisonID)]/
                                   ancestor::subClause/@id"/>
<!-- If all conditions are satisfied, generate the ID associated with the first (of
     possibly multiple) referencing rule(s) in the "other" part and generate
     a hot link to that location -->
          <xsl:variable name="outfilename" select="$output"/>
          <xsl:variable name="TheMergeWith"
                        select="$extroot//mergeWith[addRule/last][@part = $partno]
                               [(parent::item/parent::olist/
                                  (parent::SyntaxRules | parent::AccessRules |
                                   parent::GeneralRules | parent::ConformanceRules |
                                   parent::Description | parent::TablePopulation)/local-name(.)
                                 = $thisSubsection)
                            and (substring-after( parent::item/parent::olist/
                                  (parent::SyntaxRules | parent::AccessRules |
                                   parent::GeneralRules | parent::ConformanceRules |
                                   parent::Description | parent::TablePopulation)/
                                   ancestor::subClause/@id, '_')
                                 = $thisComparisonID)][1]"/>
          <xsl:variable name="mergeSection"
                        select="$TheMergeWith/ancestor::*
                                  [local-name(.)='clause' or local-name(.)='annex' or
                                   local-name(.)='subClause' or local-name(.)='subClause2' or
                                   local-name(.)='subClause3' or local-name(.)='subClause4'][1]"/>
          <xsl:variable name="backlinkRef" select="$mergeSection/@id"/>
          <xsl:variable name="backlinkID">
            <xsl:text>P</xsl:text>
            <xsl:value-of select="$partnum"/>
            <xsl:text>_GENERATED_</xsl:text>
            <xsl:value-of select="$backlinkRef"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$thisSubsectionCode"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$partno"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$thisContainerID"/>
            <xsl:text>_0</xsl:text>
          </xsl:variable>
          <xsl:variable name="thisRuleID">
            <xsl:text>R</xsl:text>
            <xsl:value-of select="$partno"/>
            <xsl:text>_GENERATED_</xsl:text>
            <xsl:value-of select="$thisContainerID"/>
            <xsl:text>_LastRuleFrom_</xsl:text>
            <xsl:value-of select="$thisSubsectionCode"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$partnum"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$referencingContainerID"/>
          </xsl:variable>

          <fo:basic-link id="{$thisRuleID}"
                         external-destination="url('file:{$outfilename}.pdf#{$backlinkID}')"
                         show-destination="new" color="#000070">
            <fo:inline border-color="red" padding-before="2pt" border-style="solid"
                       border-width="thin" color="red" font-size="{$redbox-size}">
              &nspace;<xsl:value-of select="$partnum"/>&nspace;
            </fo:inline>
          </fo:basic-link>
        </xsl:if>
      </xsl:when>
    </xsl:choose>

  </xsl:for-each>
</xsl:template>


<!-- 
     This template (GenerateLittleRedBoxForBNFdef) generates the "little red box" that
     contains the part number of a part that references the BNF definition
     being generated by the calling template. 
     NOTE: THIS TEMPLATE IS CALLED ONLY WHEN THE REFERENCE IS FROM A BNFdef!!!
-->
<xsl:template name="GenerateLittleRedBoxForBNFdef">
  <xsl:param name="name"/>
  <xsl:for-each select="$parts[@number=$standardNumber]/part[@TC = 'false'
                               and @number != '02' and @number != $partno]">
    <xsl:variable name="partnum" select="@number"/>
    <xsl:variable name="filename" select="@input"/>
    <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
<!-- Generate the "little red box" only if "this" BNFdef is not in an incremental part -->
    <xsl:if test="$extroot//BNFdef[@name = $name and
                                   descendant::allAltsFrom[@part=$partno]]">
      <xsl:variable name="outfilename" select="@output"/>
      <xsl:variable name="backlinkID">
        <xsl:text>'BNF_</xsl:text>
        <xsl:value-of select="$name"/>
        <xsl:text>'</xsl:text>
      </xsl:variable>
<!-- NOTE - PAY ATTENTION:
     In the following fo:basic-link, we put the external-destination value within
     single-quotes and the url value in double-quotes.  This is because the value of
     $backlinkID might have single-quotes in it, since it's the @id of a BNFdef. 
     This is the only known exception to our convention of enclosing attribute
     values within double-quotes.
-->
      <fo:basic-link external-destination='url("file:{$outfilename}.pdf#{$backlinkID}")'
                     show-destination="new" color="#000070">
        <fo:inline border-color="red" padding-before="2pt" border-style="solid"
                   border-width="thin" color="red" font-size="{$redbox-size}">
          &nspace;<xsl:value-of select="$partnum"/>&nspace;
        </fo:inline>
      </fo:basic-link>
    </xsl:if>
  </xsl:for-each>
</xsl:template>



<!--
=================================================================================================== 
==  Editor's Notes-related templates                                                             ==
=================================================================================================== 
-->


<!--
    Transform the reference child of the PP or LO element
-->
<xsl:template name="reference">
  <xsl:apply-templates select="reference/*"/>
</xsl:template>


<!--
    Transform the noteAt child of the PP or LO element
-->
<xsl:template name="noteAt">
  <xsl:apply-templates select="noteAt/*"/>
</xsl:template>


<!--
    Transform the source child of the PP or LO element 
-->
<xsl:template name="source">
  <xsl:apply-templates select="source/*"/>
</xsl:template>


<!--
    Transform the problem child of the PP or LO element
-->
<xsl:template name="problem">
  <xsl:apply-templates select="problem/*"/>
</xsl:template>


<!--
    Transform the solution child of the PP or LO element
-->
<xsl:template name="solution">
  <xsl:apply-templates select="solution/*"/>
</xsl:template>


<!--
=================================================================================================== 
=================================================================================================== 
==  The following templates are both called (named) and invoked while processing markup          ==
=================================================================================================== 
=================================================================================================== 
-->

<!--
    Process the docref element to reference refdoc.class elements in NormativeReferences or 
    bibliography.  This is *called* only from <xsl:template match="conditionsTable">.
-->
<xsl:template match="docref" name="docref">
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="this-referencedDocument" select="//referencedDocument[@id=$ref]"/>
  <xsl:variable name="partnum" select="substring-after($partno,'-')"/>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$partnum]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$partnum]/@output"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
  <xsl:variable name="parent" select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                                       ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                                       ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                                       [last()]"/>
  <xsl:variable name="refDocument" select="$ReferencedDocuments[@id=$ref]/self::node()"/>

  <xsl:choose>
    <xsl:when test="$refDocument[self::iso-iec-std | self::div-std | 
                                            self::electronic-doc]">
    <!-- Per Directives part 2, 2018, do not put square brackets around references to 
         documents in Normative References -->
      <fo:basic-link internal-destination="'{$ref}'" color="#000070">
        <xsl:value-of select="$refDocument/docIdentifier"/>
        <xsl:if test="$refDocument/docDate">
          <xsl:text>:</xsl:text><xsl:value-of select="$refDocument/docDate"/>
        </xsl:if>
        <xsl:variable name="bibRefNum">
          <xsl:choose>
            <xsl:when test="$this-referencedDocument/ancestor::bibliography">
              <xsl:value-of
                select="count($this-referencedDocument/
                        preceding-sibling::referencedDocument)+1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="0"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:if test="$bibRefNum != 0">
          <fo:inline>
            <xsl:text> [</xsl:text>
            <xsl:value-of select="$bibRefNum"/>
            <xsl:text>]</xsl:text>
          </fo:inline>
        </xsl:if>
      </fo:basic-link>
    </xsl:when>

    <xsl:when test="$refDocument[self::referencedDocument]">
      <xsl:variable name="ref2" select="key('generic-id', $ref)[self::referencedDocument]/@id"/>
      <xsl:variable name="theReferencedDocument"
                    select="$ReferencedDocuments[@id=$ref2]/self::node()"/>
      <fo:basic-link internal-destination="'{$ref2}'" color="#000070">
        <xsl:value-of select="$theReferencedDocument/docIdentifier"/>
        <xsl:if test="$theReferencedDocument/docDate">
          <xsl:text>:</xsl:text><xsl:value-of select="$theReferencedDocument/docDate"/>
        </xsl:if>
        <xsl:variable name="bibRefNum">
          <xsl:choose>
            <xsl:when test="ancestor::bibliography">
              <xsl:value-of
                select="count($refDocument/
                        preceding-sibling::referencedDocument[@id=$ref])+1"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="0"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <fo:inline>
          <xsl:text> [</xsl:text>
          <xsl:value-of select="$bibRefNum"/>
          <xsl:text>]</xsl:text>
        </fo:inline>
      </fo:basic-link>
    </xsl:when>

    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="( $parts[@number=$standardNumber]/part[@number=$partno]/@TC = 'true' )">
          <xsl:choose>
            <xsl:when test="$extroot//*[@id = $ref]
                            [self::iso-iec-std | self::div-std | 
                             self::electronic-doc | self::referencedDocument]">
            <!-- Per Directives part 2, 2018, do not put square brackets around references to
                 Normative References
                 When is there a docRef to anything that is not a proper document reference? -->
              <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                             show-destination="new" color="#000070">
                <xsl:value-of select="$ref"/>
              </fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
              <xsl:call-template name="ProcessError">
                <xsl:with-param name="ErrorText">This docref has no identifiable target: %s1 The element id of the parent element = %s2</xsl:with-param>
                <xsl:with-param name="ErrorValue1" select="$ref"/>
                <xsl:with-param name="ErrorValue2" select="$parent"/>
              </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
            </xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">This docref has no identifiable target: %s1 The element id of the parent element = %s2</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$ref"/>
            <xsl:with-param name="ErrorValue2" select="$parent"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!--
=================================================================================================== 
=================================================================================================== 
==  The following templates invoked as a result or normally processing markup                    ==
=================================================================================================== 
=================================================================================================== 
-->


<!--
=================================================================================================== 
==  Templates that process sections of the document                                              ==
=================================================================================================== 
-->


<!--
  Process the coverPage element
-->
<xsl:template match="coverPage">
<!--
    If we're doing a working draft, then put out the WG3 and H2 paper numbers
-->
  <xsl:if test="substring-after($formalStage, '-')='20'">
    <fo:block font="bold 14pt Helvetica" text-align="end"
              space-after.optimum="11pt" height="40pt">
      <fo:block>
        <xsl:text>WG3:</xsl:text>
        <xsl:value-of select="$parts[@number=$standardNumber]/part[@number=$partno]/@WG3"/>
      </fo:block>
      <xsl:if test="string-length($parts[@number=$standardNumber]/part[@number=$partno]/@H2) > 0">
        <fo:block>
          <xsl:text>DM32-</xsl:text>
          <xsl:value-of select="$parts[@number=$standardNumber]/part[@number=$partno]/@H2"/>
        </fo:block>
      </xsl:if>
    </fo:block>
  </xsl:if>
<!-- 
    We first have the Subcommittee information right justified
-->
  <fo:block font="bold 12pt Helvetica" text-align="end">
    <xsl:value-of select="SCtitle"/>
  </fo:block>
<!--
    Next comes the date of publication, also right justified
-->
  <fo:block font="9pt Helvetica" text-align="end"
            space-before.optimum="11pt" space-before.precedence="force">
    Date: <xsl:value-of select="substring(string(current-date()),1,10)"/>
  </fo:block>
<!--
    Then we get the formal number of the document, such as ISO/IEC 9075-4:200x(E)
-->
  <fo:block font="bold 12pt Helvetica" text-align="end"
            space-before.optimum="14pt" space-before.precedence="force">
    <xsl:value-of select="$docNumber"/>
  </fo:block>
<!--
    The Working Group information is then right justified
-->
  <fo:block font="9pt Helvetica" text-align="end"
            space-before.optimum="14pt" space-before.precedence="force">
    <xsl:value-of select="WGtitle"/>
  </fo:block>
<!--
    And we right justify the secretariat information
-->
  <fo:block font="9pt Helvetica" text-align="end"
            space-before.optimum="10pt" space-before.precedence="force">
    <xsl:value-of select="secretariat"/>
  </fo:block>
<!--
    After leaving some white space, we put the English title of the document
-->
  <fo:block font="bold 12pt Helvetica" text-align="start"
            space-before.optimum="60pt" space-before.precedence="force">
    <xsl:value-of select="partTitleEnglish/partTitleEnglish1"/>
  </fo:block>
  <xsl:if test="(partTitleEnglish/partTitleEnglish2 and
                 partTitleEnglish/partTitleEnglish2 != '')">
    <fo:block font="bold 12pt Helvetica" text-align="start" space-before="6pt">
      <xsl:value-of select="partTitleEnglish/partTitleEnglish2"/>
    </fo:block>
  </xsl:if>
  <fo:block font="bold 12pt Helvetica" text-align="start">
    <xsl:value-of select="partTitleEnglish/partTitleEnglish3"/>
  </fo:block>
  <xsl:if test="partTitleEnglish/partTitleEnglish4">
    <fo:block font="bold 12pt Helvetica" text-align="start" space-before="9pt">
      <xsl:value-of select="partTitleEnglish/partTitleEnglish4"/>
    </fo:block>
  </xsl:if>
<!--
    And then we put the French language title
-->
  <fo:block font="italic 9pt Helvetica" text-align="start"
            space-before.optimum="12pt" space-before.precedence="force">
    <xsl:value-of select="partTitleFrench/partTitleFrench1"/>
  </fo:block>
  <fo:block font="italic 9pt Helvetica" text-align="start" space-before="4pt">
    <xsl:value-of select="partTitleFrench/partTitleFrench2"/>
  </fo:block>
  <xsl:if test="partTitleFrench/partTitleFrench3">
    <fo:block font="italic 9pt Helvetica" text-align="start"
              space-before="9pt">
      <xsl:value-of select="partTitleFrench/partTitleFrench3"/>
    </fo:block>
  </xsl:if>
<!--
    If we're NOT doing a working draft, then put out a compensating empty block
-->
  <xsl:if test="substring-after($formalStage, '-')!='20'">
    <fo:block font="bold 12pt Helvetica" text-align="end"
              space-before.optimum="11pt" height="40pt"/>
  </xsl:if>
<!--
    After still more space, we put some administrative information
-->
  <fo:block font="9pt Helvetica" text-align="start"
            space-before.optimum="200pt" space-before.precedence="force">
    Document type: <xsl:value-of select="translate(/standard/@documentType, 
                                        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz_', 
                                        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ')"/>
  </fo:block>
<!--
    More administrative information 
-->
  <fo:block font="9pt Helvetica" text-align="start"
            space-before.optimum="0pt" space-before.precedence="force">
    Document subtype: <xsl:value-of select="$documentSubtype"/>
  </fo:block>
<!--
    More administrative information
-->
  <fo:block font="9pt Helvetica" text-align="start"
            space-before.optimum="0pt" space-before.precedence="force">
    Document stage: <xsl:value-of select="$formalStage"/>
  </fo:block>
<!--
    More administrative information
-->
  <fo:block font="9pt Helvetica" text-align="start"
            space-before.optimum="0pt" space-before.precedence="force">
    Document language: <xsl:value-of select="$docLanguage"/>
  </fo:block>
<!--
    More administrative information
-->
  <fo:block font="9pt Helvetica" text-align="start"
            space-before.optimum="0pt" space-before.precedence="force">
    Document name: <xsl:value-of select="$docName"/>
  </fo:block>
</xsl:template>

<!--
    Process the copyrightNoticePage element
-->
<xsl:template match="copyrightNoticePage">
<!-- 
    I want a border around the entire notice
-->
  <fo:block border-color="black" border-style="solid"
            border-width="1pt" padding="9pt">
<!--
    The copyright notice heading: centered 12 point Cambria bold
-->
    <fo:block font="{$head-weight} {$head1-size} {$font-name}"
              text-align="center" space-after="9pt">
      <xsl:text>Copyright notice</xsl:text>
    </fo:block>
<!-- 
    The specific copyright statement depends on the processing stage (WD/CD or DIS/FDIS/IS)
-->
    <xsl:choose>
<!-- When the document is an IWD, WD, CD, DIS, DTR, WDCOR, or DCOR use one copyright notice -->
      <xsl:when test="substring-after($formalStage, '-')='20' or
                      substring-after($formalStage, '-')='30'">
<!--
    The copyright body text is left-aligned, in 9 point Helvetica   
-->
&regCopyrightStage2or3;
      </xsl:when>
<!-- When the document is an FDIS, IS, TR, or COR, use the official copyright notice -->
      <xsl:otherwise>
<!-- 
    The copyright body text is left-aligned, in 9 point Helvetica   
-->
&regCopyrightStage4or5;
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<!-- 
    Process the alternateCopyrightNoticePage element                
-->
<xsl:template match="alternateCopyrightNoticePage">
<!-- 
    I want a border around the entire notice                        
-->
  <fo:block border-color="black" border-style="solid"
            border-width="1pt" padding="9pt">
<!-- 
    The copyright notice heading: centered 12 point Cambria bold  
-->
    <fo:block font="bold 12pt {$font-name}" text-align="center" space-after="9pt">
      <xsl:text>Notice</xsl:text>
    </fo:block>
<!-- 
    The INCITS copyright statement depends on the processing stage (WD/CD or DIS/FDIS/IS)
-->
    <xsl:choose>
<!-- When the document is an IWD, WD, CD, DIS, DTR, WDCOR, or DCOR use one copyright notice -->
      <xsl:when test="substring-after($formalStage, '-')='20' or
                      substring-after($formalStage, '-')='30'">
&altCopyrightStage2or3;
      </xsl:when>
<!-- When the document is an FDIS, IS, TR, or COR, use the official copyright notice -->
      <xsl:otherwise>
&altCopyrightStage4or5;
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<!--
    Process the forewordBody element 
-->
<xsl:template match="forewordBody">
  <!-- A forewordBody contains boilerplace and document-specific text -->
  <xsl:apply-templates select="bodyMatter"/>
</xsl:template>

<!--
    Process the introBody element
    An introBody is nothing other than bodyMatter
-->
<xsl:template match="introBody">
  <xsl:apply-templates select="bodyMatter"/>
</xsl:template>


<!--
    Process the partHeading element
    A partHeading has a rule above and below
-->
<xsl:template match="partHeading">
  <fo:block text-align="justify" space-before="-30pt" space-before.precedence="3"
            space-after="4pt" space-after.precedence="2">
    <fo:leader leader-pattern="rule" leader-length.maximum="210mm"
               leader-length.optimum="210mm"
               rule-style="solid" rule-thickness="2pt"/>
  </fo:block>
  <fo:block font="{$partHeading-weight} {$partHeading-size} {$font-name}"
            text-align="justify" text-align-last="justify"
            space-before="0pt" space-before.precedence="3"
            space-after="4pt" space-after.precedence="2">
    <xsl:value-of select="translate(/standard/@documentType, 'abcdefghijklmnopqrstuvwxyz_', 
                                                             'abcdefghijklmnopqrstuvwxyz ')"/>
    <fo:leader leader-pattern="space" leader-length.maximum="100%"/>
    <xsl:choose>
<!-- Added ISO/IEC PRF and ISO/IEC PRF TR as possible values -->
      <xsl:when test="$docStage != 'ISO/IEC' and $docStage != 'INCITS' and
                      $docStage != 'ISO/IEC PRF' and
                      $docStage != 'ISO/IEC TR' and $docStage != 'INCITS TR-' and
                      $docStage != 'ISO/IEC PRF TR'">
        <!-- This covers all non-publication states, such as WD -->
        <xsl:text>ISO/IEC </xsl:text>
        <xsl:value-of select="$docStage"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$isoNumber"/>
      </xsl:when>
      <xsl:when test="$docStage = 'INCITS' or $docStage = 'INCITS TR-'">
        <!-- This covers all INCITS publications -->
        <xsl:value-of select="$docStage"/><xsl:text> </xsl:text><xsl:value-of select="$isoNumber"/>
        <xsl:text>-</xsl:text><xsl:value-of select="$docYear"/>
      </xsl:when>
<!-- Added ISO/IEC PRF and ISO/IEC PRF TR as possible values -->
      <xsl:when test="$docStage = 'ISO/IEC' or $docStage = 'ISO/IEC TR' or
                      $docStage = 'ISO/IEC PRF' or $docStage = 'ISO/IEC PRF TR'">
        <!-- This covers ISO/IEC publications -->
        <xsl:value-of select="$docStage"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="$isoNumber"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="$docYear"/>
        <xsl:text>(en)</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <!-- This is for other, unknown states; should never be produced -->
        <xsl:text>:</xsl:text><xsl:value-of select="$docYear"/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
  <fo:block text-align="justify" space-before="-8pt" space-before.precedence="3"
            space-after="66pt" space-after.precedence="3">
    <fo:leader leader-pattern="rule" leader-length.maximum="210mm"
               leader-length.optimum="210mm"
               rule-style="solid" rule-thickness="2pt"/>
  </fo:block>
</xsl:template>

<!--
    Process the partTitle element
    A partTitle has partTitleOne, ..Two, ..Three, maybe ..Four
-->
<xsl:template match="partTitle">
  <fo:block font-weight="{$partTitleOne-weight}" font-size="{$partTitleOne-size}"
            text-align="start">
    <xsl:value-of select="partTitleOne"/>
  </fo:block>
  <fo:block font-weight="{$partTitleTwo-weight}" font-size="{$partTitleTwo-size}"
            text-align="start" space-before="9pt">
    <xsl:value-of select="partTitleTwo"/>
  </fo:block>
  <fo:block font-weight="{$partTitleThree-weight}" font-size="{$partTitleThree-size}"
            text-align="start">
    <xsl:value-of select="partTitleThree"/>
  </fo:block>
  <xsl:if test="partTitleFour">
    <fo:block font-weight="{$partTitleFour-weight}" font-size="{$partTitleFour-size}"
              text-align="start" space-before="18pt">
      <xsl:value-of select="partTitleFour"/>
    </fo:block>
  </xsl:if>
  <fo:block space-after="20pt"/>
</xsl:template>

<!--
    This template handles subClause, subClause2, subClause3, and subClause4 elements
    NOTE: The templates that process the clause and annex elements are contained in
    the "master" stylesheets. 
-->
<xsl:template match="subClause | subClause2 | subClause3 | subClause4">
<!--
    If the subClause* element has a newpage attribute, start a new page first, unless it is the 
    first subClause element in a clause element! 
-->
  <xsl:if test="@newpage='true' and position()>1">
    <fo:block break-before="page"/>
  </xsl:if>
<!--
    subClause = clauseHeading followed by EITHER bodyMatter or subClause[2,3,4]
-->
  <fo:block id="'{@id}'">
    <xsl:call-template name="all-headings"/>
    <xsl:apply-templates select="*[not(self::clauseHeading) and not(self::clauseNumber)]" />
  </fo:block>
</xsl:template>


<!-- ****************************************************************************************** -->
<!-- ****************************************************************************************** -->
<!-- ****************************************************************************************** -->
<!-- THE REMAINING TEMPLATES IN THIS STYLESHEET HAVE NOT YET BEEN ORGANIZED!                    -->
<!-- ****************************************************************************************** -->
<!-- ****************************************************************************************** -->
<!-- ****************************************************************************************** -->

<!--
=================================================================================================== 
==  Templates that process subsections of Subclauses                                             ==
=================================================================================================== 
-->


<!--
    Clause Heading (clauseHeading)
-->
<xsl:template match="clauseHeading">
  <xsl:param name="fromPart" select="'xx'"/>
  <xsl:param name="fromStandard" select="'xx'"/>
  <xsl:apply-templates>
    <xsl:with-param name="fromPart" select="$fromPart"/>
    <xsl:with-param name="fromStandard" select="$fromStandard"/>
  </xsl:apply-templates>
</xsl:template>

<!--
    Process the bodyMatter element
    bodyMatter includes paragraphs, lists, tables, sections, notes, code-examples, Functions,
    Formats, SyntaxRules, AccessRules, GeneralRules, ConformanceRules, Definitions, Description, 
    and comments.
    One aspect of this processing is to determine whether the containing clause, subClause, etc. 
    is modified by a clause, subCause, etc. in an incremental part and, if so, generating a 
    "modified by" annotation.
    Another aspect is to determine whether the containing clause, subClause, etc. is an invocable 
    subClause; this is determined by the presence of a <SCsignature> element.
    If so, then a Signature section is generated.
    2022-09-30: By request, this template now produces Subclause Function before Signature. 
-->
<xsl:template match="bodyMatter">
  <xsl:if test="..//Function">
     <xsl:apply-templates select="Function"/>
  </xsl:if>
  <xsl:if test="..//SCsignature and parent::subClause and not(..//tc)">
     <xsl:call-template name="SubClauseSignature"/>
  </xsl:if>
  <xsl:apply-templates select="* except Function"/>
</xsl:template>

<!--
    Process the Function element
-->
<xsl:template match="Function">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Function</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Format element 
-->
<xsl:template match="Format">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Format</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
     Process the SyntaxRules element
-->
<xsl:template match="SyntaxRules">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Syntax Rules</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the AccessRules element
-->
<xsl:template match="AccessRules">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Access Rules</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the GeneralRules element
-->
<xsl:template match="GeneralRules">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>General Rules</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the ConformanceRules element
-->
<xsl:template match="ConformanceRules">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Conformance Rules</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the InformalSemantics element 
    The InformalSemantics element is internded only to be used in the initial stages of
    standards development
-->
<xsl:template match="InformalSemantics">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Informal Semantics (temporary)</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Definition element
-->
<xsl:template match="Definition">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Definition</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Description element
-->
<xsl:template match="Description">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Description</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Tables element
-->
<xsl:template match="Tables">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Tables</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the TablePopulation element
-->
<xsl:template match="TablePopulation">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Initial Table Population</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the DefinitionsAndRules element
-->
<xsl:template match="DefinitionsAndRules">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Definitions and Rules</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Signature element
-->
<xsl:template match="Signature">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Signature</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Parameters element
-->
<xsl:template match="Parameters">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Parameters</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the BinaryComposition element
-->
<xsl:template match="BinaryComposition">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Binary Composition</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the CodeGeneration element
-->
<xsl:template match="CodeGeneration">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Code Generation</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the ProfileEntryInfoProperties element
-->
<xsl:template match="ProfileEntryInfoProperties">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Profile EntryInfo Properties</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the SeeAlso element
-->
<xsl:template match="SeeAlso">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>See Also</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Throws element
-->
<xsl:template match="Throws">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Throws</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Returns element
-->
<xsl:template match="Returns">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Returns</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Overrides element
-->
<xsl:template match="Overrides">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Overrides</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the InterpretingCustomizeResults element
-->
<xsl:template match="InterpretingCustomizeResults">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Interpreting Customize Results</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the CustomizerProperties element
-->
<xsl:template match="CustomizerProperties">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Customizer Properties</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the ProfileCustomizerUsage element
-->
<xsl:template match="ProfileCustomizerUsage">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Profile Customizer Usage</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Model element
-->
<xsl:template match="Model">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Model</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Properties element
-->
<xsl:template match="Properties">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Properties</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Purpose element
-->
<xsl:template match="Purpose">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Purpose</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the FunctionSignature element
-->
<xsl:template match="FunctionSignature">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Function Signature</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the ParameterDefinitions element
-->
<xsl:template match="ParameterDefinitions">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Parameter Definitions</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Results element
-->
<xsl:template match="Results">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Results</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the ArgumentConsiderations element
-->
<xsl:template match="ArgumentConsiderations">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Argument Considerations</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the FormalDefinition element
-->
<xsl:template match="FormalDefinition">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Formal Definition</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the ExceptionsAndWarnings element
-->
<xsl:template match="ExceptionsAndWarnings">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Exceptions and Warnings</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Process the Conformance element
-->
<xsl:template match="Conformance">
  <fo:block space-before="18pt" space-after="10pt"
            font="{$subhead-weight} {$subhead-size} {$font-name}"
            keep-with-next.within-page="always">
    <xsl:text>Conformance</xsl:text>
  </fo:block>
  <fo:block space-before="0pt" space-after="10pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>


<!--
=================================================================================================== 
==  Templates that process other block-level elements                                            ==
=================================================================================================== 
-->

<!--
=================================================================================================== 
==  Text block-level templates                                                                   ==
=================================================================================================== 
-->


<!-- 
    Paragraph (para)
-->
<xsl:template match="para">
  <xsl:variable name="paraid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:block id="'{$paraid}'"
            space-before.optimum="8pt" space-before.minimum="8pt"
            space-before.maximum="28pt" hyphenate="true">
    <xsl:if test="@name != ''">
      <xsl:variable name="paraname" select="@name"/>      
      <fo:inline font-weight="bold">
        <xsl:value-of select="$paraname"/>
      </fo:inline>
      <fo:inline>
        <xsl:text>: </xsl:text>
      </fo:inline>
    </xsl:if>
    <!-- If the <para> element has an id= attribute, then it might possibly be referenced
         from another part with a <mergeWith> reference. -->
    <xsl:if test="@id != ''">
      <xsl:variable name="id" select="@id"/>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
      <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Code examples (code, schemacode, hostcode)
    2021-08-01: Jim Melton changed "9pt" to "85%"
-->
<xsl:template match="code | schemacode | hostcode">
  <fo:block space-before="1pt"
            space-after="3pt"
            font-family="{$codefont-name}"
            font-size="80%"
            white-space-treatment="preserve"
            linefeed-treatment="preserve"
            white-space-collapse="false">
    <xsl:choose>
      <xsl:when test="@indent='yes'">
        <fo:block margin-left="inherited-property-value(margin-left) + 0.25in">
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<!--
    XML code examples (xmlcode)
-->
<xsl:template match="xmlcode">
  <fo:block space-before="1pt"
            space-after="3pt"
            font-family="{$codefont-name}"
            font-size="85%"
            font-weight="bold"
            white-space-treatment="preserve"
            linefeed-treatment="preserve"
            white-space-collapse="false">
    <xsl:choose>
      <xsl:when test="@indent='yes'">
        <fo:block margin-left="inherited-property-value(margin-left) + 0.25in">
          <xsl:apply-templates/>
        </fo:block>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </fo:block>
</xsl:template>

<!--
    Footnote
    (2022-10-18: Jim learned that <fo:footnote> inherits formatting from the parent
    list item, paragraph, etc.; therefore, to ensure that footnotes set properly at
    the left margin, the @start-indent attribute is required.)
-->
<xsl:template match="footnote">
  <fo:footnote start-indent="0pt">
    <fo:inline font-size="smaller" baseline-shift="super">
      <xsl:number level="any" count="footnote" format="1"/>
    </fo:inline>
    <fo:footnote-body>
      <fo:list-block provisional-distance-between-starts="16pt" provisional-label-separation="6pt">
        <fo:list-item>
          <fo:list-item-label end-indent="label-end()">
            <fo:block font-size="smaller">
              <xsl:number level="any" count="footnote" format="1"/>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block font-size="smaller">
              <xsl:apply-templates/>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </fo:footnote-body>
  </fo:footnote>
</xsl:template>


<!--
=================================================================================================== 
==  Note-related templates                                                                       ==
=================================================================================================== 
-->


<!--
    Numbered notes (note)
-->
<xsl:template match="note">
  <xsl:variable name="notenum">
    <xsl:choose>
      <xsl:when test="@number">
        <xsl:value-of select="@number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(preceding::*[name()='note'])+1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="noteid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>NOTE<xsl:value-of select="$notenum"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:block id="'{$noteid}'"
            margin-left="inherited-property-value(margin-left) + 0.25in"
            font-family="{$font-name}"
            font-size="{$note-size}"
            space-before.optimum="6pt"
            hyphenate="true">
    <!-- If the <note> element has an id= attribute, then it might possibly be referenced
         from another part with a <mergeWith> reference. -->
    <xsl:if test="@id != ''">
      <xsl:variable name="id" select="@id"/>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
      <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
        <xsl:with-param name="id" select="$id"/>
      </xsl:call-template>
    </xsl:if>
    <xsl:if test="substring-after($formalStage, '-')='20'">
      <xsl:if test="contains(., 'shall') or contains(., 'should') or contains(., 'may')">
<!-- LINE LENGTH CHECK OFF -->
        <xsl:call-template name="ProcessError">
          <xsl:with-param name="ErrorText">Directives violation. NOTE %s1 contains forbidden words.</xsl:with-param>
          <xsl:with-param name="ErrorValue1" select="$notenum"/>
        </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
      </xsl:if>
    </xsl:if>    
    <xsl:text>NOTE </xsl:text><xsl:value-of select="$notenum"/><xsl:text> &mdash; </xsl:text>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Editor's notes (ednote)
-->
<xsl:template match="ednote">
  <!-- If this is not a ballot document, the Editor Notes are to be included; if it is, the 
       Editor's Notes must be excluded. -->
  <xsl:if test="substring-after($formalStage, '-')='20'">
    <xsl:variable name="ednotenum"
                  select="count(preceding::*[name()='ednote'])+1"/>
    <xsl:variable name="ednoteid">
      <xsl:choose>
        <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise>EDNOTE<xsl:value-of select="$ednotenum"/></xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:block id="'{$ednoteid}'"
              margin-left="inherit"
              font-family="{$font-name}"
              font-size="{$note-size}"
              space-before.optimum="6pt"
              space-after.optimum="6pt"
              hyphenate="true"
              border-color="black" border-style="solid"
              border-width="1pt" padding="6pt">
      <fo:block font-weight="bold" text-align="center" space-after="6pt">
        <xsl:text>** Editor&rsquo;s Note (number </xsl:text>
          <xsl:value-of select="$ednotenum"/>
          <xsl:text>) **</xsl:text>
      </fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </xsl:if>
</xsl:template>


<!--
=================================================================================================== 
==  List-related templates                                                                       ==
=================================================================================================== 
-->

<!-- =================================================================================== -->
<!-- Common list-block template: generic. All subtle processing                          -->
<!-- is done in item templates.                                                          -->
<!-- =================================================================================== -->

<!--
    slist = simple list; ulist = unordered list; olist = ordered list;
    lbllist = labeled list
    blist, dlist are special (un-nested) types of ulist
    nlist, alist, rlist, Alist, and Rlist are special (un-nested) types of olist
    normativeReferences is a special kind of list used in Clause 2, Normative references    
-->
<xsl:template match="slist | ulist | olist | nlist | alist | rlist | Alist | Rlist | blist | dlist 
                     | lbllist |normativeReferences ">
  <xsl:variable name="list-type" select="name()"/>
  <xsl:variable name="list-level" select="count(ancestor-or-self::*[name()=$list-type])"/>

  <xsl:choose>
    <xsl:when test="self::lbllist[@indent and @indent='yes']">
      <fo:list-block provisional-label-separation="6pt"
                     space-before.optimum="6pt"
                     margin-left="inherited-property-value(margin-left) + 0.2in">
        <!-- set the provisional-distance-between-starts based on either the @lblwidth attribute or 
             the default value of $lbllist-label-body-separation -->
        <xsl:attribute name="provisional-distance-between-starts">
          <xsl:choose>
            <xsl:when test="@lblwidth != ''">
              <xsl:value-of select="@lblwidth"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$lbllist-label-body-separation"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:apply-templates>
          <xsl:with-param name="list-level" select="$list-level"/>
        </xsl:apply-templates>
      </fo:list-block>
    </xsl:when>
    <xsl:otherwise>
      <fo:list-block provisional-label-separation="6pt"
                     space-before.optimum="6pt">
        <xsl:choose>
          <xsl:when test="self::slist">
            <xsl:attribute name="provisional-distance-between-starts">18pt</xsl:attribute>
            <xsl:attribute name="padding-left">12pt</xsl:attribute>
            <xsl:attribute name="space-after.optimum">6pt</xsl:attribute>
          </xsl:when>
          <xsl:when test="self::rlist | self::Rlist">
            <xsl:attribute name="provisional-distance-between-starts">30pt</xsl:attribute>
          </xsl:when>
          <xsl:when test="self::olist and ($list-level=3 or $list-level=6 or $list-level=9 
                                           or $list-level=12)">
            <xsl:attribute name="provisional-distance-between-starts">
              <xsl:value-of select="$list-roman-label-body-separation"/>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="self::lbllist">
          <!-- set the provisional-distance-between-starts based on either the @lblwidth attribute
               or the default value of $lbllist-label-body-separation -->
            <xsl:attribute name="provisional-distance-between-starts">
              <xsl:choose>
                <xsl:when test="@lblwidth != ''">
                  <xsl:value-of select="@lblwidth"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$lbllist-label-body-separation"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          </xsl:when>
          <xsl:when test="self::normativeReferences">
            <xsl:attribute name="provisional-distance-between-starts">12pt</xsl:attribute>
            <xsl:attribute name="padding-left">12pt</xsl:attribute>
            <xsl:attribute name="space-after.optimum">6pt</xsl:attribute>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="provisional-distance-between-starts">
              <xsl:value-of select="$list-alphanum-label-body-separation"/>
            </xsl:attribute>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates>
          <xsl:with-param name="list-level" select="$list-level"/>
        </xsl:apply-templates>
      </fo:list-block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- =================================================================================== -->
<!-- Item for an unordered list                                                          -->
<!-- =================================================================================== -->
<xsl:template match="ulist/item">
  <xsl:param name="list-level"/>
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:list-item id="'{$itemid}'" space-before.optimum="8pt" relative-align="baseline"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        <xsl:choose>
          <!-- Odd levels use a bullet, even levels use an em dash -->
          <xsl:when test="($list-level mod 2) = 1">&mdash;</xsl:when>
          <xsl:otherwise>&bull;</xsl:otherwise> 
        </xsl:choose>  
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <!-- If the <item> element has an id= attribute, then it might possibly be referenced
             from another part with a <mergeWith> reference. -->
        <xsl:if test="@id != ''">
          <xsl:variable name="id" select="@id"/>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
          <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
            <xsl:with-param name="id" select="$id"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
      <!-- for each comment element immediately preceding this item element, print the text value
      -->
      <xsl:call-template name="maybePrintComments"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- =================================================================================== -->
<!-- Item for a dashed list                                                              -->
<!-- =================================================================================== -->
<xsl:template match="dlist/item">
  <xsl:param name="list-level"/>
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>

    </xsl:choose>
  </xsl:variable>
  <fo:list-item id="'{$itemid}'" space-before.optimum="8pt" relative-align="baseline"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        &mdash;
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <!-- If the <item> element has an id= attribute, then it might possibly be referenced
             from another part with a <mergeWith> reference. -->
        <xsl:if test="@id != ''">
          <xsl:variable name="id" select="@id"/>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
          <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
            <xsl:with-param name="id" select="$id"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
      <!-- for each comment element immediately preceding this item element, print the text value
      -->
      <xsl:call-template name="maybePrintComments"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- =================================================================================== -->
<!-- Item for a bulleted list                                                            -->
<!-- =================================================================================== -->
<xsl:template match="blist/item">
  <xsl:param name="list-level"/>
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:list-item id="'{$itemid}'" space-before.optimum="8pt" relative-align="baseline"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        &bull;
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <!-- If the <item> element has an id= attribute, then it might possibly be referenced
             from another part with a <mergeWith> reference. -->
        <xsl:if test="@id != ''">
          <xsl:variable name="id" select="@id"/>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
          <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
            <xsl:with-param name="id" select="$id"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
      <!-- for each comment element immediately preceding this item element, print the text value
      -->
      <xsl:call-template name="maybePrintComments"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- =================================================================================== -->
<!-- Item for a simple list                                                              -->
<!-- =================================================================================== -->
<xsl:template match="slist/item">
  <xsl:param name="list-level"/>
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:list-item id="'{$itemid}'" space-before.optimum="8pt" relative-align="baseline"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start"> </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <!-- If the <item> element has an id= attribute, then it might possibly be referenced from 
             another part with a <mergeWith> reference. -->
        <xsl:if test="@id != ''">
          <xsl:variable name="id" select="@id"/>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
          <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
            <xsl:with-param name="id" select="$id"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
      <!-- for each comment element immediately preceding this item element, print the text value
      -->
      <xsl:call-template name="maybePrintComments"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- =================================================================================== -->
<!-- Item for a labeled list                                                             -->
<!-- =================================================================================== -->
<xsl:template match="lbllist/lblitem">
  <xsl:param name="list-level"/>
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="@label"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:list-item id="'{$itemid}'" space-before.optimum="8pt"
                relative-align="baseline" hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        <xsl:choose>
          <xsl:when test="@label = ''">
            &bull;&bull;
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@label"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block hyphenate="false">
        <!-- If the <item> element has an id= attribute, then it might possibly be referenced from 
             another part with a <mergeWith> reference. -->
        <xsl:if test="@id != ''">
          <xsl:variable name="id" select="@id"/>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
          <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
            <xsl:with-param name="id" select="$id"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
      <!-- for each comment element immediately preceding this item element, print the text value
      -->
      <xsl:call-template name="maybePrintComments"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- =================================================================================== -->
<!-- Item for an ordered list                                                            -->
<!-- =================================================================================== -->
<xsl:template match="olist/item">
  <xsl:param name="list-level"/>
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- The variable $posn contains the value that xsl:number creates, which is used later to 
       transmit the list item position to the formatting template so the correct list item label 
       (with offset, etc.) is done. -->
  <xsl:variable name="posn">
    <xsl:number format="1"/>
  </xsl:variable>
  <!-- If the parent olist does not have a new attribute, then there is no prefix for rule 
       numbers.
       If the parent olist has a new attribute and a start attribute, then the item prefix is the 
       value of the start attribute followed by ".".
       If the parent olist has a new attribute but not a start attribute, then the item prefix is 
       the value "1" followed by ".". -->
  <xsl:variable name="item-prefix">
    <xsl:choose>
      <xsl:when test="../@start and ../@new">
        <xsl:value-of select="../@start"/>
      </xsl:when>
      <xsl:when test="../@new and not(../@start)">
        <xsl:text>1</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- If the parent olist has a start attribute, but not a new attribute, then start numbering at 
       the specified value, incrementing by one.
       If the parent olist has a new attribute (whether or not it has a start attribute, because 
       the variable $item-prefix takes care of that situation), then start numbering at the value 
       of the new attribute.
       If the parent olist has neither a start attribute nor a new attribute, then start numbering 
       with 1, as one would expect. -->
  <xsl:variable name="item-incrementing">
    <xsl:choose>
      <xsl:when test="../@start and not(../@new)">
        <xsl:value-of select="../@start"/>
      </xsl:when>
      <xsl:when test="../@new">
        <xsl:value-of select="../@new"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- Construct the list item label as the item-prefix, followed immediately by the value computed 
       by a template using "item-incrementing" -->
  <fo:list-item id="'{$itemid}'" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        <xsl:choose>
          <xsl:when test="string-length($item-prefix)!=0">
            <xsl:call-template name="olist-item-number">
              <xsl:with-param name="list-level" select="$list-level"/>
              <xsl:with-param name="item-pos" select="1"/>
              <xsl:with-param name="item-incr" select="$item-prefix"/>
            </xsl:call-template>
            <xsl:text>.</xsl:text>
            <xsl:call-template name="olist-item-number">
              <xsl:with-param name="list-level" select="1"/>
              <xsl:with-param name="item-pos" select="$posn"/>
              <xsl:with-param name="item-incr" select="$item-incrementing"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="olist-item-number">
              <xsl:with-param name="list-level" select="$list-level"/>
              <xsl:with-param name="item-pos" select="$posn"/>
              <xsl:with-param name="item-incr" select="$item-incrementing"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>)</xsl:text>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <!-- If the <item> element has an id= attribute, then it might possibly be referenced from 
             another part with a <mergeWith> reference. -->
        <xsl:if test="@id != ''">
          <xsl:variable name="id" select="@id"/>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
          <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
            <xsl:with-param name="id" select="$id"/>
          </xsl:call-template>
        </xsl:if>
        <xsl:apply-templates/>
      </fo:block>
      <!-- for each comment element immediately preceding this item element, print the text value 
      -->
      <xsl:call-template name="maybePrintComments"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- =================================================================================== -->
<!-- Item for a numbered list                                                            -->
<!-- =================================================================================== -->
<xsl:template match="nlist/item">
  <xsl:param name="list-level"/>
  <fo:list-item id="{generate-id()}" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        <xsl:number format="1)"/>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
      <!-- for each comment element immediately preceding this item element, print the text value 
      -->
      <xsl:call-template name="maybePrintComments"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- =================================================================================== -->
<!-- Item for a lower-case alphabetic list                                               -->
<!-- =================================================================================== -->
<xsl:template match="alist/item">
  <xsl:param name="list-level"/>
  <fo:list-item id="{generate-id()}" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        <xsl:number format="a)"/>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
      <!-- for each comment element immediately preceding this item element, print the text value 
      -->
      <xsl:call-template name="maybePrintComments"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- =================================================================================== -->
<!-- Item for a lower-case roman list                                                    -->
<!-- =================================================================================== -->
<xsl:template match="rlist/item">
  <xsl:param name="list-level"/>
  <fo:list-item id="{generate-id()}" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        <xsl:number format="i)"/>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
      <!-- for each comment element immediately preceding this item element, print the text value 
      -->
      <xsl:call-template name="maybePrintComments"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- =================================================================================== -->
<!-- Item for an upper-case alphabetic list                                              -->
<!-- =================================================================================== -->
<xsl:template match="Alist/item">
  <xsl:param name="list-level"/>
  <fo:list-item id="{generate-id()}" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        <xsl:number format="A)"/>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
      <!-- for each comment element immediately preceding this item element, print the text value 
      -->
      <xsl:call-template name="maybePrintComments"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- =================================================================================== -->
<!-- Item for an upper-case roman list                                                   -->
<!-- =================================================================================== -->
<xsl:template match="Rlist/item">
  <xsl:param name="list-level"/>
  <fo:list-item id="{generate-id()}" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start">
        <xsl:number format="I)"/>
      </fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <xsl:apply-templates/>
      </fo:block>
      <!-- for each comment element immediately preceding this item element, print the text value 
       -->
      <xsl:call-template name="maybePrintComments"/>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

  
<!--
=================================================================================================== 
==  Table-related templates                                                                      ==
=================================================================================================== 
-->

<!--
    The table element starts the definition of a table
-->
<xsl:template match="table">
  <xsl:variable name="keep">
    <xsl:choose>
      <xsl:when test="@keep and @keep='yes'">
        <xsl:text>always</xsl:text>
      </xsl:when>
      <xsl:otherwise>
          <xsl:text>auto</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:table-and-caption keep-together.within-page="{$keep}">
<!--
    2020-11-19: ISO Central Secretariat wants all tables to have numbers and titles
    (that is, no "anonymous" tables).  The DTD has been updated to remove the
    optionality of a tableTitle, so the following code will always be invoked.
    At some point, this should be edited to remove the presumption that the
    tableTitle is optional.  On 2021-06-08, Jim removed that presumption. 
-->
    <fo:table-caption keep-with-next.within-page="always">
      <xsl:variable name="ThisTable" select="."/>
      <xsl:variable name="tablenum">
        <xsl:choose>
          <xsl:when test="tableNumber">
            <xsl:value-of select="tableNumber"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="GetTableNumber">
              <xsl:with-param name="TheTable" select="$ThisTable"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:choose>
        <!-- If the <table> element has an id= attribute, then it might possibly be referenced
             from another part with a <mergeWith> reference.
             2020-11-19: Because ISO Central Secretariat wants all tables to be referenced in
             the document that contains them, all tables must have an id attribute. 
             The DTD has been updated to remove the optionality of a tableTitle,
             so the following code will always be invoked.
             At some point, this should be edited to remove the presumption that the
             id attribute is optional.  However, [Jim] choose[s] to leave the
             stylesheet alone for the present.
        -->
        <xsl:when test="@id">
          <fo:block space-before.minimum="15pt" space-before.maximum="20pt"
                    space-after.minimum="6pt" space-after.maximum="9pt"
                    space-before.conditionality="retain" border-style="none"
                    text-align="center" font-weight="{$head-weight}" id="'{@id}'">
            <xsl:variable name="id" select="@id"/>
            <!-- Check to be certain that the table is actually referenced at least once in the
                 document; if not, that is an error, so acknowledge the error.  2020-11-19: If
                 such a table is enountered, output a message and big red text!
            -->
            <xsl:if test="not(//*[@ref=$id]) and not(//*[@sourceTable=$id])">
<!-- LINE LENGTH CHECK OFF -->
              <xsl:call-template name="ProcessError">
                <xsl:with-param name="ErrorText">Table with id = %s1 is not referenced in this document!</xsl:with-param>
                <xsl:with-param name="ErrorValue1" select="$id"/>
              </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
            </xsl:if>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
            <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
              <xsl:with-param name="id" select="$id"/>
            </xsl:call-template>
            <xsl:text>Table </xsl:text>
            <xsl:value-of select="$tablenum"/>
            <xsl:text> &mdash; </xsl:text>
            <xsl:apply-templates select="tableTitle"/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block space-before.minimum="15pt" space-before.maximum="20pt"
                    space-after.minimum="6pt" space-after.maximum="9pt"
                    space-before.conditionality="retain" border-style="none"
                    text-align="center" font-weight="bold" id="{generate-id()}">
            <xsl:text>Table </xsl:text>
            <xsl:value-of select="$tablenum"/>
            <xsl:text> &mdash; </xsl:text>
            <xsl:apply-templates select="tableTitle"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    </fo:table-caption>
    <xsl:variable name="numcols"
                  select="ancestor-or-self::table/table-common/table-setup/@numcols"/>
    <xsl:variable name="space-before">
      <xsl:choose>
        <xsl:when test="./tableTitle">discard</xsl:when>
        <xsl:otherwise>retain</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <!-- Center the table -->
    <fo:table width="100%">
    <!-- The actual table content is put into the middle of three columns that have a variable 
         width.
         This causes the table content to be centered on the page. -->
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell/>
          <fo:table-cell>
            <fo:table width="inherit" table-layout="fixed" border-collapse="separate"
                      border-color="black" border-style="solid" border-width="0.5pt"
                      space-before.minimum="10pt" space-before.maximum="10pt"
                      space-after.minimum="6pt" space-after.maximum="9pt"
                      space-before.conditionality="{$space-before}"
                      start-indent="0" end-indent="0">
              <xsl:apply-templates select="table-common"/>
              <xsl:apply-templates select="table-body"/>
            </fo:table>
          </fo:table-cell>
          <fo:table-cell/>
        </fo:table-row>
      </fo:table-body>
    </fo:table> 
  </fo:table-and-caption>
</xsl:template>

<!--
    Front matter for tables
-->
<xsl:template match="table-common">
  <xsl:apply-templates select="table-setup | table-heads |
                               bar | endbar | delbar"/>
</xsl:template>

<!--
    Table keys and notes
-->
<xsl:template match="table-notations">
  <xsl:apply-templates/>
</xsl:template>

<!--
    Table body
-->
<xsl:template match="table-body">
  <fo:table-body start-indent="0pt" end-indent="0pt">
    <xsl:apply-templates/>
    <xsl:if test="./parent::table/table-common/table-notations">
      <xsl:apply-templates select="./parent::table/table-common/table-notations"/>
    </xsl:if>
  </fo:table-body>
</xsl:template>

<!--
    Table keynotes (table-key)
-->
<xsl:template match="table-key">
  <xsl:variable name="key-id">
    <xsl:value-of select="concat('table-', 
                          count(preceding::*[name()='table'][./tableTitle])+1, '-', @key-char)"/>
  </xsl:variable>
  <fo:block font-size="9pt" margin="5pt" id="{$key-id}">
    <fo:inline baseline-shift="super"
               font-size="smaller">
      <xsl:value-of select="@key-char"/><xsl:text> </xsl:text>
    </fo:inline>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Table footnotes (table-note)
-->
<xsl:template match="table-note">
  <xsl:variable name="note-id">
    <xsl:value-of select="concat('table-', 
                          count(preceding::*[name()='table'][./tableTitle])+1, '-', @note-char)"/>
  </xsl:variable>
  <fo:block font-size="9pt" margin="5pt" id="{$note-id}">
    <fo:inline baseline-shift="super"
               font-size="smaller">
      <xsl:value-of select="@note-char"/><xsl:text> </xsl:text>
    </fo:inline>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    Table key references (table-keyref)
-->
<xsl:template match="table-keyref">
  <xsl:variable name="key-id">
    <xsl:value-of select="concat('table-', 
                          count(preceding::*[name()='table'][./tableTitle])+1, '-', @key-char)"/>
  </xsl:variable>
  <fo:basic-link baseline-shift="super" font-size="smaller" internal-destination="{$key-id}"
                 color="#000070">
    <xsl:value-of select="@key-char"/>
  </fo:basic-link>
</xsl:template>

<!--
    Table footnote references (table-noteref)
-->
<xsl:template match="table-noteref">
  <xsl:variable name="note-id">
    <xsl:value-of select="concat('table-', 
                          count(preceding::*[name()='table'][./tableTitle])+1, '-', @note-char)"/>
  </xsl:variable>
  <fo:basic-link baseline-shift="super" font-size="smaller" internal-destination="{$note-id}"
                 color="#000070">
    <xsl:value-of select="@note-char"/>
  </fo:basic-link>
</xsl:template>

<!--
    Table Title (tableTitle)
-->
<xsl:template match="tableTitle">
  <xsl:param name="fromPart" select="'xx'"/>
  <xsl:apply-templates>
    <xsl:with-param name="fromPart" select="$fromPart"/>
  </xsl:apply-templates>
</xsl:template>

<!--
    The table-setup element sets the number of columns in the table
-->
<xsl:template match="table-setup">
  <xsl:apply-templates select="table-coldef">
    <xsl:with-param name="numcols">
      <xsl:value-of select="@numcols"/>
    </xsl:with-param>
  </xsl:apply-templates>
</xsl:template>

<!--
    The table-coldef element sets the width of a column by its number
-->
<xsl:template match="table-coldef">
  <xsl:param name="numcols"/>
  <xsl:if test="$numcols >= @colnum">
    <fo:table-column>
      <xsl:attribute name="column-number">
        <xsl:value-of select="@colnum"/>
      </xsl:attribute>

      <xsl:attribute name="column-width">
        <xsl:call-template name="calc.column.width">
          <xsl:with-param name="colwidth">
            <xsl:value-of select="@colwidth"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:attribute>
    </fo:table-column>
  </xsl:if>
</xsl:template>

<!--
    A table-heads element contains the table head for columns of the table
-->
<xsl:template match="table-heads">
  <fo:table-header keep-with-next.within-page="always" start-indent="0pt" end-indent="0pt">
    <xsl:apply-templates/>
  </fo:table-header>
</xsl:template>

<!--
    A table-head-row element allows for multi-row table heads
-->
<xsl:template match="table-head-row">
  <fo:table-row>
    <xsl:apply-templates/>
  </fo:table-row>
</xsl:template>

<!--
    A table-head element contains the table head for a single column
-->
<xsl:template match="table-head">
  <xsl:variable name="spans">
    <xsl:choose>
      <xsl:when test="@span">
        <xsl:value-of select="@span"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>1</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="vspans">
    <xsl:choose>
      <xsl:when test="@vspan">
        <xsl:value-of select="@vspan"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>1</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="alignment">
    <xsl:choose>
      <xsl:when test="@align">
        <xsl:value-of select="@align"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>left</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                 padding="5pt" font-weight="bold" number-columns-spanned="{$spans}"
                 number-rows-spanned="{$vspans}"
                 text-align="{$alignment}" relative-align="baseline">
    <fo:block>
      <xsl:apply-templates/>
    </fo:block>
  </fo:table-cell>
</xsl:template>

<!--
    A table-row element contains one row of the table
-->
<xsl:template match="table-row">
  <fo:table-row keep-together.within-page="always">
    <xsl:apply-templates/>
  </fo:table-row>
</xsl:template>

<!--
    A table-cell element contains the contents of a single cell in a row
-->
<xsl:template match="table-cell">
  <xsl:variable name="spans">
    <xsl:choose>
      <xsl:when test="@span">
        <xsl:value-of select="@span"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>1</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="vspans">
    <xsl:choose>
      <xsl:when test="@vspan">
        <xsl:value-of select="@vspan"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>1</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="alignment">
    <xsl:choose>
      <xsl:when test="@align">
        <xsl:value-of select="@align"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>left</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="valignment">
    <xsl:choose>
      <xsl:when test="@valign">
        <xsl:value-of select="@valign"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>bottom</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                 padding="5pt" number-columns-spanned="{$spans}"
                 number-rows-spanned="{$vspans}"
                 text-align="{$alignment}"
                 vertical-align="{$valignment}">
    <fo:block hyphenate="true">
      <xsl:apply-templates/>
    </fo:block>
  </fo:table-cell>
</xsl:template>

<!--
    A table-row-number element spits out the sequential number of the containing table-row element 
    within the containing table element.
    Note that the "sequential number" is 1 + the number of preceding rows of the table that contain 
    at least one cell containing an instance of table-row-number.
    Another possibility would be to count only the number of preceding table-row elements, but the 
    immediate need is for the ability to identify certain rows in a table with a number, but to
    also have rows that are unnumbered, but that does not disrupt numbering.
-->
<xsl:template match="table-row-number">
  <xsl:variable name="row-number">
    <xsl:choose>
      <xsl:when test="@number">
        <xsl:value-of select="@number"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of 
         select="count( 
                       ancestor::table-row/preceding-sibling::table-row[table-cell/table-row-number]
                      ) +1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="@id">
      <fo:inline id="'{@id}'" font-weight="bold"><xsl:value-of select="$row-number"/></fo:inline>
  </xsl:when>
  <xsl:otherwise>
      <fo:inline id="{generate-id()}" font-weight="bold">
        <xsl:value-of select="$row-number"/>
      </fo:inline>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- =================================================================================== -->
<!-- Figure-related elements                                                             -->
<!-- =================================================================================== -->

<!--
    The figure element allows the insertion of a graphic image
-->
<!-- Email from Harvey Rosenfeld, 2012-06-25, pointed out that the titles of figures are supposed
     to *follow* the figures, not precede them. -->
<xsl:template match="figure">
  <xsl:variable name="figurenum">
    <xsl:choose>
      <xsl:when test="figureNumber">
        <xsl:value-of select="figureNumber"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(preceding::*[name()='figure'])+1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="figure-width">
    <xsl:choose>
      <xsl:when test="@width"><xsl:value-of select="@width"/></xsl:when>
      <xsl:otherwise>6.5in</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="file-path">
    <xsl:value-of select="$figure-dir"/>
    <xsl:text>/</xsl:text>
    <xsl:value-of select="@file"/>
  </xsl:variable>
  <!-- fo:block space-before.minimum="10pt" space-before.maximum="15pt"
            space-after.minimum="2pt" space-after.maximum="4pt"
            space-before.conditionality="retain" border-style="none"
            text-align="center" id="'{@id}'" keep-with-next.within-page="always" -->
  <xsl:element name="fo:block">
    <xsl:attribute name="space-before.minimum">10pt</xsl:attribute>
    <xsl:attribute name="space-before.maximum">15pt</xsl:attribute>
    <xsl:attribute name="space-after.minimum">2pt</xsl:attribute>
    <xsl:attribute name="space-after.maximum">4pt</xsl:attribute>
    <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
    <xsl:attribute name="border-style">none</xsl:attribute>
    <xsl:attribute name="text-align">center</xsl:attribute>
    <xsl:attribute name="id">'<xsl:value-of select="@id"/>'</xsl:attribute>
    <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    <xsl:if test="@padding-before">
      <xsl:attribute name="padding-before"><xsl:value-of select="@padding-before"/></xsl:attribute>
    </xsl:if>
    <xsl:if test="@padding-after">
      <xsl:attribute name="padding-after"><xsl:value-of select="@padding-after"/></xsl:attribute>
    </xsl:if>
    <fo:external-graphic src="url({$file-path})" content-width="{$figure-width}"/>    
  </xsl:element>
  <!-- /fo:block -->
  <fo:block space-before="2pt" space-after="14pt" text-align="center"
            font-weight="{$head-weight}">
<!--
If the <figure> element has an id= attribute, then it might possibly be referenced
from another part with a <mergeWith> reference.
-->
    <xsl:variable name="id" select="@id"/>
    <!-- Check to be certain that the figure is actually referenced at least once in the
         document; if not, that is an error, so acknowledge the error.  2020-11-19: If
         such a table is enountered, output a message and big red text!
    -->
    <xsl:if test="not(//*[@ref=$id])">
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">Figure with id = %s1 is not referenced in this document!</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$id"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:if>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
    <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
      <xsl:with-param name="id" select="$id"/>
    </xsl:call-template>
    <xsl:text>Figure </xsl:text>
    <xsl:value-of select="$figurenum"/>
    <xsl:text> &mdash; </xsl:text>
    <xsl:apply-templates select="figureTitle"/>
  </fo:block>
</xsl:template>

<!-- Figure Title (figureTitle) -->
  <xsl:template match="figureTitle">
      <xsl:apply-templates/>
  </xsl:template>


<!-- =================================================================================== -->
<!-- Example-related elements                                                            -->
<!-- =================================================================================== -->

<!--
    The example element allows the insertion of a code fragment
    NB: The example element can only contain code in these contexts:
    grammar, code, xmlcode, schemacode, and hostcode
-->
<xsl:template match="example">
  <xsl:variable name="examplenum">
    <xsl:choose>
      <xsl:when test="exampleNumber">
        <xsl:value-of select="exampleNumber"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(preceding::*[name()='example'])+1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
<!-- ISO/CS wants example titles to precede the actual example, not follow it, 2020-04-16 -->
  <fo:block space-before.minimum="15pt" space-before.maximum="20pt"
            space-after.minimum="4pt" space-after.maximum="8pt"
            text-align="center" font-weight="{$head-weight}" keep-with-next="always">
<!--
If the <example> element has an id= attribute, then it might possibly be referenced
from another part with a <mergeWith> reference.
-->
    <xsl:variable name="id" select="@id"/>
    <!-- Check to be certain that the example is actually referenced at least once in the
         document; if not, that is an error, so acknowledge the error.  2020-11-19: If
         such a table is enountered, output a message and big red text!
    -->
    <xsl:if test="not(//*[@ref=$id])">
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">Example with id = %s1 is not referenced in this document!</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$id"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:if>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
    <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
      <xsl:with-param name="id" select="$id"/>
    </xsl:call-template>
    <xsl:text>Example </xsl:text>
    <xsl:value-of select="$examplenum"/>
    <xsl:text> &mdash; </xsl:text>
    <xsl:apply-templates select="exampleTitle"/>
  </fo:block>
<!-- Jim Melton, 2022-06-23; attempt to keep examples on the same page -->
  <fo:block space-before="2pt" space-after="14pt"
            space-before.conditionality="retain" border-style="none"
            margin-left="{$example-inset}" margin-right="{$example-inset}"
            padding-left="4pt" padding-right="4pt"
            background-color="lightgray"
            text-align="left" id="'{@id}'" keep-with-next.within-page="2">
    <xsl:apply-templates select="grammar | code | xmlcode | schemacode | hostcode"/>
  </fo:block>
</xsl:template>


<!-- Example Title (exampleTitle) -->
  <xsl:template match="exampleTitle">
      <xsl:apply-templates/>
  </xsl:template>


<!-- =================================================================================== -->
<!-- Equation-related elements                                                           -->
<!-- =================================================================================== -->

<!--
    The equation element allows the insertion of a mathematical expression
    NB: The equation element can only contain equations in these contexts:
    asciimath, texmath, and m:math
-->
<xsl:template match="equation">
  <xsl:variable name="equationnum">
    <xsl:choose>
      <xsl:when test="equationNumber">
        <xsl:value-of select="equationNumber"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="count(preceding::*[name()='equation'])+1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="id" select="@id"/>
  <fo:block space-before.minimum="15pt" space-before.maximum="20pt"
            space-after.minimum="4pt" space-after.maximum="8pt"
            text-align="center" font-weight="{$head-weight}" keep-with-next="always">
<!--
If the <equation> element has an id= attribute, then it might possibly be referenced
from another part with a <mergeWith> reference.
-->
    <!-- Check to be certain that the equation is actually referenced at least once in the
         document; if not, that is an error, so acknowledge the error.  2020-11-19: If
         such a table is enountered, output a message and big red text!
    -->
    <xsl:if test="not(//*[@ref=$id])">
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">Equation with id = %s1 is not referenced in this document!</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$id"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:if>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
    <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
      <xsl:with-param name="id" select="$id"/>
    </xsl:call-template>
    <xsl:text>Equation </xsl:text>
    <xsl:value-of select="$equationnum"/>
    <xsl:text> &mdash; </xsl:text>
    <xsl:apply-templates select="equationTitle"/>
  </fo:block>

<!-- Now, it's time to locate the graphic(s) that was (were) generated to represent
     the equation and bring it into the XSL FO output as though it were a figure. -->
  <fo:block space-before="6pt" space-after="6pt"
            space-before.conditionality="retain" border-style="none"
            text-align="center" id="'{@id}'" keep-with-next.within-page="always">

<!-- Use the value of the explicit or implicit height attribute to compute the displayed
     size of the equation (using the @content-height attribute of the external-graphic
     element).  "normal" (the default value) implies 24pt.  "smaller" implies
     12pt, "small" imples 18pt, "big" imples 30ptem, and "bigger" imples 36. -->
     <xsl:variable name="extgraphsize">
       <xsl:choose>
         <xsl:when test="@height='smaller'"><xsl:text>12pt</xsl:text></xsl:when>
         <xsl:when test="@height='small'"><xsl:text>18pt</xsl:text></xsl:when>
         <xsl:when test="@height='normal'"><xsl:text>24pt</xsl:text></xsl:when>
         <xsl:when test="@height='big'"><xsl:text>30pt</xsl:text></xsl:when>
         <xsl:when test="@height='bigger'"><xsl:text>36pt</xsl:text></xsl:when>
         <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
           <xsl:call-template name="ProcessError">
             <xsl:with-param name="ErrorText">Invalid value (%s1) for @height attribute of &lt;equation&gt; element!</xsl:with-param>
           <xsl:with-param name="ErrorValue1" select="./@height"/>
         </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
         </xsl:otherwise>
       </xsl:choose>
     </xsl:variable>

<!-- The semantic children of the <equation> element are either: one or more
     asciimath elements, or one or more texmath elements, or one or more mathml
     elements (but not a mixture of those three elements).
     Therefore, we now generate one fo:external-graphic for each of the
     semantic child (XXXmath) elements, which means computing different id
     attribute values for each, etc. -->
    <xsl:for-each select="asciimath">
      <xsl:variable name="ident">
        <xsl:value-of select="$id"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="string(count(preceding-sibling::asciimath))"/>
      </xsl:variable>
      <fo:block space-after="2pt"
                space-before.conditionality="retain" border-style="none"
                text-align="center" id="'{@ident}'" keep-with-next.within-page="always">
            <xsl:variable
          name="equation-part-png"
          select="$BlockEquations/showmath/output/rendered[@id=$ident]/part[@type='png']/text()"/>
<!-- LINE LENGTH CHECK OFF -->
        <xsl:variable
          name="equation-part-speech"
          select="$BlockEquations/showmath/output/rendered[@id=$ident]/part[@type='speech']/text()"/>
<!-- LINE LENGTH CHECK ON -->
        <fo:external-graphic src="{concat('url(', $equation-part-png, ')')}"
                             rx:alt-description="{$equation-part-speech}"
                             content-height="{$extgraphsize}"/>
      </fo:block>
    </xsl:for-each>
    <xsl:for-each select="texmath">
      <xsl:variable name="ident">
        <xsl:value-of select="$id"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="string(count(preceding-sibling::texmath))"/>
      </xsl:variable>
      <fo:block space-after="2pt"
                space-before.conditionality="retain" border-style="none"
                text-align="center" id="'{@ident}'" keep-with-next.within-page="always">
            <xsl:variable
          name="equation-part-png"
          select="$BlockEquations/showmath/output/rendered[@id=$ident]/part[@type='png']/text()"/>
<!-- LINE LENGTH CHECK OFF -->
        <xsl:variable
          name="equation-part-speech"
          select="$BlockEquations/showmath/output/rendered[@id=$ident]/part[@type='speech']/text()"/>
<!-- LINE LENGTH CHECK ON -->
        <fo:external-graphic src="{concat('url(', $equation-part-png, ')')}"
                             rx:alt-description="{$equation-part-speech}"
                             content-height="{$extgraphsize}"/>
      </fo:block>
    </xsl:for-each>
    <xsl:for-each select="m:math">
      <xsl:variable name="ident">
        <xsl:value-of select="$id"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="string(count(preceding-sibling::m:math))"/>
      </xsl:variable>
      <fo:block space-after="2pt"
                space-before.conditionality="retain" border-style="none"
                text-align="center" id="'{@ident}'" keep-with-next.within-page="always">
            <xsl:variable
          name="equation-part-png"
          select="$BlockEquations/showmath/output/rendered[@id=$ident]/part[@type='png']/text()"/>
<!-- LINE LENGTH CHECK OFF -->
        <xsl:variable
          name="equation-part-speech"
          select="$BlockEquations/showmath/output/rendered[@id=$ident]/part[@type='speech']/text()"/>
<!-- LINE LENGTH CHECK ON -->
        <fo:external-graphic src="{concat('url(', $equation-part-png, ')')}"
                             rx:alt-description="{$equation-part-speech}"
                             content-height="{$extgraphsize}"/>
      </fo:block>
    </xsl:for-each>

  </fo:block>
</xsl:template>

<!-- Equation Title (equationTitle) -->
  <xsl:template match="equationTitle">
      <xsl:apply-templates/>
  </xsl:template>

<!-- =================================================================================== -->
<!-- mathML templates                                                                    -->
<!-- =================================================================================== -->

<xsl:template match="blockMathML">
  <fo:instream-foreign-object>
    <xsl:copy-of select="child::*"/>
  </fo:instream-foreign-object>
</xsl:template>

<xsl:template match="inlineMathML">
  <fo:instream-foreign-object alignment-baseline="alphabetic">
    <xsl:copy-of select="child::*"/>
  </fo:instream-foreign-object>
</xsl:template>


<!-- =================================================================================== -->
<!-- Templates related to Normative References and the Bibliography                      -->
<!-- =================================================================================== -->

<!--
    Referenced documents in Normative References and in Bibliography
-->
<xsl:template match="referencedDocument">
  <xsl:variable name="refIdentifier" select="@id"/>
  <xsl:variable name="refDocument" select="$ReferencedDocuments[@id=$refIdentifier]/self::node()"/>
  <xsl:choose>
    <xsl:when test="count($refDocument)=0">
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">The refIdentifier: %s1 has no corresponding entry in the referencedDocuments document</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$refIdentifier"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
   </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="bibRefNum">
        <xsl:choose>
          <xsl:when test="ancestor::bibliography">
            <xsl:value-of select="count(preceding-sibling::referencedDocument)+1"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="0"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:apply-templates select="$refDocument">
        <xsl:with-param name="bibRef" select="$bibRefNum"/>
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- Process the iso-iec-std variation of normativeReferences and bibliography -->
<xsl:template match="iso-iec-std">
  <xsl:param name="bibRef" select="0"/>
<!-- If there is an id attribute, use it; else, generate one -->
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:list-item id="'{$itemid}'" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <xsl:choose>
        <xsl:when test="$bibRef != 0">
          <fo:block text-align="start">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="$bibRef"/>
            <xsl:text>]</xsl:text>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block text-align="start"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block hyphenate="false">
        <xsl:apply-templates select="docIdentifier"/>
        <xsl:if test="docDate">
          <xsl:apply-templates select="docDate"/>
        </xsl:if>
        <xsl:apply-templates select="docTitle"/>
        <xsl:if test="../URI">
          <fo:block/>
          <xsl:text>Available at: </xsl:text>
          <xsl:apply-templates select="URI"/>
        </xsl:if>
        <xsl:apply-templates 
          select="child::node() except (docIdentifier | docTitle | docDate | URI)"/>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!--
    Process the iso-iec-std child element docIdentifier
-->
<xsl:template match="docIdentifier">
  <fo:inline><xsl:apply-templates/></fo:inline>
</xsl:template>

<!--
    Process the iso-iec-std child element docDate
-->
<xsl:template match="docDate">
  <fo:inline><xsl:text>:</xsl:text><xsl:apply-templates/></fo:inline>
</xsl:template>

<!--
    Process the iso-iec-std child element docTitle
-->
<xsl:template match="docTitle">
  <fo:inline>
    <xsl:if test="@comma != 'no'">
      <xsl:text>,</xsl:text>
    </xsl:if>
    <xsl:text> </xsl:text>
    <fo:inline font-style="italic"><xsl:apply-templates/></fo:inline>
  </fo:inline>
</xsl:template>


<!-- Process the div-std variation of normativeReferences and bibliography -->
<xsl:template match="div-std">
  <xsl:param name="bibRef" select="0"/>
<!-- If there is an id attribute, use it; else, generate one -->
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:list-item id="'{$itemid}'" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <xsl:choose>
        <xsl:when test="$bibRef != 0">
          <fo:block text-align="start">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="$bibRef"/>
            <xsl:text>]</xsl:text>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block text-align="start"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block hyphenate="false">
        <xsl:value-of select="@publisher"/>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="docIdentifier"/>
        <xsl:apply-templates select="docTitle"/>
        <xsl:if test="@subordinate-responsibility">
          <xsl:text>. Edited by: </xsl:text>
          <xsl:value-of select="@subordinate-responsibility"/>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="@publication-date">
          <xsl:value-of select="@publication-date"/>
          <xsl:if test="@revision-date">
            <xsl:text>, revised </xsl:text>
            <xsl:value-of select="@revision-date"/>
          </xsl:if>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:if test="URI">
          <fo:block/>
          <xsl:text>Available at: </xsl:text>
          <xsl:apply-templates select="URI"/>
        </xsl:if>
        <xsl:apply-templates 
          select="child::node() except (docIdentifier | docTitle | docDate | URI)"/>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>


<!-- Process the electronic-doc variation of normativeReferences and bibliography -->
<xsl:template match="electronic-doc">
  <xsl:param name="bibRef" select="0"/>
<!-- If there is an id attribute, use it; else, generate one -->
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:list-item id="'{$itemid}'" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <xsl:choose>
        <xsl:when test="$bibRef != 0">
          <fo:block text-align="start">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="$bibRef"/>
            <xsl:text>]</xsl:text>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block text-align="start"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block hyphenate="false">
        <xsl:if test="@primary-responsibility">
          <xsl:value-of select="@primary-responsibility"/>
          <xsl:if test="not(fn:ends-with(@primary-responsibility, '.'))">
            <xsl:text>.</xsl:text>
          </xsl:if>
          <xsl:text> </xsl:text>
        </xsl:if>
        <xsl:apply-templates select="docTitle"/>
        <xsl:if test="@type-of-medium">
          <xsl:text> [</xsl:text>
          <xsl:value-of select="@type-of-medium"/>
          <xsl:text>]</xsl:text>
        </xsl:if>
        <xsl:text>. </xsl:text>
        <xsl:if test="@edition">
          <xsl:value-of select="@edition"/>
          <xsl:text>. </xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="@publication-place">
            <xsl:value-of select="@publication-place"/>
            <xsl:text>: </xsl:text>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>[Place of publication unknown]: </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@publisher">
          <xsl:value-of select="@publisher"/>
          <xsl:text>, </xsl:text>
        </xsl:if>
        <xsl:choose>
          <xsl:when test="@publication-date">
            <xsl:value-of select="@publication-date"/>
            <xsl:choose>
              <xsl:when test="@revision-date">
                <xsl:text>, revised </xsl:text>
                <xsl:value-of select="."/>
                <xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text> </xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
              <xsl:when test="../@citation-date">
                <xsl:text>[cited </xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>]</xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:text></xsl:text>
              </xsl:otherwise>
            </xsl:choose>
            <xsl:text>. </xsl:text>
          </xsl:when>
          <!-- If no pub date specified, say nothing (undated reference) -->
          <xsl:otherwise></xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@subordinate-responsibility">
          <xsl:value-of select="@subordinate-responsibility"/>
        </xsl:if>
        <xsl:if test="@series">
          <xsl:value-of select="@series"/>
        </xsl:if>
        <xsl:apply-templates select="docNotes"/>
        <xsl:if test="@number">
          <xsl:value-of select="@number"/>
          <xsl:text>. </xsl:text>
        </xsl:if>
        <xsl:if test="URI">
          <xsl:text>Available at </xsl:text>
          <xsl:apply-templates select="URI"/>
        </xsl:if>
        <xsl:apply-templates 
          select="child::node() except (docIdentifier | docTitle | docNotes | URI)"/>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- Process the part-of-electronic-doc variation of normativeReferences and bibliography -->
<xsl:template match="part-of-electronic-doc">
  <xsl:param name="bibRef" select="0"/>
<!-- If there is an id attribute, use it; else, generate one -->
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:list-item id="'{$itemid}'" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <xsl:choose>
        <xsl:when test="$bibRef != 0">

          <fo:block text-align="start">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="$bibRef"/>
            <xsl:text>]</xsl:text>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block text-align="start"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block hyphenate="false">
        <xsl:text>THE part-of-electronic-doc ELEMENT IS NOT YET SUPPORTED!</xsl:text>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- Process the serial variation of normativeReferences and bibliography -->
<xsl:template match="serial">
  <xsl:param name="bibRef" select="0"/>
<!-- If there is an id attribute, use it; else, generate one -->
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:list-item id="'{$itemid}'" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <xsl:choose>
        <xsl:when test="$bibRef != 0">
          <fo:block text-align="start">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="$bibRef"/>
            <xsl:text>]</xsl:text>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block text-align="start"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block hyphenate="false">
        <xsl:text>THE serial ELEMENT IS NOT YET SUPPORTED!</xsl:text>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!-- Process the part-of-serial variation of normativeReferences and bibliography -->
<xsl:template match="part-of-serial">
  <xsl:param name="bibRef" select="0"/>
<!-- If there is an id attribute, use it; else, generate one -->
  <xsl:variable name="itemid">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise>generate_id()</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:list-item id="'{$itemid}'" relative-align="baseline"
                space-before.optimum="8pt"
                hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <xsl:choose>
        <xsl:when test="$bibRef != 0">
          <fo:block text-align="start">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="$bibRef"/>
            <xsl:text>]</xsl:text>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <fo:block text-align="start"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block hyphenate="false">
        <xsl:text>THE part-of-serial ELEMENT IS NOT YET SUPPORTED!</xsl:text>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>


<!-- =================================================================================== -->
<!-- Templates related to Definitions                                                    -->
<!-- =================================================================================== -->


<!--
    Formal term definition (definition)
-->
<xsl:template match="definition">
  <xsl:param name="repeatdefn" tunnel="yes" select="false()"/>
  <xsl:variable name="defnID">
    <xsl:choose>
      <xsl:when test="@id">
        <xsl:text>'</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>'</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>'defn_</xsl:text>
        <xsl:value-of select="string(./term[1])"/>
        <xsl:text>'</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:block id="{$defnID}" space-before.optimum="8pt"
            hyphenate="true" keep-together.within-page="always">
<!-- If the definition does not have a new or start attribute, then the prefix is the current 
     annex/(sub)clause number in which the definition occurs.
     If the definition has a new attribute and a start attribute, then the definitionParentNumber 
     is the current annex/(sub)clause number followed by "." followed by the value of the start 
     attribute.
     If the definition has a new attribute but not a start attribute, then the 
     definitionParentNumber is the current annex/(sub)clause number followed by ".1". -->
    <xsl:variable name="definitionParentNumber">
      <xsl:choose>
        <xsl:when test="@start and @new">
          <xsl:call-template name="head-number"/>
          <xsl:text>.</xsl:text>
          <xsl:value-of select="@start"/>
        </xsl:when>
        <xsl:when test="@new and not(@start)">
          <xsl:call-template name="head-number"/>
          <xsl:text>.1</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="head-number"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
<!-- If the definition has a start attribute, but not a new attribute, then start numbering at the 
     specified value, incrementing by one.
     If the definition has a new attribute (whether or not it has a start attribute, because 
     definitionParentNumber takes care of that situation), then start numbering at the value of the 
     new attribute.
     If the definition has neither a start attribute nor a new attribute, then start numbering with
     1, as one would expect. -->
    <xsl:variable name="definitionNumber">
      <xsl:choose>
        <xsl:when test="@start and not(@new)">
          <xsl:value-of select="@start"/>
        </xsl:when>
        <xsl:when test="@new">
          <xsl:value-of select="@new"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="count(preceding-sibling::*[name()='definition'])+1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:block>
      <fo:inline font-weight="bold">
        <xsl:value-of select="$definitionParentNumber"/>.<xsl:value-of select="$definitionNumber"/>
      </fo:inline>
    </fo:block>
    <xsl:apply-templates select="term"/>
    <xsl:if test="defn or defnDomain">
      <fo:block space-before.optimum="1pt">
        <fo:inline>
          <xsl:if test="defnDomain" >
            <xsl:text> &lt;</xsl:text>
            <xsl:apply-templates select="defnDomain"/>
            <xsl:text>&gt; </xsl:text>
          </xsl:if>
          <xsl:if test="defn" >
            <xsl:apply-templates select="defn"/>
          </xsl:if>
        </fo:inline>
      </fo:block>
    </xsl:if>
    <xsl:apply-templates select="*[not(self::term) and not(self::defn) and
                                   not(self::defnDomain)]"/>
  </fo:block>
</xsl:template>

<!--
    The term in a formal term definition
-->
<xsl:template match="definition/term">
  <xsl:param name="repeatdefn" tunnel="yes" select="false()"/>
  <xsl:param name="ref-invoked" select="false()"/>
  <fo:block>
    <xsl:choose>
      <xsl:when test="@type='admitted'">
        <fo:inline font-weight="normal">
          <xsl:apply-templates/>
        </fo:inline>
      </xsl:when>
      <xsl:when test="@type='deprecated'">
        <fo:inline font-weight="normal">
          <xsl:text>DEPRECATED: </xsl:text>
          <xsl:apply-templates/>
        </fo:inline>
      </xsl:when>
      <xsl:otherwise>
        <fo:inline font-weight="bold">
          <xsl:apply-templates/>
        </fo:inline>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="parent::definition/@type = 'adj' and not($ref-invoked)">
      <xsl:text>, adj.</xsl:text>
    </xsl:if>
    <xsl:if test="parent::definition/@type = 'verb' and not($ref-invoked)">
      <xsl:text>, verb</xsl:text>
    </xsl:if>
    <xsl:if test="parent::definition/@type = 'adv' and not($ref-invoked)">
      <xsl:text>, adverb</xsl:text>
    </xsl:if>
  </fo:block>
</xsl:template>

<!--
    The domain (defnDomain) in a formal term definition
-->
<xsl:template match="definition/defnDomain">
  <xsl:param name="repeatdefn" tunnel="yes" select="false()"/>
  <xsl:apply-templates/>
</xsl:template>

<!--
    The definition in a formal term definition
-->
<xsl:template match="definition/defn">
  <xsl:param name="repeatdefn" tunnel="yes" select="false()"/>
  <xsl:variable name="defnId">
    <xsl:choose>
        <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
        <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>  
  <fo:inline id="'{$defnId}'">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    A normative note to entry in a formal term definition
-->
<xsl:template match="definition/defnNote">
  <fo:block space-before.optimum="6pt">
    <fo:inline>
      <xsl:text>Note </xsl:text>
      <xsl:value-of select="count(preceding-sibling::defnNote)+1"/>
      <xsl:text> to entry:&nbsp;&nbsp;</xsl:text>
      <xsl:apply-templates/>
    </fo:inline>
  </fo:block>
</xsl:template>

<!--
    An example of a formal term's usage
-->
<xsl:template match="definition/defnExample">
  <fo:block space-before.optimum="6pt">
    <fo:inline>
      <xsl:text>EXAMPLE&nbsp;&nbsp;</xsl:text>
      <xsl:apply-templates/>
    </fo:inline>
  </fo:block>
</xsl:template>

<!--
    The source of a formal term definition
-->
<xsl:template match="definition/defnSource">
  <fo:block space-before.optimum="6pt">
    <fo:inline>
      <xsl:text>[SOURCE: </xsl:text>
      <xsl:apply-templates/>
      <xsl:text>]</xsl:text>
    </fo:inline>
  </fo:block>
</xsl:template>

<xsl:template match="definition/defnSource/defnSection">
  <xsl:text>, </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="definition/defnSource/defnMods">
  <xsl:text>, </xsl:text>
  <xsl:apply-templates/>
</xsl:template>


<!-- =================================================================================== -->
<!-- Grammar-related templates                                                           -->
<!-- =================================================================================== -->


<!--
    format element (grammar)
-->
<xsl:template match="grammar">
  <fo:block font="{$grammar-size} {$codefont-name}" word-spacing="0">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    BNFdef element
-->
<!-- The xsl:for-each loop identifies parts other than "this" one in which "the same" BNF 
     non-terminal is defined and generates a red boxed number identifying that "other" part 
     immediately prior to the production for the BNF non-terminal in "this" part.
     The no-break space preceding the ::= ensures that no break occurs there -->
<xsl:template match="BNFdef">
  <xsl:variable name="BNF-offset">
    <xsl:choose>
      <xsl:when test="ancestor::example">
        <xsl:value-of select="$example-inset"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0em</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:block start-indent="{$BNF-offset} + 0em" white-space-collapse="true" id="'BNF_{@name}'"
            space-before="9pt">
    <xsl:variable name="name" select="@name"/>
    <xsl:variable name="numberDefs"
        select="count(//grammar[(@discussion != 'yes' or not(@discussion))]/BNFdef[@name=$name])"/>
    <xsl:if test="$numberDefs > 1">
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">There are %s1 BNFdef definitions of BNF non-terminal symbol %s2 in this document.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$numberDefs"/>
        <xsl:with-param name="ErrorValue2" select="$name"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:if>
    <fo:inline keep-together="always">
      <xsl:variable name="name" select="@name"/>
<!-- Generate the "little red box" signifying that this element is referenced by a 
     replicated BNFdef in an incremental part. -->
      <xsl:call-template name="GenerateLittleRedBoxForBNFdef">
        <xsl:with-param name="name" select="$name"/>
      </xsl:call-template>
<!-- NEW INDEX TECHNOLOGY BELOW -->
      <xsl:variable name="BNFdef-key">
        <xsl:value-of select="@name"/>
      </xsl:variable>
<!-- LINE LENGTH CHECK OFF -->
      <fo:inline index-key="{$BNFdef-key}">
        <xsl:text>&lt;</xsl:text><xsl:value-of select="$BNFdef-key"/><xsl:text>&gt;&nbsp;::= </xsl:text>
      </fo:inline>
<!-- ************** DEBUGGING ******************************************** -->
<!--
<xsl:message><xsl:text>DEBUG: BNFdef; index-key = </xsl:text>
  <xsl:value-of select="$BNFdef-key"/><xsl:text>.</xsl:text></xsl:message>
-->
<!-- ************** DEBUGGING ******************************************** -->
<!-- LINE LENGTH CHECK ON -->
<!-- NEW INDEX TECHNOLOGY ABOVE -->
      <xsl:if test="@predicative='yes'">
        <fo:block start-indent="{$BNF-offset} + 1.2em">
          <xsl:text>!! </xsl:text>
          <fo:inline font-style="italic" font-size="9pt">
            <xsl:text>Predicative production rule.</xsl:text>
          </fo:inline>
        </fo:block>
      </xsl:if>
    </fo:inline>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    rhs element
-->
<xsl:template match="rhs">
  <xsl:variable name="BNF-offset">
    <xsl:choose>
      <xsl:when test="ancestor::example">
        <xsl:value-of select="$example-inset"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0em</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:block start-indent="{$BNF-offset} + 1.2em">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    NoFormat element
-->
<xsl:template match="NoFormat">
  <fo:list-block provisional-label-separation="6pt"
                 space-before.optimum="6pt">
    <fo:list-item space-before.optimum="8pt" hyphenate="true">
      <fo:list-item-label end-indent="label-end()">
        <fo:block text-align="start"></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <fo:inline font-family="{$font-name}" font-size="11pt" font-style="italic">
            <xsl:text>No additional Format items. </xsl:text>
          </fo:inline>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </fo:list-block>
</xsl:template>

<!--
    alt element
-->
<xsl:template match="alt[position()=1]">
  <xsl:variable name="BNF-offset">
    <xsl:choose>
      <xsl:when test="ancestor::example">
        <xsl:value-of select="$example-inset"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0em</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="@br='no' and (parent::group or parent::opt)">
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:when test="@br='no'">
      <fo:inline><xsl:text>&nbsp;</xsl:text></fo:inline>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <fo:block space-before="0pt" start-indent="{$BNF-offset} + 2.4em">
        <xsl:apply-templates/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="alt[position()>1]">
  <xsl:variable name="BNF-offset">
    <xsl:choose>
      <xsl:when test="ancestor::example">
        <xsl:value-of select="$example-inset"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>0em</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="@br='no'">
      <xsl:text> | </xsl:text>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
      <fo:block space-before="0pt" start-indent="{$BNF-offset} + 2.4em" text-indent="-1.2em">
        <xsl:text>| </xsl:text>
        <xsl:apply-templates/>
      </fo:block>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    allAltsFrom element
-->
<xsl:template match="allAltsFrom">
  <xsl:variable name="standardnum">
    <xsl:choose>
      <xsl:when test="@standard">
        <xsl:value-of select="@standard"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$standardNumber"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="partnum">
    <xsl:choose>
      <xsl:when test="starts-with(@part, '0')">
        <xsl:value-of select="substring(@part,2)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="@part"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:inline font-style="italic">
    <xsl:text>!! All alternatives from ISO/IEC </xsl:text>
    <xsl:value-of select="$standardnum"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="$partnum"/>
  </fo:inline>
</xsl:template>

<!--
    opt element
-->
<xsl:template match="opt">
  <xsl:text> [ </xsl:text>
  <xsl:apply-templates/>
  <xsl:text> ]</xsl:text>
</xsl:template>

<!--
    group element
-->
<xsl:template match="group">
  <xsl:text> { </xsl:text>
  <xsl:apply-templates/>
  <xsl:text> }</xsl:text>
</xsl:template>

<!--
    ellipsis element
-->
<xsl:template match="ellipsis">
  <xsl:text>...</xsl:text>
</xsl:template>

<!--
    repeat element
-->
<xsl:template match="repeat">
  <xsl:text>...</xsl:text>
</xsl:template>

<!--
    terminalsymbol element
-->
<xsl:template match="terminalsymbol">
  <xsl:if test="ancestor-or-self::rhs">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
  <xsl:if test="@unicode">
    <xsl:text>    !! </xsl:text>
    <fo:inline font-style="italic" font-size="9pt">
      <xsl:if test="contains(@unicode, ',')">
        <xsl:text>&lt;</xsl:text>
      </xsl:if>
      <xsl:text>U+</xsl:text>
      <xsl:value-of select="replace(replace (@unicode,' ',''),',',', U+')"/>
      <xsl:if test="contains(@unicode, ',')">
        <xsl:text>&gt;</xsl:text>
      </xsl:if>
    </fo:inline>
  </xsl:if>
</xsl:template>

<!--
    justText element
-->
<xsl:template match="justText">
  <xsl:if test="ancestor-or-self::rhs">
    <xsl:text> </xsl:text>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<!--
    seeTheRules element
-->
<xsl:template match="seeTheRules">
  <xsl:text>!! </xsl:text>
  <fo:inline font-style="italic" font-size="9pt">
    <xsl:text>See the Syntax Rules.</xsl:text>
  </fo:inline>
</xsl:template>

<!--
    A linebreak in text (linebreak)
-->
<xsl:template match="linebreak">
  <fo:block/>
</xsl:template>

<!--
    A blank line in text (blankline)
-->
<xsl:template match="blankline">
  <fo:block space-before="9pt"/>
</xsl:template>

<!--
    A line break in text, followed by some blanks (breakindent)
-->
<xsl:template match="breakindent">
  <fo:block/>
  <xsl:text>&nbsp;&nbsp;&nbsp;</xsl:text>
</xsl:template>


<!-- =================================================================================== -->
<!-- Subsection-related templates                                                        -->
<!-- =================================================================================== -->


<!-- =================================================================================== -->
<!-- FunctionSignature elements (used only in 29075 Function libraries)                  -->
<!-- =================================================================================== -->

<xsl:template match="functionSig">
  <fo:block space-before="1pt"
            space-after="3pt"
            font="9pt {$codefont-name}"
            white-space-treatment="preserve"
            linefeed-treatment="preserve"
            white-space-collapse="false"
            margin-left="inherited-property-value(margin-left) + 0.25in">
    <xsl:text>FUNCTION </xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text> (</xsl:text>
    <xsl:apply-templates select="funcParam"/>
    <xsl:text> ) RETURNS </xsl:text>
    <xsl:apply-templates select="funcReturn"/>
  </fo:block>
</xsl:template>

<xsl:template match="funcParam">
  <fo:block space-before="1pt"
            space-after="3pt">
    <xsl:text>  </xsl:text>
    <xsl:value-of select="@paramName"/>
    <xsl:text> </xsl:text>
    <xsl:value-of select="@paramType"/>
    <xsl:if test="@paramOptional">
      <xsl:text> #OPTIONAL</xsl:text>
    </xsl:if>
  </fo:block>
</xsl:template>

<xsl:template match="funcReturn">
  <xsl:value-of select="@returnName"/>
  <xsl:text> </xsl:text>
  <xsl:value-of select="@returnType"/>
</xsl:template>

<!--
    None element
-->
<xsl:template match="None">
  <fo:list-item space-before.optimum="8pt" hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start"></fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
          <xsl:with-param name="id" select="' '"/>
        </xsl:call-template>
        <fo:inline font-style="italic">None. </fo:inline>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!--
    NoAdditional element
-->
<xsl:template match="NoAdditional">
  <fo:list-item space-before.optimum="8pt" hyphenate="true">
    <fo:list-item-label end-indent="label-end()">
      <fo:block text-align="start"></fo:block>
    </fo:list-item-label>
    <fo:list-item-body start-indent="body-start()">
      <fo:block>
        <fo:inline font-style="italic">
          <xsl:choose>
            <xsl:when test="ancestor::SyntaxRules">
              <xsl:text>No additional Syntax Rules. </xsl:text>
            </xsl:when>
            <xsl:when test="ancestor::AccessRules">
              <xsl:text>No additional Access Rules. </xsl:text>
            </xsl:when>
            <xsl:when test="ancestor::GeneralRules">
              <xsl:text>No additional General Rules. </xsl:text>
            </xsl:when>
            <xsl:when test="ancestor::ConformanceRules">
              <xsl:text>No additional Conformance Rules. </xsl:text>
            </xsl:when>
            <xsl:when test="ancestor::Description">
              <xsl:text>No additional Descriptions. </xsl:text>
            </xsl:when>
            <xsl:when test="ancestor::TablePopulation">
              <xsl:text>No additional Initial Table Population items. </xsl:text>
            </xsl:when>
            <xsl:otherwise>
              <xsl:variable name="subClauseID" select="ancestor::subClause[1]/@id"/>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">Invalid use of NoAdditional in subClauseID = %s1.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$subClauseID"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
            </xsl:otherwise>
          </xsl:choose>
        </fo:inline>
      </fo:block>
    </fo:list-item-body>
  </fo:list-item>
</xsl:template>

<!--
    NoDefinition element
-->
<xsl:template match="NoDefinition">
  <fo:list-block provisional-label-separation="6pt"
                 space-before.optimum="6pt">
    <fo:list-item space-before.optimum="8pt" hyphenate="true">
      <fo:list-item-label end-indent="label-end()">
        <fo:block text-align="start"></fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:inline font-style="italic">
          <xsl:text>No additional Definition. </xsl:text>
        </fo:inline>
      </fo:list-item-body>
    </fo:list-item>
  </fo:list-block>
</xsl:template>

<!-- The following several templates deal provide the ability for the Rules of one Subclause to 
     invoke the Rules of another "invocable" Subclause.
     They come in sets as follows:
       SCsignature, symparam, symreturn, documentation    - for invocable Subclauses
       applySC, symarg, symresult                         - Rules that invoke Subclauses
       applyExtSC, extsymarg, extsymresult                - Rule invoking in other parts -->

<!--
    Signature for subclauses invoked by other subclauses
    This element and its content should be a complete item by itself
-->
<xsl:template match="SCsignature">
  <xsl:variable name="ourParent" select="(ancestor::subClause | ancestor::subClause2
                                          | ancestor::subClause3 | ancestor::subClause4)[last()]"/>
  <xsl:variable name="rules">
    <xsl:choose>
      <xsl:when test="ancestor::SyntaxRules">Syntax</xsl:when>
      <xsl:when test="ancestor::AccessRules">Access</xsl:when>
      <xsl:when test="ancestor::GeneralRules">General</xsl:when>
      <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
        <xsl:call-template name="ProcessError">
          <xsl:with-param name="ErrorText">An SCsignature element has been placed into a subsection other than SyntaxRules, AccessRules, or GeneralRules.</xsl:with-param>
        </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="count(symparam) > 0">
      <xsl:text>Let </xsl:text>
      <xsl:apply-templates select="symparam[1]"/>
      <xsl:choose>
        <xsl:when test="count(symparam) = 2">
          <xsl:text> and let </xsl:text>
          <xsl:apply-templates select="symparam[2]"/>
        </xsl:when>
        <xsl:when test="count(symparam) > 2">
          <xsl:for-each select="symparam[position() >= 2 and position() &lt; last()]">
            <xsl:text>, let </xsl:text>
            <xsl:apply-templates select="."/>
          </xsl:for-each>
          <xsl:text>, and let </xsl:text>
          <xsl:apply-templates select="symparam[position() = last()]"/>
        </xsl:when>
      </xsl:choose>
      <xsl:text> in an application of the </xsl:text>
      <xsl:value-of select="$rules"/>
      <xsl:text> Rules of this Subclause. </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>The </xsl:text>
      <xsl:value-of select="$rules"/>
      <xsl:text> Rules of this Subclause are applied without any symbolic arguments.</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="symreturn">
    <xsl:text>The result of the application of this Subclause is returned as </xsl:text>
    <xsl:apply-templates select="symreturn[1]">
      <xsl:with-param name="PrintValue"><xsl:value-of select="0"/></xsl:with-param>
    </xsl:apply-templates>
    <xsl:choose>
      <xsl:when test="count(symreturn) = 2">
        <xsl:text> and </xsl:text>
        <xsl:apply-templates select="symreturn[2]">
          <xsl:with-param name="PrintValue"><xsl:value-of select="0"/></xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="count(symreturn) > 2">
        <xsl:for-each select="symreturn[position() >= 2 and position() &lt; last()]">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select=".">
            <xsl:with-param name="PrintValue"><xsl:value-of select="0"/></xsl:with-param>
          </xsl:apply-templates>
        </xsl:for-each>
        <xsl:text>, and </xsl:text>
        <xsl:apply-templates select="symreturn[position() = last()]">
          <xsl:with-param name="PrintValue"><xsl:value-of select="0"/></xsl:with-param>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
    <xsl:text>. </xsl:text>
  </xsl:if>
</xsl:template>

<!--
    Symbolic parameter for subclauses invoked by other subclauses
    Create a target whose id is the subclause ID + _ + symbolic parameter name, and display the 
    symbolic parameter name in italics
-->
<xsl:template match="symparam">
  <xsl:if test="parent::SCsignature">
    <xsl:apply-templates/>
    <xsl:text> be the </xsl:text>
  </xsl:if>
  <xsl:variable name="containerID" select="ancestor::subClause[1]/@id"/>
  <xsl:variable name="fullID" select="concat($containerID, '_', @name)"/>
  <fo:inline id="{$fullID}" font-style="italic"><xsl:value-of select="@name"/></fo:inline>
</xsl:template>

<!--
    Symbolic return for subclauses invoked by other subclauses
    Create a target whose id is the subclause ID + _ + symbolic parameter name, and display the 
   symbolic parameter name in italics 
-->
<xsl:template match="symreturn">
  <xsl:param name="PrintValue"/>
<!-- 2022-09-30: No longer printing the content of the Subclause result, only the symbol name -->
  <xsl:if test="$PrintValue='1'">
    <xsl:apply-templates/>
    <xsl:text>, which is returned as </xsl:text>
  </xsl:if>
<!-- 2022-09-30: No longer printing the content of the Subclause result, only the symbol name -->
  <xsl:variable name="containerID" select="ancestor::subClause[1]/@id"/>
  <xsl:variable name="fullID" select="concat($containerID, '_', @name)"/>
  <fo:inline id="{$fullID}" font-style="italic"><xsl:value-of select="@name"/></fo:inline>
</xsl:template>

<!--
    Symbolic parameter in TC for subclauses invoked by other subclauses 
-->
<xsl:template match="tcSymparam">
  <fo:inline font-style="italic">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!--
    Explicit return from invoked Subclause
-->
<xsl:template match="SCreturn">
  <!-- Ensure that there are the same number of SCretval children as there are
       symreturn children in the corresponding SCsignature -->
  <xsl:variable name="ThisSubsection">
    <xsl:choose>
      <xsl:when test="ancestor::SyntaxRules">
        <xsl:text>Syntax Rules</xsl:text>
      </xsl:when>
      <xsl:when test="ancestor::AccessRules">
        <xsl:text>Access Rules</xsl:text>
      </xsl:when>
      <xsl:when test="ancestor::GeneralRules">
        <xsl:text>General Rules</xsl:text>
      </xsl:when>
    <xsl:otherwise>
      <fo:inline font-size="18pt" font-weight="bold" color="red">
        <xsl:text>ERROR: BAD ANCESTOR</xsl:text>
      </fo:inline>
    </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <!-- Indicate that the Subclause is returning to its invoker -->
  <xsl:choose>
    <xsl:when test="@cap">
      <xsl:text>evaluation of the </xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>Evaluation of the </xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="$ThisSubsection"/>
  <xsl:text> is terminated</xsl:text>
  <xsl:variable name="numSCretval" select="count(child::SCretval)"/>
  <xsl:choose>
    <xsl:when test="$numSCretval = 0">
      <xsl:text> and control is returned to the invoking Subclause</xsl:text>
    </xsl:when>
    <xsl:when test="$numSCretval &gt; 0">
      <xsl:text> and control is returned to the invoking Subclause, which receives </xsl:text>
      <!-- Process the SCretval children -->
      <xsl:for-each select="SCretval">
        <xsl:variable name="name" select="@name"/>
        <xsl:choose>
          <xsl:when test="ancestor::SyntaxRules//SCsignature/symreturn[@name=$name] and
                          $ThisSubsection = 'Syntax Rules'">
            <xsl:apply-templates select="."/>
          </xsl:when>
          <xsl:when test="ancestor::AccessRules//SCsignature/symreturn[@name=$name] and
                          $ThisSubsection = 'Access Rules'">
            <xsl:apply-templates select="."/>
          </xsl:when>
          <xsl:when test="ancestor::GeneralRules//SCsignature/symreturn[@name=$name] and
                          $ThisSubsection = 'General Rules'">
            <xsl:apply-templates select="."/>
          </xsl:when>
          <xsl:when test="ancestor::tcBody">
            <xsl:apply-templates select="."/>
          </xsl:when>
          <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">SCretval with name = %s1 has no corresponding symreturn in the relevant SCsignature!</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$name"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:otherwise>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="$numSCretval = 2 and position() != last()">
            <xsl:text> and </xsl:text>
          </xsl:when>
          <xsl:when test="$numSCretval &gt; 2 and position() &lt; last()-1">
            <xsl:text>, </xsl:text>
          </xsl:when>
          <xsl:when test="$numSCretval &gt; 2 and position() = last()-1">
            <xsl:text>, and </xsl:text>
          </xsl:when>
        </xsl:choose>
      </xsl:for-each>
    </xsl:when>
  </xsl:choose>
  <xsl:text>.</xsl:text>
</xsl:template>


<!-- Process each SCretval
-->
<xsl:template match="SCretval">
  <xsl:apply-templates/>
  <xsl:text> as </xsl:text>
  <fo:inline font-style="italic"><xsl:value-of select="@name"/></fo:inline>
</xsl:template>

<!-- =================================================================================== -->
<!-- Templates related to document merges and other document-creation templates          -->
<!-- =================================================================================== -->


<!--
    modifiesPart
-->
<xsl:template match="modifiesPart">
  <xsl:variable name="partnum" select="@part"/>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$partnum]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$partnum]/@output"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text><xsl:value-of select="@ref"/><xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
  <fo:block font-style="italic">
    <xsl:text>This </xsl:text>
    <xsl:choose>
      <xsl:when test="../../clause">
        <xsl:text>Clause</xsl:text>
      </xsl:when>
      <xsl:when test="../../annex">
        <xsl:text>Annex</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>Subclause</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:choose>
      <xsl:when test="self::modifiesPart">
        <xsl:text> modifies </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> is modified by </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
    <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                   show-destination="new" color="#000070">
      <xsl:for-each select="$extroot//*[@id=$ref]
                                        [self::clause | self::annex
                                       | self::subClause | self::subClause2
                                       | self::subClause3 | self::subClause4]">
        <fo:inline keep-together.within-line="always">
          <xsl:choose>
            <xsl:when test="self::clause">
              <xsl:text>Clause </xsl:text>
            </xsl:when>
            <xsl:when test="self::annex">
              <xsl:text>Annex </xsl:text>
            </xsl:when>
            <xsl:when test="self::subClause | self::subClause2
                            | self::subClause3 | self::subClause4">
              <xsl:text>Subclause </xsl:text>
            </xsl:when>
          </xsl:choose>
          <xsl:variable name="body" select="count(ancestor::standardPartBody)"/>
          <xsl:variable name="number-format">
            <xsl:choose>
              <xsl:when test="$body=1">1.1.1.1</xsl:when>
              <xsl:otherwise>A.1.1.1</xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <xsl:number level="multiple"
                      count="annex|clause|subClause|subClause2|subClause3|subClause4"
                      format="{$number-format}"/>
          <xsl:text>,</xsl:text>
        </fo:inline>
        <xsl:text> &ldquo;</xsl:text>
        <xsl:apply-templates select="clauseHeading">
          <xsl:with-param name="fromPart" select="$partnum"/>
        </xsl:apply-templates>
        <xsl:text>&rdquo;</xsl:text>
      </xsl:for-each>
    </fo:basic-link>
    <xsl:text>, in ISO/IEC </xsl:text><xsl:value-of select="$standardNumber"/><xsl:text>-</xsl:text>
    <xsl:value-of select="number($partnum)"/>
    <xsl:text>. </xsl:text>
  </fo:block>
</xsl:template>


<!--
    Merge (effectively, not literally!) text in an incremental part into related text in
    a base part.  <mergeWith> accepts only a single attribute, @part, to specify the base
    part with which the specified text is to be merged.  <mergeWith> accepts exactly one
    of a selection of child elements, one for each distinct kind of merge situation. 
    NOTE: The <mergeWith> element replaces the old <mergeInstr> element.  <mergeInstr> was
    designed on the fly, became a terrible hack with many little problems that were difficult
    or infeasible to fix.  <mergeWith> was created to add specificity to merging situations
    and eliminate most or all of those little problems. 
    Sketch of the template:
    * Check whether the value of @part identifies a valid part of the current standard:
    * If not, generate error. 
    * If so, <applyTemplates> for the child elements. 
    The number of the target part is passed as a parameter to make it easy to identify that part.
-->
<xsl:template match="mergeWith">
  <xsl:variable name="partnum" select="@part"/>
  <xsl:if test="not($parts[@number=$standardNumber]/part[@number=$partnum])">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">The value of the @part attribute (%s1) does not identify a part of standard number %s2</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="$partnum"/>
      <xsl:with-param name="ErrorValue2" select="$standardNumber"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
  <xsl:apply-templates>
    <xsl:with-param name="targetPart" select="$partnum"/>
  </xsl:apply-templates>
</xsl:template>


<!--
    addListItem inserts (effectively, not literally!) a new unordered list element either:
    immediately before or immediately after the list element with @id value equal to the value of
    the @ref attribute; or as the last list element in the list subordinate to the list
    element or paragraph with @id value equal to the value of the @ref attribute. 
    Sketch of the template:
    * Check if the value of @part identifies a part of this standard
    * If not, generate an error
    * Generate "Insert into "
    * For the context element, check if the value of the @ref attribute identifies a
      paragraph (if type="para") or a list item (if type not = "para").
      - If not, generate an error. 
      - If type="para", generate "the ", followed by the ordinal number of the <para>
        element identified by the value of the @ref attribute, followed by " paragraph".
      - If type is not "para", generate "SR " ("AR ", "GR ", "CR ", "Description "),
        followed by the cardinal number of the <item> element (as with <itemref>). 
    * For each child <target> element, check if the value of the @ref identifies an
       appropriate element (<para> for the first <target>, <item> for all others) in the
       target document.
      - If not, generate an error. 
      - If the value of @position is "before" or "after":
        # For all <target> elements other than the first and last, generate ", in the ",
          followed by the ordinal number of the <item> element identified by the value
          of the @ref attribute, followed by " list item".
        # For the last <target>, generate ", ", followed by the value of @position,
          followed by " the ", followed by the ordinal number of the <item> element
          identified by the value of the @ref attribute, followed by "list item".
      - Otherwise, the value of @position is "last":
        # For all <target> elements other than the first and last, generate ", in the ",
          followed by the ordinal number of the <item> element identified by the value
          of the @ref attribute, followed by " list item".
        # For the last <target>, generate "after the last list item".  
-->
<xsl:template match="addListItem">
  <xsl:param name="targetPart"/>
  <xsl:variable name="position" select="@position"/>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
  <xsl:variable name="ref"
                select=".//target[1]/@ref"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_mW_psm_subclause_id_fnd_para_id_8                 -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="./target[1]/@ref"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith//target[@ref=$ref])"/>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
<!-- The entire merge instruction is enclosed in a box -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Insert into </xsl:text>
<!-- ************************************************************* -->
<!-- Here is where I have to process the <context> element.        -->
<!-- ************************************************************* -->
<!-- Process the <context> element -->
    <xsl:variable name="ctxtype" select="context/@type"/>
    <xsl:variable name="ctxref" select="context/@ref"/>
    <xsl:variable name="ctxlinkref">
      <xsl:text>'</xsl:text>
      <xsl:value-of select="$ctxref"/>
      <xsl:text>'</xsl:text>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$ctxtype='para'">
        <xsl:if test="not($extroot//node()[@id=$ctxref]) or
                      not($extroot//node()[@id=$ctxref]/local-name()='para')">
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify a paragraph in the target part (%s2)</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$ctxref"/>
            <xsl:with-param name="ErrorValue2" select="$targetPart"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:if>
        <xsl:text>the </xsl:text>
        <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$ctxlinkref}')"
                       show-destination="new" color="#000070">
            <!-- In the link, every para with matching id is processed (should be only one!) -->
            <xsl:for-each select="$extroot//*[@id=$ctxref][self::para]">
              <xsl:apply-templates select="key('generic-id', $ctxref)" mode="specref-mode"/>
              <xsl:text> paragraph</xsl:text>
            </xsl:for-each>
        </fo:basic-link>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="not($extroot//node()[@id=$ctxref]) or
                      not($extroot//node()[@id=$ctxref]/local-name()!='para')">
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify a Rule, Description, or Table Population item in the target part (%s2).</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$ctxref"/>
            <xsl:with-param name="ErrorValue2" select="$targetPart"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:if>
        <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$ctxlinkref}')"
                       show-destination="new" color="#000070">
          <xsl:choose>
            <xsl:when test="$ctxtype='SR'"><xsl:text>SR&nbsp;</xsl:text></xsl:when>
            <xsl:when test="$ctxtype='AR'"><xsl:text>AR&nbsp;</xsl:text></xsl:when>
            <xsl:when test="$ctxtype='GR'"><xsl:text>GR&nbsp;</xsl:text></xsl:when>
            <xsl:when test="$ctxtype='CR'"><xsl:text>CR&nbsp;</xsl:text></xsl:when>
            <xsl:when test="$ctxtype='Desc'"><xsl:text>Description&nbsp;</xsl:text></xsl:when>
            <xsl:when test="$ctxtype='TP'"><xsl:text>Initial Table Population item&nbsp;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
              <xsl:call-template name="ProcessError">
                <xsl:with-param name="ErrorText">The value of the @type attribute (%s1) is not a supported value.</xsl:with-param>
                <xsl:with-param name="ErrorValue1" select="$ctxtype"/>
              </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
            </xsl:otherwise>
          </xsl:choose>
          <!-- In the link, every para with a matching id is processed (should be only one!) -->
          <xsl:for-each select="$extroot//*[@id=$ctxref][self::item]">
            <xsl:apply-templates select="key('generic-id', $ctxref)" mode="specref-mode"/>
          </xsl:for-each>
        </fo:basic-link>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:if test="not(target) and $position='last'">
      <xsl:text>, after the last list item</xsl:text>
    </xsl:if>
    <xsl:for-each select="target">
      <xsl:variable name="ref" select="@ref"/>
      <xsl:variable name="linkref">
        <xsl:text>'</xsl:text>
        <xsl:value-of select="$ref"/>
        <xsl:text>'</xsl:text>
      </xsl:variable>
      <xsl:if test="not($extroot//node()[@id=$ref]) or
                    not($extroot//node()[@id=$ref]/local-name()='item')">
<!-- LINE LENGTH CHECK OFF -->
        <xsl:call-template name="ProcessError">
          <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify a list item in the target part (%s2).</xsl:with-param>
          <xsl:with-param name="ErrorValue1" select="$ref"/>
          <xsl:with-param name="ErrorValue2" select="$targetPart"/>
        </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
      </xsl:if>
      <xsl:choose>
        <xsl:when test="position()!=last() or (position()=last() and $position='last')">
          <xsl:text>, in the </xsl:text>
          <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                         show-destination="new" color="#000070">
              <!-- In the link, every para with matching id is processed (should be only one!) -->
              <xsl:for-each select="$extroot//*[@id=$ref][self::item]">
                <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
                <xsl:text> list item</xsl:text>
              </xsl:for-each>
          </fo:basic-link>
          <xsl:if test="$position='last'">
            <xsl:text>, after the last list item</xsl:text>
          </xsl:if>
        </xsl:when>
        <xsl:when test="position()=last() and $position!='last'">
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$position"/>
          <xsl:text> the </xsl:text>
          <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                         show-destination="new" color="#000070">
            <!-- In the link, every para with matching id is processed (should be only one!) -->
            <xsl:for-each select="$extroot//*[@id=$ref][self::item]">
              <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
              <xsl:text> list item</xsl:text>
            </xsl:for-each>
          </fo:basic-link>
        </xsl:when>
      </xsl:choose>
    </xsl:for-each>
    <xsl:text>:</xsl:text>
  </fo:inline>
  <xsl:apply-templates/>
</xsl:template>


<!--
    addPara inserts a paragraph (effectively, not literally!) either immediate after or
    immediately before the paragraph with @id value equal to the value of the @ref attribute.
    Sketch of the template:
    * Check that the value of @ref is the value of @id of a <para> element in the target doc
    * If not, generate an error
    * If so:
      - Generate, in a box, "Insert before/after the"
      - Generate, in the box and as part of a hot link, the ordinal number of the paragraph
      - Generate, in the box and as part of the hot link, " paragraph"
-->
<xsl:template match="addPara">
  <xsl:param name="targetPart"/>
  <xsl:variable name="position" select="@position"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
  <xsl:if test="not($extroot//node()[@id=$ref]) or
                not($extroot//node()[@id=$ref]/local-name()='para')">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify a paragraph in the target part (%s2).</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="$ref"/>
      <xsl:with-param name="ErrorValue2" select="$targetPart"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_psm_subclause_id_fnd_para_id_8                 -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith[@ref=$ref])"/>
  </xsl:variable>
<!-- The entire merge instruction is enclosed in a box -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Insert </xsl:text>
    <xsl:value-of select="$position"/>
    <xsl:text> the </xsl:text>
    <!-- Ordinal number of the identifid paragraph -->
    <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                   show-destination="new" color="#000070">
      <!-- In the link, every paragraph with a matching id is processed (should be only one!) -->
        <xsl:for-each select="$extroot//*[@id=$ref][self::para]">
          <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
          <xsl:text> paragraph</xsl:text>
        </xsl:for-each>
    </fo:basic-link>
    <xsl:text>:</xsl:text>
  </fo:inline>
</xsl:template>


<!--
    addRows is used to insert rows from a table in an incremental part to a table in a base part.
    Sketch of the template:
      * Check that the value of @targetTable identifies a table in the target part of the standard;
        - If not, generate an error
      * Check that the value of @sourceTable identifies a table in the current document;
        - If not, generate an error
      * Generate, in a box, "Insert into " and the #/title of the target table with hotlink
      * Generate, unboxed, " the rows of " and the #/title of the source table with hotlink
-->
<xsl:template match="addRows">
  <xsl:param name="targetPart"/>
  <xsl:variable name="targetTable" select="@targetTable"/>
  <xsl:variable name="targetLinkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$targetTable"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="sourceTable" select="@sourceTable"/>
  <xsl:variable name="sourceLinkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$sourceTable"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
<!-- Check to see if the target table exists; if not, generate an error -->
  <xsl:if test="not($extroot//table[@id=$targetTable]) and
                not($extroot//conditionsTable[@id=$targetTable]) and
                not($extroot//featuresTable[@id=$targetTable])">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">The table referenced by the value of the @targetTable attribute (%s1) does not identify a table in the target part (%s2).</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="$targetTable"/>
      <xsl:with-param name="ErrorValue2" select="$targetPart"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
<!-- Check to see if the source table exists; if not, generate an error -->
  <xsl:if test="not(//table[@id=$sourceTable]) and
                not(//conditionsTable[@id=$sourceTable]) and
                not(//featuresTable[@id=$sourceTable])">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">The table referenced by the value of the @sourceTable attribute (%s1) does not identify a table in this part.</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="$sourceTable"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_psm_subclause_id_fnd_table_id_8                 -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="$targetTable"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith[@targetTable=$targetTable])"/>
  </xsl:variable>
<!-- The entire merge instruction is enclosed in a box -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Insert into </xsl:text>
    <!-- Number and title of the target table -->
    <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$targetLinkref}')"
                   show-destination="new" color="#000070">
      <!-- In the link, every table with a matching id is processed (should be only one!) -->
        <xsl:for-each select="$extroot//*[@id=$targetTable]
                              [self::table | self::conditionsTable | self::featuresTable]">

          <xsl:variable name="ThisTable" select="."/>
          <xsl:variable name="tablenum">
            <xsl:choose>
              <xsl:when test="tableNumber">
                <xsl:value-of select="tableNumber"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="GetTableNumber">
                  <xsl:with-param name="TheTable" select="$ThisTable"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:variable>
          <fo:inline keep-together.within-line="always">
            <xsl:text>Table </xsl:text>
            <xsl:value-of select="$tablenum"/>
            <xsl:text>,</xsl:text>
          </fo:inline>
          <xsl:text> &ldquo;</xsl:text>
          <xsl:apply-templates select="tableTitle"/>
          <xsl:text>&rdquo;</xsl:text>
        </xsl:for-each>
    </fo:basic-link>
  </fo:inline>
  <xsl:text> the rows of </xsl:text>
  <!-- Number and title of the source table -->
    <fo:basic-link internal-destination="'{$sourceTable}'" color="#000070">
      <xsl:apply-templates select="key('generic-id', $sourceTable)" mode="specref-mode"/>
    </fo:basic-link>
  <xsl:text>. </xsl:text>
</xsl:template>


<!--
    addRule is used to insert a Rule (effectively, not literally!) either immediate after or
    immediately before the Rule with @id value equal to the value of the @ref attribute.
-->
<xsl:template match="addRule">
  <xsl:param name="targetPart"/>
  <xsl:apply-templates>
    <xsl:with-param name="targetPart" select="$targetPart"/>
  </xsl:apply-templates>
</xsl:template>


<!--
    before indicates that the rule to be added is placed *before* the rule identified by
    the value of the @ref attribute
    Sketch of the template:
    * Check that the value of @ref is the value of @id of an <item> element in the target doc.
    * If not, generate an error
    * If so:
      - Generate, in a box, "Insert before"
      - Generate, in the box and as part of a hot link:
        + The phrase derived from the @type attribute (e.g., "SR" ==> "Syntax Rule")
        + The generated number of the <item> identified by the value of @ref
-->
<xsl:template match="addRule/before">
  <xsl:param name="targetPart"/>
  <xsl:variable name="type" select="parent::addRule/@type"/>
  <xsl:variable name="position"><xsl:text>before </xsl:text></xsl:variable>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
  <xsl:if test="not($extroot//node()[@id=$ref]) or
                not($extroot//node()[@id=$ref]/local-name()='item')">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify an item element in the target part (%s2).</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="$ref"/>
      <xsl:with-param name="ErrorValue2" select="$targetPart"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_psm_subclause_id_fnd_para_id_8                 -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith[@ref=$ref])"/>
  </xsl:variable>
<!-- The entire merge instruction is enclosed in a box -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Insert </xsl:text>
    <xsl:value-of select="$position"/>
    <!-- Ordinal number of the identifid list item -->
    <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                   show-destination="new" color="#000070">
      <xsl:choose>
        <xsl:when test="$type='SR'"><xsl:text>SR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='AR'"><xsl:text>AR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='GR'"><xsl:text>GR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='CR'"><xsl:text>CR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='Desc'"><xsl:text>Description&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='TP'"><xsl:text>Initial Table Population item&nbsp;</xsl:text>
          </xsl:when>
        <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">The value of the @type attribute (%s1) is not a supported value.</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$type"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:otherwise>
      </xsl:choose>
      <!-- In the link, every paragraph with a matching id is processed (should be only one!) -->
      <xsl:for-each select="$extroot//*[@id=$ref][self::item]">
        <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
      </xsl:for-each>
    </fo:basic-link>
    <xsl:text>:</xsl:text>
  </fo:inline>
</xsl:template>


<!--
    after indicates that the rule to be added is placed *after* the rule identified by
    the value of the @ref attribute
    Sketch of the template:
    * Check that the value of @ref is the value of @id of an <item> element in the target doc.
    * If not, generate an error
    * If so:
      - Generate, in a box, "Insert after"
      - Generate, in the box and as part of a hot link:
        + The phrase derived from the @type attribute (e.g., "SR" ==> "Syntax Rule")
        + The generated number of the <item> identified by the value of @ref
-->
<xsl:template match="addRule/after">
  <xsl:param name="targetPart"/>
  <xsl:variable name="type" select="parent::addRule/@type"/>
  <xsl:variable name="position"><xsl:text>after </xsl:text></xsl:variable>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
  <xsl:if test="not($extroot//node()[@id=$ref]) or
                not($extroot//node()[@id=$ref]/local-name()='item')">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify an item element in the target part (%s2).</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="$ref"/>
      <xsl:with-param name="ErrorValue2" select="$targetPart"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_psm_subclause_id_fnd_para_id_8                 -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith[@ref=$ref])"/>
  </xsl:variable>
<!-- The entire merge instruction is enclosed in a box -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Insert </xsl:text>
    <xsl:value-of select="$position"/>
    <!-- Ordinal number of the identifid paragraph -->
    <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                   show-destination="new" color="#000070">
      <xsl:choose>
        <xsl:when test="$type='SR'"><xsl:text>SR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='AR'"><xsl:text>AR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='GR'"><xsl:text>GR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='CR'"><xsl:text>CR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='Desc'"><xsl:text>Description&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='TP'"><xsl:text>Initial Table Population item&nbsp;</xsl:text>
          </xsl:when>
        <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">The value of the @type attribute (%s1) is not a supported value.</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$type"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:otherwise>
      </xsl:choose>
      <!-- In the link, every paragraph with a matching id is processed (should be only one!) -->


      <xsl:for-each select="$extroot//*[@id=$ref][self::item]">
        <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
      </xsl:for-each>
    </fo:basic-link>
    <xsl:text>:</xsl:text>
  </fo:inline>
</xsl:template>


<!--
    last indicates that the rule is to be added as the last rule in the subsection. 
    Sketch of the template:
    * Check that the value of @ref is the value of @id of an <item> element in the target doc.
    * If not, generate an error
    * If so:
      - Generate, in a box, "Insert after the last"
      - Generate the phrase derived from the @type attribute (e.g., "SR" ==> "Syntax Rule")
-->
<xsl:template match="addRule/last">
  <xsl:param name="targetPart"/>
  <xsl:variable name="type" select="parent::addRule/@type"/>
  <xsl:variable name="thisSubclauseID"
                select="./ancestor::subClause/@id"/>
  <xsl:variable name="thisSubclauseComparisonID"
                select="substring-after($thisSubclauseID, '_')"/>
  <xsl:variable name="thisSubsection"
                select="./(ancestor::SyntaxRules | ancestor::AccessRules |
                           ancestor::GeneralRules | ancestor::ConformanceRules |
                           ancestor::Description | ancestor::TablePopulation)/
                          local-name(.)"/>
  <xsl:variable name="thisSubsectionCode">
    <xsl:choose>
      <xsl:when test="$thisSubsection = 'SyntaxRules'">
        <xsl:text>SR</xsl:text>
      </xsl:when>
      <xsl:when test="$thisSubsection = 'AccessRules'">
        <xsl:text>AR</xsl:text>
      </xsl:when>
      <xsl:when test="$thisSubsection = 'GeneralRules'">
        <xsl:text>GR</xsl:text>
      </xsl:when>
      <xsl:when test="$thisSubsection = 'ConformanceRules'">
        <xsl:text>CR</xsl:text>
      </xsl:when>
      <xsl:when test="$thisSubsection = 'Description'">
        <xsl:text>Desc</xsl:text>
      </xsl:when>
      <xsl:when test="$thisSubsection = 'TablePopulation'">
        <xsl:text>TP</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>UNKNOWN</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="countPreviousItems"
                select="count(ancestor::item/preceding-sibling::item)"/>

<!--
  <xsl:variable name="targetSubclauseID" select=""/>
-->

  <xsl:for-each select="$parts[@number=$standardNumber]/part[@TC = 'false'
                               and @number = $targetPart]">
    <xsl:variable name="partnum" select="@number"/>
    <xsl:variable name="filename" select="@input"/>
    <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
    <xsl:variable name="output" select="@output"/>

    <xsl:variable name="targetContainerID"
                  select="$extroot//subClause[substring-after(@id, '_') =
                                              $thisSubclauseComparisonID]/@id"/>

<!-- the @id should be id="P09_GENERATED_med_names_02_fnd_names_0" -->
<!-- P / $partno / _GENERATED_ / ancestor::subClause/@id / $targetPartNo /
     $parts/standard="$standard"/part[part="$targetPartNo"].../@id / count... -->
<!--
Compute THIS value for the target reference to the "last rule"
          <xsl:variable name="thisRuleID">
            <xsl:text>R</xsl:text>
            <xsl:value-of select="$partno"/>
            <xsl:text>_GENERATED_</xsl:text>
            <xsl:value-of select="$thisContainerID"/>
            <xsl:text>_LastRuleFrom_</xsl:text>
            <xsl:value-of select="$thisSubsectionCode"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$partnum"/>
            <xsl:text>_</xsl:text>
            <xsl:value-of select="$referencingContainerID"/>
          </xsl:variable>
-->

    <xsl:variable name="thisID">
      <xsl:text>P</xsl:text>
      <xsl:value-of select="$partno"/>
      <xsl:text>_GENERATED_</xsl:text>
      <xsl:value-of select="$thisSubclauseID"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="$thisSubsectionCode"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="$targetPart"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="$targetContainerID"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="$countPreviousItems"/>
    </xsl:variable>

    <xsl:variable name="targetRuleID">
      <xsl:text>R</xsl:text>
      <xsl:value-of select="$targetPart"/>
      <xsl:text>_GENERATED_</xsl:text>
      <xsl:value-of select="$targetContainerID"/>
      <xsl:text>_LastRuleFrom_</xsl:text>
      <xsl:value-of select="$thisSubsectionCode"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="$partno"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="$thisSubclauseID"/>
    </xsl:variable>

<!-- The entire merge instruction is enclosed in a box -->
<!-- A <last> insertion DOES cause a "little red box" in the target document! -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->

    <fo:inline id="{$thisID}"
               border-style="solid" border-color="black"
               border-width="0.4pt" padding-before="2pt"
               padding-after="0.9pt" padding-start="1.8pt"
               padding-end="1.8pt" margin-end="1.5pt">
      <xsl:text>Insert after </xsl:text>
      <fo:basic-link external-destination="url('file:{$output}.pdf#{$targetRuleID}')"
                     show-destination="new" color="#000070">
        <xsl:text>the last </xsl:text>
        <xsl:choose>
          <xsl:when test="$type='SR'"><xsl:text>SR</xsl:text></xsl:when>
          <xsl:when test="$type='AR'"><xsl:text>AR</xsl:text></xsl:when>
          <xsl:when test="$type='GR'"><xsl:text>GR</xsl:text></xsl:when>
          <xsl:when test="$type='CR'"><xsl:text>CR</xsl:text></xsl:when>
          <xsl:when test="$type='Desc'"><xsl:text>Description</xsl:text></xsl:when>
          <xsl:when test="$type='TP'"><xsl:text>Initial Table Population item</xsl:text></xsl:when>
          <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">The value of the @type attribute (%s1) is not a supported value.</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$type"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:otherwise>
        </xsl:choose>
      </fo:basic-link>
      <xsl:text>:</xsl:text>
    </fo:inline>
  </xsl:for-each>
</xsl:template>


<!--
    augmentListItem modifies (effectively, not literally!) the text of an unordered list element
    whose @id value is equal to the value of the @ref attribute. 
    Sketch of the template:
    * Check if the value of @part identifies a part of this standard
    * If not, generate an error
    * Start a box and generate "Augment "
    * For each child <target> element, check if the value of @ref identifies an appropriate
      element (<para> for the first <target>, <item> for all others) in the target document
      - If not, generate an error
      - For the first <target>, generate "the ", followed by a hot link containing
        the ordinal number of the <para> element identified by the value of the
        @ref attribute, followed by " paragraph"
      - For all <target> elements other than the first generate ", in the ", followed by
        a hot link containing the ordinal number of the <item> element identified by
        the value of the @ref attribute, followed by " list item"
      - Terminate the box, then generate " by adding ", followed by the content of
        the <addition> element in quotes using <applyTemplates>, followed by the content
        of the <location> element using <applyTemplates>
-->
<xsl:template match="augmentListItem">
  <xsl:param name="targetPart"/>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
  <xsl:variable name="ref"
                select=".//target[1]/@ref"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_psm_subclause_id_fnd_para_id_8                 -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="./target[1]/@ref"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith//target[@ref=$ref])"/>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
<!-- The entire merge instruction is enclosed in a box -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Augment </xsl:text>
    <xsl:for-each select="target">
      <xsl:variable name="ref" select="@ref"/>
      <xsl:variable name="linkref">
        <xsl:text>'</xsl:text>
        <xsl:value-of select="$ref"/>
        <xsl:text>'</xsl:text>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="position()=1">
          <xsl:if test="not($extroot//node()[@id=$ref]) or
                        not($extroot//node()[@id=$ref]/local-name()='para')">
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify a paragraph in the target part (%s2).</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$ref"/>
              <xsl:with-param name="ErrorValue2" select="$targetPart"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:if>
        </xsl:when>
        <xsl:otherwise>
          <xsl:if test="not($extroot//node()[@id=$ref]) or
                        not($extroot//node()[@id=$ref]/local-name()='item')">
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify a list item in the target part (%s2).</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$ref"/>
              <xsl:with-param name="ErrorValue2" select="$targetPart"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:choose>
        <xsl:when test="position()=1">
          <xsl:text>the </xsl:text>
          <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                         show-destination="new" color="#000070">
              <!-- In the link, every para with matching id is processed (should be only one!) -->
              <xsl:for-each select="$extroot//*[@id=$ref][self::para]">
                <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
                <xsl:text> paragraph</xsl:text>
              </xsl:for-each>
          </fo:basic-link>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>, </xsl:text>
          <xsl:text> the </xsl:text>
          <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                         show-destination="new" color="#000070">
              <!-- In the link, every para with matching id is processed (should be only one!) -->
              <xsl:for-each select="$extroot//*[@id=$ref][self::item]">
                <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
                <xsl:text> list item</xsl:text>
              </xsl:for-each>
          </fo:basic-link>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </fo:inline>
  <xsl:text> by adding &ldquo;</xsl:text>
  <xsl:apply-templates select="addition"/>
  <xsl:text>&rdquo; </xsl:text>
  <xsl:apply-templates select="location"/>
  <xsl:text>.</xsl:text>
</xsl:template>


<!--
    augmentNote modifies (effectively, not literally!) the content of the Note with
    @id value equal to the value of the @ref attribute.
    Sketch of the template:
    * Check that the value of @ref is the value of @id of a <note> element in the target doc
    * If not, generate an error
    * If so:
      - Generate, in a box, "Augment Note"
      - Generate, in the box and as part of a hot link, the number of the Note
      - Generate the text to be added and the final location for the augmentation
-->
<xsl:template match="augmentNote">
  <xsl:param name="targetPart"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
  <xsl:if test="not($extroot//node()[@id=$ref]) or
                not($extroot//node()[@id=$ref]/local-name()='note')">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify a Note in the target part (%s2).</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="$ref"/>
      <xsl:with-param name="ErrorValue2" select="$targetPart"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_psm_subclause_id_fnd_para_id_8                 -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith[@ref=$ref])"/>
  </xsl:variable>
<!-- The entire merge instruction is enclosed in a box -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Augment </xsl:text>
    <!-- Ordinal number of the identifid paragraph -->
    <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                   show-destination="new" color="#000070">
      <!-- In the link, every paragraph with a matching id is processed (should be only one!) -->
        <xsl:for-each select="$extroot//*[@id=$ref][self::note]">
          <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
        </xsl:for-each>
    </fo:basic-link>
  </fo:inline>
  <xsl:text> by adding &ldquo;</xsl:text>
  <xsl:apply-templates select="addition"/>
  <xsl:text>&rdquo; </xsl:text>
  <xsl:apply-templates select="location"/>
  <xsl:text>. </xsl:text>
</xsl:template>


<!--
    augmentPara modifies (effectively, not literally!) the content of the paragraph with
    @id value equal to the value of the @ref attribute.
    Sketch of the template:
    * Check that the value of @ref is the value of @id of a <para> element in the target doc
    * If not, generate an error
    * If so:
      - Generate, in a box, "Augment the"
      - Generate, in the box and as part of a hot link, the ordinal number of the paragraph
      - Generate, in the box and as part of the hot link, " paragraph"
      - Generate the text to be added and the final location for the augmentation
-->
<xsl:template match="augmentPara">
  <xsl:param name="targetPart"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
  <xsl:if test="not($extroot//node()[@id=$ref]) or
                not($extroot//node()[@id=$ref]/local-name()='para')">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify a paragraph in the target part (%s2).</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="$ref"/>
      <xsl:with-param name="ErrorValue2" select="$targetPart"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_psm_subclause_id_fnd_para_id_8                 -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith[@ref=$ref])"/>
  </xsl:variable>
<!-- The entire merge instruction is enclosed in a box -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Augment the </xsl:text>
    <!-- Ordinal number of the identifid paragraph -->
    <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                   show-destination="new" color="#000070">
      <!-- In the link, every paragraph with a matching id is processed (should be only one!) -->
        <xsl:for-each select="$extroot//*[@id=$ref][self::para]">
          <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
          <xsl:text> paragraph</xsl:text>
        </xsl:for-each>
    </fo:basic-link>
  </fo:inline>
  <xsl:text> by adding &ldquo;</xsl:text>
  <xsl:apply-templates select="addition"/>
  <xsl:text>&rdquo; </xsl:text>
  <xsl:apply-templates select="location"/>
  <xsl:text>. </xsl:text>
</xsl:template>


<!--
    augmentRule modifies (effectively, not literally!) the content of a Rule with
    @id value equal to the value of the @ref attribute.  The Rule must be either an SR, an AR,
    a GR, a CR, a Description, or an Initial Table Population. 
    Sketch of the template:
    * Check that the value of @ref is the value of @id of an <item> element in the target doc
    * If not, generate an error
    * If so:
      - Generate, in a box, "Augment "
      - Generate, in the box and as part of a hot link, the string and fully-qualified Rule #
      - Generate the text to be added and the text for final location of the augmentation
-->
<xsl:template match="augmentRule">
  <xsl:param name="targetPart"/>
  <xsl:variable name="leadText" select="@leadText"/>
  <xsl:variable name="type" select="@type"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
  <xsl:if test="not($extroot//node()[@id=$ref]) or
                not($extroot//node()[@id=$ref]/local-name()='item')">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify an item element in the target part (%s2).</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="$ref"/>
      <xsl:with-param name="ErrorValue2" select="$targetPart"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_psm_subclause_id_fnd_para_id_8                 -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith[@ref=$ref])"/>
  </xsl:variable>
<!-- The entire merge instruction is enclosed in a box -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Augment </xsl:text>
    <xsl:if test="$leadText = 'yes'">
      <xsl:text>the lead text of </xsl:text>
    </xsl:if>
    <!-- Generate the Rule number -->
    <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                   show-destination="new" color="#000070">
      <xsl:choose>
        <xsl:when test="$type='SR'"><xsl:text>SR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='AR'"><xsl:text>AR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='GR'"><xsl:text>GR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='CR'"><xsl:text>CR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='Desc'"><xsl:text>Description&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='TP'"><xsl:text>Initial Table Population item&nbsp;</xsl:text>
          </xsl:when>
        <xsl:when test="$type='LE'"></xsl:when>
        <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">The value of the @type attribute (%s1) is not a supported value.</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$type"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:otherwise>
      </xsl:choose>
      <!-- In the link, every paragraph with a matching id is processed (should be only one!) -->
      <xsl:for-each select="$extroot//*[@id=$ref][self::item]">
        <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
      </xsl:for-each>
    </fo:basic-link>
  </fo:inline>
  <xsl:text> by adding &ldquo;</xsl:text>
  <xsl:apply-templates select="addition"/>
  <xsl:text>&rdquo; </xsl:text>
  <xsl:apply-templates select="location"/>
  <xsl:text>. </xsl:text>
</xsl:template>


<!--
    addition simply processes the content of the element
-->
<xsl:template match="augmentPara/addition | agumentRule/addition">
  <xsl:apply-templates/>
</xsl:template>


<!--
    location simply processes the content of the element
-->
<xsl:template match="augmentPara/location | agumentRule/location">
  <xsl:apply-templates/>
</xsl:template>


<!--
    convertRuleToCase is used to transform (virtually, not literally!) a Rule that is not a Case
    in a base part to a Case: in an incremental part, referencing the original text of the Rule
    in the base part as a new subrule in the incremental part after emitting a "Case:" and the
    new subrule (contained in the <addition> child element) defined in the markup. 
-->
<xsl:template match="convertRuleToCase">
  <xsl:param name="targetPart"/>
  <xsl:variable name="type" select="@type"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
  <xsl:if test="not($extroot//node()[@id=$ref]) or
                not($extroot//node()[@id=$ref]/local-name()='item')">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify an item element in the target part (%s2).</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="$ref"/>
      <xsl:with-param name="ErrorValue2" select="$targetPart"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_psm_subclause_id_fnd_para_id_8                 -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith[@ref=$ref])"/>
  </xsl:variable>
<!-- The entire merge instruction is enclosed in a box -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Convert </xsl:text>
    <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                   show-destination="new" color="#000070">
      <xsl:choose>
        <xsl:when test="$type='SR'"><xsl:text>SR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='AR'"><xsl:text>AR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='GR'"><xsl:text>GR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='CR'"><xsl:text>CR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='Desc'"><xsl:text>Description&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='TP'"><xsl:text>Initial Table Population item&nbsp;</xsl:text>
          </xsl:when>
        <xsl:when test="$type='LE'"></xsl:when>
        <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">The value of the @type attribute (%s1) is not a supported value.</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$type"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:otherwise>
      </xsl:choose>
      <!-- In the link, every paragraph with a matching id is processed (should be only one!) -->
      <xsl:for-each select="$extroot//*[@id=$ref][self::item]">
        <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
      </xsl:for-each>
    </fo:basic-link>
    <xsl:text> to be:</xsl:text>
  </fo:inline>
  <xsl:text>Case:</xsl:text>
  <xsl:variable name="list-level" select="count(ancestor-or-self::*[name()='olist'])+1"/>
  <fo:list-block provisional-label-separation="3pt" space-before.optimum="6pt">
    <xsl:choose>
      <xsl:when test="($list-level=3 or $list-level=6 or $list-level=9 or $list-level=12)">
        <xsl:attribute name="provisional-distance-between-starts">
         <xsl:value-of select="$list-roman-label-body-separation"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="provisional-distance-between-starts">
          <xsl:value-of select="$list-alphanum-label-body-separation"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
    <fo:list-item relative-align="baseline"
                  space-before.optimum="8pt"
                  hyphenate="true">
      <fo:list-item-label end-indent="label-end()">
        <fo:block text-align="start">
          <xsl:call-template name="olist-item-number">
            <xsl:with-param name="list-level" select="$list-level"/>
            <xsl:with-param name="item-pos" select="1"/>
            <xsl:with-param name="item-incr" select="1"/>
          </xsl:call-template>
          <xsl:text>)</xsl:text>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates select="newSubrule"/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
    <fo:list-item relative-align="baseline"
                  space-before.optimum="8pt"
                  hyphenate="true">
      <fo:list-item-label end-indent="label-end()">
        <fo:block text-align="start">
          <xsl:call-template name="olist-item-number">
            <xsl:with-param name="list-level" select="$list-level"/>
            <xsl:with-param name="item-pos" select="2"/>
            <xsl:with-param name="item-incr" select="1"/>
          </xsl:call-template>
          <xsl:text>)</xsl:text>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:text>Otherwise, </xsl:text>
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
          <fo:inline border-style="solid" border-color="black"
                     border-width="0.4pt" padding-before="2pt"
                     padding-after="0.9pt" padding-start="1.8pt"
                     padding-end="1.8pt" margin-end="1.5pt">
            <xsl:text>the original </xsl:text>
            <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                           show-destination="new" color="#000070">
              <xsl:choose>
                <xsl:when test="$type='SR'"><xsl:text>SR&nbsp;</xsl:text></xsl:when>
                <xsl:when test="$type='AR'"><xsl:text>AR&nbsp;</xsl:text></xsl:when>
                <xsl:when test="$type='GR'"><xsl:text>GR&nbsp;</xsl:text></xsl:when>
                <xsl:when test="$type='CR'"><xsl:text>CR&nbsp;</xsl:text></xsl:when>
                <xsl:when test="$type='Desc'"><xsl:text>Description&nbsp;</xsl:text></xsl:when>
                <xsl:when test="$type='TP'">
                  <xsl:text>Initial Table Population item&nbsp;</xsl:text>
                </xsl:when>
                <xsl:when test="$type='LE'"></xsl:when>
                <xsl:otherwise></xsl:otherwise>
              </xsl:choose>
              <!-- In the link, every paragraph with a matching id is processed
                   (should be only one!) -->
              <xsl:for-each select="$extroot//*[@id=$ref][self::item]">
                <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
              </xsl:for-each>
            </fo:basic-link>
          </fo:inline>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </fo:list-block>
</xsl:template>


<!-- newSubrule inserts (effectively,  not literally!) a new subrule into a rule that was,
     in the base part, a monolithic rule, but that has been convered, in the incremental
     part, to a new Case-structured rule.  <newSubrule> is a lot like <addition>, except
     that it can contains block-structured child elements (such as <code>) instead of
     only inline markup.
-->
<xsl:template match="newSubrule">
  <xsl:apply-templates/>
</xsl:template>


<!-- insertCode inserts (effectively, not literally!) a code block immediately before or after
     a specified block (or line) of text (most likely something in <code>, <hostcode> or
     <schemacode>) specified as the children of the <currentText> child element. 
     The context of the <currentText> is identified by the @ref attribute of the <target>
     child element.  What that context is (SR, GR, Desc) is specified by the @type
     attribute of the <insertCode> element, as is the positioning (@position) of the insertion. 
     Sketch of the template:
     * Check if the value of @part identifies a part of this standard
     * If not, generate an error
     * Generate "Insert into "
     * Use the value XXX of <target ref="XXX"/> and the value TTT of @type="TTT" to generate
       "Syntax Rule n)", "General Rule n)", or "Description n)", as appropriate.
     * Use the value of @position ("before" or "after") to generate " before " or " after ". 
     * Generate a block containing the value of <currentText> by applying templates. 
     * Generate a block containing one line that says "the code:".
-->
<xsl:template match="insertCode">
  <xsl:param name="targetPart"/>
  <xsl:variable name="position" select="@position"/>
  <xsl:variable name="type" select="@type"/>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
  <xsl:variable name="ref"
                select=".//target[1]/@ref"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_mW_psm_subclause_id_fnd_para_id_8                 -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="./target/@ref"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith//target[@ref=$ref])"/>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
<!-- The entire merge instruction is enclosed in a box -->
<!-- 2022-03-20: TEMPORARILY CHANGE border-color from black to blue, changed back to black -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Insert into </xsl:text>
    <xsl:choose>
      <xsl:when test="$type!='Defn' and $type!='code'">
        <xsl:variable name="ref" select="target/@ref"/>
        <xsl:variable name="linkref">
          <xsl:text>'</xsl:text>
          <xsl:value-of select="$ref"/>
          <xsl:text>'</xsl:text>
        </xsl:variable>
        <xsl:if test="not($extroot//node()[@id=$ref]) or
                      not($extroot//node()[@id=$ref]/local-name()='item')">
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">The value of the @ref attribute (%s1) does not identify a list item in the target part (%s2).</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$ref"/>
            <xsl:with-param name="ErrorValue2" select="$targetPart"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:if>
<!-- Use the value XXX of <target ref="XXX"/> and the value TTT of @type="TTT" to generate
       "Syntax Rule n)", "General Rule n)", "Description n)", or "Initial Table Population item n)",
       as appropriate. -->
        <xsl:choose>
          <xsl:when test="$type='SR'">
            <xsl:text>SR&nbsp;</xsl:text>
          </xsl:when>
          <xsl:when test="$type='GR'">
            <xsl:text>GR&nbsp;</xsl:text>
          </xsl:when>
          <xsl:when test="$type='Desc'">
            <xsl:text>Description&nbsp;</xsl:text>
          </xsl:when>
          <xsl:when test="$type='TP'">
            <xsl:text>Initial Table Population item&nbsp;</xsl:text>
          </xsl:when>
          <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">The value of the @type attribute (%s1) is not a supported value.</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$type"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:otherwise>
        </xsl:choose>
        <!-- In the link, every paragraph with a matching id is processed (should be only one!) -->
        <!-- Ordinal number of the identifid list item -->
        <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                       show-destination="new" color="#000070">
          <xsl:for-each select="$extroot//*[@id=$ref][self::item]">
            <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
          </xsl:for-each>
        </fo:basic-link>
      </xsl:when>
      <!-- @type = 'code' -->
      <xsl:when test="$type='code'">
        <xsl:text>the code</xsl:text>
      </xsl:when>
      <!-- @type = 'Defn' -->
      <xsl:otherwise>
        <xsl:text>the Definition</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </fo:inline>
  <xsl:text> </xsl:text>
  <xsl:value-of select="$position"/>
<!-- Apply templates to process the <currentText> element -->
  <fo:block>
    <xsl:apply-templates select="currentText"/>
  </fo:block>
  <fo:block>
    <xsl:text>the code:</xsl:text>
  </fo:block>
</xsl:template>


<!--
    replicateSCsig creates in an incremental part an exact copy of a Rule in a base part.
    The Rule that is replicated is always a Rule containing only an <SCsignature> element. 
    Note: This <replicateSCsig> element only provides the merge instruction in a box.
          The copy of the rule itself is arranged in AddGeneratedItems.xsl

    Sketch of the template:
    * Check that the value of @ref is the value of @id of an <item> element in the target doc
      and that the <item> element's first child is an <SCsignature> element. 
    * If not, generate an error
    * If so:
      - Generate, in a box, "Replicate "
      - Generate, in the box and as part of a hot link, the string and fully-qualified Rule #
      - Apply the template for <SCsignature> from the target document
-->
<xsl:template match="replicateSCsig">
  <xsl:variable name="targetPart" select="@part"/>
  <xsl:variable name="type" select="@type"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="ourSubclause" select="(ancestor::subClause | 
                                             ancestor::subClause2 | ancestor::subClause3 | 
                                             ancestor::subClause4)[last()]"/>
  <xsl:variable name="ourSection" select="(ancestor::SyntaxRules | ancestor::AccessRules | 
                                           ancestor::GeneralRules)"/>
<!-- Check that the @type attribute matches the Section -->
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@output"/>
<!-- If @active is 'no', prefix $filename with "./published" (force use of published text) -->
  <xsl:variable name="active"
                select="$parts[@number=$standardNumber]/part[@number=$targetPart]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
  <xsl:variable name="target" select="$extroot//item[@id=$ref]
                                      [ancestor::subClause | ancestor::subClause2 |
                                       ancestor::subClause3 | ancestor::subClause4]"/>
<!-- DETERMINE WHETHER THE REFERENCED RULES (SR, AR, GR) HAVE A SIGNATURE -->
  <xsl:variable name="SCsignatureCount">
    <xsl:choose>
      <xsl:when test="$type='SR'">
        <xsl:value-of select="count($target//SCsignature[ancestor::SyntaxRules])"/>
      </xsl:when>
      <xsl:when test="$type='AR'">
        <xsl:value-of select="count($target//SCsignature[ancestor::AccessRules])"/>
      </xsl:when>
      <xsl:when test="$type='GR'">
        <xsl:value-of select="count($target//SCsignature[ancestor::GeneralRules])"/>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>
  <xsl:if test="$SCsignatureCount = 0">
    <xsl:variable name="section">
      <xsl:value-of select="($ourSection/local-name())"/>
      <xsl:text> in </xsl:text>
      <xsl:value-of select="($ourSubclause/@id)"/>
    </xsl:variable>
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">$nonterminal = replicateSCsig references a target (%s1 in part %s3) without an SCsignature of type %s2. parent = %s4</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="$ref"/>
      <xsl:with-param name="ErrorValue2" select="$type"/>
      <xsl:with-param name="ErrorValue3" select="$targetPart"/>
      <xsl:with-param name="ErrorValue4" select="$section"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
<!-- Get @id of Clause/Annex/Subclause containing the <mergeWith> -->
  <xsl:variable name="container"
                select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                         ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                         ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                         [last()]"/>
<!-- Compute the required "backlink" attribute for basic-link to <mergeWith> -->
<!--   e.g., P04_GENERATED_psm_subclause_id_fnd_para_id_8                    -->
  <xsl:variable name="mergeInstrID">
    <xsl:text>P</xsl:text>
    <xsl:value-of select="$partno"/>
    <xsl:text>_GENERATED_</xsl:text>
    <xsl:value-of select="$container"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>_</xsl:text>
    <xsl:value-of select="count(preceding-sibling::mergeWith[@ref=$ref])"/>
  </xsl:variable>
<!-- The entire merge instruction is enclosed in a box -->
  <fo:inline id="{$mergeInstrID}"
             border-style="solid" border-color="black"
             border-width="0.4pt" padding-before="2pt"
             padding-after="0.9pt" padding-start="1.8pt"
             padding-end="1.8pt" margin-end="1.5pt">
    <xsl:text>Replicate </xsl:text>
    <!-- Ordinal number of the identifing paragraph -->
    <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                   show-destination="new" color="#000070">
      <xsl:choose>
        <xsl:when test="$type='SR'"><xsl:text>SR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='AR'"><xsl:text>AR&nbsp;</xsl:text></xsl:when>
        <xsl:when test="$type='GR'"><xsl:text>GR&nbsp;</xsl:text></xsl:when>
        <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">The value of the @type attribute (%s1) is not a supported value.</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$type"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:otherwise>
      </xsl:choose>
      <!-- In the link, every item with a matching id is processed (should be only one!) -->
      <xsl:for-each select="$extroot//*[@id=$ref][self::item]">
        <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
      </xsl:for-each>
    </fo:basic-link>
    <xsl:text>:</xsl:text>
  </fo:inline>
</xsl:template>


<!--
    Invoke, or apply, the rules of another subcause
    We need to ensure that the number of symargs in this applySC is equal to the number of 
    symparams in the target Subclauses's SCsignature element, and that the number of symresults in 
    this applySC is equal to the number of symreturns in the target Subclause's 
    SCsignature element. 
    The context in which this element is used will normally start with the word "The" or the word 
    "the", depending on earlier context.
-->
<xsl:template match="applySC">
  <xsl:variable name="ourParent" select="(ancestor::subClause | ancestor::subClause2
                                        | ancestor::subClause3 | ancestor::subClause4)[last()]"/>
  <xsl:variable name="rules" select="@rules"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="type" select="@type"/>
  <xsl:variable name="symargCount">
    <xsl:value-of select="count(./symarg)"/>
  </xsl:variable>
  <xsl:variable name="symresultCount">
    <xsl:value-of select="count(./symresult)"/>
  </xsl:variable>

  <xsl:if test="$type='asTest'">
    <xsl:choose>
      <xsl:when test="$symresultCount != 1">
<!-- LINE LENGTH CHECK OFF -->
        <xsl:call-template name="ProcessError">
          <xsl:with-param name="ErrorText">In id=%s1", an applySC contained attribute @type with a value of 'asTest' but with no symresult children or more than one symresult child.</xsl:with-param>
          <xsl:with-param name="ErrorValue1" select="($ourParent/@id)"/>
        </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="symresult" mode="asTest-mode"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> when the </xsl:text>
  </xsl:if>
<!-- 1) OUTPUT SOME TEXT ABOUT WHAT RULES ARE APPLIED -->
  <xsl:choose>
    <xsl:when test="$rules='SR'">
      <xsl:text>Syntax</xsl:text>
    </xsl:when>
    <xsl:when test="$rules='AR'">
      <xsl:text>Access</xsl:text>
    </xsl:when>
    <xsl:when test="$rules='GR'">
      <xsl:text>General</xsl:text>
    </xsl:when>
  </xsl:choose>
<!-- 2) OUTPUT "Rules of" TEXT -->
  <xsl:text> Rules of </xsl:text>
  <xsl:choose>
<!-- 3) TEST WHETHER @ref ATTRIBUTE MATCHES SOME SUBCLAUSE[n] ID ATTRIBUTE -->
  <!-- Is there a Subclause[n] whose id matches this ref value? -->
    <xsl:when test="key('generic-id', $ref)
                    [self::subClause | self::subClause2 |
                     self::subClause3 | self::subClause4]">
<!-- 4) IF THERE IS A MATCH, GRAB THE SUBCLAUSE[n] ELEMENT -->
      <xsl:variable name="target" select="key('generic-id', $ref)
                                          [self::subClause | self::subClause2 |
                                           self::subClause3 | self::subClause4]"/>
<!-- 5) DETERMINE WHETHER THE REFERENCED RULES (SR, AR, GR) HAVE A SIGNATURE -->
      <xsl:variable name="SCsignatureCount">
        <xsl:choose>
          <xsl:when test="$rules='SR'">
            <xsl:value-of select="count($target//SCsignature[ancestor::SyntaxRules])"/>
          </xsl:when>
          <xsl:when test="$rules='AR'">
            <xsl:value-of select="count($target//SCsignature[ancestor::AccessRules])"/>
          </xsl:when>
          <xsl:when test="$rules='GR'">
            <xsl:value-of select="count($target//SCsignature[ancestor::GeneralRules])"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
<!-- 6) DETERMINE HOW MANY SYMPARAMS THE RELEVANT SIGNATURE HAS -->
      <xsl:variable name="symparamCount">
        <xsl:choose>
          <xsl:when test="$rules='SR'">
            <xsl:value-of select="count($target//SCsignature/symparam[ancestor::SyntaxRules])"/>
          </xsl:when>
          <xsl:when test="$rules='AR'">
            <xsl:value-of select="count($target//SCsignature/symparam[ancestor::AccessRules])"/>
          </xsl:when>
          <xsl:when test="$rules='GR'">
            <xsl:value-of select="count($target//SCsignature/symparam[ancestor::GeneralRules])"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
<!-- 7) DETERMINE HOW MANY SYMRETURNS THE RELEVANT SIGNATURE HAS -->
      <xsl:variable name="symreturnCount">
        <xsl:choose>
          <xsl:when test="$rules='SR'">
            <xsl:value-of select="count($target//SCsignature/symreturn[ancestor::SyntaxRules])"/>
          </xsl:when>
          <xsl:when test="$rules='AR'">
            <xsl:value-of select="count($target//SCsignature/symreturn[ancestor::AccessRules])"/>
          </xsl:when>
          <xsl:when test="$rules='GR'">
            <xsl:value-of select="count($target//SCsignature/symreturn[ancestor::GeneralRules])"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
<!-- 8) ERROR IF THE RELEVANT RULES DO NOT HAVE A SIGNATURE -->
      <!-- Let us see if the contents of this applySC match the needs of the target -->
      <xsl:choose>
        <!-- Oops...the target is not an invocable Subclause after all -->
        <xsl:when test="$SCsignatureCount = 0">
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">$nonterminal = applySC references a target (%s1,%s2) without an SCsignature element. parent = %s3</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$ref"/>
            <xsl:with-param name="ErrorValue2" select="$rules"/>
            <xsl:with-param name="ErrorValue3" select="($ourParent/@id)"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:when>
<!-- 9) ERROR IF THE RELEVANT SIGNATURE HAS DIFFERENT NUMBER OF PARAMETERS -->
        <!-- Oops...the number of arguments does not match the number of parameters -->
        <xsl:when test="count(./symarg) != $symparamCount">
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">$nonterminal = applySC references a target (%s1, %s2) with a different number of symargs than the target&rsquo;s parent = %s3</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$ref"/>
            <xsl:with-param name="ErrorValue2" select="$rules"/>
            <xsl:with-param name="ErrorValue3" select="($ourParent/@id)"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:when>
<!-- 10) ERROR IF THE RELEVANT SIGNATURE HAS DIFFERENT NUMBER OF RETURNS -->
        <!-- Oops...either we do not expect a return and the target does a return, or we expect 
             one and the target does not provide one. -->
        <xsl:when test="count(./symresult) != $symreturnCount">
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">$nonterminal = applySC references a target (%s1, %s2) with a different number of symresults than the target&rsquo;s SCsignature&rsquo;s symreturns. parent = %s3</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$ref"/>
            <xsl:with-param name="ErrorValue2" select="$rules"/>
            <xsl:with-param name="ErrorValue3" select="($ourParent/@id)"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:when>
<!-- 11) IF EVERYTHING MATCHES UP, OUTPUT "this Subclause" or "Subclause x.x, 'name'" -->
        <!-- The invocation seems to match the invocable Subclause's needs -->
        <xsl:otherwise>
          <xsl:choose>
            <!-- If we're invoking our selves, then let us use a nice phrase to say so -->
            <xsl:when test="$ourParent/@id = $ref">
              <xsl:text>this Subclause</xsl:text>
            </xsl:when>
            <!-- If not, then give the full identify of the target Subclause -->
            <xsl:otherwise>
              <fo:basic-link internal-destination="'{@ref}'" color="#000070">
                <xsl:apply-templates select="key('generic-id', @ref)" mode="specref-mode"/>
              </fo:basic-link>
              <xsl:text>,</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
<!-- 12) IF @ref ATTRIBUTE HAS NO MATCHING SUBCLAUSE[n] ID, THEN ERROR -->
    <!-- If the ref attribute does not identify an existing subclause element... -->
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">$nonterminal = applySC has no identifiable target (%s1, %s2). parent = %s3</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
        <xsl:with-param name="ErrorValue2" select="$rules"/>
        <xsl:with-param name="ErrorValue3" select="($ourParent/@id)"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
<!-- 13) IF @ref MATCHES SOME ID, ARG COUNT IS GOOD, AND RESULT COUNT IS GOOD, PROCESS -->
  <xsl:choose>
    <xsl:when test="$type='normal'">
      <xsl:text> are applied</xsl:text>
    </xsl:when> 
    <xsl:when test="$type='asTrial'">
      <xsl:text> can be applied successfully</xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:if test="$symargCount > 0">
<!-- 14) IF AT LEAST ONE ARGUMENT, THEN "Xxx Rules of YYY are applied with" and arg info -->
    <xsl:text> with </xsl:text>
    <xsl:apply-templates select="symarg[1]"/>
    <xsl:choose>
      <xsl:when test="count(symarg) = 2">
        <xsl:text> and </xsl:text>
          <xsl:apply-templates select="symarg[2]"/>
      </xsl:when>
      <xsl:when test="count(symarg) > 2">
        <xsl:for-each select="symarg[position() >= 2 and position() &lt; last()]">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="."/>
        </xsl:for-each>
        <xsl:text>, and </xsl:text>
        <xsl:apply-templates select="symarg[position() = last()]"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
<!-- 15) DO FOR RESULTS AS WE JUST DID FOR ARGS -->
  <xsl:if test="symresult and not($type='asTest')">
    <xsl:choose>
      <xsl:when test="$type='normal'">
        <xsl:text>; let </xsl:text>
      </xsl:when> 
      <xsl:when test="$type='asTrial'">
        <xsl:text>; returning </xsl:text>
      </xsl:when>
    </xsl:choose>
    <xsl:apply-templates select="symresult[1]">
      <xsl:with-param name="type" select="$type"/>
    </xsl:apply-templates>
    <xsl:choose>
      <xsl:when test="count(symresult) = 2">
        <xsl:choose>
          <xsl:when test="$type='normal'">
            <xsl:text> and let </xsl:text>
          </xsl:when> 
          <xsl:when test="$type='asTrial'">
            <xsl:text> and returning </xsl:text>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="symresult[2]">
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="count(symresult) > 2">
        <xsl:for-each select="symresult[position() >= 2 and position() &lt; last()]">
        <xsl:choose>
          <xsl:when test="$type='normal'">
            <xsl:text>, let </xsl:text>
          </xsl:when> 
          <xsl:when test="$type='asTrial'">
            <xsl:text>, returning </xsl:text>
          </xsl:when>
        </xsl:choose>
          <xsl:apply-templates select=".">
            <xsl:with-param name="type" select="$type"/>
          </xsl:apply-templates>
        </xsl:for-each>
        <xsl:choose>
          <xsl:when test="$type='normal'">
            <xsl:text>, and let </xsl:text>
          </xsl:when> 
          <xsl:when test="$type='asTrial'">
            <xsl:text>, and returning </xsl:text>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="symresult[position() = last()]">
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="not($type='asTrial')">
      <xsl:text> returned from the application of those </xsl:text>
      <xsl:choose>
      <xsl:when test="$rules='SR'">
          <xsl:text>Syntax</xsl:text>
        </xsl:when>
        <xsl:when test="$rules='AR'">
          <xsl:text>Access</xsl:text>
        </xsl:when>
        <xsl:when test="$rules='GR'">
          <xsl:text>General</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:text> Rules</xsl:text>
    </xsl:if>
  </xsl:if>
<!-- 16) AND WE ARE FINISHED -->
</xsl:template>

<!--
     Symbolic argument for invoking other subclauses in "this" document
-->
<!-- The "param" argument gives the name of the symbolic parameter. 
     Generate a link to the symbolic parameter: subclause ID + _ + symbolic parameter name. 
     The tricky bit is this: We need to check to see whether the target subclause has a symparam
     with the given name. If so, all is well.
     If not, however, we generate some obnoxious text for attention. -->
<xsl:template match="symarg">
  <xsl:variable name="param" select="@param"/>
  <xsl:variable name="subClauseID" select="ancestor::subClause[1]/@id"/>
  <xsl:variable name="ref" select="parent::applySC/@ref"/>
  <xsl:choose>
    <xsl:when test="key('generic-id', $ref)
                       [self::subClause | self::subClause2 |
                        self::subClause3 | self::subClause4]
                       [.//symparam/@name=$param]">
      <xsl:variable name="fullID" select="concat($ref, '_', $param)"/>
      <xsl:apply-templates/>
      <xsl:text> as </xsl:text>
      <fo:basic-link internal-destination="{$fullID}" color="#000070">
        <fo:inline font-style="italic"><xsl:value-of select="$param"/></fo:inline>
      </fo:basic-link>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText"> $param = %s1, no corresponding symparam in %s2 $subClauseID = %s3</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$param"/>
        <xsl:with-param name="ErrorValue2" select="$ref"/>
        <xsl:with-param name="ErrorValue3" select="$subClauseID"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Result corresponding to the symbolic return from an invoke subclause
    "Normal" processing (applySC has no @type attribute or @type<>"asTest")
-->
<!-- The "param" argument gives the name of the symbolic parameter
     Generate a link to the symbolic parameter: subclause ID + _ + symbolic parameter name.
     The tricky bit is this: We need to check to see whether the target subclause has a symparam
     with the given name.
     If so, all is well.
     If not, however, we generate some obnoxious text for attention. -->
<xsl:template match="symresult">
  <xsl:param name="type"/>
  <xsl:variable name="param" select="@param"/>
  <xsl:variable name="subClauseID" select="ancestor::subClause[1]/@id"/>
  <xsl:variable name="ref" select="parent::applySC/@ref"/>
  <xsl:choose>
    <xsl:when test="key('generic-id', $ref)
                       [self::subClause | self::subClause2 |
                        self::subClause3 | self::subClause4]
                       [.//symreturn/@name=$param]">
      <xsl:variable name="fullID" select="concat($ref, '_', $param)"/>
      <xsl:apply-templates/>
      <xsl:choose>
        <xsl:when test="$type='asTrial'">
          <xsl:text> as the </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> be the </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <fo:basic-link internal-destination="{$fullID}" color="#000070">
        <fo:inline font-style="italic">
          <xsl:value-of select="$param"/>
        </fo:inline>
      </fo:basic-link>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText"> $param = %s1, no corresponding symreturn in %s2 $subClauseID = %s3</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$param"/>
        <xsl:with-param name="ErrorValue2" select="$ref"/>
        <xsl:with-param name="ErrorValue3" select="$subClauseID"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Result corresponding to the symbolic return from an invoke subclause
    "asTest" processing (applySC @type="asTest")
-->
<!-- The "param" argument gives the name of the symbolic parameter
     Generate a link to the symbolic parameter: subclause ID + _ + symbolic parameter name.
     The tricky bit is this: We need to check to see whether the target subclause has a symparam
     with the given name.
     If so, all is well.
     If not, however, we generate some obnoxious text for attention. -->
<xsl:template match="symresult" mode="asTest-mode">
  <xsl:variable name="param" select="@param"/>
  <xsl:variable name="subClauseID" select="ancestor::subClause[1]/@id"/>
  <xsl:variable name="ref" select="parent::applySC/@ref"/>
  <xsl:choose>
    <xsl:when test="key('generic-id', $ref)
                       [self::subClause | self::subClause2 |
                        self::subClause3 | self::subClause4]
                       [.//symreturn/@name=$param]">
      <xsl:variable name="fullID" select="concat($ref, '_', $param)"/>
      <xsl:text> is the </xsl:text>
      <fo:basic-link internal-destination="{$fullID}" color="#000070">
        <fo:inline font-style="italic">
          <xsl:value-of select="$param"/>
        </fo:inline>
      </fo:basic-link>
      <xsl:text> returned as </xsl:text>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">$param = %s1, no corresponding symreturn in %s2 $subClauseID = %s3</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$param"/>
        <xsl:with-param name="ErrorValue2" select="$ref"/>
        <xsl:with-param name="ErrorValue3" select="$subClauseID"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Symbolic argument for invoking other subclauses in "this" TC document
-->
<xsl:template match="tcSymarg">
  <fo:inline font-style="italic">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!--
    Invoke, or apply, the rules of another subcause in a different document
-->

<xsl:template match="applyExtSC">
  <xsl:variable name="ourParent" select="(ancestor::subClause | ancestor::subClause2
                                        | ancestor::subClause3 | ancestor::subClause4)[last()]"/>
  <xsl:variable name="rules" select="@rules"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="type" select="@type"/>
  <xsl:variable name="extsymargCount">
    <xsl:value-of select="count(./extsymarg)"/>
  </xsl:variable>
  <xsl:variable name="extsymresultCount">
    <xsl:value-of select="count(./extsymresult)"/>
  </xsl:variable>
  <xsl:variable name="standardnum">
    <xsl:choose>
      <xsl:when test="@standard">
        <xsl:value-of select="@standard"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$standardNumber"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="partnum" select="@part"/>
  <xsl:variable name="filename"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@output"/>
  <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="@ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>

  <xsl:if test="$type='asTest'">
    <xsl:choose>
      <xsl:when test="$extsymresultCount != 1">
<!-- LINE LENGTH CHECK OFF -->
        <xsl:call-template name="ProcessError">
          <xsl:with-param name="ErrorText">In id=%s1, an applyExtSC contained attribute @type with value 'asTest', but with no extsymresult children or more than one extsymresult child.</xsl:with-param>
          <xsl:with-param name="ErrorValue1" select="($ourParent/@id)"/>
        </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="extsymresult" mode="asTest-mode"/>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:text> when the </xsl:text>
  </xsl:if>
<!-- 1) OUTPUT SOME TEXT ABOUT WHAT RULES ARE APPLIED -->
  <xsl:choose>
    <xsl:when test="$rules='SR'">
      <xsl:text>Syntax</xsl:text>
    </xsl:when>
    <xsl:when test="$rules='AR'">
      <xsl:text>Access</xsl:text>
    </xsl:when>
    <xsl:when test="$rules='GR'">
      <xsl:text>General</xsl:text>
    </xsl:when>
  </xsl:choose>
<!-- 2) OUTPUT "Rules of" TEXT -->
  <xsl:text> Rules of </xsl:text>
  <!-- Is there a Subclause(n) whose id matches this ref value? -->
  <xsl:choose>
<!-- 3) TEST WHETHER @ref ATTRIBUTE MATCHES SOME SUBCLAUSE[n] ID ATTRIBUTE -->
    <xsl:when test="$extroot//*[@id=$ref]
                               [self::subClause | self::subClause2 |
                                self::subClause3 | self::subClause4]">
<!-- 4) IF THERE IS A MATCH, GRAB THE SUBCLAUSE[n] ELEMENT -->
      <xsl:variable name="target" select="$extroot//*[@id=$ref]
                                          [self::subClause | self::subClause2 |
                                           self::subClause3 | self::subClause4]"/>
<!-- 5) DETERMINE WHETHER THE REFERENCED RULES (SR, AR, GR) HAVE A SIGNATURE -->
      <xsl:variable name="SCsignatureCount">
        <xsl:choose>
          <xsl:when test="$rules='SR'">
            <xsl:value-of select="count($target//SCsignature[ancestor::SyntaxRules])"/>
          </xsl:when>
          <xsl:when test="$rules='AR'">
            <xsl:value-of select="count($target//SCsignature[ancestor::AccessRules])"/>
          </xsl:when>
          <xsl:when test="$rules='GR'">
            <xsl:value-of select="count($target//SCsignature[ancestor::GeneralRules])"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
<!-- 6) DETERMINE HOW MANY SYMPARAMS THE RELEVANT SIGNATURE HAS -->
      <xsl:variable name="symparamCount">
        <xsl:choose>
          <xsl:when test="$rules='SR'">
            <xsl:value-of select="count($target//SCsignature/symparam[ancestor::SyntaxRules])"/>
          </xsl:when>
          <xsl:when test="$rules='AR'">
            <xsl:value-of select="count($target//SCsignature/symparam[ancestor::AccessRules])"/>
          </xsl:when>
          <xsl:when test="$rules='GR'">
            <xsl:value-of select="count($target//SCsignature/symparam[ancestor::GeneralRules])"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
<!-- 7) DETERMINE HOW MANY SYMRETURNS THE RELEVANT SIGNATURE HAS -->
      <xsl:variable name="symreturnCount">
        <xsl:choose>
          <xsl:when test="$rules='SR'">
            <xsl:value-of select="count($target//SCsignature/symreturn[ancestor::SyntaxRules])"/>
          </xsl:when>
          <xsl:when test="$rules='AR'">
            <xsl:value-of select="count($target//SCsignature/symreturn[ancestor::AccessRules])"/>
          </xsl:when>
          <xsl:when test="$rules='GR'">
            <xsl:value-of select="count($target//SCsignature/symreturn[ancestor::GeneralRules])"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
<!-- 8) ERROR IF THE RELEVANT RULES DO NOT HAVE A SIGNATURE -->
      <!-- Let us see if the contents of this applySC match the needs of the target -->
      <xsl:choose>
        <!-- Oops...the target is not an invocable Subclause after all -->
        <xsl:when test="$SCsignatureCount = 0">
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">$nonterminal = applyExtSC references a target (%s1, %s2, in part %s3) without an SCsignature. parent = %s4</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$ref"/>
            <xsl:with-param name="ErrorValue2" select="$rules"/>
            <xsl:with-param name="ErrorValue3" select="$partnum"/>
            <xsl:with-param name="ErrorValue4" select="($ourParent/@id)"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:when>
<!-- 9) ERROR IF THE RELEVANT SIGNATURE HAS DIFFERENT NUMBER OF PARAMETERS -->
        <!-- Oops...the number of arguments does not match the number of parameters -->
        <xsl:when test="count(./extsymarg) != $symparamCount">
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">$nonterminal = applyExtSC (ref=%s1) has a different number of extsymargs than the target has symparams. parent = %s2</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$ref"/>
            <xsl:with-param name="ErrorValue2" select="($ourParent/@id)"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:when>
<!-- 10) ERROR IF THE RELEVANT SIGNATURE HAS DIFFERENT NUMBER OF RETURNS -->
        <!-- Oops...either we do not expect a return and the target does a return, or we expect
             one and the target does not perform one. -->
        <xsl:when test="count(./extsymresult) != $symreturnCount">
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">$nonterminal = applyExtSC (ref=%s1) has a different number of extsymresults than the target has symreturns.  parent = %s2</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$ref"/>
            <xsl:with-param name="ErrorValue2" select="($ourParent/@id)"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:when>
<!-- 11) IF EVERYTHING MATCHES UP, OUTPUT "Subclause x.x, 'name'" -->
        <!-- The invocation seems to match the invocable Subclause's needs -->
        <xsl:otherwise>
          <!-- So give the full identify of the target Subclause -->
          <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                         show-destination="new" color="#000070">
            <xsl:for-each select="$extroot//*[@id=$ref]
                                             [self::subClause | self::subClause2 |
                                              self::subClause3 | self::subClause4]">
              <fo:inline keep-together.within-line="always">
                <xsl:text>Subclause </xsl:text>
                <xsl:variable name="body" select="count(ancestor::standardPartBody)"/>
                <xsl:variable name="number-format">
                  <xsl:choose>
                    <xsl:when test="$body=1">1.1.1.1</xsl:when>
                    <xsl:otherwise>A.1.1.1</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:number level="multiple"
                            count="annex|clause|subClause|subClause2|subClause3|subClause4"
                            format="{$number-format}"/>
                <xsl:text>,</xsl:text>
              </fo:inline>
              <xsl:text> &ldquo;</xsl:text>
              <xsl:apply-templates select="clauseHeading">
                <xsl:with-param name="fromPart" select="$partnum"/>
              </xsl:apply-templates>
              <xsl:text>&rdquo;</xsl:text>
            </xsl:for-each>
          </fo:basic-link>
          <xsl:text>,</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
<!-- 12) IF @ref ATTRIBUTE HAS NO MATCHING SUBCLAUSE[n] ID, THEN ERROR -->
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">$nonterminal = applyExtSC has no identifiable target: %s1. parent = %s2</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
        <xsl:with-param name="ErrorValue2" select="($ourParent/@id)"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
<!-- 13) IF @ref MATCHES SOME ID, ARG COUNT IS GOOD, AND RESULT COUNT IS GOOD, PROCESS -->
  <xsl:if test="not($parts[@number=$standardNumber]/part[@number=$partno]/@TC='true')
                or ($parts[@number=$standardNumber]/part[@number=$partno]/@TC='true' 
                and not(number($partnum)=number(substring-after(/standard/@partNumber2digit,'-')
                )))">
    <xsl:text> in ISO/IEC </xsl:text>
    <xsl:value-of select="$standardnum"/>
    <xsl:text>-</xsl:text>
    <xsl:value-of select="number($partnum)"/>
    <xsl:text>,</xsl:text>
  </xsl:if>
<!-- 14) IF AT LEAST ONE ARGUMENT, THEN "Xxx Rules of YYY are applied with" and arg info -->
  <xsl:choose>
    <xsl:when test="$type='normal'">
      <xsl:text> are applied</xsl:text>
    </xsl:when> 
    <xsl:when test="$type='asTrial'">
      <xsl:text> can be applied successfully</xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:if test="$extsymargCount > 0">
    <xsl:text> with </xsl:text>
    <xsl:apply-templates select="extsymarg[1]"/>
    <xsl:choose>
      <xsl:when test="count(extsymarg) = 2">
        <xsl:text> and </xsl:text>
        <xsl:apply-templates select="extsymarg[2]"/>
      </xsl:when>
      <xsl:when test="count(extsymarg) > 2">
        <xsl:for-each select="extsymarg[position() >= 2 and position() &lt; last()]">
          <xsl:text>, </xsl:text>
          <xsl:apply-templates select="."/>
        </xsl:for-each>
        <xsl:text>, and </xsl:text>
        <xsl:apply-templates select="extsymarg[position() = last()]"/>
      </xsl:when>
    </xsl:choose>
  </xsl:if>
<!-- 15) DO FOR RESULTS AS WE JUST DID FOR ARGS -->
  <xsl:if test="extsymresult and not($type='asTest')">
  <xsl:choose>
    <xsl:when test="$type='normal'">
      <xsl:text>; let </xsl:text>
    </xsl:when> 
    <xsl:when test="$type='asTrial'">
      <xsl:text>; returning </xsl:text>
    </xsl:when>
  </xsl:choose>
    <xsl:apply-templates select="extsymresult[1]">
      <xsl:with-param name="type" select="$type"/>
    </xsl:apply-templates>
    <xsl:choose>
      <xsl:when test="count(extsymresult) = 2">
        <xsl:choose>
          <xsl:when test="$type='normal'">
            <xsl:text> and let </xsl:text>
          </xsl:when> 
          <xsl:when test="$type='asTrial'">
            <xsl:text> and returning </xsl:text>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="extsymresult[2]">
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates>
      </xsl:when>
      <xsl:when test="count(extsymresult) > 2">
        <xsl:for-each select="extsymresult[position() >= 2 and position() &lt; last()]">
          <xsl:choose>
            <xsl:when test="$type='normal'">
              <xsl:text>, let </xsl:text>
            </xsl:when> 
            <xsl:when test="$type='asTrial'">
              <xsl:text>, returning </xsl:text>
            </xsl:when>
          </xsl:choose>
          <xsl:apply-templates select=".">
            <xsl:with-param name="type" select="$type"/>
          </xsl:apply-templates>
        </xsl:for-each>
        <xsl:choose>
          <xsl:when test="$type='normal'">
            <xsl:text>, and let </xsl:text>
          </xsl:when> 
          <xsl:when test="$type='asTrial'">
            <xsl:text>, and returning </xsl:text>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="extsymresult[position() = last()]">
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates>
      </xsl:when>
    </xsl:choose>
    <xsl:if test="not($type='asTrial')">
      <xsl:text> returned from the application of those </xsl:text>
      <xsl:choose>
        <xsl:when test="$rules='SR'">
          <xsl:text>Syntax</xsl:text>
        </xsl:when>
        <xsl:when test="$rules='AR'">
          <xsl:text>Access</xsl:text>
        </xsl:when>
        <xsl:when test="$rules='GR'">
          <xsl:text>General</xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:text> Rules</xsl:text>
    </xsl:if>
  </xsl:if>
<!-- 16) AND WE ARE FINISHED -->
</xsl:template>

<!--
    Symbolic argument for invoking other subclauses in "other" documents
-->
<!-- The "part" argument is the 2-digit part number of the "other" doc.
     The "param" argument gives the name of the symbolic parameter.
     Generate a link to the symbolic parameter: subclause ID + _ + symbolic parameter name.
     The tricky bit is this: We need to check to see whether the target subclause has a symparam
     with the given name.
     If so, all is well.
     If not, however, we generate some obnoxious text for attention. -->
<xsl:template match="extsymarg">
  <xsl:variable name="param" select="@param"/>
  <xsl:variable name="subClauseID" select="ancestor::subClause[1]/@id"/>
  <xsl:variable name="ref" select="parent::applyExtSC/@ref"/>
  <xsl:variable name="partnum" select="parent::applyExtSC/@part"/>
  <xsl:variable name="standardnum">
    <xsl:choose>
      <xsl:when test="parent::applyExtSC/@standard">
        <xsl:value-of select="parent::applyExtSC/@standard"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$standardNumber"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@output"/>
  <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
  <xsl:choose>
    <xsl:when test="$extroot//*[@id=$ref]
                               [self::subClause | self::subClause2 |
                                self::subClause3 | self::subClause4]
                               [.//symparam/@name=$param]">
      <xsl:variable name="fullID" select="concat(@ref, '_', @param)"/>
      <xsl:variable name="linkref">
        <xsl:text>'</xsl:text>
        <xsl:value-of select="$fullID"/>
        <xsl:text>'</xsl:text>
      </xsl:variable>
      <xsl:apply-templates/>
      <xsl:text> as </xsl:text>
      <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$fullID}')"
                     show-destination="new" color="#000070">
        <fo:inline font-style="italic">
          <xsl:value-of select="$param"/>
        </fo:inline>
      </fo:basic-link>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">$filename = %s1. $param = %2, no corresponding symparam. $subClauseID = %s3</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$filename"/>
        <xsl:with-param name="ErrorValue2" select="$param"/>
        <xsl:with-param name="ErrorValue3" select="$subClauseID"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Result corresponding to the symbolic return from an invoke subclause
-->
<!-- The "param" argument gives the name of the symbolic parameter
     Generate a link to the symbolic parameter: subclause ID + _ + symbolic parameter name.
     The tricky bit is this: We need to check to see whether the target subclause has a symparam
     with the given name.
     If so, all is well.
     If not, however, we generate some obnoxious text for attention. -->
<xsl:template match="extsymresult">
  <xsl:param name="type"/>
  <xsl:variable name="param" select="@param"/>
  <xsl:variable name="ref" select="parent::applyExtSC/@ref"/>
  <xsl:variable name="partnum" select="parent::applyExtSC/@part"/>
  <xsl:variable name="standardnum">
    <xsl:choose>
      <xsl:when test="parent::applyExtSC/@standard">
        <xsl:value-of select="parent::applyExtSC/@standard"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$standardNumber"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="subClauseID" select="ancestor::subClause[1]/@id"/>
  <xsl:variable name="filename"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@output"/>
  <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
  <xsl:choose>
    <xsl:when test="$extroot//*[@id=$ref]
                               [self::subClause | self::subClause2 |
                                self::subClause3 | self::subClause4]
                               [.//symreturn/@name=$param]">
      <xsl:variable name="fullID" select="concat($ref, '_', $param)"/>
      <xsl:variable name="linkref">
        <xsl:text>'</xsl:text>
        <xsl:value-of select="$fullID"/>
        <xsl:text>'</xsl:text>
      </xsl:variable>
      <xsl:apply-templates/>
      <xsl:choose>
        <xsl:when test="$type='asTrial'">
          <xsl:text> as the </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text> be the </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$fullID}')"
                     show-destination="new" color="#000070">
        <fo:inline font-style="italic">
          <xsl:value-of select="$param"/>
        </fo:inline>
      </fo:basic-link>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">$filename = %s1 $param = %s2, no corresponding symreturn. $subClauseID = %s3.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$filename"/>
        <xsl:with-param name="ErrorValue2" select="$param"/>
        <xsl:with-param name="ErrorValue3" select="$subClauseID"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="extsymresult" mode="asTest-mode">
  <xsl:variable name="param" select="@param"/>
  <xsl:variable name="ref" select="parent::applyExtSC/@ref"/>
  <xsl:variable name="partnum" select="parent::applyExtSC/@part"/>
  <xsl:variable name="standardnum">
    <xsl:choose>
      <xsl:when test="parent::applyExtSC/@standard">
        <xsl:value-of select="parent::applyExtSC/@standard"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$standardNumber"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="subClauseID" select="ancestor::subClause[1]/@id"/>
  <xsl:variable name="filename"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@output"/>
  <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
  <xsl:choose>
    <xsl:when test="$extroot//*[@id=$ref]
                               [self::subClause | self::subClause2 |
                                self::subClause3 | self::subClause4]
                               [.//symreturn/@name=$param]">
      <xsl:variable name="fullID" select="concat($ref, '_', $param)"/>
      <xsl:variable name="linkref">
        <xsl:text>'</xsl:text>
        <xsl:value-of select="$fullID"/>
        <xsl:text>'</xsl:text>
      </xsl:variable>
      <xsl:text> is the </xsl:text>
      <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$fullID}')"
                     show-destination="new" color="#000070">
        <fo:inline font-style="italic">
          <xsl:value-of select="$param"/>
        </fo:inline>
      </fo:basic-link>
      <xsl:text> returned as </xsl:text>
      <xsl:apply-templates/>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">$filename = %s1 $param = %s2, no corresponding symreturn. $subClauseID = %s3</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$filename"/>
        <xsl:with-param name="ErrorValue2" select="$param"/>
        <xsl:with-param name="ErrorValue3" select="$subClauseID"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Generate table of conditions raised in the document being processed (conditionsTable)
-->
<xsl:template match="conditionsTable">
  <fo:table-and-caption keep-together.within-page="auto">
    <fo:table-caption keep-with-next.within-page="always">
      <xsl:variable name="ThisTable" select="."/>
      <xsl:variable name="tablenum">
        <xsl:choose>
          <xsl:when test="tableNumber">
            <xsl:value-of select="tableNumber"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="GetTableNumber">
              <xsl:with-param name="TheTable" select="$ThisTable"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <fo:block space-before.minimum="15pt" space-before.maximum="20pt"
                space-after.minimum="6pt" space-after.maximum="9pt"
                space-before.conditionality="retain" border-style="none"
                text-align="center" font-weight="{$head-weight}" id="'{@id}'">
        <!-- If the <conditions%able> element has an id= attribute, then it might possibly be
             referenced from another part with a <mergeWith> reference. -->
        <xsl:variable name="id" select="@id"/>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
        <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
          <xsl:with-param name="id" select="$id"/>
        </xsl:call-template>
        <xsl:text>Table </xsl:text>
        <xsl:value-of select="$tablenum"/>
        <xsl:text> &mdash; </xsl:text>
        <xsl:apply-templates select="tableTitle"/>
      </fo:block>
    </fo:table-caption>
    <!-- Center the table -->
    <fo:table width="100%" keep-with-next.within-page="always">
    <!-- The actual table content is put into the middle of three columns
         that have a variable width.
         This causes the table content to be centered on the page. -->
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell/>
<!-- This is the "real" conditions table that we're trying to display -->
          <fo:table-cell>
            <fo:table width="inherit" table-layout="fixed" border-collapse="separate"
                      border-color="black" border-style="solid" border-width="0.5pt"
                      space-before.minimum="10pt" space-before.maximum="10pt"
                      space-after.minimum="6pt" space-after.maximum="9pt"
                      space-before.conditionality="discard"
                      start-indent="0" end-indent="0">

              <fo:table-column column-number="1" column-width="0.8in"/>
              <fo:table-column column-number="2" column-width="2.2in"/>
              <fo:table-column column-number="3" column-width="0.6in"/>
              <fo:table-column column-number="4" column-width="2.2in"/>
              <fo:table-column column-number="5" column-width="0.8in"/>

<!-- The conditions table always has a header row -->   
              <fo:table-header keep-with-next.within-page="always" start-indent="0pt"
                               end-indent="0pt">
   
                <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                               padding="5pt" font-weight="bold" number-columns-spanned="1"
                               number-rows-spanned="1" text-align="left" relative-align="baseline">
                  <fo:block text-align="center">Category</fo:block>
                </fo:table-cell>
                <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                               padding="5pt" font-weight="bold" number-columns-spanned="1"
                               number-rows-spanned="1" text-align="left" relative-align="baseline">
                  <fo:block text-align="center">Condition</fo:block>
                </fo:table-cell>
                <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                               padding="5pt" font-weight="bold" number-columns-spanned="1"
                               number-rows-spanned="1" text-align="left" relative-align="baseline">
                  <fo:block text-align="center">Class</fo:block>
                </fo:table-cell>
                <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                               padding="5pt" font-weight="bold" number-columns-spanned="1"
                               number-rows-spanned="1" text-align="left" relative-align="baseline">
                  <fo:block text-align="center">Subcondition</fo:block>
                </fo:table-cell>
                <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                               padding="5pt" font-weight="bold" number-columns-spanned="1"
                               number-rows-spanned="1" text-align="left" relative-align="baseline">
                  <fo:block text-align="center">Subclass</fo:block>
                </fo:table-cell>
              </fo:table-header>
              <fo:table-body start-indent="0pt" end-indent="0pt">
<!-- If there is one or more conditionsFrom children, then collect text nodes containing
     ALL conditions in ALL such parts
     NOTE: This variable contains a character string containing a series of substrings
     that look like " raise(cc,sss) ", where "cc" is a class value and "sss" is
     either a provided subclass value or "000" if no subclass value is provided.
-->
                <xsl:variable name="importedRaises">
                  <xsl:for-each select="conditionsFrom">
                    <xsl:sort select="@part"/>
                    <xsl:variable name="importedPart" select="@part"/>
                    <xsl:variable name="filename"
                      select="$parts[@number=$standardNumber]/part[@number=$importedPart]/@input"/>
                    <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
                    <xsl:variable name="externalRaises"
                                  select="$extroot//raise[not(class | subclass)]"/>
                    <xsl:variable name="distinctExternalRaises"
                      select="distinct-values($externalRaises/concat(' raise(', 
                                                                     @class, ',', 
                                                                     @subclass, ') '))"/>
                    <xsl:value-of select="$distinctExternalRaises"/>
                  </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="localOnlyRaises"
                              select="distinct-values($allRaises
                                        [not(contains($importedRaises,
                                                      concat(' raise(', @class, ',', 
                                                             @subclass, ') ')))]/
                                        concat(' raise(', @class, ',', @subclass, ') '))"/>
                <xsl:variable name="localOnlyString">
                  <xsl:value-of select="$localOnlyRaises"/>
                </xsl:variable>
<!-- This is the "meat" of the conditions table - the code where it differs from
     all "ordinary" tables.
     This XSLT generates one row for each unique class code with the category, the class name,
     the class code, subclass name "(no subclass)", and subclass code "000".
     For that unique class code, this XSLT then generates one row for each unique subclass code
     containing three blank columns, the subclass name, and the subclass code.
     -->
                <xsl:for-each-group select="//standard//raise[contains($localOnlyString, 
                                                                        concat('raise(', @class))]"
                                    group-by="@class">
                  <xsl:sort select="fn:current-grouping-key()"/>
                  <xsl:variable name="classCode" select="fn:current-grouping-key()"/>
                  <xsl:variable name="classCategory"
                                select="$Conditions/class[@code=$classCode]/@category"/>
                  <xsl:variable name="classText"
                                select="$Conditions/class[@code=$classCode]/name"/>
                  <!-- output the "class row" -->
<!-- If this @class was imported from another standard with no @subclass,
     then DO NOT create a table row for the @class and no subclass ('000'),
     UNLESS there will be rows for the @class with actual @class values. 
-->
                  <xsl:if test="( not(contains($importedRaises, 
                                      concat(' raise(', @class, ',', @subclass, ') '))) and
                                  exists($Conditions/class[@code=$classCode]) ) or
                                ( contains($importedRaises, 
                                  concat(' raise(', @class, ',', @subclass, ') ')) and
                                  exists($Conditions/class[@code=$classCode]/subclass) )">
                    <fo:table-row keep-together.within-page="always">
                      <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                                     padding="5pt" number-columns-spanned="1" 
                                     number-rows-spanned="1"
                                     text-align="left" vertical-align="bottom">
                        <fo:block hyphenate="true" text-align="center">
                          <xsl:value-of select="$classCategory"/>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                                     padding="5pt" number-columns-spanned="1" 
                                     number-rows-spanned="1"
                                     text-align="left" vertical-align="bottom">
                        <fo:block hyphenate="true">
                          <fo:inline font-style="italic">
                            <xsl:value-of select="$classText"/>
                          </fo:inline>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                                     padding="5pt" number-columns-spanned="1" 
                                     number-rows-spanned="1"
                                     text-align="left" vertical-align="bottom">
                        <fo:block hyphenate="true" text-align="center">
                          <xsl:value-of select="$classCode"/>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                                     padding="5pt" number-columns-spanned="1" 
                                     number-rows-spanned="1"
                                     text-align="left" vertical-align="bottom">
                        <fo:block hyphenate="true">
                          <xsl:text>(</xsl:text>
                          <fo:inline font-style="italic">
                            <xsl:text>no subclass</xsl:text>
                          </fo:inline>
                          <xsl:text>)</xsl:text>
                        </fo:block>
                      </fo:table-cell>
                      <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                                     padding="5pt" number-columns-spanned="1" 
                                     number-rows-spanned="1"
                                     text-align="left" vertical-align="bottom">
                        <fo:block hyphenate="true" text-align="center">000</fo:block>
                      </fo:table-cell>
                    </fo:table-row>
                  </xsl:if>
<!-- ================================================================= -->
<!-- The following XSLT generates one row per subclass in "this" class -->
<!-- ================================================================= -->
                  <xsl:for-each-group select="current-group()[contains($localOnlyString, 
                                              concat('raise(', @class, ',', @subclass, ')'))]"
                                      group-by="@subclass">
                  <xsl:sort select="fn:current-grouping-key()"/>
                    <xsl:variable name="classCodeValue">
                      <xsl:value-of select="$classCode"/>
                    </xsl:variable>
                    <xsl:variable name="subclassCode" select="fn:current-grouping-key()"/>
                    <xsl:variable name="subclassText"
                                  select="$Conditions/class[@code=$classCodeValue]/
                                                              subclass[@code=$subclassCode]/name"/>
<!-- If this combination of @class and @subclass was impoarted from another standard,
     then DO NOT create a table row for the combination.
-->
                    <xsl:if test="not(contains($importedRaises, 
                       concat(' raise(', @class, ',', @subclass, ') '))) and
                       exists($Conditions/class[@code=$classCode]/subclass[@code=$subclassCode])">

                      <fo:table-row keep-together.within-page="always">
                        <fo:table-cell border-color="black" border-style="solid"
                                       border-width="0.5pt"
                                       padding="5pt" number-columns-spanned="1" 
                                       number-rows-spanned="1"
                                         text-align="left" vertical-align="bottom">
                          <fo:block hyphenate="true"/>
                        </fo:table-cell>
                        <fo:table-cell border-color="black" border-style="solid"
                                       border-width="0.5pt"
                                       padding="5pt" number-columns-spanned="1" 
                                       number-rows-spanned="1"
                                       text-align="left" vertical-align="bottom">
                          <fo:block hyphenate="true"/>
                        </fo:table-cell>
                        <fo:table-cell border-color="black" border-style="solid"
                                       border-width="0.5pt"
                                       padding="5pt" number-columns-spanned="1" 
                                       number-rows-spanned="1"
                                       text-align="left" vertical-align="bottom">
                          <fo:block hyphenate="true"/>
                        </fo:table-cell>
                        <fo:table-cell border-color="black" border-style="solid"
                                       border-width="0.5pt"
                                       padding="5pt" number-columns-spanned="1" 
                                       number-rows-spanned="1"
                                       text-align="left" vertical-align="bottom">
                          <fo:block hyphenate="true">
                            <fo:inline font-style="italic">
                              <xsl:value-of select="$subclassText"/>
                            </fo:inline>
                          </fo:block>
                        </fo:table-cell>
                        <fo:table-cell border-color="black" border-style="solid" 
                                       border-width="0.5pt"
                                       padding="5pt" number-columns-spanned="1" 
                                       number-rows-spanned="1"
                                       text-align="left" vertical-align="bottom">
                          <fo:block hyphenate="true" text-align="center">
                            <xsl:value-of select="$subclassCode"/>
                          </fo:block>
                        </fo:table-cell>
                      </fo:table-row>
                    </xsl:if>
                  </xsl:for-each-group>
                </xsl:for-each-group>
              </fo:table-body>
            </fo:table>
          </fo:table-cell>
          <fo:table-cell/>
        </fo:table-row>
      </fo:table-body>
    </fo:table> 
  </fo:table-and-caption>
</xsl:template>

<!--
    The "Ada library unit package also defines the condition codes,
    but in an Ada syntax.  Instead of marking everything up by hand,
    this part of the package should be automatically generated.
-->
<xsl:template match="adaPackageConditions">
<!-- Rough description: Find all of the conditions -->
  <xsl:variable name="importedRaises">
    <xsl:for-each select="/standard//conditionsTable/conditionsFrom">
      <xsl:sort select="@part"/>
      <xsl:variable name="importedPart" select="@part"/>
      <xsl:variable name="filename"
                    select="$parts[@number=$standardNumber]/part[@number=$importedPart]/@input"/>
      <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
      <xsl:variable name="externalRaises" select="$extroot//raise[not(class | subclass)]"/>
      <xsl:variable name="distinctExternalRaises"
                    select="distinct-values($externalRaises/concat(' raise(', 
                                                                   @class, ',', 
                                                                   @subclass, ') '))"/>
      <xsl:value-of select="$distinctExternalRaises"/>
    </xsl:for-each>
  </xsl:variable>
  <xsl:variable name="localOnlyRaises"
                select="distinct-values($allRaises
                          [not(contains($importedRaises,
                                          concat(' raise(', @class, ',', @subclass, ') ')))]/
                                          concat(' raise(', @class, ',', @subclass, ') '))"/>
  <xsl:variable name="localOnlyString">
    <xsl:value-of select="$localOnlyRaises"/>
  </xsl:variable>

  <xsl:for-each-group select="//standard//raise[contains($localOnlyString,
                                                            concat('raise(', @class))]"
                      group-by="@class">
    <xsl:sort select="fn:current-grouping-key()"/>
    <xsl:variable name="classCode" select="fn:current-grouping-key()"/>
    <xsl:variable name="classCategory"
                  select="$Conditions/class[@code=$classCode]/@category"/>
    <xsl:variable name="classText"
                  select="$Conditions/class[@code=$classCode]/name"/>
                  <!-- output the "class row" -->
<!-- If this @class was imported from another standard with no @subclass,
     then DO NOT create a constant for the @class and no subclass ('000'),
     UNLESS there will be rows for the @class with actual @class values. 
-->
    <xsl:if test="( not(contains($importedRaises,
                                 concat(' raise(', @class, ',', @subclass, ') '))) and
                    exists($Conditions/class[@code=$classCode]) ) or
                  ( contains($importedRaises, concat(' raise(', @class, ',', @subclass, ') ')) and
                    exists($Conditions/class[@code=$classCode]/subclass) )">
<!-- Generate the "no subclass" lines -->
<!-- NOTE: DO NOT add any indents or change any spaces in the following lines -->
<!-- LINE LENGTH CHECK OFF -->
<xsl:text>    </xsl:text><xsl:value-of select="replace(replace(replace(replace(concat(upper-case($classText),
                                                              '_NO_SUBCLASS'), ' ', '_'), '-', '_'), '/', '_'), ',', '')"/><xsl:text>:
</xsl:text>
<fo:inline font-weight="bold"><xsl:text>      constant </xsl:text></fo:inline><xsl:text>SQLSTATE_TYPE := "</xsl:text><xsl:value-of select="$classCode"/>000<xsl:text>";
</xsl:text>
<!-- LINE LENGTH CHECK ON -->
<!-- NOTE: DO NOT add any indents or change any spaces in the preceding lines -->
    </xsl:if>

<!-- ================================================================= -->
<!-- The following XSLT generates one row per subclass in "this" class -->
<!-- ================================================================= -->
    <xsl:for-each-group select="current-group()[contains($localOnlyString,
                                                         concat('raise(', @class, ',', @subclass, 
                                                                ')'))]"
                        group-by="@subclass">
      <xsl:sort select="fn:current-grouping-key()"/>
      <xsl:variable name="classCodeValue">
        <xsl:value-of select="$classCode"/>
      </xsl:variable>
      <xsl:variable name="subclassCode" select="fn:current-grouping-key()"/>
      <xsl:variable name="subclassText"
                    select="$Conditions/class[@code=$classCodeValue]/
                                        subclass[@code=$subclassCode]/name"/>
<!-- If this combination of @class and @subclass was imported from another standard,
     then DO NOT create a table row for the combination.
-->
      <xsl:if test="not(contains($importedRaises,
                                 concat(' raise(', @class, ',', @subclass, ') '))) and
                    exists($Conditions/class[@code=$classCode]/subclass[@code=$subclassCode])">

<!-- Now, construct each condition/subcondition combination for "this" condition,
     doing so in SQL standard Ada symtax -->
<!-- Here is an example of the output:
    AMBIGUOUS_CURSOR_NAME_NO_SUBCLASS:
      <bold>constant</bold> SQLSTATE_TYPE :="3C000";
     In that example, "AMBIGUOUS_CURSOR_NAME" is derived from the class name
     associated with class code "3C" by replacing spaces with underscores
     and forcing everything to upper case.  Similarly, "NO_SUBCLASS" is
     derived from the subclass name associated with subclass code "000"
     using the same algorithm. The two parts are concatenated together with
     a single underscore separating them. 
-->
<!-- NOTE: DO NOT add any indents or change any spaces in the following lines -->
<!-- LINE LENGTH CHECK OFF -->
<xsl:text>    </xsl:text><xsl:value-of select="replace(replace(replace(replace(concat(upper-case($classText),
                                                              '_',
                                                              upper-case($subclassText)), ' ', '_'), '-', '_'), '/', '_'), ',', '')"/><xsl:text>:
</xsl:text>
<fo:inline font-weight="bold"><xsl:text>      constant </xsl:text></fo:inline><xsl:text>SQLSTATE_TYPE := "</xsl:text><xsl:value-of select="$classCode"/><xsl:value-of select="$subclassCode"/><xsl:text>";
</xsl:text>
<!-- LINE LENGTH CHECK ON -->
<!-- NOTE: DO NOT add any indents or change any spaces in the preceding lines -->
      </xsl:if>
    </xsl:for-each-group>
  </xsl:for-each-group>
</xsl:template>

<!--
    Generate table of optional features in the document being processed (featuresTable)
-->
<xsl:template match="featuresTable">
  <fo:table-and-caption keep-together.within-page="auto">
    <fo:table-caption keep-with-next.within-page="always">
      <xsl:variable name="ThisTable" select="."/>
      <xsl:variable name="tablenum">
        <xsl:choose>
          <xsl:when test="tableNumber">
            <xsl:value-of select="tableNumber"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="GetTableNumber">
              <xsl:with-param name="TheTable" select="$ThisTable"/>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <fo:block space-before.minimum="15pt" space-before.maximum="20pt"
                space-after.minimum="6pt" space-after.maximum="9pt"
                space-before.conditionality="retain" border-style="none"
                text-align="center" font-weight="{$head-weight}" id="'{@id}'">
        <!-- If the <featuresTable> element has an id= attribute, then it might possibly be
             referenced from another part with a <mergeWith> reference. -->
        <xsl:variable name="id" select="@id"/>
<!-- Generate the "little red box" signifying that this element is referenced by a mergeWith -->
        <xsl:call-template name="GenerateLittleRedBoxForMergeWith">
          <xsl:with-param name="id" select="$id"/>
        </xsl:call-template>
        <xsl:text>Table </xsl:text>
        <xsl:value-of select="$tablenum"/>
        <xsl:text> &mdash; </xsl:text>
        <xsl:apply-templates select="tableTitle"/>
      </fo:block>
    </fo:table-caption>
    <!-- Center the table -->
    <fo:table width="100%">
    <!-- The actual table content is put into the middle of three columns
         that have a variable width.
         This causes the table content to be centered on the page. -->
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-column/>
      <fo:table-column column-width="proportional-column-width(1)"/>
      <fo:table-body>
        <fo:table-row>
          <fo:table-cell/>
<!-- This is the "real" features table that we're trying to display -->
          <fo:table-cell>
            <fo:table width="inherit" table-layout="fixed" border-collapse="separate"
                      border-color="black" border-style="solid" border-width="0.5pt"
                      space-before.minimum="10pt" space-before.maximum="10pt"
                      space-after.minimum="6pt" space-after.maximum="9pt"
                      space-before.conditionality="discard"
                      start-indent="0" end-indent="0">
              <fo:table-column column-number="1" column-width="0.4in"/>
              <fo:table-column column-number="2" column-width="1.0in"/>
              <fo:table-column column-number="3" column-width="5.1in"/>

<!-- The features table always has a header row -->   
              <fo:table-header keep-with-next.within-page="always" start-indent="0pt"
                               end-indent="0pt">
   
                <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                               padding="5pt" font-weight="bold" number-columns-spanned="1"
                               number-rows-spanned="1" text-align="left" relative-align="baseline">
                  <fo:block text-align="center"></fo:block>
                </fo:table-cell>
                <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                               padding="5pt" font-weight="bold" number-columns-spanned="1"
                               number-rows-spanned="1" text-align="left" relative-align="baseline">
                  <fo:block text-align="center">Feature ID</fo:block>
                </fo:table-cell>
                <fo:table-cell border-color="black" border-style="solid" border-width="0.5pt"
                               padding="5pt" font-weight="bold" number-columns-spanned="1"
                               number-rows-spanned="1" text-align="left" relative-align="baseline">
                  <fo:block text-align="center">Feature Name</fo:block>
                </fo:table-cell>

              </fo:table-header>

              <fo:table-body start-indent="0pt" end-indent="0pt">
<!-- This is the "meat" of the features table - the code where it differs from
     all "ordinary" tables.
     This XSLT generates one row for each unique feature code with the feature name and
     the feature code.
-->
                <xsl:variable name="mandFeatures">
                  <xsl:value-of select="$Features/feature[child::usedIn[@mand='yes' and 
                                                          @standard=$standardNumber]]/@code"/>
                </xsl:variable>
                <xsl:for-each-group
                   select="//standard/standardPartBody//
                      feature[not(matches($mandFeatures, concat('.*', string(@code), '.*')))] |
                           //standard//annex[@normative='normative']//
                      feature[not(matches($mandFeatures, concat('.*', string(@code), '.*')))]"
                    group-by="@code">
                  <xsl:sort select="fn:current-grouping-key()"/>
                  <xsl:variable name="featureCode" select="fn:current-grouping-key()"/>
                  <xsl:variable name="featureText">
                    <xsl:apply-templates
                      select="$Features/feature[@code=$featureCode]/name"/>
                  </xsl:variable>
                  <fo:table-row keep-together.within-page="always">
                    <fo:table-cell border-color="black" border-style="solid"
                                   border-width="0.5pt"
                                   padding="5pt" font-weight="bold"
                                   number-columns-spanned="1" number-rows-spanned="1"
                                   text-align="left" vertical-align="bottom">
                      <fo:block hyphenate="true">
                        <xsl:value-of select="position()"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-color="black" border-style="solid"
                                   border-width="0.5pt"
                                   padding="5pt" font-weight="bold"
                                   number-columns-spanned="1" number-rows-spanned="1"
                                   text-align="left" vertical-align="bottom">
                      <fo:block hyphenate="true">
                        <xsl:value-of select="$featureCode"/>
                      </fo:block>
                    </fo:table-cell>
                    <fo:table-cell border-color="black" border-style="solid" 
                                   border-width="0.5pt"
                                   padding="5pt" font-weight="bold"
                                   number-columns-spanned="1" number-rows-spanned="1"
                                   text-align="left" vertical-align="bottom">
                      <fo:block hyphenate="true">
                        <xsl:value-of select="$featureText"/>
                      </fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </xsl:for-each-group>
              </fo:table-body>
            </fo:table>
          </fo:table-cell>
          <fo:table-cell/>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </fo:table-and-caption>
</xsl:template>



<!-- =================================================================================== -->
<!-- Templates related the Technical Corrigenda                                          -->
<!-- =================================================================================== -->


<!--
    A tc element contains nothing but specified child elements; handle them
-->
<xsl:template match="tc">
  <fo:block space-before="16pt">
    <fo:list-block provisional-distance-between-starts="20pt"
                   provisional-label-separation="6pt">
      <fo:list-item>
        <fo:list-item-label end-indent="label-end()">
          <fo:block text-align="start" text-align-last="start">
            <xsl:value-of select="count(preceding-sibling::*[name()='tc'])+1"/>
            <xsl:text>.</xsl:text>
          </fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()">
          <fo:block text-align="left" keep-together.within-page="always">
          <!-- NOTE: The following list is not robust; it would be more robust to apply templates 
                     for "everything except tcBody".
                     Do this when needed. -->
            <xsl:apply-templates select="tcRationale"/>
            <xsl:apply-templates select="tcSource"/>
            <xsl:apply-templates select="tcInstruction"/>
          </fo:block>
          <fo:block text-align="left">
            <xsl:apply-templates select="tcBody"/>
          </fo:block>
        </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </fo:block>
</xsl:template>

<!--
    A tcRationale element contains (possibly formatted) text
-->
<xsl:template match="tcRationale">
  <fo:block font-style="italic" space-before="9pt">
    <fo:list-block provisional-distance-between-starts="42pt"
                   provisional-label-separation="6pt">
      <fo:list-item>
        <fo:list-item-label end-indent="label-end()">
          <fo:block text-align="start" text-align-last="start">
            <xsl:text>Rationale: </xsl:text>
          </fo:block>
        </fo:list-item-label>
        <fo:list-item-body start-indent="body-start()">
          <fo:block text-align="left">
            <xsl:apply-templates/>
          </fo:block>
        </fo:list-item-body>
      </fo:list-item>
    </fo:list-block>
  </fo:block>
</xsl:template>

<!-- 
    A tcSource element contains one or more of three alternative children
    The tcSource template only generates output if the formalStage is '20' (i.e.WDCOR)
--> 
<xsl:template match="tcSource">
  <xsl:if test="substring-after($formalStage, '-')='20'">
    <fo:block font-style="italic" space-before="6pt">
      <fo:list-block provisional-distance-between-starts="42pt"
                     provisional-label-separation="6pt">
        <fo:list-item>
          <fo:list-item-label end-indent="label-end()">
            <fo:block text-align="start" text-align-last="start">
              <xsl:text>Source: </xsl:text>
            </fo:block>
          </fo:list-item-label>
          <fo:list-item-body start-indent="body-start()">
            <fo:block text-align="left">
              <xsl:for-each select="*">
                <xsl:apply-templates select="."/>
                <xsl:if test="position() != last()">
                  <xsl:text>, </xsl:text>
                </xsl:if>
              </xsl:for-each>
            </fo:block>
          </fo:list-item-body>
        </fo:list-item>
      </fo:list-block>
    </fo:block>
  </xsl:if>
</xsl:template>

<!--
    A paperNumber is merely plain, unformatted text
-->
<xsl:template match="paperNumber">
  <xsl:apply-templates/>
</xsl:template>

<!--
    A ballotComment is merely plain, unformatted text
-->
<xsl:template match="ballotComment">
  <xsl:apply-templates/>
</xsl:template>

<!--
    An emailMessage is merely plain, unformatted text
-->
<xsl:template match="emailMessage">
  <xsl:text>Email from: </xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<!--
    An editorialChange is merely plain, unformatted text
-->
<xsl:template match="editorialChange">
  <xsl:text>Editorial Change</xsl:text>
  <xsl:if test="string-length() != 0">
    <xsl:text>: </xsl:text>
    <xsl:apply-templates/>
  </xsl:if>
</xsl:template>

<!--
    A tcInstruction is (possible formatted) text
-->
<xsl:template match="tcInstruction">
  <fo:block space-before="12pt">
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>

<!--
    A tcBody may have complex content
-->
<xsl:template match="tcBody">
  <fo:block space-before="12pt">
    <xsl:if test="..//SCsignature">
      <xsl:for-each select="..//SCsignature">
        <xsl:call-template name="SubClauseSignature">
          <xsl:with-param name="rules" select="@rules"/>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:if>
    <xsl:apply-templates/>
  </fo:block>
</xsl:template>



<!-- =================================================================================== -->
<!-- Templates used for the Editors Notes                                                -->
<!-- =================================================================================== -->


<!--
    Process the EditorNotes element
-->
<xsl:template match="EditorNotes">
  <!-- ...but only if we're not producing a ballot document! -->
  <xsl:if test="substring-after($formalStage, '-')='20'">
    <!-- The EditorNotes get a page sequence all their own -->
    <fo:page-sequence master-reference="editor-notes-sequence"
                      initial-page-number="1" format="1">
      <!-- Of course, the editor notes pages have to have a page number -->
      <xsl:call-template name="standard-static-contents">
        <xsl:with-param name="page-kind">editor-notes</xsl:with-param>
        <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
      </xsl:call-template>
      <fo:flow flow-name="xsl-region-body"
               text-align="justify">
        <!-- The editor notes first page has a header and some introductory text -->
        <fo:block font-weight="bold" font-size="36pt" text-align="center" id="EditorNotesBlock">
          <fo:marker marker-class-name="PPLOtype">
            <fo:wrapper font-weight="bold">
              <xsl:text>Introduction</xsl:text>
            </fo:wrapper>
          </fo:marker>
          <xsl:text>Editor&rsquo;s Notes</xsl:text>
        </fo:block>
        <fo:block font-size="10pt" text-align="left" space-before="18pt">
          <xsl:text>Some possible problem and language opportunities have been observed </xsl:text>
          <xsl:text>with the specifications contained in this document. </xsl:text>
          <xsl:text>Further contributions to this list are welcome. </xsl:text>
          <xsl:text>Deletions from the list (resulting from change proposals that </xsl:text>
          <xsl:text>correct the problems or from research indicating that the problems </xsl:text>
          <xsl:text>do not, in fact, exist) are even more welcome. </xsl:text>
        </fo:block>
        <fo:block font-size="10pt" text-align="left" space-before="12pt">
          <xsl:text>Because of the dynamic nature of this list (problems being removed </xsl:text>
          <xsl:text>because they are solved, new problems being added), each problem or </xsl:text>
          <xsl:text>opportunity has been assigned a "fixed" number. </xsl:text>
          <xsl:text>These numbers do not change from draft to draft. </xsl:text>
        </fo:block>
        <!-- If there are any major technical PPs, output them, starting a new page -->        
        <fo:block break-before="page"/>
        <xsl:if test="PP[@severity='major' and @realm='technical']">
          <fo:block text-align="center" font-weight="bold" font-size="24pt" space-after="12pt">
            <fo:inline text-decoration="underline">
              <xsl:text>Possible Problems: Major Technical</xsl:text>
            </fo:inline>
          </fo:block>
        </xsl:if>
        <xsl:apply-templates select="PP[@severity='major' and @realm='technical']">
          <xsl:sort select="@number"/>
        </xsl:apply-templates>
        <!-- If there are any minor technical PPs, output them, starting a new page -->        
        <fo:block break-before="page"/>
        <xsl:if test="PP[@severity='minor' and @realm='technical']">
          <fo:block text-align="center" font-weight="bold" font-size="24pt" space-after="12pt">
            <fo:inline text-decoration="underline">
              <xsl:text>Possible Problems: Minor Technical</xsl:text>
            </fo:inline>
          </fo:block>
        </xsl:if>
        <xsl:apply-templates select="PP[@severity='minor' and @realm='technical']">
          <xsl:sort select="@number"/>
        </xsl:apply-templates>
        <!-- If there are any major editorial PPs, output them, starting a new page -->        
        <fo:block break-before="page"/>
          <xsl:if test="PP[@severity='major' and @realm='editorial']">
            <fo:block text-align="center" font-weight="bold" font-size="24pt" space-after="12pt">
              <fo:inline text-decoration="underline">
                <xsl:text>Possible Problems: Major Editorial</xsl:text>
              </fo:inline>
            </fo:block>
          </xsl:if>
          <xsl:apply-templates select="PP[@severity='major' and @realm='editorial']">
            <xsl:sort select="@number"/>
          </xsl:apply-templates>
          <!-- If there are any minor editorial PPs, output them, starting a new page -->        
          <fo:block break-before="page"/>
            <xsl:if test="PP[@severity='minor' and @realm='editorial']">
              <fo:block text-align="center" font-weight="bold" font-size="24pt"
                        space-after="12pt">
                <fo:inline text-decoration="underline">
                  <xsl:text>Possible Problems: Minor Editorial</xsl:text>
                </fo:inline>
          </fo:block>
        </xsl:if>
        <xsl:apply-templates select="PP[@severity='minor' and @realm='editorial']">
          <xsl:sort select="@number"/>
        </xsl:apply-templates>
        <!-- If there are any Language Opportunities, output them on a new page -->        
        <fo:block break-before="page"/>
        <xsl:if test="LO">
          <fo:block text-align="center" font-weight="bold" font-size="24pt" space-after="12pt">
            <fo:inline text-decoration="underline">
              <xsl:text>Language Opportunities</xsl:text>
            </fo:inline>
          </fo:block>
        </xsl:if>
        <xsl:apply-templates select="LO">
          <xsl:sort select="@number"/>
        </xsl:apply-templates>
      </fo:flow>
    </fo:page-sequence>
  </xsl:if>
</xsl:template>


<!--
    Process the PP element
-->
<xsl:template match="PP">
  <!-- Set up the marker that will be used for page headers and footers -->
  <fo:block>
    <fo:marker marker-class-name="PPLOtype">
      <fo:wrapper font-weight="bold">
        <xsl:text>Possible Problems</xsl:text>
      </fo:wrapper>
    </fo:marker>
    <!-- Identify the Possible Problem, including the PP number in a box -->
    <fo:block space-before="16pt" id="'{@id}'">
      <fo:inline border-style="solid" border-color="black"
                 border-width="0.4pt" padding-before="2pt" padding-after="0.9pt"
                 padding-start="1.8pt" padding-end="1.8pt">
        <xsl:value-of select="@number"/>
      </fo:inline>
      <xsl:text> The following Possible Problem has been noted:</xsl:text>
    </fo:block>
    <!-- Print the severity and the realm of the PP -->
    <fo:block margin-left="16pt" space-before="6pt">
      <fo:inline font-weight="bold">
        <xsl:text>Severity: </xsl:text>
      </fo:inline>
      <xsl:value-of select="@severity"/>
      <xsl:text> </xsl:text>
      <xsl:value-of select="@realm"/>
    </fo:block>
    <!-- Print the reference of the place in the document that has the PP -->
    <fo:block margin-left="16pt" space-before="6pt">
      <fo:inline font-weight="bold">
        <xsl:text>Reference: </xsl:text>
      </fo:inline>
      <xsl:apply-templates select="reference"/>
    </fo:block>
    <!-- Specify where a note in the document references the PP, or else "None". -->
    <fo:block margin-left="16pt" space-before="6pt">
      <fo:inline font-weight="bold">
        <xsl:text>Note At: </xsl:text>
      </fo:inline>
      <xsl:choose>
        <xsl:when test="noteAt">
          <xsl:apply-templates select="noteAt"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>None. </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block>
    <!-- Identify the source of the PP (often a numbered paper) -->
    <fo:block margin-left="16pt" space-before="6pt">
      <fo:inline font-weight="bold">
        <xsl:text>Source: </xsl:text>
      </fo:inline>
      <xsl:apply-templates select="source"/>
    </fo:block>
    <!-- Print the text of the problem itself -->
    <fo:block margin-left="16pt" space-before="6pt">
      <fo:inline font-weight="bold">
        <xsl:text>Possible Problem: </xsl:text>
      </fo:inline>
      <fo:block margin-left="9pt">
        <xsl:apply-templates select="problem"/>
      </fo:block>
    </fo:block>
    <!-- If a solution was offered with the PP, print it; otherwise say so -->
    <fo:block margin-left="16pt" space-before="6pt">
      <fo:inline font-weight="bold">
        <xsl:text>Solution: </xsl:text>
      </fo:inline>
      <fo:block margin-left="9pt">
        <xsl:choose>
          <xsl:when test="solution">
            <xsl:apply-templates select="solution"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>None provided with comment. </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:block>
  </fo:block>
</xsl:template>


<!--
    Process the LO element
-->
<xsl:template match="LO">
  <xsl:variable name="loColor">
    <xsl:choose>
      <xsl:when test="@status = 'deferred'">#D0D0D0</xsl:when>
      <xsl:otherwise>black</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:wrapper color="{$loColor}">
    <fo:block>
      <!-- Set up the marker that will be used for page headers and footers -->
      <fo:marker marker-class-name="PPLOtype">
        <fo:wrapper font-weight="bold">
          <xsl:text>Language Opportunities</xsl:text>
        </fo:wrapper>
      </fo:marker>
      <!-- Identify the Language Opportunity, including the LO number in a box -->
      <fo:block space-before="16pt" id="'{@id}'">
        <fo:inline border-style="solid" border-color="{$loColor}"
                   border-width="0.4pt" padding-before="2pt" padding-after="0.9pt"
                   padding-start="1.8pt" padding-end="1.8pt">
          <xsl:value-of select="@number"/>
        </fo:inline>
        <xsl:text> The following Language Opportunity has been noted:</xsl:text>
      </fo:block>
      <!-- Document that this is a Language Opportunity -->
      <fo:block margin-left="16pt" space-before="6pt">
        <fo:inline font-weight="bold">
          <xsl:text>Severity: </xsl:text>
        </fo:inline>
        <xsl:text>Language Opportunity</xsl:text>
        <xsl:if test="@status = 'deferred'"><xsl:text> (deferred)</xsl:text></xsl:if>
      </fo:block>
      <!-- Identify the place in the document to which the LO applies -->
      <fo:block margin-left="16pt" space-before="6pt">
        <fo:inline font-weight="bold">
          <xsl:text>Reference: </xsl:text>
        </fo:inline>
        <xsl:apply-templates select="reference"/>
      </fo:block>
      <!-- Specify where a note in the document references the LO, or else "None". -->
      <fo:block margin-left="16pt" space-before="6pt">
        <fo:inline font-weight="bold">
          <xsl:text>Note At: </xsl:text>
        </fo:inline>
        <xsl:choose>
          <xsl:when test="noteAt">
            <xsl:apply-templates select="noteAt"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:text>None. </xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
      <!-- Identify the source of the LO (often a numbered paper) -->
      <fo:block margin-left="16pt" space-before="6pt">
        <fo:inline font-weight="bold">
          <xsl:text>Source: </xsl:text>
        </fo:inline>
        <xsl:apply-templates select="source"/>
      </fo:block>
      <!-- Print since attribute, if present -->
      <xsl:if test="boolean(since)">
        <fo:block margin-left="16pt" space-before="6pt">
          <fo:inline font-weight="bold">
            <xsl:text>Since: </xsl:text>
          </fo:inline>
          <xsl:apply-templates select="since"/>
        </fo:block>        
      </xsl:if>
      <!-- Print the text of the opportunity itself -->
      <fo:block margin-left="16pt" space-before="6pt">
        <fo:inline font-weight="bold">
          <xsl:text>Language Opportunity: </xsl:text>
        </fo:inline>
        <fo:block margin-left="9pt">
          <xsl:apply-templates select="problem"/>
        </fo:block>
      </fo:block>
      <!-- If a solution was offered with the LO, print it; otherwise say so -->
      <fo:block margin-left="16pt" space-before="6pt">
        <fo:inline font-weight="bold">
          <xsl:text>Solution: </xsl:text>
        </fo:inline>
        <fo:block margin-left="9pt">
          <xsl:choose>
            <xsl:when test="solution">
              <xsl:apply-templates select="solution"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>None provided with comment. </xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:block>
    </fo:block>
  </fo:wrapper>
</xsl:template>


<!-- =================================================================================== -->
<!-- Templates related to comments and changebars                                        -->
<!-- =================================================================================== -->


<!--
    Process the comment element (do nothing)                       
-->
<xsl:template match="comment">
</xsl:template>

<!--
    Process the bar (start changebar) element                       
    Transform to fo:change-bar-begin
-->
<xsl:template match="bar">
<!--
    If this is not a ballot document, changebars are permitted.
    If this is a ballot document, then changebars are omitted. 
-->
  <xsl:if test="substring-after($formalStage, '-')='20'">
    <xsl:variable name="depth" select="count(preceding::bar)-count(preceding::endbar)"/>
    <xsl:variable name="offset"
                  select="24+4*(count(preceding::bar)-count(preceding::endbar))"/>
    <xsl:variable name="colour">
      <xsl:choose>
        <xsl:when test="@colour">
          <xsl:value-of select="@colour"/>
        </xsl:when>
        <xsl:otherwise>
          red
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable name="style">
      <xsl:choose>
        <xsl:when test="@style">
          <xsl:value-of select="@style"/>
        </xsl:when>
        <xsl:otherwise>
          solid
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:change-bar-begin change-bar-class="CB{$depth}" change-bar-color="{$colour}"
                         change-bar-placement="start"
                         change-bar-offset="{$offset}pt"
                         change-bar-style="{$style}"/>
    <xsl:if test="@note">
<!-- The note attribute of the bar outputs a block of text.  In certain locations,
     (e.g., within lists and tables), this causes that text to appear in the wrong
      place (specifically, at the top of the list or table).  The following code
      causes the text to appear in a much more appropriate location. -->
      <xsl:choose>
<!-- Makes the bar note text appear in the intended location within a list -->
        <xsl:when test="parent::slist | parent::ulist | parent::blist | parent::dlist |
                        parent::olist | parent::nlist | parent::alist | parent::rlist |
                        parent::Alist | parent::Rlist | parent::lbllist">
          <fo:list-item>
            <fo:list-item-label end-indent="0.01in"><xsl:text> </xsl:text></fo:list-item-label>
            <fo:list-item-body start-indent="0.02in">
              <fo:block space-before="3pt" space-after="3pt" color="{$colour}"
                        font-family="{$font-name}">
                <xsl:text>&laquo; </xsl:text>
                <xsl:value-of select="@note"/>
                <xsl:text> &raquo;</xsl:text>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </xsl:when>
<!-- Makes the bar note text appear in the intended location within a table -->
        <xsl:when test="parent::table-body | parent::table-heads | parent::table-head-row">
          <xsl:variable name="requiredSpan"
                        select="ancestor::table[1]//table-common/table-setup/@numcols"/>
          <fo:table-row>
            <fo:table-cell number-columns-spanned="{$requiredSpan}"> 
             <fo:block space-before="3pt" space-after="3pt" color="{$colour}">
                <xsl:text>&laquo; </xsl:text>
                <xsl:value-of select="@note"/>
                <xsl:text> &raquo;</xsl:text>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:when>
<!-- Makes the bar note text appear in the intended location within a table row.  Sort of. -->
<!-- The following WHEN is a real hack and will result in a table row with too many columns -->
        <xsl:when test="parent::table-row">
          <fo:table-cell> 
            <fo:block space-before="3pt" space-after="3pt" color="{$colour}">
              <xsl:text>&laquo; </xsl:text>
              <xsl:value-of select="@note"/>
              <xsl:text> &raquo;</xsl:text>
            </fo:block>
          </fo:table-cell>
        </xsl:when>
<!-- For all non-list and non-table situations, just output the appropriate block -->
        <xsl:otherwise>
          <fo:block space-before="3pt" space-after="3pt" color="{$colour}">
            <xsl:text>&laquo; </xsl:text>
            <xsl:value-of select="@note"/>
            <xsl:text> &raquo;</xsl:text>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
<!--
      <fo:block space-before="3pt" space-after="3pt" color="green">
        <xsl:text>&laquo; </xsl:text>
        <xsl:value-of select="@note"/>
        <xsl:text> &raquo;</xsl:text>
      </fo:block>
-->
    </xsl:if>
  </xsl:if>
</xsl:template>

<!--
    Process the endbar terminate changebar) element 
    Transform to fo:change-bar-end 
-->
<xsl:template match="endbar">
<!--
    If this is not a ballot document, changebars are permitted.
    If this is a ballot document, then changebars are omitted.
-->
  <xsl:if test="substring-after($formalStage, '-')='20'">
    <xsl:variable name="depth" select="count(preceding::bar)-count(preceding::endbar)-1"/>
    <xsl:if test="@note">

<!-- The note attribute of the delbar outputs a block of text.  In certain locations,
     (e.g., within lists and tables), this causes that text to appear in the wrong
      place (specifically, at the top of the list or table).  The following code
      causes the text to appear in a much more appropriate location. -->
      <xsl:choose>
<!-- Makes the endbar note text appear in the intended location within a list -->
        <xsl:when test="parent::slist | parent::ulist | parent::blist | parent::dlist |
                        parent::olist | parent::nlist | parent::alist | parent::rlist |
                        parent::Alist | parent::Rlist | parent::lbllist">
          <fo:list-item>
            <fo:list-item-label end-indent="0.01in"><xsl:text> </xsl:text></fo:list-item-label>
            <fo:list-item-body start-indent="0.02in">
              <fo:block space-before="3pt" space-after="3pt" color="green">
                <xsl:text>&laquo; </xsl:text>
                <xsl:value-of select="@note"/>
                <xsl:text> &raquo;</xsl:text>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </xsl:when>
<!-- Makes the endbar note text appear in the intended location within a table -->
        <xsl:when test="parent::table-body | parent::table-heads | parent::table-head-row">
          <xsl:variable name="requiredSpan"
                        select="ancestor::table[1]//table-common/table-setup/@numcols"/>
          <fo:table-row>
            <fo:table-cell number-columns-spanned="{$requiredSpan}"> 
             <fo:block space-before="3pt" space-after="3pt" color="green">
                <xsl:text>&laquo; </xsl:text>
                <xsl:value-of select="@note"/>
                <xsl:text> &raquo;</xsl:text>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:when>
<!-- Makes the endbar note text appear in the intended location within a table row.  Sort of. -->
<!-- The following WHEN is a real hack and will result in a table row with too many columns -->
        <xsl:when test="parent::table-row">
          <fo:table-cell> 
            <fo:block space-before="3pt" space-after="3pt" color="green">
              <xsl:text>&laquo; </xsl:text>
              <xsl:value-of select="@note"/>
              <xsl:text> &raquo;</xsl:text>
            </fo:block>
          </fo:table-cell>
        </xsl:when>
<!-- For all non-list and non-table situations, just output the appropriate block -->
        <xsl:otherwise>
          <fo:block space-before="3pt" space-after="3pt" color="green">
            <xsl:text>&laquo; </xsl:text>
            <xsl:value-of select="@note"/>
            <xsl:text> &raquo;</xsl:text>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
<!--
      <fo:block space-before="3pt" space-after="3pt" color="green">
        <xsl:text>&laquo; </xsl:text>
        <xsl:value-of select="@note"/>
        <xsl:text> &raquo;</xsl:text>
      </fo:block>
-->
    </xsl:if>    
    <fo:change-bar-end change-bar-class="CB{$depth}"/>
  </xsl:if>
</xsl:template>

<!--
    Process the delbar (make bullet for deletions) element 
    NOTE: THIS ONLY WORKS BETWEEN PARAGRAPHS; MORE WORK WILL BE REQUIRED TO ALLOW IT TO BE 
    USED IN ARBITRARY LOCATIONS!!!!!
-->
<xsl:template match="delbar">
  <xsl:if test="substring-after($formalStage, '-')='20'">
    <xsl:variable name="depth" select="count(preceding::bar)-count(preceding::endbar)"/>
    <xsl:variable name="offset"
                  select="24+4*(count(preceding::bar)-count(preceding::endbar))"/>
    <xsl:variable name="colour">
      <xsl:choose>
        <xsl:when test="@colour">
          <xsl:value-of select="@colour"/>

        </xsl:when>
        <xsl:otherwise>
          red
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:change-bar-begin change-bar-class="CBdel" change-bar-color="{$colour}"
                         change-bar-placement="start"
                         change-bar-offset="{$offset}pt"
                         change-bar-style="solid"/>
<!-- The note attribute of the delbar outputs a block of text.  In certain locations,
     (e.g., within lists and tables), this causes that text to appear in the wrong
      place (specifically, at the top of the list or table).  The following code
      causes the text to appear in a much more appropriate location. -->
      <xsl:choose>
<!-- Makes the delbar note text appear in the intended location within a list -->
        <xsl:when test="parent::slist | parent::ulist | parent::blist | parent::dlist |
                        parent::olist | parent::nlist | parent::alist | parent::rlist |
                        parent::Alist | parent::Rlist | parent::lbllist">
          <fo:list-item>
            <fo:list-item-label end-indent="0.01in"><xsl:text> </xsl:text></fo:list-item-label>
            <fo:list-item-body start-indent="0.02in">
              <fo:block space-before="3pt" space-after="3pt" color="{$colour}">
                <xsl:text>&laquo; </xsl:text>
                <xsl:value-of select="@note"/>
                <xsl:text> &raquo;</xsl:text>
              </fo:block>
            </fo:list-item-body>
          </fo:list-item>
        </xsl:when>
<!-- Makes the delbar note text appear in the intended location within a table -->
        <xsl:when test="parent::table-body | parent::table-heads | parent::table-head-row">
          <xsl:variable name="requiredSpan"
                        select="ancestor::table[1]//table-common/table-setup/@numcols"/>
          <fo:table-row>
            <fo:table-cell number-columns-spanned="{$requiredSpan}"> 
             <fo:block space-before="3pt" space-after="3pt" color="{$colour}">
                <xsl:text>&laquo; </xsl:text>
                <xsl:value-of select="@note"/>
                <xsl:text> &raquo;</xsl:text>
              </fo:block>
            </fo:table-cell>
          </fo:table-row>
        </xsl:when>
<!-- Makes the delbar note text appear in the intended location within a table row.  Sort of. -->
<!-- The following WHEN is a real hack and will result in a table row with too many columns -->
        <xsl:when test="parent::table-row">
          <fo:table-cell> 
            <fo:block space-before="3pt" space-after="3pt" color="{$colour}">
              <xsl:text>&laquo; </xsl:text>
              <xsl:value-of select="@note"/>
              <xsl:text> &raquo;</xsl:text>
            </fo:block>
          </fo:table-cell>
        </xsl:when>
<!-- For all non-list and non-table situations, just output the appropriate block -->
        <xsl:otherwise>
          <fo:block space-before="3pt" space-after="3pt" color="{$colour}">
            <xsl:text>&laquo; </xsl:text>
            <xsl:value-of select="@note"/>
            <xsl:text> &raquo;</xsl:text>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>
    <fo:change-bar-end change-bar-class="CBdel"/>
  </xsl:if>
</xsl:template>



<!--
===================================================================================================
===================================================================================================
The final grouping of templates are those used to process in-line elements
===================================================================================================
===================================================================================================
-->

<!-- =================================================================================== -->
<!-- Templates to process textual elements                                               -->
<!-- =================================================================================== -->


<!--
    BNF non-terminal including a "hot link" to the its definition 
-->
<!-- If the BNF element contains a part= attribute, then an external link is made to the location 
     associated with the presumed BNFdef element in the referenced part; if these is no such 
     element in that part, an error is generated.
     In the absence of a part= attribute, an internal link is generated to the location associated 
     with the presumed BNFdef element in "this" part; if there is no such element in "this" part, 
     there is NO ERROR GENERATED, but the link is non-functional.
    (The non-functional link is generated for compatibility with behavior created and universally 
    used before the part= attribute was available.) -->
<xsl:template match="BNF">
  <xsl:param name="fromPart" select="'xx'"/>
  <xsl:param name="fromStandard" select="'xx'"/>
<!-- ***************************************************************** -->
<!-- NEW INDEX TECHNOLOGY BELOW -->
<!-- ***************************************************************** -->
  <xsl:param name="suppressIndexKey" select="no" tunnel="yes"/>
<!-- ***************************************************************** -->
<!-- NEW INDEX TECHNOLOGY ABOVE -->
<!-- ***************************************************************** -->
  <xsl:variable name="nonterminal" select="@name"/>
  <xsl:variable name="linkref">
    <xsl:text>'BNF_</xsl:text>
    <xsl:value-of select="@name"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="subClauseID" select="ancestor::subClause[1]/@id"/>
  <xsl:choose>
    <xsl:when test="@part or $fromPart != 'xx'">
      <xsl:variable name="nonterminal" select="@name"/>
      <xsl:variable name="linkref">
        <xsl:text>'BNF_</xsl:text>
        <xsl:value-of select="@name"/>
        <xsl:text>'</xsl:text>
      </xsl:variable>
      <xsl:variable name="partnum">
        <xsl:choose>
          <xsl:when test="@part">
            <xsl:value-of select="@part"/>
          </xsl:when>
          <xsl:when test="$fromPart != 'xx'">
            <xsl:value-of select="$fromPart"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@part"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="standardnum">
        <xsl:choose>
          <xsl:when test="@standard">
            <xsl:value-of select="@standard"/>
          </xsl:when>
          <xsl:when test="$fromStandard != 'xx'">
            <xsl:value-of select="$fromStandard"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$standardNumber"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:variable name="filename"
                    select="$parts[@number=$standardnum]/part[@number=$partnum]/@input"/>
      <xsl:variable name="resultfile"
                    select="$parts[@number=$standardnum]/part[@number=$partnum]/@output"/>
      <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
      <xsl:choose>
        <xsl:when test="$extroot//BNFdef[@name=$nonterminal]">
          <xsl:if test="ancestor-or-self::rhs">
            <xsl:text> </xsl:text>
          </xsl:if>
          <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                         show-destination="new">
<!--
            <xsl:text>&lt;</xsl:text>
            <fo:inline id="{generate-id()}"><xsl:value-of select="@name"/></fo:inline>
            <xsl:text>&gt;</xsl:text>
-->
<!-- NEW INDEX TECHNOLOGY BELOW -->
            <xsl:variable name="BNF-key">
              <xsl:value-of select="@name"/>
            </xsl:variable>
<!-- LINE LENGTH CHECK OFF -->
            <xsl:choose>
<!-- ############################################################################## -->
<!-- TEST INDEX IDEA    TEST INDEX IDEA    TEST INDEX IDEA    TEST INDEX IDEA       -->
<!-- ############################################################################## -->
              <xsl:when test="$suppressIndexKey = 'yes'">
<!-- ############################################################################## -->
<!-- TEST INDEX IDEA    TEST INDEX IDEA    TEST INDEX IDEA    TEST INDEX IDEA       -->
<!-- ############################################################################## -->
<!--
              <xsl:when test="ancestor::clauseHeading | ancestor::tableTitle |
                              ancestor::figureTitle | ancestor::exampleTitle |
                              ancestor::equationTitle">
-->
<!-- ############################################################################## -->
<!-- TEST INDEX IDEA    TEST INDEX IDEA    TEST INDEX IDEA    TEST INDEX IDEA       -->
<!-- ############################################################################## -->
                <fo:inline id="{generate-id()}"><xsl:text>&lt;</xsl:text><xsl:value-of select="$BNF-key"/><xsl:text>&gt;</xsl:text></fo:inline>
              </xsl:when>
              <xsl:otherwise>
                <fo:inline id="{generate-id()}" index-key="{$BNF-key}"><xsl:text>&lt;</xsl:text><xsl:value-of select="$BNF-key"/><xsl:text>&gt;</xsl:text></fo:inline>
              </xsl:otherwise>
            </xsl:choose>
<!-- ************** DEBUGGING ******************************************** -->
<!--
<xsl:message><xsl:text>DEBUG: BNF usage; index-key = </xsl:text>
  <xsl:value-of select="$BNF-key"/><xsl:text>.</xsl:text></xsl:message>
-->
<!-- ************** DEBUGGING ******************************************** -->
<!-- LINE LENGTH CHECK ON -->
          </fo:basic-link>          
        </xsl:when>
        <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">$filename = %s1  $nonterminal = %s2 , no corresponding BNFdef. $subClauseID = </xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$filename"/>
            <xsl:with-param name="ErrorValue2" select="$nonterminal"/>
            <xsl:with-param name="ErrorValue3" select="$subClauseID"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="//BNFdef[@name=$nonterminal]">
          <xsl:if test="ancestor-or-self::rhs">
            <xsl:text> </xsl:text>
          </xsl:if>
<!-- 2022-11-21: Jim eliminated incorrect index entry pointing into ToC -->
<!--    The secret is DO NOT generate @id attribute for <BNF> within <clauseHeading> -->
<!--
          <xsl:choose>
            <xsl:when test="ancestor::clauseHeading">
              <fo:basic-link internal-destination="'BNF_{@name}'">
                <xsl:text>&lt;</xsl:text>
                <xsl:value-of select="@name"/>
                <xsl:text>&gt;</xsl:text>
              </fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
              <fo:basic-link internal-destination="'BNF_{@name}'" id="{generate-id(.)}">
                <xsl:text>&lt;</xsl:text>
                <xsl:value-of select="@name"/>
                <xsl:text>&gt;</xsl:text>
              </fo:basic-link>
            </xsl:otherwise>
          </xsl:choose>
-->
<!-- NEW INDEX TECHNOLOGY BELOW -->
          <xsl:variable name="BNF-key" select="@name"/>
          <xsl:choose>
            <xsl:when test="ancestor::clauseHeading | ancestor::tableTitle |
                            ancestor::figureTitle | ancestor::exampleTitle |
                            ancestor::equationTitle">
              <fo:basic-link internal-destination="'BNF_{@name}'">
                <xsl:text>&lt;</xsl:text>
                <xsl:value-of select="@name"/>
                <xsl:text>&gt;</xsl:text>
              </fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
              <fo:inline index-key="{$BNF-key}">
                <fo:basic-link internal-destination="'BNF_{@name}'" id="{generate-id(.)}">
                  <xsl:text>&lt;</xsl:text>
                  <xsl:value-of select="@name"/>
                  <xsl:text>&gt;</xsl:text>
                </fo:basic-link>
              </fo:inline>
            </xsl:otherwise>
          </xsl:choose>
<!-- ************** DEBUGGING ******************************************** -->
<!--
<xsl:message><xsl:text>DEBUG: BNF usage; index-key = </xsl:text>
  <xsl:value-of select="$BNF-key"/><xsl:text>.</xsl:text></xsl:message>
-->
<!-- ************** DEBUGGING ******************************************** -->
<!-- NEW INDEX TECHNOLOGY ABOVE -->
<!-- 2022-11-21: END OF elimination of incorrect index entry pointing into ToC -->
        </xsl:when>
        <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
          <xsl:call-template name="ProcessError">
            <xsl:with-param name="ErrorText">$filename = THIS PART. $nonterminal = %s1 $subClauseID = %s2</xsl:with-param>
            <xsl:with-param name="ErrorValue1" select="$nonterminal"/>
            <xsl:with-param name="ErrorValue2" select="$subClauseID"/>
          </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    kw element (keywords)
    2020-06-01: Add a check that the keyword is also listed in either the BNF production
      <reserved word> or the BNF production <non-reserved word>, either in the "current"
      part or in part 2.
-->

<xsl:template match="kw">
<!--
The first test is intended to see if the text of "this" keyword is anywhere in the list of keywords
-->
  <xsl:if test="not(fn:contains(fn:concat($NonReservedWords/text(), $ReservedWords/text()),
                                fn:concat(' ', ./text(), ' ')))">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">Keyword not categorized as reserved or non-reserved (in any relevant Part): %s1</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="./text()"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
<!--
The next test is intended to see if the text of "this" keyword is included in both keyword lists
in any combination of parts.
However, on 2020-10-18, the editors decided that incremental parts could validly "promote"
a keyword that is a <non-reserved word> in Foundation to become a <reserved word> in
that incremental part. 
-->
  <xsl:if test="fn:contains($NonReservedWords/text(), fn:concat(' ', ./text(), ' ')) and
                fn:contains($ReservedWords/text(), fn:concat(' ', ./text(), ' ')) and
                not(fn:contains($NonReservedWords9075-2/text(), fn:concat(' ', ./text(), ' ')))">
<!-- LINE LENGTH CHECK OFF -->
    <xsl:call-template name="ProcessError">
      <xsl:with-param name="ErrorText">Keyword is categorized as both reserved and non-reserved, but is not promoted: %s1</xsl:with-param>
      <xsl:with-param name="ErrorValue1" select="./text()"/>
    </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
  </xsl:if>
  <xsl:if test="ancestor-or-self::rhs">
    <xsl:text> </xsl:text>
  </xsl:if>
<!-- NEW INDEX TECHNOLOGY BELOW -->
  <xsl:variable name="kw-key" select="string(.)"/>
  <fo:inline id="{generate-id(.)}" index-key="{$kw-key}">
    <xsl:apply-templates/>
  </fo:inline>
<!-- ************** DEBUGGING ******************************************** -->
<!--
<xsl:message><xsl:text>DEBUG: kw; index-key = </xsl:text>
  <xsl:value-of select="$kw-key"/><xsl:text>.</xsl:text></xsl:message>
-->
<!-- ************** DEBUGGING ******************************************** -->
<!-- NEW INDEX TECHNOLOGY ABOVE -->
<!--
  <fo:inline id="{generate-id(.)}">
    <xsl:apply-templates/>
  </fo:inline>
-->
</xsl:template>

<!--
    sjkw element (SQL/JSON keywords)
-->
<xsl:template match="sjkw">
  <xsl:if test="ancestor-or-self::rhs">
    <xsl:text> </xsl:text>
  </xsl:if>
<!-- NEW INDEX TECHNOLOGY BELOW -->
  <xsl:variable name="sjkw-key" select="string(.)"/>
  <fo:inline id="{generate-id(.)}" index-key="{$sjkw-key}">
    <fo:inline font-family="{$codefont-name}"><xsl:apply-templates/></fo:inline>
  </fo:inline>
<!-- ************** DEBUGGING ******************************************** -->
<!--
<xsl:message><xsl:text>DEBUG: sjkw; index-key = </xsl:text>
  <xsl:value-of select="$sjkw-key"/><xsl:text>.</xsl:text></xsl:message>
-->
<!-- ************** DEBUGGING ******************************************** -->
<!-- NEW INDEX TECHNOLOGY ABOVE -->
</xsl:template>

<!--
    Passage definition (passage)
-->
<xsl:template match="passage">
  <xsl:variable name="passageId">
    <xsl:choose>
      <xsl:when test="@id != ''"><xsl:value-of select="@id"/></xsl:when>
      <xsl:otherwise><xsl:value-of select="generate-id(.)"/></xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:inline id="'{$passageId}'">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>
  
<!--
    Reference to details (phrase)
-->
<xsl:template match="phrase">
  <xsl:choose>
    <xsl:when test="$render-phrase-links = 'yes'">
      <fo:basic-link internal-destination="'{@ref}'">
        <fo:inline border-bottom=".8pt darkgray dotted" padding-bottom="-0.2em">
          <xsl:apply-templates/>
        </fo:inline>
      </fo:basic-link>      
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Insert the contents of a defn, ignoring its attributes (repeatdefn)
-->
<xsl:template match="repeatdefn">
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="defn1" select="//definition[@id = $ref]/defn"/>
  <xsl:variable name="defn2" select="//passage[@id = $ref and @type = 'defn']"/>
  <!-- Only one of the two apply-templates below will match regularly; this handles a corner case
       with terms inherited from non-WG3 standards and defined by <passage>, e.g., time scale -->
  <xsl:choose>
    <xsl:when test="$defn1">
      <xsl:apply-templates select="$defn1">
        <xsl:with-param name="repeatdefn" tunnel="yes" select="true()"/>
      </xsl:apply-templates>      
    </xsl:when>
    <xsl:when test="$defn2">
      <xsl:apply-templates select="$defn2"/>      
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">Repeated definition with id = %s1 not found.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>    
  </xsl:choose>
  </xsl:template>

<!--
    Insert the contents of a passage, ignoring its attributes (repeatpassage)
-->
<xsl:template match="repeatpassage">
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="elt" select="//passage[@id = $ref]"/>
  <xsl:choose>
    <xsl:when test="$elt">    
      <xsl:apply-templates select="$elt"/> 
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText"> Repeated text passage with id =  %s1 not found.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

  
<!--
    Insert the contents of an item, ignoring its attributes (repeatitem)
-->
<xsl:template match="repeatitem">
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="elt" select="//item[@id = $ref]"/>
  <xsl:choose>
    <xsl:when test="$elt">
      <xsl:for-each select="$elt">
        <xsl:apply-templates/>
      </xsl:for-each>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">Repeated item with id = %s1 not found.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
  
  
<!--
    New term definition (newterm)
-->
<xsl:template match="newterm">
<!-- NEW INDEX TECHNOLOGY BELOW -->
  <xsl:variable name="newterm-key">
    <xsl:value-of select="string(.)"/>
  </xsl:variable>
  <fo:inline font-style="italic" id="{generate-id(.)}" index-key="{$newterm-key}">
    <xsl:apply-templates/>
  </fo:inline>
<!-- ************** DEBUGGING ******************************************** -->
<!--
<xsl:message><xsl:text>DEBUG: newterm; index-key = </xsl:text>
  <xsl:value-of select="$newterm-key"/><xsl:text>.</xsl:text></xsl:message>
-->
<!-- ************** DEBUGGING ******************************************** -->
<!-- NEW INDEX TECHNOLOGY ABOVE -->
<!--
  <fo:inline font-style="italic" id="{generate-id(.)}">
    <xsl:apply-templates/>
  </fo:inline>
-->
</xsl:template>

<!--
    XML words, phrases, and terms (xmlterm)
-->
<xsl:template match="xmlterm">
<!-- NEW INDEX TECHNOLOGY BELOW -->
  <xsl:variable name="xmlterm-key" select="string(.)"/>
  <fo:inline font-weight="bold" id="{generate-id(.)}" index-key="{$xmlterm-key}">
    <xsl:apply-templates/>
  </fo:inline>
<!-- ************** DEBUGGING ******************************************** -->
<!--
<xsl:message><xsl:text>DEBUG: xmlterm; index-key = </xsl:text>
  <xsl:value-of select="$xmlterm-key"/><xsl:text>.</xsl:text></xsl:message>
-->
<!-- ************** DEBUGGING ******************************************** -->
<!-- NEW INDEX TECHNOLOGY ABOVE -->
</xsl:template>

<!--
    indexTerm element
-->
<xsl:template match="indexTerm">
<!-- NEW INDEX TECHNOLOGY BELOW -->
  <xsl:variable name="indexTerm-key">
    <xsl:choose>
      <xsl:when test="string(.) = 'Implementation-defined'">
        <xsl:text>implementation-defined</xsl:text>
      </xsl:when>
      <xsl:when test="string(.) = 'Implementation-dependent'">
        <xsl:text>implementation-dependent</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="string(.)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:inline id="{generate-id(.)}" index-key="{$indexTerm-key}">
    <xsl:apply-templates/>
  </fo:inline>
<!-- NEW INDEX TECHNOLOGY ABOVE -->
</xsl:template>

<!--
    Informal symbol definition (symdef)
-->
<xsl:template match="symdef">
  <fo:inline font-style="italic">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Use of informal symbols (sym)
-->
<xsl:template match="sym">
  <fo:inline font-style="italic">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Informal XML symbol definition (xmlsymdef)
-->
<xsl:template match="xmlsymdef">
  <fo:inline font-family="{$codefont-name}" font-style="italic" font-weight="bold">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Use of informal XML symbols (xmlsym)
-->
<xsl:template match="xmlsym">
  <fo:inline font-family="{$codefont-name}" font-style="italic" font-weight="bold">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    XML text (xmltext)
-->
<xsl:template match="xmltext">
  <fo:inline font-family="{$codefont-name}" font-weight="bold">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Features of the language (feature)
-->
<xsl:template match="feature">
  <xsl:variable name="code" select="@code"/>
  <xsl:variable name="standardnum">
    <xsl:choose>
      <xsl:when test="@standard">
       <xsl:value-of select="@standard"/>
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="$standardNumber"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="feature-string">
    <xsl:apply-templates select="$Features/feature[@code=$code]/name"/>
  </xsl:variable>
  <xsl:variable name="parent" select="(ancestor::clause | ancestor::annex | ancestor::subClause | 
                                       ancestor::subClause2 | ancestor::subClause3 | 
                                       ancestor::subClause4) [last()]"/>
  <xsl:variable name="clauseName">
    <xsl:apply-templates select="$parent/clauseHeading"/>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="count($Features/feature[@code=$code and 
                                            child::usedIn[@standard=$standardnum]])=0">
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">code = %s1, standard = %s2, has no corresponding entry in the Features document. The element id of the parent element = %s3.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$code"/>
        <xsl:with-param name="ErrorValue2" select="$standardnum"/>
        <xsl:with-param name="ErrorValue3" select="$parent/@id"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:when>
    <xsl:when test="$Features/feature[@code=$code and 
                                      child::usedIn[@standard=$standardnum and
                                                    @status='O']] and
                    not(contains($clauseName, 'Incompatibilities'))">
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">code = %s1, standard = %s2, is an obsolete entry in the Features document. The element id of the parent element = %s3.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$code"/>
        <xsl:with-param name="ErrorValue2" select="$standardnum"/>
        <xsl:with-param name="ErrorValue3" select="$parent/@id"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:when>
    <xsl:when test="$Features/feature[@code=$code and 
                                      child::usedIn[@standard=$standardnum and
                                                     @mand='yes']] and
                    not(contains($clauseName, 'SQL mandatory feature taxonomy'))">
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">code = %s1, standard = %s2, is a mandatory feature in the Features document. The element id of the parent element = %s3.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$code"/>
        <xsl:with-param name="ErrorValue2" select="$standardnum"/>
        <xsl:with-param name="ErrorValue3" select="$parent/@id"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:when>
    <xsl:otherwise>
<!-- NEW INDEX TECHNOLOGY BELOW -->
      <xsl:variable name="feature-key" select="$code"/>
      <xsl:choose>
        <xsl:when test="@codeOnly='yes'">
          <fo:inline id="{generate-id()}"
                     index-key="{$feature-key}"><xsl:value-of select="$code"/></fo:inline>
        </xsl:when>
<!-- LINE LENGTH CHECK OFF -->
        <xsl:when test="@textOnly='yes'">
          <fo:inline id="{generate-id()}" index-key="{$feature-key}"><xsl:value-of select="$feature-string"/></fo:inline>
        </xsl:when>
<!-- LINE LENGTH CHECK ON -->
        <xsl:otherwise>
          <fo:inline id="{generate-id()}" index-key="{$feature-key}">
            <xsl:text>Feature </xsl:text>
            <xsl:value-of select="$code"/>
            <xsl:text>, &ldquo;</xsl:text>
            <xsl:value-of select="$feature-string"/>
            <xsl:text>&rdquo;</xsl:text>
          </fo:inline>
        </xsl:otherwise>
      </xsl:choose>
<!-- ************** DEBUGGING ******************************************** -->
<!--
<xsl:message><xsl:text>DEBUG: feature; index-key = </xsl:text>
  <xsl:value-of select="$feature-key"/><xsl:text>.</xsl:text></xsl:message>
-->
<!-- ************** DEBUGGING ******************************************** -->
<!-- NEW INDEX TECHNOLOGY ABOVE -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    URIs (URI)
-->
<xsl:template match="URI">
  <xsl:variable name="theURI">
    <xsl:apply-templates/>
  </xsl:variable>
  <fo:inline font-family="{$codefont-name}">
    <xsl:choose>
      <xsl:when test="@active='no'">
        <xsl:value-of select="fn:replace(fn:replace(fn:replace($theURI, '//', '~~'), 
                              '/', '/&shy;'), '~~', '//')"/>
      </xsl:when>
      <xsl:otherwise>
        <fo:basic-link external-destination="url('{$theURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($theURI, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </xsl:otherwise>
    </xsl:choose>
  </fo:inline>
</xsl:template>


<xsl:template match="digitalArtifact">
  <xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
<!-- LINE LENGTH CHECK OFF -->
  <xsl:variable name="baseURI">
    <xsl:value-of
      select="$parts[@number=$standardNumber]/part[@number=$partno]/@artifactURI"/>
  </xsl:variable>
  <xsl:variable name="partFilename">
    <xsl:value-of
      select="$parts[@number=$standardNumber]/part[@number=$partno]/@output"/>
  </xsl:variable>
  <xsl:variable name="suffix">
    <xsl:value-of
      select="$parts[@number=$standardNumber]/part[@number=$partno]/artifact[@type=$type]/@suffix"/>
  </xsl:variable>
 <xsl:variable name="fullURI">
    <xsl:value-of select="$baseURI"/><xsl:value-of select="$partFilename"/><xsl:value-of select="$suffix"/>
  </xsl:variable>
 <xsl:variable name="fullName">
    <xsl:value-of select="$partFilename"/><xsl:value-of select="$suffix"/>
  </xsl:variable>
  <xsl:choose>
<!-- Process BNF in text and XML format -->
    <xsl:when test="$type='BNFText' or $type='BNFXML'">
      <xsl:variable name="fullURIText">
        <xsl:value-of select="$baseURI"/><xsl:value-of select="$partFilename"/><xsl:value-of
          select="$parts[@number=$standardNumber]/part[@number=$partno]/artifact[@type='BNFText']/@suffix"/>
      </xsl:variable>
      <xsl:variable name="fullURIXML">
        <xsl:value-of select="$baseURI"/><xsl:value-of select="$partFilename"/><xsl:value-of
          select="$parts[@number=$standardNumber]/part[@number=$partno]/artifact[@type='BNFXML']/@suffix"/>
      </xsl:variable>
      <xsl:variable name="fullNameText">
        <xsl:value-of select="$partFilename"/><xsl:value-of
          select="$parts[@number=$standardNumber]/part[@number=$partno]/artifact[@type='BNFText']/@suffix"/>
      </xsl:variable>
      <xsl:variable name="fullNameXML">
        <xsl:value-of select="$partFilename"/><xsl:value-of
          select="$parts[@number=$standardNumber]/part[@number=$partno]/artifact[@type='BNFXML']/@suffix"/>
      </xsl:variable>
      <xsl:text>The syntax defined in this document is available from the ISO website as a
        &ldquo;digital artifact&rdquo;.  See </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$baseURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($baseURI, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text> to download digital artifacts for this document. 
        To download the syntax defined in a plain-text format, select the file named </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$fullURIText}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($fullNameText, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text>. To download the syntax defined in an XML format, select the file named </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$fullURIXML}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($fullNameXML, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text>. </xsl:text>
    </xsl:when>
<!-- Process the conditions artifact -->
    <xsl:when test="$type='Conditions'">
      <xsl:text>The condition codes and their associated text are available from the ISO website as a
        &ldquo;digital artifact&rdquo;.  See </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$baseURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($baseURI, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text> to download digital artifacts for this document. 
        To download the condition codes and associated text, select the file named </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$fullURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($fullName, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text>. </xsl:text>
    </xsl:when>
<!-- Process the features artifact -->
    <xsl:when test="$type='Features'">
      <xsl:text>This information is available from the ISO website as a
        &ldquo;digital artifact&rdquo;.  See </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$baseURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($baseURI, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text> to download digital artifacts for this document. 
        To download information about the features defined in this document,
        select the file named </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$fullURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($fullName, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text>. </xsl:text>
    </xsl:when>
<!-- Process the implementation-defined artifact -->
    <xsl:when test="$type='ImpDef'">
      <xsl:text>This information is available from the ISO website as a
        &ldquo;digital artifact&rdquo;.  See </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$baseURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($baseURI, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text> to download digital artifacts for this document. 
        To download information about the implementation-defined aspects of this document,
        select the file named </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$fullURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($fullName, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text>. </xsl:text>
    </xsl:when>
<!-- Process the implementation-dependent artifact -->
    <xsl:when test="$type='UnDef'">
      <xsl:text>This information is available from the ISO website as a
        &ldquo;digital artifact&rdquo;.  See </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$baseURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($baseURI, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text> to download digital artifacts for this document. 
        To download information about the implementation-dependent aspects of this document,
        select the file named </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$fullURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($fullName, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text>. </xsl:text>
    </xsl:when>
<!-- Process the C header file artifact -->
    <xsl:when test="$type='HeaderC'">
      <xsl:text>A C language header file is available from the ISO website as a
        &ldquo;digital artifact&rdquo;.  See </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$baseURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($baseURI, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text> to download digital artifacts for this document. 
        To download the C header file associated with this document,
        select the file named </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$fullURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($fullName, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text>. </xsl:text>
    </xsl:when>
<!-- Process the COBOL library file artifact -->
    <xsl:when test="$type='HeaderCobol'">
      <xsl:text>A COBOL language library file is available from the ISO website as a
        &ldquo;digital artifact&rdquo;.  See </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$baseURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($baseURI, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text> to download digital artifacts for this document. 
        To download the COBOL library file associated with this document,
        select the file named </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$fullURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($fullName, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text>. </xsl:text>
    </xsl:when>
<!-- Process the schema definition language artifact -->
    <xsl:when test="$type='SDL'">
      <xsl:text>These schema definition and manipulation statements are also
        available from the ISO website as a
        &ldquo;digital artifact&rdquo;.  See </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$baseURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($baseURI, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text> to download digital artifacts for this document. 
        To download the schema definition and manipulation statements,
        select the file named </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$fullURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($fullName, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text>. </xsl:text>
    </xsl:when>
<!-- Process the Ada interface package artifact -->
    <xsl:when test="$type='AdaInterface'">
      <xsl:text>The text of the Ada library unit package Interfaces.SQL is also
        available from the ISO website as a
        &ldquo;digital artifact&rdquo;.  See </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$baseURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($baseURI, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text> to download digital artifacts for this document. 
        To download the library unit package,
        select the file named </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$fullURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($fullName, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text>. </xsl:text>
    </xsl:when>
<!-- Process the XML Schema document artifact -->
    <xsl:when test="$type='XMLSchema'">
      <xsl:text>The text of the SQL/XML XML Schema document is also
        available from the ISO website as a
        &ldquo;digital artifact&rdquo;.  See </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$baseURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($baseURI, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text> to download digital artifacts for this document. 
        To download the XML Schema document,
        select the file named </xsl:text>
      <fo:inline font-family="{$codefont-name}">
        <fo:basic-link external-destination="url('{$fullURI}')"
                       show-destination="new" color="#000070">
          <xsl:value-of select="fn:replace(fn:replace(fn:replace($fullName, '//', '~~'), 
                                '/', '/&shy;'), '~~', '//')"/>
        </fo:basic-link>
      </fo:inline>
      <xsl:text>. </xsl:text>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">Invalid @type attribute %s1 in a &lt;digitalArtifacts&gt; element.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$type"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
<!-- LINE LENGTH CHECK ON -->
</xsl:template>

<!--
    An inlineEquation is just a bit of MathML not in a block
    The alignment-adjust value was selected through experimentation,
    ensuring that simple, single-line equations "sit" on the very
    same baseline that the surrounding text sits. 
-->
<xsl:template match="inlineEquation">

  <fo:inline>
    <xsl:variable name="ident">
      <xsl:choose>
        <xsl:when test="@id">
          <xsl:value-of select="@id"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>InlineEquation_</xsl:text>
          <xsl:value-of select="string(count(preceding::inlineEquation)+1)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <xsl:variable
      name="equation-part-png"
      select="$InlineEquations/showmath/output/rendered[@id=$ident]/part[@type='png']/text()"/>
    <xsl:variable
      name="equation-part-speech"
      select="$InlineEquations/showmath/output/rendered[@id=$ident]/part[@type='speech']/text()"/>
    <xsl:variable
      name="equation-part-measures-vertalign"
      select="$InlineEquations/showmath/output/rendered[@id=$ident]/
              part[@type='measures']/vertical-align/text()"/>
    <xsl:variable
      name="equation-part-measures-height"
      select="$InlineEquations/showmath/output/rendered[@id=$ident]/
              part[@type='measures']/height/text()"/>
    <xsl:variable
      name="height"
      select="concat(string(number(substring-before($equation-part-measures-height, 'ex')) * 0.4),
                     'em')"/>
    <xsl:variable
      name="vertalign"
      select="concat(string(number(substring-before($equation-part-measures-vertalign, 'ex')) *
                            0.4), 'em')"/>

    <fo:external-graphic src="{concat('url(', $equation-part-png, ')')}"
                         rx:alt-description="{$equation-part-speech}"
                         content-height="{$height}"
                         alignment-adjust="{$vertalign}"/>
  </fo:inline>
</xsl:template>

<!--
    A math expression for SUM using SIGMA and bounds
-->
<xsl:template match="math-sum">
  <fo:inline>
    <fo:inline font="133% Symbol">&Sigma;</fo:inline>
    <fo:leader leader-pattern="use-content"
               leader-length="{@length}"
               leader-pattern-width="{@length}"
               padding-end="{@upadding}"
               font-size="70%"
               baseline-shift="55%">
      <xsl:apply-templates select="upper"/>
    </fo:leader>
    <fo:leader leader-pattern="use-content"
               leader-length="{@length}"
               leader-pattern-width="{@length}"
               padding-end="{@lpadding}"
               font-size="70%"
               baseline-shift="sub">
      <fo:inline font-style="italic">
        <xsl:value-of select="@index"/>
      </fo:inline>=<xsl:apply-templates select="lower"/>
    </fo:leader>
  </fo:inline>
  <xsl:apply-templates select="expression"/>
</xsl:template>

<!--
    A math expression for PROD using PI and bounds
-->
<xsl:template match="math-prod">
  <fo:inline>
    <fo:inline font="133% Symbol">&PI;</fo:inline>
    <fo:leader leader-pattern="use-content"
               leader-length="{@length}"
               leader-pattern-width="{@length}"
               padding-end="{@upadding}"
               font-size="70%"
               baseline-shift="55%">
      <xsl:apply-templates select="upper"/>
    </fo:leader>
    <fo:leader leader-pattern="use-content"

               leader-length="{@length}"
               leader-pattern-width="{@length}"
               padding-end="{@lpadding}"
               font-size="70%"
               baseline-shift="sub">
      <fo:inline font-style="italic">
        <xsl:value-of select="@index"/>
      </fo:inline>=<xsl:apply-templates select="lower"/>
    </fo:leader>
  </fo:inline>
  <xsl:apply-templates select="expression"/>
</xsl:template>

<!--
    Symbolic cross references (specref)
-->
<xsl:template match="specref">
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="parent" select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                                       ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                                       ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                                       [last()]"/>
  <xsl:variable name="refColour">
    <xsl:choose>
      <xsl:when test="boolean(ancestor::LO[@status = 'deferred'])">#8080A0</xsl:when>
      <xsl:otherwise>#000070</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="key('generic-id', $ref)
                       [self::clause | self::annex |
                        self::subClause | self::subClause2 |
                        self::subClause3 | self::subClause4 |
                        self::table | self::conditionsTable | self::featuresTable |
                        self::figure | self::example | self::equation |
                        self::note | self::ednote | self::bibliography]">
      <fo:basic-link  internal-destination="'{@ref}'" color="{$refColour}">
        <xsl:apply-templates select="key('generic-id', @ref)" mode="specref-mode"/>
      </fo:basic-link>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">specref has no identifiable target: %s1 The element id of the parent element = %s2.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
        <xsl:with-param name="ErrorValue2" select="$parent"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Symbolic cross references to definition elements (defnref)
-->
<xsl:template match="defnref">
  <xsl:param name="repeatdefn" tunnel="yes" select="false()"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="plural" select="@plural"/>
  <xsl:variable name="parent" select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                                       ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                                       ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                                       [last()]"/>
  <xsl:variable name="refColour">
    <xsl:choose>
      <xsl:when test="$repeatdefn">#000000</xsl:when>
      <xsl:otherwise>#000070</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="key('generic-id', $ref)[self::definition]">
      <fo:basic-link internal-destination="'{@ref}'" color="{$refColour}">
        <fo:inline keep-together.within-line="always">
          <xsl:choose>
            <xsl:when test="not($plural='yes')">
              <xsl:apply-templates select="key('generic-id', $ref)" mode="defnref-single"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="key('generic-id', $ref)" mode="defnref-plural"/>
            </xsl:otherwise>
          </xsl:choose>
          <xsl:apply-templates select="key('generic-id', $ref)" mode="defnref-number"/>
        </fo:inline>
      </fo:basic-link>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">defnref has no identifiable target: %s1 The element id of the parent element = %s2</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
        <xsl:with-param name="ErrorValue2" select="$parent"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Symbolic cross references to list elements (itemref)
-->
<xsl:template match="itemref">
  <xsl:variable name="type" select="@type"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="parent" select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                                       ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                                       ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                                       [last()]"/>
  <xsl:variable name="refColour">
    <xsl:choose>
      <xsl:when test="boolean(ancestor::LO[@status = 'deferred'])">#8080A0</xsl:when>
      <xsl:otherwise>#000070</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:choose>
    <xsl:when test="key('generic-id', $ref)
                    [self::item | self::para | self::table-row-number]">
      <fo:basic-link internal-destination="'{@ref}'" color="{$refColour}">
        <xsl:choose>
          <xsl:when test="$type = 'SR'">
            <xsl:text>Syntax Rule&nbsp;</xsl:text>
          </xsl:when>
          <xsl:when test="$type = 'AR'">
            <xsl:text>Access Rule&nbsp;</xsl:text>
          </xsl:when>
          <xsl:when test="$type = 'GR'">
            <xsl:text>General Rule&nbsp;</xsl:text>
          </xsl:when>
          <xsl:when test="$type = 'CR'">
            <xsl:text>Conformance Rule&nbsp;</xsl:text>
          </xsl:when>
          <xsl:when test="$type = 'Desc'">
            <xsl:text>Description&nbsp;</xsl:text>
          </xsl:when>
          <xsl:when test="$type = 'LE'">
            <xsl:text>Item&nbsp;</xsl:text>
          </xsl:when>
          <xsl:when test="$type = 'row'">
            <xsl:text>Row#&nbsp;</xsl:text>
          </xsl:when>
          <xsl:when test="$type = 'step'">
            <xsl:text>Step&nbsp;</xsl:text>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates select="key('generic-id', $ref)" mode="specref-mode"/>
        <xsl:choose>
          <xsl:when test="$type = 'item'">
            <xsl:text>&nbsp;list item</xsl:text>
          </xsl:when>
          <xsl:when test="$type = 'para'">
            <xsl:text>&nbsp;paragraph</xsl:text>
          </xsl:when>
        </xsl:choose>
      </fo:basic-link>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">itemref has no identifiable target: %s1 The element id of the parent element = %s2.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
        <xsl:with-param name="ErrorValue2" select="$parent"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Process the PPref element to reference PPs and LOs in the same document
-->
<xsl:template match="PPref">
  <xsl:variable name="thePP" select="@ref"/>
  <xsl:variable name="parent" select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                                       ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                                       ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                                       [last()]"/>
  <xsl:variable name="refColour">
    <xsl:choose>
      <xsl:when test="boolean(ancestor::LO[@status = 'deferred'])">#8080A0</xsl:when>
      <xsl:otherwise>#000070</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <fo:basic-link internal-destination="'{$thePP}'" color="{$refColour}">
    <xsl:choose>
      <xsl:when test="//PP[@id = $thePP]">
        <xsl:text>Possible Problem </xsl:text>
      </xsl:when>
      <xsl:when test="//LO[@id = $thePP]">
        <xsl:text>Language Opportunity </xsl:text>
      </xsl:when>
      <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
        <xsl:call-template name="ProcessError">
          <xsl:with-param name="ErrorText">PPref has no identifiable target: %s1 The element id of the parent element = %s2.</xsl:with-param>
          <xsl:with-param name="ErrorValue1" select="$thePP"/>
          <xsl:with-param name="ErrorValue2" select="$parent"/>
        </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
      </xsl:otherwise>
    </xsl:choose>
    <fo:inline border-style="solid" border-color="black"
               border-width="0.4pt" padding-before="2pt"
               padding-after="0.9pt" padding-start="1.8pt"
               padding-end="1.8pt">
      <fo:inline font-weight="bold">
        <xsl:value-of select="//PP[@id = $thePP]/@number"/>
        <xsl:value-of select="//LO[@id = $thePP]/@number"/>
      </fo:inline>
    </fo:inline>
  </fo:basic-link>
</xsl:template>

<!--
    Process the ExtPPref element to reference PPs and LOs in another document
-->
<xsl:template match="ExtPPref">
  <xsl:variable name="partnum">
    <xsl:choose>
      <xsl:when test="@part">
        <xsl:value-of select="@part"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'00'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="standardnum">
    <xsl:choose>
      <xsl:when test="@standard">
        <xsl:value-of select="@standard"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$standardNumber"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@output"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="$ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
<!-- extroot is the actual source file of the part we're currently checking -->
  <xsl:variable name="extroot"
                select="document(concat($filename, '_editor_notes.xml'))"/>
  <xsl:choose>
    <xsl:when test="$extroot//PP[@id = $ref] or $extroot//LO[@id = $ref]">
      <xsl:choose>
        <xsl:when test="$extroot//PP[@id = $ref]">
          <xsl:text>Possible Problem </xsl:text>
        </xsl:when>
        <xsl:when test="$extroot//LO[@id = $ref]">
          <xsl:text>Language Opportunity </xsl:text>
        </xsl:when>
      </xsl:choose>
      <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                     show-destination="new" color="#000070">
        <fo:inline border-style="solid" border-color="black"
                   border-width="0.4pt" padding-before="2pt"
                   padding-after="0.9pt" padding-start="1.8pt"
                   padding-end="1.8pt">
          <fo:inline font-weight="bold">
            <xsl:value-of select="$extroot//PP[@id = $ref]/@number"/>
            <xsl:value-of select="$extroot//LO[@id = $ref]/@number"/>
          </fo:inline>
        </fo:inline>
      </fo:basic-link>    
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">ExtPPref has no identifiable target: %s1</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Process the lblitemref element to reference lblitems
-->
<xsl:template match="lblitemref">
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="parent" select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                                       ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                                       ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                                       [last()]"/>
  <xsl:choose>
    <xsl:when test="key('generic-id', $ref)[self::lblitem]">
      <fo:basic-link internal-destination="'{$ref}'" color="#000070">
        <xsl:text>[</xsl:text><xsl:value-of select="$ref"/><xsl:text>]</xsl:text>
      </fo:basic-link>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">lblitemref has no identifiable target: %s1 The element id of the parent element = %s2</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
        <xsl:with-param name="ErrorValue2" select="$parent"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Symbolic cross references to other documents (extref) (clauses, subclauses, tables, figures, 
    notes, and editor's notes)
-->
<xsl:template match="extref">
  <xsl:variable name="partnum" select="@part"/>
  <xsl:variable name="standardnum">
    <xsl:choose>
      <xsl:when test="@standard">
        <xsl:value-of select="@standard"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$standardNumber"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="filename"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@output"/>

  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="@ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
<!-- extroot is the actual source file of the part we're currently checking -->
<!-- This is where we need to check whether @active="no" or not.  If @active="no", then the
     variable needs to prefix the $filename with "./published/". -->
<!--    <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/> -->
  <xsl:variable name="active"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
  <xsl:variable name="parent" select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                                       ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                                       ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                                       [last()]"/>
  <xsl:choose>
    <xsl:when test="$extroot//*[@id = $ref]
                               [self::clause | self::annex |
                                self::subClause | self::subClause2 |
                                self::subClause3 | self::subClause4 |
                                self::bibliography | self::definition |
                                self::table | self::conditionsTable | self::featuresTable |
                                self::figure | self::example | self::equation |
                                self::note | self::ednote]">
      <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                     show-destination="new" color="#000070">
        <xsl:for-each select="$extroot//*[@id=$ref]
                                         [self::clause | self::annex |
                                          self::subClause | self::subClause2 |
                                          self::subClause3 | self::subClause4 |
                                          self::bibliography | self::definition |
                                          self::table | self::conditionsTable | 
                                          self::featuresTable |
                                          self::figure | self::example | self::equation |
                                          self::note | self::ednote]">
          <xsl:choose>
            <xsl:when test="self::clause | self::annex |
                            self::subClause | self::subClause2 |
                            self::subClause3 | self::subClause4 |
                            self::definition">
              <fo:inline keep-together.within-line="always">
                <xsl:choose>
                  <xsl:when test="self::clause">
                    <xsl:text>Clause </xsl:text>
                  </xsl:when>
                  <xsl:when test="self::annex">
                    <xsl:text>Annex </xsl:text>
                  </xsl:when>
                  <xsl:when test="self::subClause | self::subClause2 |
                                  self::subClause3 | self::subClause4">
                    <xsl:text>Subclause </xsl:text>
                  </xsl:when>
                </xsl:choose>
                <xsl:variable name="body" select="count(ancestor::standardPartBody)"/>
                <xsl:variable name="number-format">
                  <xsl:choose>
                    <xsl:when test="$body=1">1.1.1.1</xsl:when>
                    <xsl:otherwise>A.1.1.1</xsl:otherwise>
                  </xsl:choose>
                </xsl:variable>
                <xsl:number level="multiple"
                            count="annex|clause|
                                   subClause|subClause2|subClause3|subClause4|
                                   definition"
                            format="{$number-format}"/>
                <xsl:if test="not(self::definition)">
                  <xsl:text>,</xsl:text>
                </xsl:if>
              </fo:inline>
              <xsl:if test="not(self::definition)">
                <xsl:text> &ldquo;</xsl:text>
                <xsl:apply-templates select="clauseHeading">
                  <xsl:with-param name="fromPart" select="$partnum"/>
                  <xsl:with-param name="fromStandard" select="$standardnum"/>
                </xsl:apply-templates>
                <xsl:text>&rdquo;</xsl:text>
              </xsl:if>
            </xsl:when>
            <xsl:when test="self::bibliography">
              <fo:inline>
                <xsl:text>Bibliography</xsl:text>
              </fo:inline>
            </xsl:when>
            <xsl:when test="self::table | self::conditionsTable | self::featuresTable">
              <xsl:variable name="ThisTable" select="."/>
              <xsl:variable name="tablenum">
                <xsl:choose>
                  <xsl:when test="tableNumber">
                    <xsl:value-of select="tableNumber"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:call-template name="GetTableNumber">
                      <xsl:with-param name="TheTable" select="$ThisTable"/>
                    </xsl:call-template>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:variable>
              <fo:inline keep-together.within-line="always">
                <xsl:text>Table </xsl:text>
                <xsl:value-of select="$tablenum"/>
                <xsl:text>,</xsl:text>
              </fo:inline>
              <xsl:text> &ldquo;</xsl:text>
              <xsl:apply-templates select="tableTitle">
                <xsl:with-param name="fromPart" select="$partnum"/>
              </xsl:apply-templates>
              <xsl:text>&rdquo;</xsl:text>
            </xsl:when>
            <xsl:when test="self::figure">
              <fo:inline keep-together.within-line="always">
                <xsl:text>Figure </xsl:text>
                <xsl:value-of select="count(preceding::*[name()='figure'])+1"/>
                <xsl:text>,</xsl:text>
              </fo:inline>
              <xsl:text> &ldquo;</xsl:text>
              <xsl:apply-templates select="figureTitle"/>
              <xsl:text>&rdquo;</xsl:text>
            </xsl:when>
            <xsl:when test="self::example">
              <fo:inline keep-together.within-line="always">
                <xsl:text>Example </xsl:text>
                <xsl:value-of select="count(preceding::*[name()='example'])+1"/>
                <xsl:text>,</xsl:text>
              </fo:inline>
              <xsl:text> &ldquo;</xsl:text>
              <xsl:apply-templates select="exampleTitle"/>
              <xsl:text>&rdquo;</xsl:text>
            </xsl:when>
            <xsl:when test="self::equation">
              <fo:inline keep-together.within-line="always">
                <xsl:text>Equation </xsl:text>
                <xsl:value-of select="count(preceding::*[name()='equation'])+1"/>
                <xsl:text>,</xsl:text>
              </fo:inline>
              <xsl:text> &ldquo;</xsl:text>
              <xsl:apply-templates select="equationTitle"/>
              <xsl:text>&rdquo;</xsl:text>
            </xsl:when>
            <xsl:when test="self::note">
              <fo:inline keep-together.within-line="always">
                <xsl:text>Note </xsl:text>
                <xsl:value-of select="count(preceding::*[name()='note'])+1"/>
              </fo:inline>
            </xsl:when>
            <xsl:when test="self::ednote">
              <fo:inline keep-together.within-line="always">
                <xsl:text>Editor&rsquo;s Note </xsl:text>
                <xsl:value-of select="count(preceding::*[name()='ednote'])+1"/>
              </fo:inline>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </fo:basic-link>
    </xsl:when>
    <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">extref has no identifiable target or references invalid object: %s1 The element id of the parent element = %s2.</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
        <xsl:with-param name="ErrorValue2" select="$parent"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!--
    Symbolic cross references to list items in other documents (extitemref)
-->
<xsl:template match="extitemref">
  <xsl:variable name="partnum" select="@part"/>
  <xsl:variable name="ref" select="@ref"/>
  <xsl:variable name="standardnum">
    <xsl:choose>
      <xsl:when test="@standard">
        <xsl:value-of select="@standard"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$standardNumber"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="linkref">
    <xsl:text>'</xsl:text>
    <xsl:value-of select="@ref"/>
    <xsl:text>'</xsl:text>
  </xsl:variable>
  <xsl:variable name="type" select="@type"/>
  <xsl:variable name="filename"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@input"/>
  <xsl:variable name="resultfile"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@output"/>
<!-- extroot is the actual source file of the part we're currently checking                 -->
<!-- This is where we need to check whether @active="no" or not.  If @active="no", then the
     variable needs to prefix the $filename with "./published/".                     -->
  <xsl:variable name="active"
                select="$parts[@number=$standardnum]/part[@number=$partnum]/@active"/>
  <xsl:variable name="dirstring">
    <xsl:choose>
      <xsl:when test="$active='no'">
        <xsl:text>./published/</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text></xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:variable name="extroot" select="document(concat($dirstring, $filename, '.xml'))"/>
  <xsl:variable name="parent" select="(ancestor::clause[1]/@id | ancestor::annex[1]/@id |
                                       ancestor::subClause[1]/@id | ancestor::subClause2[1]/@id |
                                       ancestor::subClause3[1]/@id | ancestor::subClause4[1]/@id)
                                       [last()]"/>
  <xsl:choose>
    <xsl:when test="$extroot//*[@id=$ref]
                               [self::item | self::para | self::table-row-number]">
      <fo:basic-link external-destination="url('file:{$resultfile}.pdf#{$linkref}')"
                     show-destination="new" color="#000070">
        <!-- In the link, every item, para, or table-row-number with a "matching" id is processed
             (there should be only one!) -->
        <xsl:for-each select="$extroot//*[@id=$ref]
                                         [self::item | self::para | self::table-row-number]">
          <xsl:variable name="list-level">
            <xsl:value-of select="count(ancestor-or-self::olist)"/>
          </xsl:variable>
          <xsl:choose>
            <!-- NOT item and NOT para and NOT row means SR, AR, GR, CR, Desc, LE, or step -->
            <xsl:when test="$type != 'row' and
                            $type != 'item' and
                            $type != 'para'">
              <xsl:choose>
                <xsl:when test="$type = 'SR'">
                  <xsl:text>Syntax Rule&nbsp;</xsl:text>
                </xsl:when>
                <xsl:when test="$type = 'AR'">
                  <xsl:text>Access Rule&nbsp;</xsl:text>
                </xsl:when>
                <xsl:when test="$type = 'GR'">
                  <xsl:text>General Rule&nbsp;</xsl:text>
                </xsl:when>
                <xsl:when test="$type = 'CR'">
                  <xsl:text>Conformance Rule&nbsp;</xsl:text>
                </xsl:when>
                <xsl:when test="$type = 'Desc'">
                  <xsl:text>Description&nbsp;</xsl:text>
                </xsl:when>
                <xsl:when test="$type='LE'">
                  <xsl:text>Item&nbsp;</xsl:text>
                </xsl:when>
                <xsl:when test="$type = 'step'">
                  <xsl:text>Step&nbsp;</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <!-- Excluded by DTD so, in principle, cannot happen -->
                  <fo:inline font-size="18pt" font-weight="bold" color="red">
                    <xsl:value-of select="'ERROR: BAD VALUE FOR type ATTRIBUTE:'"/>
                    <xsl:value-of select="@type"/>
                  </fo:inline>
                </xsl:otherwise>
              </xsl:choose>
              <xsl:call-template name="olist-item-number-ref">
                <xsl:with-param name="list-level" select="$list-level"/>
              </xsl:call-template>
            </xsl:when>
<!-- Handle <table-row-number>" a little differently to avoid ")" at the end of the number -->
            <xsl:when test="$type = 'row'">
              <xsl:text>Row#&nbsp;</xsl:text>
              <xsl:value-of
                select="count(ancestor::table-row/preceding-sibling::table-row[table-cell/
                              table-row-number])+1"/>
            </xsl:when>
<!-- At this point, only <item> and <para> are possibilities -->
            <xsl:when test="$type = 'item'">
              <xsl:number level="single" format="1" ordinal="yes" lang="en"/>
              <xsl:text>&nbsp;list item</xsl:text>
            </xsl:when>
            <xsl:when test="$type = 'para'">
              <xsl:number level="single" format="1" ordinal="yes" lang="en"/>
              <xsl:text>&nbsp;paragraph</xsl:text>
            </xsl:when>
          </xsl:choose>
        </xsl:for-each>
      </fo:basic-link>
    </xsl:when>
    <xsl:otherwise>

<!-- LINE LENGTH CHECK OFF -->
      <xsl:call-template name="ProcessError">
        <xsl:with-param name="ErrorText">extitemref has no identifiable target: %s1 The element id of the parent element = %s2</xsl:with-param>
        <xsl:with-param name="ErrorValue1" select="$ref"/>
        <xsl:with-param name="ErrorValue2" select="$parent"/>
      </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- =================================================================================== -->
<!-- Templates to process elements that generate special characters and phrases          -->
<!-- =================================================================================== -->

<!--
    Less-than-or-equal sign (leq)
-->
<xsl:template match="leq">
  <fo:inline font-family="ArialUnicodeMS">&le;</fo:inline>
</xsl:template>

<!--
    Greater-than-or-equal sign (geq)
-->
<xsl:template match="geq">
  <fo:inline font-family="ArialUnicodeMS">&ge;</fo:inline>
</xsl:template>

<!--
    Not-equal sign (neq)
-->
<xsl:template match="neq">
  <fo:inline font-family="ArialUnicodeMS">&neq;</fo:inline>
</xsl:template>

<!--
    Precedes symbol (prec)
-->
<xsl:template match="prec">
  <fo:inline font-family="ArialUnicodeMS">&precedes;</fo:inline>
</xsl:template>

<!--
   Succeeds symbol (succ)
-->
<xsl:template match="succ">
  <fo:inline font-family="ArialUnicodeMS">&succeeds;</fo:inline>
</xsl:template>

<!--
    Same precedence symbol (simeq)
-->
<xsl:template match="simeq">
  <fo:inline font-family="ArialUnicodeMS">&simeq;</fo:inline>
</xsl:template>

<!--
    Maps-to symbol (mapsto)
-->
<xsl:template match="mapsto">
  <fo:inline font-family="ArialUnicodeMS">&rarrowb;</fo:inline>
</xsl:template>

<!--
    Set union symbol (setunion)
-->
<xsl:template match="setunion">
  <fo:inline font-family="ArialUnicodeMS">&setunion;</fo:inline>
</xsl:template>

<!--
    Right arrow (rtarr) 
-->
<xsl:template match="rtarr">
  <fo:inline font-family="ArialUnicodeMS">&rarrow;</fo:inline>
</xsl:template>

<!--
    Double right arrow (dblrtarr)
-->
<xsl:template match="dblrtarr">
  <fo:inline font-family="ArialUnicodeMS">&dblrtarr;</fo:inline>
</xsl:template>

<!--
    Double left arrow (dblltarr)
-->
<xsl:template match="dblltarr">
  <fo:inline font-family="ArialUnicodeMS">&dblltarr;</fo:inline>
</xsl:template>

<!--
    Double left-right arrow (dblltrtarr)
-->
<xsl:template match="dblltrtarr">
  <fo:inline font-family="ArialUnicodeMS">&dblltrtarr;</fo:inline>
</xsl:template>

<!--
    Right curly bracket upper hook (rcbuh)
-->
<xsl:template match="rcbuh">
  <fo:inline font-family="DejaVuSans">&rcbuh;</fo:inline>
</xsl:template>

<!--

    Right curly bracket lower hook (rcblh)
-->
<xsl:template match="rcbmp">
  <fo:inline font-family="DejaVuSans">&rcbmp;</fo:inline>
</xsl:template>

<!--
    Right curly bracket middle part (rcbmp)
-->
<xsl:template match="rcblh">
  <fo:inline font-family="DejaVuSans">&rcblh;</fo:inline>
</xsl:template>

<!--
    Curly bracket extension (cbe) 
-->
<xsl:template match="cbe">
  <fo:inline font-family="DejaVuSans">&cbe;</fo:inline>
</xsl:template>

<!--
    Greek lower-case omega (omega) 
-->
<xsl:template match="omega">
  <fo:inline font-family="ArialUnicodeMS">&omega;</fo:inline>
</xsl:template>

<!--
    Infinity symbol (infinity)
-->
<xsl:template match="infinity">
  <fo:inline font-family="ArialUnicodeMS">&infinity;</fo:inline>
</xsl:template>

<!--
    dot operator symbol (dotOp)
-->
<xsl:template match="dotOp">
  <fo:inline font-family="ArialUnicodeMS" alignment-baseline="central">&sdot;</fo:inline>
</xsl:template>

<!--
    subset operator symbol (subset)
-->
<xsl:template match="subset">
  <fo:inline font-family="ArialUnicodeMS" alignment-baseline="central">&subset;</fo:inline>
</xsl:template>

<!--
    forall operator symbol (forall)
-->
<xsl:template match="forall">
  <fo:inline font-family="ArialUnicodeMS" alignment-baseline="central">&forall;</fo:inline>
</xsl:template>

<!--
    exists operator symbol (exists)
-->
<xsl:template match="exists">
  <fo:inline font-family="ArialUnicodeMS" alignment-baseline="central">&exists;</fo:inline>
</xsl:template>

<!--
    element operator symbol (element)
-->
<xsl:template match="element">
  <fo:inline font-family="ArialUnicodeMS" alignment-baseline="central">&element;</fo:inline>
</xsl:template>

<!--
    vector or cross product symbol (crossProd)
-->
<xsl:template match="crossProd">
  <fo:inline font-family="{$font-name}"
             alignment-baseline="central">&cp;</fo:inline>
</xsl:template>

<!--
    Concatenation symbol (concat)
-->
<xsl:template match="concat">
  <fo:inline font-family="{$codefont-name}">||</fo:inline>
</xsl:template>

<!--
    ie => i.e.,
-->
<xsl:template match="ie">
  <fo:inline keep-together="always">
    <xsl:text>i.e.,</xsl:text>
  </fo:inline>
</xsl:template>

<!--
    eg => e.g.,
-->
<xsl:template match="eg">
  <fo:inline keep-together="always">
    <xsl:text>e.g.,</xsl:text>
  </fo:inline>
</xsl:template>

<!--
    etc => etc.
-->
<xsl:template match="etc">
  <fo:inline keep-together="always">
    <xsl:text>etc.</xsl:text>
  </fo:inline>
</xsl:template>

<!--
    cf => cf.
-->
<xsl:template match="cf">
  <fo:inline keep-together="always">
    <xsl:text>cf.</xsl:text>
  </fo:inline>
</xsl:template>

<!--
    vs => vs.
-->
<xsl:template match="vs">
  <fo:inline keep-together="always">
    <xsl:text>vs.</xsl:text>
  </fo:inline>
</xsl:template>


<!-- =================================================================================== -->
<!-- Templates to process elements that format text                                      -->
<!-- =================================================================================== -->


<!--
    Emphasis/Italics (emph)
-->
<xsl:template match="emph">
  <fo:inline font-style="italic">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Boldface (bold)
-->
<xsl:template match="bold">
  <fo:inline font-weight="bold">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Underlined (underline)
-->
<xsl:template match="underline">
  <fo:inline text-decoration="underline">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Struck-through (strikethrough)
-->
<xsl:template match="strikethrough">
  <fo:inline text-decoration="line-through">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Mark as to be inserted (mark-inserted)
-->
<xsl:template match="mark-inserted">
  <fo:inline color="red" font-weight="bold">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Mark as to be deleted (mark-deleted)
-->
<xsl:template match="mark-deleted">
  <fo:inline color="darkblue" text-decoration="line-through">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Unicode character by Unicode value (unicode)
-->
<xsl:template match="unicode">
  <fo:inline>
    <xsl:text>U+</xsl:text>
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Punctuation apostrophe
-->
<xsl:template match="apos">
  <xsl:text>&rsquo;</xsl:text>
</xsl:template>

<!--
    Prime
-->
<xsl:template match="prime">
  <xsl:text>&prime;</xsl:text>
</xsl:template>

<!--
    Spc
-->
<xsl:template match="spc">
  <fo:leader leader-length="{$space.thinspace.width}"/>
</xsl:template>

<!--
    SQL
-->
<xsl:template match="SQL">
  <xsl:text>SQL</xsl:text>
</xsl:template>

<!--
    Text quoted with double turned comma quotation marks
-->
<xsl:template match="quote">
  <xsl:text>&ldquo;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&rdquo;</xsl:text>
</xsl:template>

<!--
    Text quoted with single turned comma quotation marks
-->
<xsl:template match="squote">
  <xsl:text>&lsquo;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&rsquo;</xsl:text>
</xsl:template>

<!--
    Text representing a character string in a language that uses single quotes
-->
<xsl:template match="string">
  <xsl:text>&apos;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&apos;</xsl:text>
</xsl:template>

<!--
    Text representing a character string in a language that uses double quotes
-->
<xsl:template match="stringd">
  <xsl:text>&quot;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>&quot;</xsl:text>
</xsl:template>

<!--
    Text representing a delimited identifier
-->
<xsl:template match="delimId">
  <xsl:variable name="delimIdQuote">
    <xsl:choose>
      <xsl:when test="$standardNumber='39075'">&grave;</xsl:when>
      <xsl:otherwise>&quot;</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:value-of select="$delimIdQuote"/>
  <xsl:apply-templates/>
  <xsl:value-of select="$delimIdQuote"/>
</xsl:template>

<!--
    In-line code excerpts (mono)
    2021-08-01: Jim Melton changed "9pt" to "85%"
-->
<xsl:template match="mono">
  <fo:inline
    font-family="{$codefont-name}" 
    font-size="85%" xml:space="preserve"><xsl:apply-templates/></fo:inline>
</xsl:template>

<!--
    In-line host programming language code excerpts (hosttext)
    2021-08-01: Jim Melton changed "9pt" to "85%"
-->
<xsl:template match="hosttext">
  <fo:inline
    font-family="{$codefont-name}" 
    font-size="85%" xml:space="preserve"><xsl:apply-templates/></fo:inline>
</xsl:template>

<xsl:template match="raise">
  <fo:inline font-style="italic">
    <xsl:choose>
<!-- ================================================================ -->
<!-- This case is prohibited by the DTD and is not strictly necessary -->
<!-- ================================================================ -->
      <xsl:when test="@subclass and not(@class)">
        <xsl:variable name="subClass" select="@subclass"/>
<!-- LINE LENGTH CHECK OFF -->
        <xsl:call-template name="ProcessError">
          <xsl:with-param name="ErrorText">A raise element with a subclass attribute but no class attribute was found: %s1</xsl:with-param>
          <xsl:with-param name="ErrorValue1" select="$subClass"/>
        </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
      </xsl:when>
      <xsl:when test="@class and not(@subclass)">
        <xsl:variable name="parentClass" select="@class"/>
        <xsl:choose>
          <xsl:when test="not($Conditions/class[@code=$parentClass])">
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">A raise element has been encountered with an @class (%s1) that is not defined in conditions.xml</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$parentClass"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:when>
          <xsl:when 
            test="not($Conditions/class[@code=$parentClass]/usedIn[@standard=$standardNumber and
              not(@status='O')])">
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">A raise element has been encountered with an @class (%s1) that is not valid for standard %s2 in conditions.xml</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$parentClass"/>
              <xsl:with-param name="ErrorValue2" select="$standardNumber"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="class-key" select="$Conditions/class[@code=$parentClass]/name"/>
            <fo:inline id="{generate-id(./@class)}" index-key="{$class-key}">
              <xsl:value-of select="$Conditions/class[@code=$parentClass]/name"/>
              <xsl:text> (</xsl:text>
              <xsl:value-of select="$parentClass"/>
              <xsl:text>000)</xsl:text>
            </fo:inline>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="parentClass" select="@class"/>
        <xsl:variable name="subClass" select="@subclass"/>
        <xsl:choose>
<!-- Determine whether this @class/@subclass combo exists in conditions.xml -->
          <xsl:when test="not($Conditions/class[@code=$parentClass])">
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">A raise element has been encountered with an @class (%s1) that is not defined in conditions.xml</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$parentClass"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:when>
          <xsl:when 
            test="not($Conditions/class[@code=$parentClass]/usedIn[@standard=$standardNumber and
             not(@status='O')])">
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">A raise element has been encountered with an @class (%s1) that is not valid for standard %s2 in conditions.xml</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$parentClass"/>
              <xsl:with-param name="ErrorValue2" select="$standardNumber"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:when>
          <xsl:when test="not($Conditions/class[@code=$parentClass]/subclass[@code=$subClass])">
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">A raise element has been encountered with an @class that is defined in conditions.xml: %s1 , but a @subclass that is not: %s2</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$parentClass"/>
              <xsl:with-param name="ErrorValue2" select="$subClass"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:when>
          <xsl:when test="not($Conditions/class[@code=$parentClass]/subclass[@code=$subClass]/
            usedIn[@standard=$standardNumber and not(@status='O')])">)">
<!-- LINE LENGTH CHECK OFF -->
            <xsl:call-template name="ProcessError">
              <xsl:with-param name="ErrorText">A raise element has been encountered with an @class (%s1) that is defined in conditions.xml, but a @subclass (%s2) that is not valid for standard %s3</xsl:with-param>
              <xsl:with-param name="ErrorValue1" select="$parentClass"/>
              <xsl:with-param name="ErrorValue2" select="$subClass"/>
              <xsl:with-param name="ErrorValue3" select="$standardNumber"/>
            </xsl:call-template>
<!-- LINE LENGTH CHECK ON -->
          </xsl:when>
          <xsl:otherwise>
            <xsl:variable name="class-key" select="$Conditions/class[@code=$parentClass]/name"/>
            <xsl:variable name="subclass-key"
                          select="$Conditions/class[@code=$parentClass]/
                                    subclass[@code=$subClass]/name"/>
            <fo:inline id="{generate-id(./@class)}" index-key="{$class-key}">
              <xsl:value-of
                select="$Conditions/class[@code=$parentClass]/name"/>
            </fo:inline>
            <xsl:text> &mdash; </xsl:text>
            <fo:inline id="{generate-id(./@subclass)}" index-key="{$subclass-key}">
              <xsl:value-of
                select="$Conditions/class[@code=$parentClass]/subclass[@code=$subClass]/name"/>
            </fo:inline>
            <xsl:text> (</xsl:text>
            <xsl:value-of select="$parentClass"/>
            <xsl:value-of select="$subClass"/>
            <xsl:text>)</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </fo:inline>
</xsl:template>

<!--
    Boolean values (bool)
-->
<xsl:template match="bool">
  <fo:inline font-style="italic" text-decoration="underline">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Subscript values (sub)
-->
<xsl:template match="sub">
  <fo:inline baseline-shift="sub" font-size="smaller">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    Superscript values (super)
-->
<xsl:template match="super">
  <fo:inline baseline-shift="super" font-size="smaller">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>

<!--
    In-line material with a box drawn around it (box)
-->
<xsl:template match="box">
  <fo:inline border-style="solid" border-color="black" border-width="0.5pt" padding-before="1pt"
             padding-after="0.9pt" padding-start="0.9pt" padding-end="0.9pt">
    <xsl:apply-templates/>
  </fo:inline>
</xsl:template>


<!--
    impDef
-->
<xsl:template match="impDef">
  <xsl:choose>
    <xsl:when test="@cap">
      <xsl:text>Implemen&shy;tation-defined</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>implemen&shy;tation-defined</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="not(@annex)">
    <fo:basic-link color="#000070">
      <xsl:attribute name="internal-destination">
        <xsl:text>'impDef_</xsl:text>
        <xsl:value-of select="@code"/>
        <xsl:text>'</xsl:text>
      </xsl:attribute>
      <xsl:text> (</xsl:text>
      <xsl:value-of select="@code"/>
      <xsl:text>)</xsl:text>
    </fo:basic-link>
  </xsl:if>
</xsl:template>


<!--
    unDef
-->
<xsl:template match="unDef">
  <xsl:choose>
    <xsl:when test="@cap">
      <xsl:text>Implemen&shy;tation-dependent</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>implemen&shy;tation-dependent</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:if test="not(@annex)">
    <fo:basic-link color="#000070">
      <xsl:attribute name="internal-destination">
        <xsl:text>'unDef_</xsl:text>
        <xsl:value-of select="@code"/>
        <xsl:text>'</xsl:text>
      </xsl:attribute>
      <xsl:text> (</xsl:text>
      <xsl:value-of select="@code"/>
      <xsl:text>)</xsl:text>
    </fo:basic-link>
  </xsl:if>
</xsl:template>

<xsl:template match="lt">
  <xsl:text>&lt;</xsl:text>
</xsl:template>

<xsl:template match="gt">
  <xsl:text>&gt;</xsl:text>
</xsl:template>

<!--
    Error Processing
    The template ProcessError sends the errormessage in "ErrorText" to the terminal 
    and places it in big red letters in the pdf.
    Parameters:
    ErrorText: Text for the errormessage
    ErrorValue1: Replaces the token %s1 in the error message.
    ErrorValue2: Replaces the token %s2 in the error message.
    ErrorValue3: Replaces the token %s3 in the error message.
    ErrorValue4: Replaces the token %s4 in the error message.
-->
<xsl:template name="ProcessError">
  <xsl:param name="ErrorText"/>
  <xsl:param name="ErrorValue1"/>
  <xsl:param name="ErrorValue2"/>
  <xsl:param name="ErrorValue3"/>
  <xsl:param name="ErrorValue4"/>
  
  <xsl:variable name="errtxt" select="$ErrorText"/>

  <xsl:variable name="errval1">
    <xsl:choose> 
      <xsl:when test="$ErrorValue1=''"> 
       ' '
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="$ErrorValue1"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="errval2">
    <xsl:choose> 
      <xsl:when test="$ErrorValue2=''"> 
       ' '
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="$ErrorValue2"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="errval3">
    <xsl:choose> 
      <xsl:when test="$ErrorValue3=''"> 
       ' '
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="$ErrorValue3"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="errval4">
    <xsl:choose> 
      <xsl:when test="$ErrorValue4=''"> 
      ' '
      </xsl:when>
      <xsl:otherwise>
       <xsl:value-of select="$ErrorValue4"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="errtxt" 
                    select="replace (replace (replace (replace ($errtxt, '%s1', $errval1),
                                                                         '%s2', $errval2),
                                                                         '%s3', $errval3),
                                                                         '%s4', $errval4)"/>



  <xsl:message>
    <xsl:text>ERROR: </xsl:text><xsl:value-of select="$errtxt"/>
  </xsl:message>
  <fo:inline font-size="18pt" font-weight="bold" color="red">
    <xsl:text>Error: </xsl:text><xsl:value-of select="$errtxt"/>
  </fo:inline>
</xsl:template>



<!-- These templates are handled in an early phase.
<xsl:template match="conformanceSummary">
</xsl:template>


<xsl:template match="impDefSummary">
</xsl:template>


<xsl:template match="unDefSummary">
</xsl:template>
-->

<!--
<xsl:template match="NewTemplate">
</xsl:template>
-->

<!--
    KNOWN BUGS IN THIS STYLESHEET (TO BE RESOLVED WHEN FEASIBLE)

* When a <mergeInstr> references a <table> having a <tableTitle> that contains
  a <BNF> that has an @part="xx" attribute, the XSL FO code produced by that
  <mergeInstr> contains an <fo:basic-link> with an *internal-destination* that
  presumes to reference a "local" (in this document) <BNFdef> for the BNF
  non-terminal symbol, even if there is no such local <BNFdef>.  The XSLT code
  for <mergeInstr> must be fixed to correctly generate an *external-destination*
  for such <BNF> references.  For an example, see SQL/PGQ, Subclause 15.1, 
  "<get diagnostics statement>", SR 1), which references Table 2, the <tableTitle>
  of which is encoded thus:
  <tableTitle><BNF name="condition information item name"/>s for use with 
  <BNF name="get diagnostics statement" part="02"/></tableTitle>

* When a document's Editor Notes of one standard reference a BNF nonterminal symbol
  that is defined in a part of a *different* standard, the new indexing code
  reports that we're attempting to index a term that does not appear in the standard
  being compiled. 

-->

</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2008. Progress Software Corporation. All rights reserved.

<metaInformation>
  <scenarios/>
  <MapperMetaTag>
    <MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
    <MapperBlockPosition></MapperBlockPosition>
    <TemplateContext></TemplateContext>
    <MapperFilter side="source"></MapperFilter>
  </MapperMetaTag>
</metaInformation>
-->