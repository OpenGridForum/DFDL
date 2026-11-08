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

</xsl:stylesheet>
