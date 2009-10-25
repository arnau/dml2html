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
      <dml:item property="dct:created">2009-09-30</dml:item>
      <dml:item property="dct:modified">2009-10-25</dml:item>
      <dml:item property="dct:description">Common functions</dml:item>
      <dml:item property="dct:rights">Copyright 2009 Arnau Siches</dml:item>
      <dml:item property="dct:license">
        This file is part of dml2html.

        dml2html is free software: you can redistribute it and/or modify
        it under the terms of the GNU General Public License as published by
        the Free Software Foundation, either version 3 of the License, or
        (at your option) any later version.

        dml2html is distributed in the hope that it will be useful,
        but WITHOUT ANY WARRANTY; without even the implied warranty of
        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
        GNU General Public License for more details.

        You should have received a copy of the GNU General Public License
        along with dml2html.  If not, see http://www.gnu.org/licenses/.
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
          (upper-case($level), $message)
        else
          ('FATAL ERROR', $message)
      " separator=": "/>
    </xsl:message>
  </xsl:function>

  <xsl:function name="df:param.constructor">
    <xsl:param name="param.name" as="xs:string"/>
    
    <xsl:variable name="values" select="$params//*[@rdf:ID eq $param.name]/rdf:value"/>
    <xsl:sequence select="$values"/>
  </xsl:function>

  <xsl:function name="df:param.constructor">
    <xsl:param name="param.name" as="xs:string"/>
    <xsl:param name="lang" as="xs:string"/>
    
    <xsl:sequence select="
      if (string-length($lang) != 2) then
        df:message(concat('$lang of df:param.constructor(''', $param.name ,''', $lang) needs a valid ISO 639-1 language code'), 'fail')
      else
        ()
    "/>
    <xsl:variable name="values" select="$params//*[@rdf:ID eq $param.name]/rdf:value[lang($lang)]"/>
    <xsl:sequence select="$values"/>
  </xsl:function>

  <xsl:function name="df:literal.constructor">
    <xsl:param name="literal.name" as="xs:string"/>
    
    <xsl:variable name="literal" select="$literals//*[@rdf:ID eq $literal.name]/rdf:value[lang($document.language)]"/>
    <xsl:variable name="default.literal" select="$literals//*[@rdf:ID eq $literal.name]/rdf:value[not(@xml:lang)]"/>
    <xsl:sequence select="if ($literal) then $literal else $default.literal"/>
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
        tokenize($ca.quote.variant, ',')
      else if (lang('es', $context)) then
        tokenize($es.quote.variant, ',')
      else if (lang('ja', $context)) then
        tokenize($ja.quote.variant, ',')
      else if (lang('en', $context)) then
        tokenize($en.quote.variant, ',')
      else
        tokenize($default.quote.variant, ',')
    "/>
    <xsl:sequence select="
      if (($ancestors = 1) or empty($quote.variant[$position[1]]) or empty($quote.variant[$position[2]])) then
          $quote.variant[$position[1]]
      else
        $quote.variant[$position[2]]
    "/>
  </xsl:function>


  <xsl:function name="df:get.metadata">
    <xsl:param name="context"/>
    <xsl:param name="type" as="xs:string"/>
    <xsl:sequence select="
      $context//*[
        (replace(@property, '.+:(.+)', '$1') eq $type) and
        (some $i in $metadata.ns satisfies $i eq namespace-uri-for-prefix(replace(@property, '(.+):.+', '$1'), /*))
      ]/node()
    "/>
  </xsl:function>

</xsl:stylesheet>