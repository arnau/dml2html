<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dml="http://purl.oclc.org/NET/dml/1.0/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:df="dml:functions"
  exclude-result-prefixes="xs dml rdf df">

  <dml:note>
    <dml:list>
      <dml:item property="dct:creator">Arnau Siches</dml:item>
      <dml:item property="dct:issued">2009-09-28</dml:item>
      <dml:item property="dct:issued">2009-10-14</dml:item>
      <dml:item property="dct:description">
        <p>Basic parameters and attribute set definitions for dml2html.xsl</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>

  <xsl:param name="literals.path" as="xs:anyURI">../literals/literals.rdf</xsl:param>
  <xsl:variable name="document.language" select="/*/@xml:lang"/>
  <xsl:variable name="literals" select="document($literals.path)"/>

  <xsl:param name="params.path" as="xs:anyURI">../config/config.rdf</xsl:param>
  <xsl:variable name="params" select="document($params.path)"/>

  <xsl:param name="debug" select="df:param.constructor('debug')" as="xs:boolean"/>
  <xsl:param name="status.hidden.values" select="df:param.constructor('status.hidden.values')" as="item()*"/>
  <xsl:param name="link.stylesheet.all" select="df:param.constructor('link.stylesheet.all')" as="xs:anyURI"/>
  <xsl:param name="output.type" select="df:param.constructor('output.type')" as="xs:string"/>
  <xsl:param name="output.types" select="df:param.constructor('output.types')" as="xs:string+"/>

  <xsl:param name="toc" select="df:param.constructor('toc')" as="xs:boolean"/>
  <xsl:param name="toc.depth" select="df:param.constructor('toc.depth')" as="xs:integer"/>
  <xsl:param name="toc.skipped.sections" select="df:param.constructor('toc.skipped.sections')" as="xs:integer"/>
  <xsl:param name="toc.position" select="df:param.constructor('toc.position')" as="xs:integer"/>

  <xsl:param name="header.numbers" select="df:param.constructor('header.numbers')" as="xs:boolean"/>
  <xsl:param name="xref.numbers" select="df:param.constructor('xref.numbers')" as="xs:boolean"/>
  <xsl:param name="numbered.elements" select="df:param.constructor('numbered.elements')" as="item()+"/>
  <xsl:param name="format.number.type" select="df:param.constructor('format.number.type')" as="xs:string"/>
  <xsl:param name="appendix.format.number" select="df:param.constructor('appendix.format.number')" as="xs:boolean"/>
  <xsl:param name="appendix.separator" select="df:param.constructor('appendix.separator')" as="xs:string"/>
  <xsl:param name="appendix.format.number.type" select="df:param.constructor('appendix.format.number.type')" as="xs:string"/>

  <xsl:param name="quote.marks" select="df:param.constructor('quote.marks')" as="xs:boolean"/>
  <xsl:param name="fallback.pattern" select="df:param.constructor('fallback.pattern')" as="xs:string"/>
  <xsl:param name="fallback.pattern.replace" select="df:param.constructor('fallback.pattern.replace')" as="xs:string"/>
  <xsl:param name="node.element.prefix" select="df:param.constructor('node.element.prefix')" as="xs:string"/>
  <xsl:param name="node.attribute.prefix" select="df:param.constructor('node.attribute.prefix')" as="xs:string"/>
  <xsl:param name="value.quotes" select="df:param.constructor('value.quotes')" as="xs:string"/>
  <xsl:param name="code.linelength" select="df:param.constructor('code.linelength')" as="xs:integer"/>

  <xsl:param name="default.quote.variant" select="df:param.constructor('quote.variant', 'en')" as="xs:string"/>
  <xsl:param name="ca.quote.variant" select="df:param.constructor('quote.variant', 'ca')" as="xs:string"/>
  <xsl:param name="en.quote.variant" select="df:param.constructor('quote.variant', 'en')" as="xs:string"/>
  <xsl:param name="es.quote.variant" select="df:param.constructor('quote.variant', 'es')" as="xs:string"/>
  <xsl:param name="ja.quote.variant" select="df:param.constructor('quote.variant', 'ja')" as="xs:string"/>

</xsl:stylesheet>