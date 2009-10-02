<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dml="http://purl.oclc.org/NET/dml/1.0/"
  xmlns:pml="http://purl.oclc.org/NET/pml/1.0/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:df="dml:functions"
  exclude-result-prefixes="xs dml pml df">

  <xsl:import href="string.xsl"/>
  <xsl:import href="highlight.xsl"/>

  <dml:note>
    <dml:list>
      <dml:item property="dct:creator">Arnau Siches</dml:item>
      <dml:item property="dct:issued">2009-09-30</dml:item>
      <dml:item property="dct:modified">2009-10-01</dml:item>
      <dml:item property="dct:description">Common functions</dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>

  <xsl:function name="df:message">
    <xsl:param name="message" as="item()+"/>
    <xsl:param name="level" as="xs:string"/>
    <xsl:variable name="message" select="string-join(for $i in $message return string($i), ' ')"/>
    <xsl:variable name="levels" select="('info', 'warning', 'fallback', 'resource')"/>
    <xsl:variable name="condition" select="some $i in $levels satisfies $i eq $level"/>
    <xsl:message terminate="{if ($condition) then 'no' else 'yes'}">
      <xsl:value-of select="
        if ($condition) then
          (upper-case( $level ), $message)
        else
          ('FATAL ERROR', $message)
      " separator=": "/>
    </xsl:message>
  </xsl:function>


  <xsl:function name="df:quotes">
    <xsl:param name="context" as="item()"/>
    <xsl:param name="type" as="xs:string"/>
    <xsl:param name="ancestors" as="xs:integer"/>
    
    <xsl:variable name="position" select="
      if ($type eq 'open') then 
        (1, 3)
      else if ($type eq 'close') then
        (2, 4)
      else
        df:message(('df:quotes() $type only allow values `open` and `close`'), 'fail')
    "/>
    <xsl:variable name="quote.variant" select="
      if (lang('ca', $context)) then
        (:tokenize($ca.quote.variant, ','):)
        $ca.quote.variant
      else if (lang('es', $context)) then
        $es.quote.variant
      else if (lang('ja', $context)) then
        $ja.quote.variant
      else if (lang('en', $context)) then
        $en.quote.variant
      else
        $default.quote.variant
    "/>
    <xsl:sequence select="
      if (($ancestors = 1) or empty($quote.variant[$position[1]]) or empty($quote.variant[$position[2]])) then
          $quote.variant[$position[1]]
      else
        $quote.variant[$position[2]]
    "/>
  </xsl:function>

</xsl:stylesheet>