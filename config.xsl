<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dml="http://purl.oclc.org/NET/dml/1.0/"
  xmlns:dct="http://purl.org/dc/terms/"
  exclude-result-prefixes="xs dml">

  <dml:note>
    <dml:list>
      <dml:item property="dct:creator">Arnau Siches</dml:item>
      <dml:item property="dct:issued">2008-12-27</dml:item>
      <dml:item property="dct:description">
        <p>Basic parameters and attribute set definitions for dml2html.xsl</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>

  <!-- dml2html.xsl -->
  <xsl:param name="link.stylesheet.all" as="xs:anyURI">../styles/original.css</xsl:param> <!-- xs:anyURI -->
  <xsl:param name="output.type" as="xs:string">xml</xsl:param> <!-- (xml | xhtml | html) -->


  <xsl:param name="node.element.prefix"/>
  <xsl:param name="node.attribute.prefix">@</xsl:param>

</xsl:stylesheet>