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
      <dml:item property="dct:issued">2009-09-28</dml:item>
      <dml:item property="dct:modified">2009-10-23</dml:item>
      <dml:item property="dct:description">
        <p>Common templates library for dml2html.</p>
      </dml:item>
      <dml:item property="dct:rights">
        Copyright 2009 Arnau Siches
      </dml:item>
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
  
  <xsl:template match="*" mode="self">
    <xsl:apply-templates select="
      if ($debug) then
        self::node()
      else
        self::node()[not(some $i in $status.hidden.values satisfies $i eq @status)]
    "/>
  </xsl:template>

  <xsl:template name="common.children">
    <xsl:param name="strip.links" tunnel="yes" as="xs:boolean?"/>
    <xsl:variable name="href.attribute" select="@href"/>
    <xsl:variable name="first.char" select="substring($href.attribute, 1, 1)"/>
    <xsl:variable name="idref" select="substring-after($href.attribute, '#')"/>

    <xsl:choose>
      <xsl:when test="not(boolean($href.attribute)) or $strip.links">
        <xsl:apply-templates mode="self"/>
      </xsl:when>
      <xsl:when test="*[@href]">
        <xsl:sequence select="df:message('Elements with @href attributes cannot has children with @href attribute.','fail')"/>
      </xsl:when>
      <xsl:when test="dml:cell | dml:dml | dml:example | dml:figure | dml:group | dml:item | dml:list | dml:note | dml:p | dml:section | dml:summary | dml:table | dml:title">
        <xsl:sequence select="df:message(('Block elements cannot be child of', name(), 'element when it has @href attribute.'),'fail')"/>
      </xsl:when>
      <xsl:when test="($first.char eq '#') and not(id($idref))">
        <xsl:choose>
          <xsl:when test="$debug">
            <span class="xref.error">
              <xsl:apply-templates mode="self"/> (xref error)
            </span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="self"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$href.attribute}">
          <xsl:apply-templates mode="self"/>
        </a>
        <xsl:choose>
          <xsl:when test="
            ($first.char eq '#') and id($idref) and $idref = //dml:note[@role eq 'footnote']/@xml:id
          ">
            <xsl:call-template name="footnote.number">
              <xsl:with-param name="idref" tunnel="yes" select="$idref"/>
            </xsl:call-template>
          </xsl:when>
          <xsl:when test="
            ($first.char eq '#') and id($idref) and $header.numbers and
            id($idref)[ancestor-or-self::dml:*[parent::dml:dml and count(preceding-sibling::dml:section) ge $toc.skipped.sections]]
          ">
            <xsl:call-template name="xref.number">
              <xsl:with-param name="idref" tunnel="yes" select="$idref"/>
            </xsl:call-template>
          </xsl:when>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="common.attributes">
    <xsl:param name="class.attribute" as="xs:string?" tunnel="yes"/>
    <xsl:if test="@class or $class.attribute or @status">
      <xsl:attribute name="class" select="
        (
          if (@class) then @class else (), 
          if ($class.attribute) then $class.attribute else (),
          if (@status and $debug) then @status else ()
        )
      "/>
    </xsl:if>
    <xsl:if test="@dir">
      <xsl:attribute name="dir" select="@dir"/>
    </xsl:if>
    
    <xsl:if test="@xml:lang">
      <xsl:choose>
        <xsl:when test="$output.type eq 'xml'">
          <xsl:attribute name="xml:lang" select="@xml:lang"/>
        </xsl:when>
        <xsl:when test="$output.type eq 'html'">
          <xsl:attribute name="lang" select="@xml:lang"/>
        </xsl:when>
        <xsl:when test="$output.type eq 'xhtml'">
          <xsl:attribute name="xml:lang" select="@xml:lang"/>
          <xsl:attribute name="lang" select="@xml:lang"/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="self::dml:section">
        <xsl:call-template name="set.id">
          <xsl:with-param name="id.attribute" tunnel="yes" select="@xml:id"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="@xml:id">
        <xsl:attribute name="id" select="@xml:id"/>
      </xsl:when>
    </xsl:choose>
    
    <xsl:if test="@xml:base and $output.type eq 'xml'">
      <xsl:sequence select="df:message('@xml:base attribute is a non-tested feature.','warning')"/>
      <xsl:attribute name="xml:base" select="@xml:base"/>
    </xsl:if>
    
    <xsl:if test="@status and $debug">
      <xsl:call-template name="set.status"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="set.status">
    <xsl:variable name="status.values" select="('draft', 'review', 'added', 'deleted')"/>

    <xsl:choose>
      <xsl:when test="self::*[dml:group | dml:list | dml:summary | dml:table | dml:object]">
        <xsl:sequence select="df:message(('@status for', name(), 'element not fully implemented'), 'warning')"/>
      </xsl:when>
      <xsl:when test="some $i in $status.values satisfies $i eq @status">
        <xsl:variable name="status.literal" select="concat('debug.', @status)"/>
        <xsl:choose>
          <xsl:when test="empty(df:literal.constructor($status.literal))">
            <xsl:sequence select="df:message(('No literal found in', $literals.path, 'for @status', @status, 'in', $document.language, 'language.'), 'warning')"/>
          </xsl:when>
          <xsl:otherwise>
            <small>(<xsl:value-of select="df:literal.constructor($status.literal)"/>) </small>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="common.attributes.and.children">
    <xsl:call-template name="common.attributes"/>
    <xsl:call-template name="common.children"/>
  </xsl:template>


  <xsl:template name="get.id">
    <xsl:param name="id.attribute" tunnel="yes" as="xs:string?"/>
    <xsl:value-of select="
      if (empty($id.attribute)) then 
        generate-id() 
      else 
        $id.attribute
    "/>
  </xsl:template>
  <xsl:template name="set.id">
    <xsl:attribute name="id">
      <xsl:call-template name="get.id"/>
    </xsl:attribute>
  </xsl:template>
  <xsl:template name="get.idref">
    <xsl:variable name="id">
      <xsl:call-template name="get.id"/>
    </xsl:variable>
    <xsl:value-of select="concat('#', $id)"/>
  </xsl:template>

  <xsl:template name="header.number">
    <xsl:param name="appendix.format.number.type" tunnel="yes" select="$appendix.format.number.type"/>
    <xsl:choose>
      <xsl:when test="ancestor-or-self::dml:*[parent::dml:dml and @role='appendix'] and $appendix.format.number">
        <xsl:number level="multiple" format="{$appendix.format.number.type}"
           count="dml:section[ancestor-or-self::dml:*[parent::dml:dml and @role='appendix']]"/>
      </xsl:when>
      <xsl:when test="ancestor-or-self::dml:*[parent::dml:dml and count(preceding-sibling::dml:section) ge $toc.skipped.sections]">
        <xsl:number level="multiple" format="{$format.number.type}"
           count="dml:section[ancestor-or-self::dml:*[parent::dml:dml and count(preceding-sibling::dml:section) ge $toc.skipped.sections]]"/>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="section.number">
    <xsl:if test="$header.numbers">
      <xsl:variable name="number">
        <xsl:call-template name="header.number"/>
      </xsl:variable>
      <xsl:value-of select="
        if (parent::dml:section[@role='appendix'] and $appendix.format.number) then
          concat(df:literal.constructor('appendix.prefix'), ' ', $number, ' ', $appendix.separator, ' ')
        else if (parent::dml:section) then
          concat($number, ' ')
        else
          $number
      "/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="element.number">
    <xsl:if test="$header.numbers">
      <xsl:variable name="number">
        <xsl:call-template name="header.number"/>
        <!-- <xsl:number from="dml:section" count="dml:*[some $i in $numbered.elements satisfies $i eq parent::dml:*/local-name()]" level="any" format="-1"/> -->
        <xsl:choose>
          <xsl:when test="parent::dml:example">
            <xsl:number from="dml:section" count="dml:example" level="any" format="-1"/>
          </xsl:when>
          <xsl:when test="parent::dml:figure">
            <xsl:number from="dml:section" count="dml:figure" level="any" format="-1"/>
          </xsl:when>
          <xsl:when test="parent::dml:table">
            <xsl:number from="dml:section" count="dml:table" level="any" format="-1"/>
          </xsl:when>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="ancestor::dml:*[parent::dml:dml and count(preceding-sibling::dml:section) ge $toc.skipped.sections]">
        <strong>
          <xsl:value-of select="
            concat(df:literal.constructor(concat(parent::dml:*/local-name(), '.label')), ' ', $number, ': ')"/>
        </strong>
      </xsl:if>
    </xsl:if>
  </xsl:template>


  <xsl:template name="xref.number">
    <xsl:param name="idref" tunnel="yes"/>
    <xsl:if test="$xref.numbers and not(ancestor::dml:title)">
      <xsl:variable name="element.name" select="id($idref)/local-name()"/>
      <xsl:for-each select="id($idref)">
        <xsl:variable name="number">
          <xsl:call-template name="header.number"/>
        </xsl:variable>

        <xsl:variable name="set.number">
          <xsl:choose>
            <xsl:when test="some $i in $numbered.elements satisfies $i eq $element.name">
              <xsl:value-of select="concat(df:literal.constructor(concat($element.name, '.label')), ' ', $number)"/>
              <xsl:number from="dml:section" count="dml:*[local-name() eq $element.name]" level="any" format="-1"/>
            </xsl:when>
            <xsl:when test="id($idref)/ancestor-or-self::*[@role='appendix']">
              <xsl:value-of select="concat(df:literal.constructor('appendix.prefix'), ' ', $number)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="concat(df:literal.constructor('section.label'), ' ', $number)"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:value-of select="concat(' (', $set.number,')')"/>

      </xsl:for-each>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>