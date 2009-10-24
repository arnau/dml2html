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

  <dml:note>
    <dml:list>
      <dml:item property="dct:creator">Arnau Siches</dml:item>
      <dml:item property="dct:created">2008-10-20</dml:item>
      <dml:item property="dct:modified">2009-09-30</dml:item>
      <dml:item property="dct:description">String functions</dml:item>
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

  <xsl:function name="df:replace">
    <xsl:param name="string"/>
    <xsl:param name="list"/>
    <xsl:value-of select="
      if(empty($list)) 
        then $string 
      else
        df:replace(replace($string,$list[1],$list[2]), $list[position() &gt; 2])
    "/>
  </xsl:function>

  <xsl:function name="df:capitalize">
    <xsl:param name="string"/>
    <xsl:value-of select="
      concat(upper-case(substring($string, 1, 1)), substring($string, 2))
      "/>
  </xsl:function>

  <xsl:function name="df:linelength">
    <xsl:param name="context"/>
    <xsl:param name="limit" as="xs:integer"/>
    <xsl:variable name="line" as="xs:string">^(.+)$</xsl:variable>
    <xsl:analyze-string select="$context" regex="{$line}" flags="m">
      <xsl:matching-substring>
        <xsl:value-of select="df:linelength.controller(., $limit, $limit)"/>
      </xsl:matching-substring>
    </xsl:analyze-string>
  </xsl:function>

  <xsl:function name="df:linelength.controller">
    <xsl:param name="context"/>
    <xsl:param name="limit"/>
    <xsl:param name="original.limit"/>
    <xsl:choose>
      <xsl:when test="string-length($context) le $limit">
        <xsl:value-of select="($context, '&#xA;')" separator=""/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="line" as="xs:string" select="concat('(.{', $limit , '})(.+)')"/>
        <xsl:analyze-string select="$context" regex="{$line}">
          <xsl:matching-substring>
            <xsl:variable name="first.part.line" select="regex-group(1)"/>
            <xsl:variable name="second.part.line" select="regex-group(2)"/>
            <xsl:variable name="indent.spaces.line" select="substring-before($context, normalize-space($context))"/>
            <xsl:variable name="last.char" select="substring($first.part.line, string-length($first.part.line))"/>

            <xsl:choose>
              <xsl:when test="not(matches(normalize-space($first.part.line), '\s')) or matches($last.char, '\s')">
                <xsl:value-of select="
                  (
                    $first.part.line,
                    '&#xA;',
                    $indent.spaces.line,
                    df:linelength($second.part.line, $original.limit - string-length($indent.spaces.line))
                  )" separator=""/>

              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="df:linelength.controller($context, $limit - 1, $original.limit)"/>
              </xsl:otherwise>
            </xsl:choose>

          </xsl:matching-substring>
          <xsl:non-matching-substring>
            <xsl:value-of select="'fail'"/>
          </xsl:non-matching-substring>
        </xsl:analyze-string>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:function>


  <!-- count chars -->
  <!-- sum(for $i in preceding-sibling::text() return string-length($i)) -->
  

</xsl:stylesheet>