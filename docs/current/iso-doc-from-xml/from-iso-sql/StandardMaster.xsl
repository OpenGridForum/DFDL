<?xml version='1.0' encoding='UTF-8'?>
<!--
                                                                                                   1
         1         2         3         4         5         6         7         8         9         0
1234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
-->

<!--
     Copyright © 1999, 2000, 2002, 2005, 2010, 2028, 2019, 2020, 2021 Jim Melton
     Copyright © 2021 Editors of ISO/IEC JTC 1/SC 32/WG 3:
                 Jim Melton, Stephen Cannan, Jörn Bartels, Stefan Plantikow
                 (Granted by Jim Melton, 2021-10-21)
-->

<!-- 
====================================================================================================
StandardMaster.xsl
  Sets up everything for (parts) of standards, technical reports, and technical specifications
  maintained by WG3.
Version 1.10 - - 2021-08-25
  Active effort to document started 2021-08-25 by Jim Melton
====================================================================================================

====================================================================================================

This stylesheet renders the standard documents into XSL Formatting Objects (XSL-FO), suitable
for rendering into printable formats, such as PDF.

It presumes an XSLT 2.0 processing engine, but does not require XML schema awareness.

XSL FO version taken into account (XSL 1.1):
    http://www.w3.org/TR/2006/REC-xsl11-20061205/
XSLT version required (XSLT 2.0):
    https://www.w3.org/TR/2021/REC-xslt20-20210330/

    Author: Jim Melton

    © Oracle Corp., 2002, 2004, 2006
    © Jim Melton, 2020, 2021

====================================================================================================

====================================================================================================
CHANGE HISTORY:
Earliest versions:    (lost in history): Jim Melton; 2001-??-??
Up to date with DTD v0.7         (v0.7): Jim Melton; 2003-04-19
Fixed various spacing errors   (v0.7.1): Jim Melton; 2003-04-21
Generation of Annex A          (v0.7.2): Jim Melton; 2003-04-27
Miscellaneous fixes            (v0.7.3): Jim Melton; 2003-06-15
Editor Notes (PPs, LOs)          (v0.8): Jim Melton; 2003-12-11
Technical Corrigenda   (v0.9): S. Cannan/Jim Melton; 2004-02-20
Add para references             (v0.91): Jim Melton; 2004-05-01
Split standard+TC XSLT   (v0.92): J.Melton/S.Cannan; 2004-05-25
Declare V1.0              (v1.0): J.Melton/S.Cannan; 2004-05-28
Fix page header/footer          (v1.01): Jim Melton; 2004-06-24
Add Associate Editor support    (v1.02): Jim Melton; 2004-10-01
Global var w/all features       (v1.03): Jim Melton; 2009-01-14
Support alt copyrt page INCITS  (v1.04): Jim Melton; 2011-05-12
Get rid of blank (left) pages per ISO/CS
                                (V1.05): Jim Melton; 2019-02-22
Add render-phrase-links        (V1.06): S.Plantikow; 2020-02-17
Add figure-dir variable        (V1.07): S.Plantikow; 2021-08-04
Improve internal documentation  (V1.10): Jim Melton; 2021-08-25
Turn off bnf elts listing      (v1.11): S.Plantikow; 2022-03-23
Center headers and footers     (v1.12): S.Plantikow; 2024-01-05
=================================================================================================== 
-->


<!DOCTYPE xsl:stylesheet [
  <!-- Include the definition of character entities -->
  <!-- This file has no official standing; Jim found it in 2001 by
       searching for a starting point for character entity defs.     -->
  <!ENTITY % winansi SYSTEM "./winansi.entities">
  %winansi;
]>

<xsl:stylesheet version="3.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format">

<xsl:output method="xml"
            version="1.0"
            indent="no"
            encoding="UTF-8"/>


<!--
===================================================================================================
===================================================================================================
The following stylesheet parameter declarations determine how the document will be compiled
===================================================================================================
===================================================================================================
-->

<!--
===================================================================================================
Define a global variable to know whether the transformation should or should not render comments 
into the resulting PDF
===================================================================================================
-->
<xsl:param name="render-comments" required="no" select="'no'"/>


<!--
===================================================================================================
Define a global variable to know whether the transformation should or should not render 
phrase links into the resulting PDF
===================================================================================================
-->
<xsl:param name="render-phrase-links" required="no" select="'yes'"/>


<!--
===================================================================================================
Define a global variable to know whether the transformation should or should not include a list of 
BNF elements in the resulting PDF
===================================================================================================
-->
<xsl:param name="list-bnf-elements" required="no" select="'no'"/>
  

<!--
===================================================================================================
===================================================================================================
The following key declarations improve the performance of document compilation.
Keys are defined by the XSLT Recommendation and are used only for XSLT processing.
===================================================================================================
===================================================================================================
-->

<!--
=================================================================================================== 
 Define the principal key for this transformation
=================================================================================================== 
-->
<!--
    The 'generic-id' key matches all elements having an id attribute, based on the values of the 
    elements' id attributes
-->
<xsl:key name="generic-id" match="*[@id]" use="@id"/>


<!--
===================================================================================================
===================================================================================================
The following global variable declarations hold information extracted from 'external' files,
meaning files that are not directly a part of any document being compiled.
===================================================================================================
===================================================================================================
-->

<!--
===================================================================================================
standardParts.xml is a file that contains compilation information about all WG 3 standards (etc.)
This information is required to compile a specific instance of a document. 
Consequently, this file is updated frequently. 
===================================================================================================
-->
<xsl:variable name="parts"
              select="document('standardParts.xml')/parts/standard"/>

<!--
=================================================================================================== 
 Define a global variable to hold Feature ID ("number") and Feature Name (text) information.
 The file features.xml contains a list of every feature defined by every WG 3 standard,
 including the feature ID and the natural language term ("name") describing that feature. 
 The feature IDs are normative, meaning that they must be used whenever implementations of the
 relevant standard claim conformance to a particular feature of that standard. 
=================================================================================================== 
-->
<xsl:variable name="Features"
              select="document('features.xml')/features"/>

<!--
=================================================================================================== 
 Define a global variable to hold Condition (class and subclass) Codes
 The file conditions.xml contains a list of every condition code (class code and subclass code)
 defined by every WG 3 standard, including the code value (two or three characters) and name.
 The condition code values are normative, meaning that they must be used whenever a conforming
 implementation of the relevant standard reports the relevant condition; the names defined are
 not normative, but are included to assist readers and implementers of the relevant standard. 
=================================================================================================== 
-->
<xsl:variable name="Conditions"
              select="document('conditions.xml')/conditions"/>

<!--
=================================================================================================== 
 Define a global variable to hold the markup for all referenced documents
 The file ReferencedDocuments identifies every document that is referenced, either in Clause 2,
 "Normative references", or in the Bibliography, of every WG 3 document.
 This file provides information used to properly format all such normative or bibliographic
 references. 
=================================================================================================== 
-->
<xsl:variable name="ReferencedDocuments"
              select="document('referencedDocuments.xml')/ReferencedDocuments/*"/>

<!--
===================================================================================================
===================================================================================================
The following global variable declarations hold details of the document being built and its status
===================================================================================================
===================================================================================================
-->

<!--
===================================================================================================
standardNumber is limited to values '9075', '19075', and '39075'; '29075' is planned
===================================================================================================
-->
<xsl:variable name="standardNumber" select="/standard/@standard"/>

<!--
===================================================================================================
Valid values of partno are determined by the value of standardNumber
===================================================================================================
-->
<xsl:variable name="partno" select="/standard/@partNumber2digit"/>

<!--
===================================================================================================
Valid values of implementable are 'yes' and 'no'
This global variable is used when determining the value of two other global variables:
ReservedWords and NonReservedWords
===================================================================================================
-->
<xsl:variable name="implementable" select="/standard/@implementable"/>

<!--
===================================================================================================
In order to determine whether a sequence of characters marked up using <kw>...</kw> is actually
a defined keyword, we need to know where to find its definition...which standard and which part
of that standard.
===================================================================================================
-->
<xsl:variable name="keywordsFromStandard">
  <xsl:choose>
    <xsl:when test="/standard/@keywordFromStandard">
      <xsl:value-of select="/standard/@keywordFromStandard"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>xxx</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="keywordsFromPart">
  <xsl:choose>
    <xsl:when test="/standard/@keywordFromPart">
      <xsl:value-of select="/standard/@keywordFromPart"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>xxx</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!--
===================================================================================================
The value of docYear states the actual or expected publication date of the eventual standard,
technical report, or technical specification in which the document being compiled participates
===================================================================================================
-->
<xsl:variable name="docYear">
  <xsl:choose>
    <xsl:when
      test="document('standardParts.xml'
                     )/parts/standard[@number=$standardNumber]/part[@number=$partno]/@docYear">
      <xsl:value-of
        select="document('standardParts.xml'
                    )/parts/standard[@number=$standardNumber]/part[@number=$partno]/@docYear"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of
        select="document('standardParts.xml')/parts/standard[@number=$standardNumber]/@docYear"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!--
===================================================================================================
The value of documentSubtype is a phrase used in the ISO/IEC (JTC 1) Directives, Part 1,
indicating the type of document (e.g., International Standard) and its current stage (e.g.,
Working Draft). 
Valid values are defined in StandardParts.dtd and are not identical to the wording in the
Directives, but have some extended information incorporated. 
===================================================================================================
-->
<xsl:variable name="documentSubtype">
  <xsl:choose>
    <xsl:when
      test="document('standardParts.xml')/
            parts/standard[@number=$standardNumber]/part[@number=$partno]/@documentSubtype">
      <xsl:value-of
        select="document('standardParts.xml')/
                parts/standard[@number=$standardNumber]/part[@number=$partno]/@documentSubtype"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of
        select="document('standardParts.xml')/
                parts/standard[@number=$standardNumber]/@documentSubtype"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!--
===================================================================================================
The value of formatStage is a term used in the ISO/IEC (JTC 1) Directives, Part 1,
indicating the current stage of processing of the document being compiles. 
It incorporates the first digit of the ISO Stage Code with additional text for clarification.
Valid values are defined in StandardParts.dtd 
===================================================================================================
-->
<xsl:variable name="formalStage">
  <xsl:choose>
    <xsl:when
      test="document('standardParts.xml')/
            parts/standard[@number=$standardNumber]/part[@number=$partno]/@formalStage">
      <xsl:value-of
        select="document('standardParts.xml')/
                parts/standard[@number=$standardNumber]/part[@number=$partno]/@formalStage"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of
        select="document('standardParts.xml')/
                parts/standard[@number=$standardNumber]/@formalStage"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!--
===================================================================================================
The value of docStage is a term used in the ISO/IEC (JTC 1) Directives, Part 1,
indicating the current stage of processing of the document being compiles. 
It is a natural language version of the value of formalStage 
===================================================================================================
-->
<xsl:variable name="docStage">
  <xsl:choose>
    <xsl:when
      test="document('standardParts.xml')/ 
            parts/standard[@number=$standardNumber]/part[@number=$partno]/@docStage">
      <xsl:value-of
        select="document('standardParts.xml')/
                parts/standard[@number=$standardNumber]/part[@number=$partno]/@docStage"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of
        select="document('standardParts.xml')/parts/standard[@number=$standardNumber]/@docStage"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!--
===================================================================================================
The value of docName is the filename (less filename extension) that must be given to the
distributed version of the PDF file containing the compiled document. 
"Hot links" between documents depend on the PDF files having this name. 
===================================================================================================
-->
<xsl:variable name="docName">
  <xsl:value-of 
    select="document('standardParts.xml')/
            parts/standard[@number=$standardNumber]/part[@number=$partno]/@output"/>
</xsl:variable>

<!--
===================================================================================================
The value of isoNumber is the number of the standard (technical report, etc.) to which the
document being compiled belongs and, if the document is a part of a multi-part standard (etc.),
a hyphen and the part number without leading zeros.
===================================================================================================
-->
<xsl:variable name="isoNumber"
              select="/standard/@isoNumber"/>

<!--
===================================================================================================
The value of docNumber is for an IWD a concatenation of the values of docStage, isoNumber, 
and docYear, with required punctuation and white space included.  For other stages it is 
a concatenation of the values of 'ISO/IEC', isoNumber, and docYear, with required punctuation 
and white space included. 
It is suitable for printing in the document.
===================================================================================================
-->
<xsl:variable name="docNumber">
  <xsl:choose>
    <xsl:when
      test="substring-after($formalStage, '-')='20'">
      <xsl:value-of
        select="concat($docStage, '&nbsp;', $isoNumber, ':', $docYear, '(en)')"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of
        select="concat('ISO/IEC', '&nbsp;', $isoNumber, ':', $docYear, '(en)')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
<!--
===================================================================================================
The value of docLanguage is the official name of the language in which the document is published.
This value is normally 'English' for all JTC 1 documents. 
===================================================================================================
-->
<xsl:variable name="docLanguage"
              select="/standard/@documentLanguage"/>

<!--
=================================================================================================== 
 Define a global variable to hold all <raise> element nodes in the current document
 NOTE: This variable contains the actual <raise> nodes, not string values, etc.
=================================================================================================== 
-->
<xsl:variable name="allRaises"
              select="/standard//raise[not(class | subclass)]"/>

<!--
==================================================================================================
 Global variable to hold the list of all <non-reserved word>s 9075-2 (sql-foundation)
==================================================================================================
-->
<xsl:variable name="NonReservedWords9075-2">
  <xsl:if test="$keywordsFromStandard = '9075' or not($keywordsFromStandard)">
    <xsl:for-each select="$parts[@number='9075']/part[@number = '02']">
      <xsl:variable name="partnum" select="@number"/>
      <xsl:variable name="filename" select="@input"/>
      <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
<!-- Append every reserved word in Foundation to the variable containing
     reserved words, with a space separating those reserved words from one another -->
      <xsl:for-each
        select="$extroot/standard//BNFdef[@name='non-reserved word']//kw">
        <xsl:text> </xsl:text>
        <xsl:value-of select="./text()"/>
        <xsl:text> </xsl:text>
      </xsl:for-each>
    </xsl:for-each>
  </xsl:if>
</xsl:variable>

<!--
==================================================================================================
 Global variable to hold the list of all <reserved word>s in all parts of the specified standard
==================================================================================================
-->
<xsl:variable name="ReservedWords">
  <xsl:choose>
<!-- If "this" is an implementable standard, such as 9075,
     then get keywords from "this" part and those cited in allAltsFrom -->
    <xsl:when test="$implementable='yes' or not($implementable)">
<!-- get a sequence of 2-digit strings representing the numbers of parts
     from which alternatives are to be imported -->
      <xsl:variable name="alternativesFrom"
                    select="//standard//BNFdef[@name='reserved word' or
                                                  @name='pre-reserved word']//
                            allAltsFrom/format-number(@part, '0')"/>
<!-- The initial space in $ReservedWords is required; it makes searching the contents
     of the variable easier. -->
      <xsl:text> </xsl:text>
<!-- For every part of "this" standard that is either "this" part or a part that
     is specified in an <allAltsFrom part=XX"/> element (but that is not a TC part),
     identify the part number and the associated filename, and construct the filename. -->
      <xsl:for-each select="$parts[@number=$standardNumber]/
                            part[@number = $partno or
                                 (string-length(@number) != 5 and
                                  not(empty(index-of($alternativesFrom, 
                                                     format-number(@number, '0')))) and
                                 (@TC != 'true' or not(@TC)))]">
        <xsl:variable name="partnum" select="@number"/>
        <xsl:variable name="filename" select="@input"/>
        <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
<!-- In each relevant part in turn, append every reserved word to the variable containing
     reserved words, with a space separating those reserved words from one another -->
        <xsl:for-each
          select="$extroot/standard//BNFdef[@name='reserved word' or
                                               @name='pre-reserved word']//kw">
          <xsl:text> </xsl:text>
          <xsl:value-of select="./text()"/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:when>
<!-- If "this" standard is NOT an implementable standard, such as 9075 (e.g., 19075),
     then get keywords from the standard cited in @keywordsFromStandard, from all
     part(s) cited in @keywordFromPart -->
    <xsl:otherwise>
<!-- For every part of the standard identified in @keywordsFromStandard that is a part that
     is specified in an <allAltsFrom part=XX"/> element (but that is not a TC part),
     identify the part number and the associated filename, and construct the filename. -->
      <xsl:for-each select="$parts[@number=$keywordsFromStandard]/
                            part[(string-length(@number) != 5 and
                                  contains($keywordsFromPart, @number) and
                                 (@TC != 'true' or not(@TC)))]">
        <xsl:variable name="partnum" select="@number"/>
        <xsl:variable name="filename" select="@input"/>
        <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
<!-- In each relevant part in turn, append every reserved word to the variable containing
     reserved words, with a space separating those reserved words from one another -->
        <xsl:for-each
           select="$extroot/standard//BNFdef[@name='reserved word' or
                                                @name='pre-reserved word']//kw">
          <xsl:text> </xsl:text>
          <xsl:value-of select="./text()"/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!--
==================================================================================================
 Global variable to hold a list of all <non-reserved word>s in all parts of the specified standard
==================================================================================================
-->
<xsl:variable name="NonReservedWords">
<!-- get a sequence of 2-digit strings representing the numbers of parts
     from which alternatives are to be imported -->
  <xsl:choose>
<!-- If "this" is an implementable standard, such as 9075,
     then get keywords from "this" part and those cited in allAltsFrom -->
    <xsl:when test="$implementable='yes' or not($implementable)">
<!-- get a sequence of 2-digit strings representing the numbers of parts
     from which alternatives are to be imported -->
      <xsl:variable name="alternativesFrom"
                    select="//standard//BNFdef[@name='non-reserved word']//
                            allAltsFrom/format-number(@part, '0')"/>
<!-- The initial space in $NonReservedWords is required; it makes searching the contents
     of the variable easier. -->
      <xsl:text> </xsl:text>
<!-- For every part of "this" standard that is either "this" part or a part that
     is specified in an <allAltsFrom part=XX"/> element (but that is not a TC part),
     identify the part number and the associated filename, and construct the filename. -->
      <xsl:for-each select="$parts[@number=$standardNumber]/
                            part[@number = $partno or
                                 (string-length(@number) != 5 and
                                  not(empty(index-of($alternativesFrom, 
                                                     format-number(@number, '0')))) and
                                 (@TC != 'true' or not(@TC)))]">
        <xsl:variable name="partnum" select="@number"/>
        <xsl:variable name="filename" select="@input"/>
        <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
<!-- In each relevant part in turn, append every reserved word to the variable containing
     reserved words, with a space separating those reserved words from one another -->
        <xsl:for-each
           select="$extroot/standard//BNFdef[@name='non-reserved word']//kw">
          <xsl:text> </xsl:text>
          <xsl:value-of select="./text()"/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:when>
<!-- If "this" standard is NOT an implementable standard, such as 9075 (e.g., 19075),
     then get keywords from the standard cited in @keywordsFromStandard, from all
     part(s) cited in @keywordFromPart -->
    <xsl:otherwise>
<!-- For every part of the standard identified in @keywordsFromStandard that is a part that
     is specified in an <allAltsFrom part=XX"/> element (but that is not a TC part),
     identify the part number and the associated filename, and construct the filename. -->
      <xsl:for-each select="$parts[@number=$keywordsFromStandard]/
                            part[(string-length(@number) != 5 and
                                  contains($keywordsFromPart, @number) and
                                 (@TC != 'true' or not(@TC)))]">
        <xsl:variable name="partnum" select="@number"/>
        <xsl:variable name="filename" select="@input"/>
        <xsl:variable name="extroot" select="document(concat($filename, '.xml'))"/>
<!-- In each relevant part in turn, append every non-reserved word to the variable containing
     non-reserved words, with a space separating those non-reserved words from one another -->
        <xsl:for-each
           select="$extroot/standard//BNFdef[@name='non-reserved word']//kw">
          <xsl:text> </xsl:text>
          <xsl:value-of select="./text()"/>
          <xsl:text> </xsl:text>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!--
=================================================================================================== 
The value of provisional-copyright is either a zero-length string (implying that the document
being compiled does not [yet?] have a copyright) or it contains the required ISO copyright and date
=================================================================================================== 
-->
<xsl:variable name="provisional-copyright">
  <xsl:choose>
    <xsl:when test="substring-after($formalStage, '-')='20' or
                    substring-after($formalStage, '-')='30'">
      <xsl:text></xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> &copy; ISO/IEC </xsl:text>
        <xsl:value-of select="$docYear"/>
        <xsl:text> </xsl:text><xsl:text>&ndash;</xsl:text><xsl:text> All rights reserved</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!--
=================================================================================================== 
The value of acknowledge-renderx is either 'yes' or 'no'
RenderX is the company who provided free-of-charge copies of their XSL FO rendering engine, XEP,
for use in producing WG 3 standards in exchange for an acknowledgement on all non-ballot documents.
=================================================================================================== 
-->
<xsl:variable name="acknowledge-renderx">
  <xsl:choose>
    <xsl:when test="substring-after($formalStage, '-')='20'">
      <xsl:text>yes</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>no</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!--
=================================================================================================== 
 Define global variables to hold the <showmath> elements containing all equations in the document
=================================================================================================== 
-->
<xsl:variable name="equation-basic-filename">
  <xsl:value-of select="document('standardParts.xml')/
                        parts/standard[@number=$standardNumber]/part[@number=$partno]/@input"/>
</xsl:variable>
              
<xsl:variable name="BlockEquations"
              select="document(concat($equation-basic-filename, '_equations-block.xml'))"/>

<xsl:variable name="InlineEquations"
              select="document(concat($equation-basic-filename, '_equations-inline.xml'))"/>

<!--
=================================================================================================== 
 Define miscellaneous global variables to control certain aspects of the documents' appearance that 
 may vary between the parts of the standard and the Technical Corrigendum
=================================================================================================== 
-->
<xsl:variable name="clause-space-before-minimum">0pt</xsl:variable>
<xsl:variable name="clause-space-before-optimum">0pt</xsl:variable>
<xsl:variable name="clause-space-before-maximum">0pt</xsl:variable>
<xsl:variable name="clause-space-after-minimum">12pt</xsl:variable>
<xsl:variable name="clause-space-after-optimum">14pt</xsl:variable>
<xsl:variable name="clause-space-after-maximum">16pt</xsl:variable>

<xsl:variable name="subclause-space-before-minimum">10pt</xsl:variable>
<xsl:variable name="subclause-space-before-optimum">12pt</xsl:variable>
<xsl:variable name="subclause-space-before-maximum">14pt</xsl:variable>
<xsl:variable name="subclause-space-after-minimum">8pt</xsl:variable>
<xsl:variable name="subclause-space-after-optimum">10pt</xsl:variable>
<xsl:variable name="subclause-space-after-maximum">12pt</xsl:variable>

<xsl:variable name="subclause2-space-before-minimum">8pt</xsl:variable>
<xsl:variable name="subclause2-space-before-optimum">10pt</xsl:variable>
<xsl:variable name="subclause2-space-before-maximum">12pt</xsl:variable>
<xsl:variable name="subclause2-space-after-minimum">7pt</xsl:variable>
<xsl:variable name="subclause2-space-after-optimum">9pt</xsl:variable>
<xsl:variable name="subclause2-space-after-maximum">11pt</xsl:variable>

<xsl:variable name="subclause3-space-before-minimum">8pt</xsl:variable>
<xsl:variable name="subclause3-space-before-optimum">10pt</xsl:variable>
<xsl:variable name="subclause3-space-before-maximum">12pt</xsl:variable>
<xsl:variable name="subclause3-space-after-minimum">7pt</xsl:variable>
<xsl:variable name="subclause3-space-after-optimum">9pt</xsl:variable>
<xsl:variable name="subclause3-space-after-maximum">11pt</xsl:variable>

<xsl:variable name="subclause4-space-before-minimum">8pt</xsl:variable>
<xsl:variable name="subclause4-space-before-optimum">10pt</xsl:variable>
<xsl:variable name="subclause4-space-before-maximum">12pt</xsl:variable>
<xsl:variable name="subclause4-space-after-minimum">7pt</xsl:variable>
<xsl:variable name="subclause4-space-after-optimum">9pt</xsl:variable>
<xsl:variable name="subclause4-space-after-maximum">11pt</xsl:variable>

<xsl:variable name="annex-space-before">0pt</xsl:variable>
<xsl:variable name="annex-space-after">0pt</xsl:variable>
<xsl:variable name="bibliography-space-before">0pt</xsl:variable>
<xsl:variable name="bibliography-space-after">20pt</xsl:variable>
<xsl:variable name="definitions-label-body-separation">48pt</xsl:variable>
<xsl:variable name="list-alphanum-label-body-separation">26pt</xsl:variable>
<xsl:variable name="list-roman-label-body-separation">32pt</xsl:variable>
<xsl:variable name="list-bibliography-label-body-separation">30pt</xsl:variable>
<xsl:variable name="lbllist-label-body-separation">18pt</xsl:variable>
<xsl:variable name="example-inset">30pt</xsl:variable>

<!--
=================================================================================================== 
 Define miscellaneous global variables to control certain font-related aspects of the documents'
  appearance that may vary between versions of the ISO Directives and/or Style guide
=================================================================================================== 
-->
<xsl:variable name="font-name">Cambria</xsl:variable>
<xsl:variable name="codefont-name">Courier</xsl:variable>

<xsl:variable name="body-size">11pt</xsl:variable>
<xsl:variable name="body-line-height">1.1</xsl:variable>
<xsl:variable name="grammar-size">9pt</xsl:variable>

<xsl:variable name="page-hdr-size">10pt</xsl:variable>
<xsl:variable name="page-hdr-weight">bold</xsl:variable>

<xsl:variable name="page-footer-size">10pt</xsl:variable>
<xsl:variable name="page-footer-weight">bold</xsl:variable>
<xsl:variable name="footer-copyright-size">8pt</xsl:variable>

<xsl:variable name="toc-pagehead-size">16pt</xsl:variable>
<xsl:variable name="toc-head-size">14pt</xsl:variable>
<xsl:variable name="toc-head-pagenum-size">10pt</xsl:variable>
<xsl:variable name="toc-head-weight">bold</xsl:variable>
<xsl:variable name="toc-fwd-size">11pt</xsl:variable>
<xsl:variable name="toc-fwd-spacebefore">6pt</xsl:variable>
<xsl:variable name="toc-intro-size">11pt</xsl:variable>
<xsl:variable name="toc-intro-spacebefore">6pt</xsl:variable>
<xsl:variable name="toc-level1-size">11pt</xsl:variable>
<xsl:variable name="toc-otherlevel-size">10pt</xsl:variable>
<xsl:variable name="toc-level1-spacebefore">6pt</xsl:variable>
<xsl:variable name="toc-otherlevel-spacebefore">3pt</xsl:variable>
<xsl:variable name="toc-level1-weight">bold</xsl:variable>
<xsl:variable name="toc-otherlevel-weight">normal</xsl:variable>
<xsl:variable name="toc-table-size">10pt</xsl:variable>
<xsl:variable name="toc-table-spacebefore">0pt</xsl:variable>
<xsl:variable name="toc-figure-size">10pt</xsl:variable>
<xsl:variable name="toc-figure-spacebefore">0pt</xsl:variable>
<xsl:variable name="toc-example-size">10pt</xsl:variable>
<xsl:variable name="toc-example-spacebefore">0pt</xsl:variable>
<xsl:variable name="toc-equation-size">10pt</xsl:variable>
<xsl:variable name="toc-equation-spacebefore">0pt</xsl:variable>
<xsl:variable name="toc-bibl-size">11pt</xsl:variable>
<xsl:variable name="toc-bibl-spacebefore">6pt</xsl:variable>
<xsl:variable name="toc-BNFdef-size">10pt</xsl:variable>
<xsl:variable name="toc-BNFdef-spacebefore">0pt</xsl:variable>
<xsl:variable name="toc-line-height">1.3</xsl:variable>

<xsl:variable name="partHeading-weight">bold</xsl:variable>
<xsl:variable name="partHeading-size">12pt</xsl:variable>
<xsl:variable name="partTitleOne-weight">bold</xsl:variable>
<xsl:variable name="partTitleOne-size">14pt</xsl:variable>
<xsl:variable name="partTitleTwo-weight">normal</xsl:variable>
<xsl:variable name="partTitleTwo-size">14pt</xsl:variable>
<xsl:variable name="partTitleThree-weight">bold</xsl:variable>
<xsl:variable name="partTitleThree-size">12pt</xsl:variable>
<xsl:variable name="partTitleFour-weight">bold</xsl:variable>
<xsl:variable name="partTitleFour-size">14pt</xsl:variable>

<xsl:variable name="head1-size">14pt</xsl:variable>
<xsl:variable name="head-weight">bold</xsl:variable>
<xsl:variable name="head2-size">14pt</xsl:variable>
<xsl:variable name="head3-size">12pt</xsl:variable>
<xsl:variable name="head4-size">12pt</xsl:variable>
<xsl:variable name="head5-size">12pt</xsl:variable>

<xsl:variable name="subhead-size">14pt</xsl:variable>
<xsl:variable name="subhead-weight">bold</xsl:variable>

<xsl:variable name="note-size">10pt</xsl:variable>

<xsl:variable name="redbox-size">6pt</xsl:variable>

<xsl:variable name="index-expl-size">9pt</xsl:variable>


<!--
<xsl:variable name=""></xsl:variable>
<xsl:variable name=""></xsl:variable>
<xsl:variable name=""></xsl:variable>
<xsl:variable name=""></xsl:variable>
<xsl:variable name=""></xsl:variable>
<xsl:variable name=""></xsl:variable>
<xsl:variable name=""></xsl:variable>
-->

<!--
=================================================================================================== 
  Relative path to all the figures
=================================================================================================== 
-->
<xsl:variable name="figure-dir">figures</xsl:variable>


<!--
=================================================================================================== 
=================================================================================================== 
== Common headers/footers                                                                        ==
=================================================================================================== 
=================================================================================================== 
-->

<xsl:template name="standard-static-contents">
  <xsl:param name="page-kind"/>
  <xsl:param name="page-number"/>

  <xsl:if test="$page-kind != 'editor-notes'">
    <fo:static-content flow-name="right-header-first">
      <fo:block text-align="center" font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
        <xsl:value-of select="$docNumber"/>
      </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="right-header">
      <fo:block text-align="center" font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
        <xsl:value-of select="$docNumber"/>
      </fo:block>
      <fo:block text-align="center" font="{$page-hdr-weight} {$page-hdr-size} {$font-name}">
        <fo:retrieve-marker retrieve-class-name="head1Num"
                            retrieve-position="first-including-carryover"
                            retrieve-boundary="page"/>
        &nbsp;
        <fo:retrieve-marker retrieve-class-name="head1String"
                            retrieve-position="first-including-carryover"
                            retrieve-boundary="page"/>
      </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="left-header-first">
      <fo:block text-align="center" font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
        <xsl:value-of select="$docNumber"/>
      </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="left-header">
      <fo:block text-align="center" font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
        <xsl:value-of select="$docNumber"/>
      </fo:block>  
      <fo:block text-align="center" font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
        <fo:retrieve-marker retrieve-class-name="head1Num"
                            retrieve-position="first-including-carryover"
                            retrieve-boundary="page"/>
        &nbsp;
        <fo:retrieve-marker retrieve-class-name="head1String"
                            retrieve-position="first-including-carryover"
                            retrieve-boundary="page"/>
      </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="right-footer">
      <fo:block text-align="center"
                font-weight="{$page-footer-weight}" font-size="{$page-footer-size}">
        <fo:block font="{$footer-copyright-size} {$font-name}">
          <xsl:value-of select="$provisional-copyright"/>
        </fo:block>
        <fo:leader leader-pattern="space"/>
        <fo:block>
          <xsl:copy-of select="$page-number"/>
        </fo:block>
      </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="left-footer">
      <fo:block text-align="center"
                font-weight="{$page-footer-weight}" font-size="{$page-footer-size}">
        <fo:block font="{$footer-copyright-size} {$font-name}">
          <xsl:value-of select="$provisional-copyright"/>
        </fo:block>
        <fo:leader leader-pattern="space"/>
        <fo:block>
          <xsl:copy-of select="$page-number"/>
        </fo:block>
      </fo:block>
    </fo:static-content>
  </xsl:if>
  
  <fo:static-content flow-name="xsl-footnote-separator">
      <fo:block text-align-last="justify">
         <fo:leader leader-length="50%" rule-thickness="1pt" leader-pattern="rule"/>
      </fo:block>
  </fo:static-content>

  <xsl:if test="$page-kind = 'index'">
    <fo:static-content flow-name="index-first-header">
      <fo:block text-align="center" font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
        <xsl:value-of select="$docNumber"/>
      </fo:block>
      <fo:block text-align="center" font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
        <fo:retrieve-marker retrieve-class-name="head1Num"
                            retrieve-position="first-including-carryover"
                            retrieve-boundary="page"/>
        &nbsp;
        <fo:retrieve-marker retrieve-class-name="head1String"
                            retrieve-position="first-including-carryover"
                            retrieve-boundary="page"/>
      </fo:block>
      <fo:block font-weight="bold" font-size="{$head1-size}"
                space-before.optimum="72pt"
                space-after.optimum="24pt"
                text-align="center"
                id="index-start-page">Index</fo:block>
        
      <fo:block font="{$index-expl-size} {$font-name}"
                space-after.optimum="12pt"
                text-align="start">
        Index entries appearing in
        <fo:inline font-weight="bold">boldface</fo:inline> indicate the page
        where the word, phrase, or BNF non-terminal was defined; index entries
        appearing in <fo:inline font-style="italic">italics</fo:inline>
        indicate a page where the BNF non-terminal was used in a Format; 
        and index entries appearing in roman type indicate a page where the word, phrase, 
        or BNF non-terminal was used in a heading, Function, Syntax Rule, Access Rule,
        General Rule, Conformance Rule, Table, or other descriptive text.
      </fo:block>
    </fo:static-content>
  </xsl:if>

  <xsl:if test="$page-kind = 'editor-notes'">
    <fo:static-content flow-name="editor-notes-right-header">
      <fo:block text-align="center" font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
        <xsl:text>Editor&rsquo;s Notes for </xsl:text>
        <xsl:value-of select="$docNumber"/>
      </fo:block>
      <fo:block text-align="center" font="{$page-hdr-weight} {$page-hdr-size} {$font-name}">
        <fo:retrieve-marker retrieve-class-name="PPLOtype"
                            retrieve-position="first-including-carryover"
                            retrieve-boundary="page"/>
      </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="editor-notes-left-header">
      <fo:block text-align="center" font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
        <xsl:text>Editor&rsquo;s Notes for </xsl:text>
        <xsl:value-of select="$docNumber"/>
      </fo:block>
      <fo:block text-align="center" font-weight="{$page-hdr-weight}" font-size="{$page-hdr-size}">
        <fo:retrieve-marker retrieve-class-name="PPLOtype"
                            retrieve-position="first-including-carryover"
                            retrieve-boundary="page"/>
      </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="editor-notes-right-footer">
      <fo:block text-align="center"
                font-weight="{$page-footer-weight}" font-size="{$page-footer-size}">
        <fo:block>
          <xsl:text>Editor&rsquo;s Notes (</xsl:text>
          <fo:retrieve-marker retrieve-class-name="PPLOtype"
                              retrieve-boundary="page-sequence"/>
          <xsl:text>)</xsl:text>
        </fo:block>
        <fo:leader leader-pattern="space"/>
        <fo:block>
          <xsl:text>Notes&ndash;</xsl:text>
          <xsl:copy-of select="$page-number"/>
        </fo:block>
      </fo:block>
    </fo:static-content>

    <fo:static-content flow-name="editor-notes-left-footer">
      <fo:block text-align="center"
                font-weight="{$page-footer-weight}" font-size="{$page-footer-size}">
        <fo:block>
          <xsl:text>Editor&rsquo;s Notes (</xsl:text>
          <fo:retrieve-marker retrieve-class-name="PPLOtype"
                              retrieve-boundary="page-sequence"/>
          <xsl:text>)</xsl:text>
        </fo:block>
        <fo:leader leader-pattern="space"/>
        <fo:block>
          <xsl:text>Notes&ndash;</xsl:text>
          <xsl:copy-of select="$page-number"/>
        </fo:block>
      </fo:block>
    </fo:static-content>
  </xsl:if>

<!--
    The content of this static content was "This page left intentionally blank", but ISO seems to 
    prefer "(Blank page)", so I changed it on 2003-12-11
    On 2020-04-16, in a sop to new ISO/CS demands, I've removed the text entirely. 
-->
  <fo:static-content flow-name="blank-body">
    <fo:block font-style="italic" font-size="10pt" text-align="center">
      <xsl:text> </xsl:text>
    </fo:block>
  </fo:static-content>
</xsl:template>


<!-- ****************************************************************************************** -->
<!-- ****************************************************************************************** -->
<!--                                     BEGIN PROCESSING                                       -->
<!-- ****************************************************************************************** -->
<!-- ****************************************************************************************** -->


<!--
=================================================================================================== 
=================================================================================================== 
==  Start processing the standards document                                                   ==
=================================================================================================== 
=================================================================================================== 
-->

<!--
    Start processing the root of the document
-->
<xsl:template match="/">
  <xsl:if
    test="not($parts[@number=$standardNumber]/part[@number=$partno])">
    <xsl:message terminate="yes">
      ERROR: The document is not configured in standardParts.xml
    </xsl:message>
  </xsl:if>
  <xsl:if test="/standard/@corSeq or 
                /standard/@standardYear or
                $parts[@number=$standardNumber]/part[@number=$partno]/@TC='true'">
    <xsl:message terminate="yes">
      ERROR: The document is probably defined as a TC, and not a standard
    </xsl:message>
   </xsl:if>

<!--
    The following processing instructions use XEP extensions
    Note that there are many XEP extensions; most are allowed to take their default values.
-->
<!-- XEP does not produce any PDF version greater than 1.5, but 1.4 is what we use.
     Futher development might choose to extend this to version 1.5 -->
  <xsl:processing-instruction name="xep-pdf-pdf-version">1.4</xsl:processing-instruction>
<!-- Unicode annotations make the file larger for no good reason -->
  <xsl:processing-instruction name="xep-pdf-unicode-annotations">false</xsl:processing-instruction>
<!-- If unused destinations are dropped, then inter-document links will often fail completely -->
  <xsl:processing-instruction name="xep-pdf-drop-unused-destinations">
    false
  </xsl:processing-instruction>
<!-- This controls how the viewing window maps to the screen window -->
  <xsl:processing-instruction name="xep-pdf-initial-zoom">fit-width</xsl:processing-instruction>
<!-- This controls whether the viewing window contains panes for the bookmarks (document
     outline), page thumbnails, a full-screen view, etc.  'show-none' is preferred. -->
  <xsl:processing-instruction name="xep-pdf-view-mode">show-none</xsl:processing-instruction>
  
  <!-- Disabled by request from Jan-Eike Michels, 2017-07
  <xsl:processing-instruction name="xep-pdf-viewer-preferences">
    display-document-title
  </xsl:processing-instruction>
  <xsl:processing-instruction name="xep-pdf-linearize">true</xsl:processing-instruction> 
-->
<!--
    The preceding processing instructions use XEP extensions
-->

<!--
    Note: The text of the standard is set in 11pt Cambria; the font-family 
          and/or the point size may be changed in specific contexts
          
    Note: Setting xml:lang is suggested by renderx documentation for accessibility
-->
  <fo:root xmlns:fo="http://www.w3.org/1999/XSL/Format"
           xmlns:rx="http://www.renderx.com/XSL/Extensions"
           xml:lang="en"
           hyphenation-push-character-count="3"
           hyphenation-remain-character-count="3"
           font="{$body-size}/{$body-line-height} {$font-name}">
<!--
           font="{$body-size}/1.10 {$font-name}"
-->

    <xsl:variable name="docTitle" select="standard//partTitleEnglish"/>
    <xsl:variable name="docSubject" select="$docNumber"/>
    <xsl:variable name="principleEditor" select="standard/@principleEditor"/>
    <xsl:variable name="associateEditor">
      <xsl:choose>
        <xsl:when test="standard/@associateEditor">
          <xsl:text> and </xsl:text>
          <xsl:value-of select="standard/@associateEditor"/>
          <xsl:text> (Assoc. Ed.)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="''"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- The following rx:meta-info element is an XEP extension -->
    <rx:meta-info>
      <rx:meta-field name="author" value="{$principleEditor} (Ed.){$associateEditor}"/>
      <rx:meta-field name="title" value="{$docTitle}"/>
      <rx:meta-field name="subject" value="{$docSubject}"/>
    </rx:meta-info>
    <!-- The preceding rx:meta-info element is an XEP extension -->

<!--
=================================================================================================== 
=================================================================================================== 
==  Define the layouts, pages, etc.                                                              ==
=================================================================================================== 
=================================================================================================== 
-->
<!--
    The layout master set defines all of the page masters that are used in the document being
    compiled.  Note that some kinds of pages have multiple page masters (normally a "first",
    a "left", and a "right".  In early 2019, ISO Central Secretariat demanded that all "blank"
    pages be eliminated; previously, if a Clause ended on an odd-numbered (right-hand) page,
    a "blank" page would be inserted so that the next Clause would start on an odd-numbered
    (right-hand) page, but now Clauses are allowed to start on either an odd-numbered or an
    even-numbered page.  One consequence is that most "first" page masters are no longer used.
    The major exceptions to this are the table of contents (ToC) and the Scope clause
    (Clause 1), the index, and the editor's notes.
    The first page of each Clause and Annex does have slightly "special" formatting,
    compared to the other pages of the same Clause or Annex. 
-->
    <fo:layout-master-set>
<!--
    Cover Page page master                                          
-->
      <fo:simple-page-master master-name="CoverPage"
                             page-width="210mm" page-height="297mm"
                             margin-top="0in" margin-bottom="0in"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="104pt" margin-bottom="65pt" margin-right="36pt"/>
        <fo:region-after region-name="cover-footer" extent="65pt"/>
      </fo:simple-page-master>
<!--
    Copyright Page page master                                      
-->
      <fo:simple-page-master master-name="CopyrightPage"
                             page-width="210mm" page-height="297mm"
                             margin-top="0in" margin-bottom="0in">
        <fo:region-body margin-top="104pt" margin-bottom="65pt"
                        margin-left="20mm" margin-right="92pt"/>
      </fo:simple-page-master>
<!--             
    Blank pages in standards are always on the left and thus even-numbered 
-->
      <!-- 2019-02-22: ISO/CS does not want blank pages at all -->
      <fo:simple-page-master master-name="blank"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body region-name="blank-body" margin-top="270pt" margin-bottom="12mm"/>
<!-- Eliminate all text (ISOCS edited the header and footer out of the blank page following the 
      Introduction, so we follow the example)
        <fo:region-before region-name="left-header" extent="22pt"/>
        <fo:region-after region-name="left-footer" extent="11pt"/>
-->
      </fo:simple-page-master>
<!--
    First Page of main Table of Contents (for Clauses, Annexes, and Subclauses)  
-->
      <fo:simple-page-master master-name="TOCfirst"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body region-name="contents" margin-top="110pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header" extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>
<!--
    Left Page of Tables of Contents                                 
-->
      <fo:simple-page-master master-name="TOCleft"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body region-name="contents" margin-top="40pt" margin-bottom="12mm"/>
        <fo:region-before region-name="left-header" extent="22pt"/>
        <fo:region-after region-name="left-footer" extent="11pt"/>
      </fo:simple-page-master>
<!--
    Right Page of Tables of Contents
-->
      <fo:simple-page-master master-name="TOCright"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body region-name="contents" margin-top="40pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header" extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>
<!--
    First Page of Table of Contents for Tables
-->
      <fo:simple-page-master master-name="TOCtablesfirst"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body region-name="contents" margin-top="82pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header" extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!-- 
    First Page of Table of Contents for Figures
-->
      <fo:simple-page-master master-name="TOCfiguresfirst"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body region-name="contents" margin-top="82pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header" extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!-- 
    First Page of Table of Contents for Examples
-->
      <fo:simple-page-master master-name="TOCexamplesfirst"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body region-name="contents" margin-top="82pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header" extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!-- 
    First Page of Table of Contents for Equations
-->
      <fo:simple-page-master master-name="TOCequationsfirst"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body region-name="contents" margin-top="82pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header" extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    First Page of Table of Contents for BNF non-terminal symbols
-->
      <xsl:if test="$list-bnf-elements = 'yes'">
        <fo:simple-page-master master-name="TOCnonterminalsfirst"
                               page-width="210mm" page-height="297mm"
                               margin-top="20mm" margin-bottom="13mm"
                               margin-left="20mm" margin-right="20mm">
          <fo:region-body region-name="contents" margin-top="82pt" margin-bottom="12mm"/>
          <fo:region-before region-name="right-header" extent="22pt"/>
          <fo:region-after region-name="right-footer" extent="11pt"/>
        </fo:simple-page-master>
      </xsl:if>

<!--
    Left Page of Front Matter sections (Foreword and Introduction)
-->
      <fo:simple-page-master master-name="frontmatter-page-left"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="40pt" margin-bottom="12mm"/>
        <fo:region-before region-name="left-header" extent="22pt"/>
        <fo:region-after region-name="left-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    Right Page of Front Matter (Foreword and Introduction)
-->
      <fo:simple-page-master master-name="frontmatter-page-right"
            page-width="210mm" page-height="297mm"
            margin-top="20mm" margin-bottom="13mm"
            margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="40pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header" extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    First Page of First Clause (Scope Clause with Title)
-->
      <fo:simple-page-master master-name="scope-clause-page-first"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="6pt" margin-bottom="12mm"/>
        <fo:region-before extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    First Page of Other Clauses (not Scope Clause)
-->
      <fo:simple-page-master master-name="clause-page-first-odd"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="84pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header-first" extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

      <fo:simple-page-master master-name="clause-page-first-even"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="84pt" margin-bottom="12mm"/>
        <fo:region-before region-name="left-header-first" extent="22pt"/>
        <fo:region-after region-name="left-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    First Page of Annexes
-->
      <fo:simple-page-master master-name="annex-page-first-odd"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="88pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header-first" extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

      <fo:simple-page-master master-name="annex-page-first-even"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="88pt" margin-bottom="12mm"/>
        <fo:region-before region-name="left-header-first" extent="22pt"/>
        <fo:region-after region-name="left-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    First Page of Bibliography
-->
      <fo:simple-page-master master-name="bibliography-page-first"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="84pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header" extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    Left Page of Clauses and Annexes
-->
      <fo:simple-page-master master-name="regular-page-left"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="40pt" margin-bottom="12mm"/>
        <fo:region-before region-name="left-header" extent="22pt"/>
        <fo:region-after region-name="left-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    Right Page of Clauses and Annexes
-->
      <fo:simple-page-master master-name="regular-page-right"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="40pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header" extent="22pt"/>
          <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    First Page of Index
-->
      <fo:simple-page-master master-name="indexFirst"
            page-width="210mm" page-height="297mm"
            margin-top="20mm" margin-bottom="13mm"
            margin-left="20mm" margin-right="20mm">
        <fo:region-body column-count="2" column-gap="30pt"
              margin-top="206pt" margin-bottom="12mm"/>
        <fo:region-before region-name="index-first-header" extent="240pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    Left Page of Index
-->
      <fo:simple-page-master
            master-name="indexLeft"
            page-width="210mm" page-height="297mm"
            margin-top="20mm" margin-bottom="13mm"
            margin-left="20mm" margin-right="20mm">
        <fo:region-body column-count="2" column-gap="30pt"
              margin-top="40pt" margin-bottom="12mm"/>
        <fo:region-before region-name="left-header" extent="22pt"/>
        <fo:region-after region-name="left-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    Right Page of Index
-->
      <fo:simple-page-master master-name="indexRight"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body column-count="2" column-gap="30pt" margin-top="40pt" margin-bottom="12mm"/>
        <fo:region-before region-name="right-header" extent="22pt"/>
        <fo:region-after region-name="right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    Dummy index page (used in "first pass" to record page numbers for everything indexed
-->
      <fo:simple-page-master master-name="index-dummy"
                             page-width="175in" page-height="10000mm"
                             margin-top="15mm" margin-bottom="15mm"
                             margin-left="15mm" margin-right="15in">
        <fo:region-body region-name="index-body"/>
      </fo:simple-page-master>

<!--
    First Page of Editor's Notes
-->
      <fo:simple-page-master master-name="editor-notes-page-first"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="90pt" margin-bottom="12mm"/>
        <fo:region-before region-name="editor-notes-right-header" extent="22pt"/>
        <fo:region-after region-name="editor-notes-right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    Left Page of Editor's Notes
-->
      <fo:simple-page-master master-name="editor-notes-page-left"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="40pt" margin-bottom="12mm"/>
        <fo:region-before region-name="editor-notes-left-header" extent="22pt"/>
        <fo:region-after region-name="editor-notes-left-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    Right Page of Editor's Notes
-->
      <fo:simple-page-master master-name="editor-notes-page-right"
                             page-width="210mm" page-height="297mm"
                             margin-top="20mm" margin-bottom="13mm"
                             margin-left="20mm" margin-right="20mm">
        <fo:region-body margin-top="40pt" margin-bottom="12mm"/>
        <fo:region-before region-name="editor-notes-right-header" extent="22pt"/>
        <fo:region-after region-name="editor-notes-right-footer" extent="11pt"/>
      </fo:simple-page-master>

<!--
    Need simple-page-master for other pages, too (if any)
-->

<!--
=================================================================================================== 
=================================================================================================== 
==  Define the sequences of pages                                                                ==
=================================================================================================== 
=================================================================================================== 
-->
<!--
    Page sequences specify how page masters are generated for each kind of page
-->
      <fo:page-sequence-master master-name="TOC-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference blank-or-not-blank="blank"
                                                master-reference="blank"/>
          <fo:conditional-page-master-reference page-position="first"
                                                master-reference="TOCfirst"/>
          <fo:conditional-page-master-reference odd-or-even="even" master-reference="TOCleft"/>
          <fo:conditional-page-master-reference odd-or-even="odd" master-reference="TOCright"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <fo:page-sequence-master master-name="TOCtables-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference
                blank-or-not-blank="blank" master-reference="blank"/>
<!--
          <fo:conditional-page-master-reference page-position="first" 
                                                master-reference="TOCtablesfirst"/>
-->
          <fo:conditional-page-master-reference
                odd-or-even="even" master-reference="TOCleft"/>
          <fo:conditional-page-master-reference
                odd-or-even="odd" master-reference="TOCright"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <fo:page-sequence-master master-name="TOCfigures-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference blank-or-not-blank="blank"
                                                master-reference="blank"/>
<!--
          <fo:conditional-page-master-reference page-position="first" 
                                                master-reference="TOCfiguresfirst"/>
-->
          <fo:conditional-page-master-reference odd-or-even="even" master-reference="TOCleft"/>
          <fo:conditional-page-master-reference odd-or-even="odd" master-reference="TOCright"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <fo:page-sequence-master master-name="TOCexamples-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference blank-or-not-blank="blank"
                                                master-reference="blank"/>
<!--
          <fo:conditional-page-master-reference page-position="first" 
                                                master-reference="TOCexamplesfirst"/>
-->
          <fo:conditional-page-master-reference odd-or-even="even" master-reference="TOCleft"/>
          <fo:conditional-page-master-reference odd-or-even="odd" master-reference="TOCright"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <fo:page-sequence-master master-name="TOCequations-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference blank-or-not-blank="blank"
                                                master-reference="blank"/>
<!--
          <fo:conditional-page-master-reference page-position="first" 
                                                master-reference="TOCequationsfirst"/>
-->
          <fo:conditional-page-master-reference odd-or-even="even" master-reference="TOCleft"/>
          <fo:conditional-page-master-reference odd-or-even="odd" master-reference="TOCright"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <xsl:if test="$list-bnf-elements = 'yes'">
        <fo:page-sequence-master master-name="TOCnonterminals-sequence">
          <fo:repeatable-page-master-alternatives>
            <fo:conditional-page-master-reference blank-or-not-blank="blank"
                                                  master-reference="blank"/>
  <!--
            <fo:conditional-page-master-reference
                  page-position="first" master-reference="TOCnonterminalsfirst"/>
  -->
            <fo:conditional-page-master-reference odd-or-even="even" master-reference="TOCleft"/>
            <fo:conditional-page-master-reference odd-or-even="odd" master-reference="TOCright"/>
          </fo:repeatable-page-master-alternatives>
        </fo:page-sequence-master>
      </xsl:if>
      
      <fo:page-sequence-master master-name="foreword-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference blank-or-not-blank="blank"
                                                master-reference="blank"/>
          <fo:conditional-page-master-reference odd-or-even="even"
                                                master-reference="frontmatter-page-left"/>
          <fo:conditional-page-master-reference odd-or-even="odd"
                                                master-reference="frontmatter-page-right"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <fo:page-sequence-master master-name="intro-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference blank-or-not-blank="blank"
                                                master-reference="blank"/>
          <fo:conditional-page-master-reference odd-or-even="even"
                                                master-reference="frontmatter-page-left"/>
          <fo:conditional-page-master-reference odd-or-even="odd"
                                                master-reference="frontmatter-page-right"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <fo:page-sequence-master master-name="scope-clause-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference blank-or-not-blank="blank"
                                                master-reference="blank"/>
          <fo:conditional-page-master-reference page-position="first"
                                                master-reference="scope-clause-page-first"/>
          <fo:conditional-page-master-reference odd-or-even="even"
                                                master-reference="regular-page-left"/>
          <fo:conditional-page-master-reference odd-or-even="odd"
                                                master-reference="regular-page-right"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <fo:page-sequence-master master-name="other-clause-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference
              blank-or-not-blank="blank" master-reference="blank"/>
          <fo:conditional-page-master-reference page-position="first"
                                                odd-or-even="even"
                                                master-reference="clause-page-first-even"/>
          <fo:conditional-page-master-reference page-position="first"
                                                odd-or-even="odd"
                                                master-reference="clause-page-first-odd"/>
          <fo:conditional-page-master-reference odd-or-even="even"
                                                master-reference="regular-page-left"/>
          <fo:conditional-page-master-reference odd-or-even="odd"
                                                master-reference="regular-page-right"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <fo:page-sequence-master master-name="annex-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference blank-or-not-blank="blank"
                                                master-reference="blank"/>
          <fo:conditional-page-master-reference page-position="first"
                                                odd-or-even="even"
                                                master-reference="annex-page-first-even"/>
          <fo:conditional-page-master-reference page-position="first"
                                                odd-or-even="odd"
                                                master-reference="annex-page-first-odd"/>
          <fo:conditional-page-master-reference odd-or-even="even"
                                                master-reference="regular-page-left"/>
          <fo:conditional-page-master-reference odd-or-even="odd"
                                                master-reference="regular-page-right"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <fo:page-sequence-master master-name="bibliography-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference
                blank-or-not-blank="blank" master-reference="blank"/>
<!--
          <fo:conditional-page-master-reference page-position="first" 
                                                master-reference="bibliography-page-first"/>
-->
          <fo:conditional-page-master-reference odd-or-even="even"
                                                master-reference="regular-page-left"/>
          <fo:conditional-page-master-reference odd-or-even="odd"
                                                master-reference="regular-page-right"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <fo:page-sequence-master master-name="index-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference blank-or-not-blank="blank"
                                                master-reference="blank"/>
          <fo:conditional-page-master-reference page-position="first"
                                                master-reference="indexFirst"/>
          <fo:conditional-page-master-reference odd-or-even="even"
                                                master-reference="indexLeft"/>
          <fo:conditional-page-master-reference odd-or-even="odd"
                                                master-reference="indexRight"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>

      <fo:page-sequence-master master-name="editor-notes-sequence">
        <fo:repeatable-page-master-alternatives>
          <fo:conditional-page-master-reference blank-or-not-blank="blank"
                                                master-reference="blank"/>
          <fo:conditional-page-master-reference page-position="first"
                                                master-reference="editor-notes-page-first"/>
          <fo:conditional-page-master-reference odd-or-even="even"
                                                master-reference="editor-notes-page-left"/>
          <fo:conditional-page-master-reference odd-or-even="odd"
                                                master-reference="editor-notes-page-right"/>
        </fo:repeatable-page-master-alternatives>
      </fo:page-sequence-master>
    </fo:layout-master-set>


<!--
    At this point, we generate PDF bookmarks for all sections of the document, using colors as 
    cues; all bookmarks are initially collapsed.
    Bookmarks are generated for the following: TOC, TOCtable, TOCfigure, TOCexamples,
    TOCequations, TOCnonterminals,
    Foreword, Introduction, Clauses, Subclauses (all levels), and Annexes.
-->
    <fo:bookmark-tree>
      <!-- First, let's get the structural bits out of the way    -->
      <xsl:variable name="TOCgeneral-id">TOCgeneral</xsl:variable>
      <xsl:variable name="TOCgeneral-title">Contents</xsl:variable>
      <xsl:variable name="TOCtables-id">TOCtables</xsl:variable>
      <xsl:variable name="TOCtables-title">Tables</xsl:variable>
      <xsl:variable name="TOCfigures-id">TOCfigures</xsl:variable>
      <xsl:variable name="TOCfigures-title">Figures</xsl:variable>
      <xsl:variable name="TOCexamples-id">TOCexamples</xsl:variable>
      <xsl:variable name="TOCexamples-title">Examples</xsl:variable>
      <xsl:variable name="TOCequations-id">TOCequations</xsl:variable>
      <xsl:variable name="TOCequations-title">Equations</xsl:variable>
      <xsl:variable name="TOCnonterminals-id">TOCnonterminals</xsl:variable>
      <xsl:variable name="TOCnonterminals-title">BNF non-terminal symbols</xsl:variable>
      <fo:bookmark internal-destination="{$TOCgeneral-id}" starting-state="hide">
        <fo:bookmark-title font-weight="bold" color="#943634">
          <xsl:value-of select="$TOCgeneral-title"/>
        </fo:bookmark-title>
      </fo:bookmark>
      <xsl:if test="count(//table/tableTitle)>0">
        <fo:bookmark internal-destination="{$TOCtables-id}" starting-state="hide">
          <fo:bookmark-title font-weight="bold" color="#943634">
            <xsl:value-of select="$TOCtables-title"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="count(//figure)>0">
        <fo:bookmark internal-destination="{$TOCfigures-id}" starting-state="hide">
          <fo:bookmark-title font-weight="bold" color="#943634">
            <xsl:value-of select="$TOCfigures-title"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="count(//example)>0">
        <fo:bookmark internal-destination="{$TOCexamples-id}" starting-state="hide">
          <fo:bookmark-title font-weight="bold" color="#943634">
            <xsl:value-of select="$TOCexamples-title"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      <xsl:if test="count(//equation)>0">
        <fo:bookmark internal-destination="{$TOCequations-id}" starting-state="hide">
          <fo:bookmark-title font-weight="bold" color="#943634">
            <xsl:value-of select="$TOCequations-title"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>
      
      <xsl:if test="$list-bnf-elements = 'yes'">
        <xsl:if test="count(//Format/grammar/BNFdef | //Properties/grammar/BNFdef)>0">
          <fo:bookmark internal-destination="{$TOCnonterminals-id}" starting-state="hide">
            <fo:bookmark-title font-weight="bold" color="#943634">
              <xsl:value-of select="$TOCnonterminals-title"/>
            </fo:bookmark-title>
          </fo:bookmark>
        </xsl:if>
      </xsl:if>
      
      <!-- Next, handle the Foreword and Introduction             -->
      <xsl:variable name="foreword-id">ForewordBlock</xsl:variable>
      <xsl:variable name="foreword-title">
        <xsl:value-of select=".//forewordHeading"/>
      </xsl:variable>
      <xsl:variable name="intro-id">IntroBlock</xsl:variable>
      <xsl:variable name="intro-title">
        <xsl:value-of select=".//introHeading"/>
      </xsl:variable>
      <fo:bookmark internal-destination="{$foreword-id}" starting-state="hide">
        <fo:bookmark-title color="#943634">
          <xsl:value-of select="$foreword-title"/>
        </fo:bookmark-title>
      </fo:bookmark>
      <fo:bookmark internal-destination="{$intro-id}" starting-state="hide">
        <fo:bookmark-title color="#943634">
          <xsl:value-of select="$intro-title"/>
        </fo:bookmark-title>
      </fo:bookmark>

      <!-- Now, do all Clauses, Subclauses, and Annexes -->
      <xsl:for-each select=".//clause | .//annex">
        <xsl:variable name="this-id">
          <xsl:value-of select="./@id"/>
        </xsl:variable>
        <xsl:variable name="this-number">
          <xsl:call-template name="head-number"/>
        </xsl:variable>
        <xsl:variable name="this-title-raw">
          <xsl:apply-templates select="./clauseHeading"/>
        </xsl:variable>
        <xsl:variable name="this-title">
          <xsl:value-of select="translate($this-title-raw,'&shy;','')"/>
        </xsl:variable>
        <fo:bookmark internal-destination="'{$this-id}'" starting-state="hide">
          <fo:bookmark-title font-weight="bold" color="#943634">
            <xsl:value-of select="$this-number"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="$this-title"/>
          </fo:bookmark-title>
          <xsl:for-each select="subClause">
            <xsl:variable name="this-id">
              <xsl:value-of select="./@id"/>
            </xsl:variable>
            <xsl:variable name="this-number">
              <xsl:call-template name="head-number"/>
            </xsl:variable>
            <xsl:variable name="this-title-raw">
              <xsl:apply-templates select="./clauseHeading"/>
            </xsl:variable>
            <xsl:variable name="this-title">
              <xsl:value-of select="translate($this-title-raw,'&shy;','')"/>
            </xsl:variable>
            <fo:bookmark internal-destination="'{$this-id}'" starting-state="hide">
              <fo:bookmark-title color="#003399">
                <xsl:value-of select="$this-number"/>
                <xsl:text> </xsl:text>
                <xsl:value-of select="$this-title"/>
              </fo:bookmark-title>
              <xsl:for-each select="subClause2">
                <xsl:variable name="this-id">
                  <xsl:value-of select="./@id"/>
                </xsl:variable>
                <xsl:variable name="this-number">
                  <xsl:call-template name="head-number"/>
                </xsl:variable>
                <xsl:variable name="this-title-raw">
                  <xsl:apply-templates select="./clauseHeading"/>
                </xsl:variable>
                <xsl:variable name="this-title">
                  <xsl:value-of select="translate($this-title-raw,'&shy;','')"/>
                </xsl:variable>
                <fo:bookmark internal-destination="'{$this-id}'" starting-state="hide">
                  <fo:bookmark-title color="#336600">
                    <xsl:value-of select="$this-number"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="$this-title"/>
                  </fo:bookmark-title>
                  <xsl:for-each select="subClause3">
                    <xsl:variable name="this-id"><xsl:value-of select="./@id"/></xsl:variable>
                    <xsl:variable name="this-number">
                      <xsl:call-template name="head-number"/>
                    </xsl:variable>
                    <xsl:variable name="this-title-raw">
                      <xsl:apply-templates select="./clauseHeading"/>
                    </xsl:variable>
                    <xsl:variable name="this-title">
                      <xsl:value-of select="translate($this-title-raw,'&shy;','')"/>
                    </xsl:variable>
                    <fo:bookmark internal-destination="'{$this-id}'" starting-state="hide">
                      <fo:bookmark-title color="#CC9900">
                        <xsl:value-of select="$this-number"/>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="$this-title"/>
                      </fo:bookmark-title>
                    </fo:bookmark>
                  </xsl:for-each>
                </fo:bookmark>
              </xsl:for-each>
            </fo:bookmark>
          </xsl:for-each>
        </fo:bookmark>
      </xsl:for-each>

      <!-- Next, handle the Bibliography                          -->
      <xsl:if test="count(//bibliography)>0">
        <xsl:variable name="bibliography-id">BibliographyBlock</xsl:variable>
        <xsl:variable name="bibliography-title">Bibliography</xsl:variable>
        <fo:bookmark internal-destination="{$bibliography-id}" starting-state="hide">
          <fo:bookmark-title font-weight="bold" color="#943634">
            <xsl:value-of select="$bibliography-title"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>

      <!-- Finally, handle the Index                              -->
      <xsl:variable name="index-id">index-start-page</xsl:variable>
      <xsl:variable name="index-title">Index</xsl:variable>
      <fo:bookmark internal-destination="{$index-id}" starting-state="hide">
        <fo:bookmark-title font-weight="bold" color="#943634">
          <xsl:value-of select="$index-title"/>
        </fo:bookmark-title>
      </fo:bookmark>

      <xsl:if test="substring-after($formalStage, '-')='20'">
        <xsl:variable name="ednotes-id">EditorNotesBlock</xsl:variable>
        <xsl:variable name="ednotes-title">Editor<apos/>s Notes</xsl:variable>
        <fo:bookmark internal-destination="{$ednotes-id}" starting-state="hide">
          <fo:bookmark-title font-weight="bold" color="#943634">
            <xsl:value-of select="$ednotes-title"/>
          </fo:bookmark-title>
        </fo:bookmark>
      </xsl:if>

    </fo:bookmark-tree>

<!--
    We first process the CoverPage sequence by applying the template for the coverPage element
-->
    <fo:page-sequence master-reference="CoverPage" initial-page-number="1" format="i">
      <fo:static-content flow-name="cover-footer">
        <fo:block text-align="end">
          <xsl:choose>
            <xsl:when test="$acknowledge-renderx = 'yes'">
              <fo:block font-family="ArialUnicodeMS">
                <xsl:text>Edited by: </xsl:text>
                <xsl:value-of select="$principleEditor"/>
                <xsl:text> (Ed.)</xsl:text>
                <xsl:value-of select="$associateEditor"/>
              </fo:block>
              <fo:wrapper color="blue">
                <fo:basic-link external-destination="url(http://www.renderx.com)"
                               role="www.renderx.com">
                  <xsl:text>PDF rendering performed by XEP, courtesy of RenderX, Inc.</xsl:text>
                  <fo:external-graphic src="url('renderx-square-logo.jpg')" content-height="30pt"/>
                </fo:basic-link>
              </fo:wrapper>
            </xsl:when>
            <xsl:otherwise>
              <xsl:text>&nbsp;</xsl:text>
            </xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <xsl:apply-templates select="/standard/coverPage"/>
      </fo:flow>
    </fo:page-sequence>

<!--
    Next, we process the CopyrightPage sequence by applying the template for the 
    copyrightNoticePage element, but only if this is not a TC or the TCFrontMatterPage if it is a TC
-->
    <fo:page-sequence master-reference="CopyrightPage" format="i">
      <fo:static-content flow-name="xsl-region-after">
        <fo:block text-align="start"><fo:page-number/></fo:block>
      </fo:static-content>
      <fo:flow flow-name="xsl-region-body">
        <xsl:apply-templates
          select="/standard/copyrightNoticePage | /standard/alternateCopyrightNoticePage"/>
      </fo:flow>
    </fo:page-sequence>

<!--
    Then, we call the template for the TOC and start applying templates for the Foreword, the 
    Introduction, the Clauses, and the Annexes, after which we call the Index template.
-->
<!--
    This version of the code is for INCITS standards only!!!!!!!!!!!!!!!!!!!!!!!!
-->
    <xsl:if test="$docStage = 'INCITS'">
      <xsl:call-template name="toc">
        <xsl:with-param name="initial-page-number"><xsl:text>1</xsl:text></xsl:with-param>
        <xsl:with-param name="format"><xsl:text>i</xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
<!--
    This version of the code is for ISO standards only!!!!!!!!!!!!!!!!!!!!!!!!!!!
-->
    <xsl:if test="$docStage != 'INCITS'">
      <xsl:call-template name="toc">
        <xsl:with-param name="initial-page-number"><xsl:text>3</xsl:text></xsl:with-param>
        <xsl:with-param name="format"><xsl:text>i</xsl:text></xsl:with-param>
      </xsl:call-template>
    </xsl:if>
 
    <xsl:apply-templates select="/standard/standardPartBody/foreword"/>
    <xsl:apply-templates select="/standard/standardPartBody/intro"/>
    <xsl:apply-templates select="/standard/standardPartBody/clause"/>
    <xsl:apply-templates select="/standard/backMatter/annex"/>
    <xsl:apply-templates select="/standard/backMatter/bibliography"/>
<!-- ****************************************************************************** -->
<!-- *** DECISION REQUIRED - - Automaticall "call" index, or apply a template?  ***
    <xsl:call-template name="index"/>
-->
<!-- ****************************************************************************** -->
    <xsl:apply-templates select="/standard/index"/>
<!-- ****************************************************************************** -->
<!--
    <xsl:call-template name="index"/>
-->
    <xsl:apply-templates select="/standard/EditorNotes"/>
  </fo:root>
</xsl:template>


<!--
    Process the foreword element
-->
<xsl:template match="foreword">
  <!-- Test for the presence of <mergeWith> elements in any Clause or Subclause that
       does not have a <modifiesPart> element.  Issue an error message with the
       values of the @id attribute of all such Clauses/Subclauses. -->
  <xsl:for-each select="//(clause | annex | subClause | subClause2 | subClause3 | subClause4)
                          //mergeWith[1]">
    <xsl:variable name="sectionContaining-mergeWith"
                  select="(ancestor::clause[1] | ancestor::annex[1] |
                           ancestor::subClause[1] | ancestor::subClause2[1] |
                           ancestor::subClause3[1] | ancestor::subClause4[1])
                           [last()]"/>
    <xsl:choose>
      <xsl:when test="$sectionContaining-mergeWith[modifiesPart]"></xsl:when>
      <xsl:otherwise>
<!-- LINE LENGTH CHECK OFF -->
        <xsl:message>ERROR: mergeWith without associated modifiesPart. @id = <xsl:value-of select="$sectionContaining-mergeWith/@id"/>. </xsl:message>
<!-- LINE LENGTH CHECK ON -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>

  <!-- 2019-02-22: ISO/CS does not want any blank pages!! So don't!
  <fo:page-sequence master-reference="foreword-sequence"
      initial-page-number="auto-odd" format="i">
  -->
  <fo:page-sequence master-reference="foreword-sequence" initial-page-number="auto" format="i">
    <xsl:call-template name="standard-static-contents">
      <xsl:with-param name="page-kind">foreword</xsl:with-param>
      <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
    </xsl:call-template>

    <fo:flow flow-name="xsl-region-body" text-align="justify">
      <fo:marker marker-class-name="clauseString">
        <fo:wrapper font-weight="bold">
          <xsl:text>Foreword</xsl:text>
        </fo:wrapper>
      </fo:marker>
<!--
    The Foreword starts off with a heading 
-->
      <fo:block font-weight="{$head-weight}" font-size="{$head1-size}" text-align="start"
                line-height="3" id="ForewordBlock">
        <xsl:value-of select="forewordHeading"/>
      </fo:block>
<!--
    Then, the Foreword just contains normal body elements
-->
      <fo:block text-align="start">
        <xsl:apply-templates select="forewordBody"/>
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>


<!--
    Process the intro element
-->
<xsl:template match="intro">
  <fo:page-sequence master-reference="intro-sequence" format="i">
    <xsl:call-template name="standard-static-contents">
      <xsl:with-param name="page-kind">intro</xsl:with-param>
      <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
    </xsl:call-template>

    <fo:flow flow-name="xsl-region-body" text-align="start">
      <fo:marker marker-class-name="clauseString">
        <fo:wrapper font-weight="bold">
          <xsl:text>Introduction</xsl:text>
        </fo:wrapper>
      </fo:marker>
<!--
    The Introduction starts off with a heading
-->
      <fo:block font-weight="{$head-weight}" font-size="{$head1-size}" text-align="start"
                line-height="3" id="IntroBlock">
        <xsl:value-of select="introHeading"/>
      </fo:block>
<!--
    Then, the Introduction just contains normal body elements
-->
      <fo:block text-align="start">
        <xsl:apply-templates select="introBody"/>
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>


<!--
    The clause element is used for every clause, including the Scope clause.
    There are two templates for the clause element.
    The first template is for the Scope clause; the other is for all others.
-->
<xsl:template match="clause[position()=1]">
  <!-- Force this to be a page on the right-hand/odd side -->
  <fo:page-sequence master-reference="scope-clause-sequence" initial-page-number="1" format="1">
    <xsl:call-template name="standard-static-contents">
      <xsl:with-param name="page-kind">scope-clause</xsl:with-param>
      <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
    </xsl:call-template>
    <fo:flow flow-name="xsl-region-body" text-align="start">
<!--
    We process the partHeading and partTitle elements from the standardPartBody content.
-->
<!--
    The scopeClause of the document starts off with a partHeading
-->
      <fo:block font="{$partHeading-weight} {$partHeading-size} {$font-name}" text-align="start">
        <xsl:apply-templates select="../partHeading"/>
      </fo:block>
<!--
    The scopeClause of the document continues with a partTitle
-->
      <fo:block font-weight="{$head-weight}" font-size="{$head1-size}" text-align="start">
        <xsl:apply-templates select="../partTitle"/>
      </fo:block>
<!--
    A scope element is a clauseHeading followed by bodyMatter
-->
      <fo:block id="'{@id}'">
        <xsl:call-template name="all-headings"/>
        <xsl:apply-templates select="*[not(self::partHeading) and
                                       not(self::partTitle) and
                                       not(self::clauseHeading) and
                                       not(self::clauseNumber)]" />
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>


<!--
    This template is for all clause elements other than the first
-->
<xsl:template match="clause[position()>1]">
  <!-- 2019-02-22: ISO/CS does not want any blank pages!! So don't!
       Force this to be a page on the right-hand/odd side
  <fo:page-sequence master-reference="other-clause-sequence" initial-page-number="auto-odd" 
                    format="1">
-->
  <fo:page-sequence master-reference="other-clause-sequence" initial-page-number="auto" format="1">
    <xsl:call-template name="standard-static-contents">
      <xsl:with-param name="page-kind">other-clause</xsl:with-param>
      <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
    </xsl:call-template>
    <fo:flow flow-name="xsl-region-body" text-align="start">
<!--
    A clause element is a clauseHeading followed by bodyMatter
-->
      <fo:block id="'{@id}'">
        <xsl:call-template name="all-headings"/>
        <xsl:apply-templates select="*[not(self::partHeading) and
                                       not(self::partTitle) and
                                       not(self::clauseHeading) and
                                       not(self::clauseNumber)]" />
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>


<!--
    This template is for all annex elements
-->
<xsl:template match="annex">
  <!-- 2019-02-22: ISO/CS does not want any blank pages!! So don't!
       Force this to be a page on the right-hand/odd side
  <fo:page-sequence master-reference="annex-sequence" initial-page-number="auto-odd" format="1">
  -->
  <fo:page-sequence master-reference="annex-sequence" initial-page-number="auto" format="1">
    <xsl:call-template name="standard-static-contents">
      <xsl:with-param name="page-kind">annex</xsl:with-param>
      <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
    </xsl:call-template>
    <fo:flow flow-name="xsl-region-body" text-align="start">
    <!-- An annex element is a clauseHeading followed by bodyMatter -->
      <fo:block id="'{@id}'">
        <xsl:call-template name="all-headings"/>
        <xsl:apply-templates select="*[not(self::partHeading) and
                                       not(self::partTitle) and
                                       not(self::clauseHeading) and
                                       not(self::clauseNumber)]" />
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>


<xsl:template match="bibliography">
  <!-- 2019-02-22: ISO/CS does not want any blank pages!! So don't!
       Force this to be a page on the right-hand/odd side
  <fo:page-sequence master-reference="bibliography-sequence" initial-page-number="auto-odd" 
                    format="1">
-->
  <fo:page-sequence master-reference="bibliography-sequence" initial-page-number="auto" format="1">
    <xsl:call-template name="standard-static-contents">
      <xsl:with-param name="page-kind">bibliography</xsl:with-param>
      <xsl:with-param name="page-number"><fo:page-number/></xsl:with-param>
    </xsl:call-template>
    <fo:flow flow-name="xsl-region-body" text-align="start">
<!--
    A bibliography element is a fixed heading, a bibtitle a bibdescription, and an optional URI
-->
      <fo:block id="BibliographyBlock">
        <fo:block id="'{@id}'" font-size="{$head1-size}" line-height="3"
                  space-before.optimum="{$bibliography-space-before}"
                  space-after.optimum="{$bibliography-space-after}" hyphenate="true"
                  font-weight="{$head-weight}" text-align="center">
          <xsl:text>Bibliography</xsl:text>
        </fo:block>
      </fo:block>
      <fo:list-block provisional-label-separation="3pt"
                     space-before.optimum="6pt">
        <xsl:attribute name="provisional-distance-between-starts">
          <xsl:value-of select="$list-bibliography-label-body-separation"/>
        </xsl:attribute>
        <xsl:apply-templates/>
      </fo:list-block>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>


<!--
===================================================================================================
===================================================================================================
The following include causes the templates (etc.) for all remaining elements of the standard
to be included into the stylesheet. 
===================================================================================================
===================================================================================================
-->


<xsl:include href="./StandardFormatting.xsl"/>
  
</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c) 2004-2008. Progress Software Corporation. All rights reserved.

<metaInformation>
  <scenarios>
    <scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="guide-model.xml" htmlbaseurl="" outputurl="" processortype="internal" useresolver="yes" profilemode="0" profiledepth="" profilelength="" urlprofilexml=""
              commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator=""/>
  </scenarios>
  <MapperMetaTag>
    <MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
    <MapperBlockPosition></MapperBlockPosition>
    <TemplateContext></TemplateContext>
    <MapperFilter side="source"></MapperFilter>
  </MapperMetaTag>
</metaInformation>
-->