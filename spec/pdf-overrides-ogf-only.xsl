<?xml version="1.0" encoding="UTF-8"?>
<!--
  PDF style overrides for the OGF edition only.

  tools/overrides.py adds everything inside this stylesheet to
  pdf-overrides.xsl, which both editions use, to make pdf-overrides-ogf.xsl,
  the override spec/dfdl-ogf.adoc names.  The ISO edition never sees these.

  Nothing that changes between releases is typed here.  The text comes from
  presentation-metadata-ogf-* attributes in spec/dfdl-ogf.adoc, which reach
  the built XML as presentation metadata.
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:mn="https://www.metanorma.org/ns/standoc">

  <xsl:variable name="ogf" select="/mn:metanorma/mn:metanorma-extension/mn:presentation-metadata"/>

  <!--
    One attribute's value.  Metanorma splits a presentation-metadata value at
    its commas into several elements of the same name, so join them again.
  -->
  <xsl:template name="ogf-value">
    <xsl:param name="name"/>
    <xsl:for-each select="$ogf/*[local-name() = $name]">
      <xsl:if test="position() &gt; 1">, </xsl:if>
      <xsl:value-of select="normalize-space(.)"/>
    </xsl:for-each>
  </xsl:template>

  <!--
    Header and footer, as in the MS-Word v1.2.2 draft: the document number,
    with the dates on the right, above; the OGF address, with the page number
    on the right, below.  Word numbers front matter pages bare ("ii") and
    body pages as "Page 2".  No copyright line: OGF carries its copyright on
    the cover and in the Full Copyright Notice, not on every page.
  -->
  <xsl:template name="ogf-header-block">
    <fo:block-container margin-top="12mm">
      <fo:table table-layout="fixed" width="100%" font-size="10pt">
        <fo:table-column column-width="50%"/>
        <fo:table-column column-width="50%"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block><xsl:call-template name="ogf-value"><xsl:with-param name="name">ogf-docid</xsl:with-param></xsl:call-template></fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <fo:block><xsl:call-template name="ogf-value"><xsl:with-param name="name">ogf-date</xsl:with-param></xsl:call-template></fo:block>
              <fo:block><xsl:call-template name="ogf-value"><xsl:with-param name="name">ogf-updated</xsl:with-param></xsl:call-template></fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block-container>
  </xsl:template>

  <xsl:template name="ogf-footer-block">
    <xsl:param name="preface"/>
    <fo:block-container margin-top="4mm">
      <fo:table table-layout="fixed" width="100%" font-size="10pt">
        <fo:table-column column-width="50%"/>
        <fo:table-column column-width="50%"/>
        <fo:table-body>
          <fo:table-row>
            <fo:table-cell>
              <fo:block><xsl:call-template name="ogf-value"><xsl:with-param name="name">ogf-contact</xsl:with-param></xsl:call-template></fo:block>
            </fo:table-cell>
            <fo:table-cell text-align="right">
              <fo:block><xsl:if test="$preface != 'true'">Page </xsl:if><fo:page-number/></fo:block>
            </fo:table-cell>
          </fo:table-row>
        </fo:table-body>
      </fo:table>
    </fo:block-container>
  </xsl:template>

  <xsl:template name="insertHeader">
    <xsl:param name="num"/>
    <xsl:param name="is_header">true</xsl:param>
    <xsl:param name="border_around_page">false</xsl:param>
    <xsl:param name="insert_header_first">true</xsl:param>
    <fo:static-content flow-name="header-even" role="artifact"><xsl:call-template name="ogf-header-block"/></fo:static-content>
    <xsl:if test="$insert_header_first = 'true'">
      <fo:static-content flow-name="header-first" role="artifact"><xsl:call-template name="ogf-header-block"/></fo:static-content>
    </xsl:if>
    <fo:static-content flow-name="header-odd" role="artifact"><xsl:call-template name="ogf-header-block"/></fo:static-content>
  </xsl:template>

  <xsl:template name="insertFooter">
    <xsl:param name="num"/>
    <xsl:param name="font-weight" select="'bold'"/>
    <xsl:param name="is_footer">false</xsl:param>
    <xsl:param name="insert_footer_last">true</xsl:param>
    <xsl:variable name="preface">
      <xsl:choose>
        <xsl:when test="parent::mn:preface or self::mn:preface">true</xsl:when>
        <xsl:otherwise>false</xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <fo:static-content flow-name="footer-even" role="artifact"><xsl:call-template name="ogf-footer-block"><xsl:with-param name="preface" select="$preface"/></xsl:call-template></fo:static-content>
    <xsl:if test="$insert_footer_last = 'true'">
      <fo:static-content flow-name="footer-even-last" role="artifact"><xsl:call-template name="ogf-footer-block"><xsl:with-param name="preface" select="$preface"/></xsl:call-template></fo:static-content>
    </xsl:if>
    <fo:static-content flow-name="footer-odd" role="artifact"><xsl:call-template name="ogf-footer-block"><xsl:with-param name="preface" select="$preface"/></xsl:call-template></fo:static-content>
  </xsl:template>

</xsl:stylesheet>
