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
      <dml:item property="dct:issued">2009-10-01</dml:item>
      <dml:item property="dct:modified">2009-10-13</dml:item>
      <dml:item property="dct:description">
        <p>Block templates for dml2html.</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>
  
  <xsl:template match="dml:dml/dml:title" mode="metadata">
    <title><xsl:call-template name="common.attributes.and.children"/></title>
  </xsl:template>
  <xsl:template match="dml:example/dml:title | dml:figure/dml:title">
    <p property="dct:title">
      <xsl:call-template name="common.attributes"/>
      <xsl:call-template name="example.and.figure.number"/>
      <xsl:call-template name="common.children"/>
    </p>
  </xsl:template>
  <xsl:template match="dml:title">
    <xsl:variable name="header" select="concat('h', count(ancestor::*))"/>
    <xsl:element name="{$header}">
      <xsl:call-template name="common.attributes"/>
      <xsl:if test="parent::dml:section">
        <xsl:call-template name="header.number"/>
      </xsl:if>
      <xsl:call-template name="common.children"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dml:section">
    <xsl:if test="count(/dml:dml/dml:section) le $toc.skipped.sections">
      <xsl:sequence select="df:message(('$toc.skipped.sections is out of range. This document has only', count(/dml:dml/dml:section), 'sections.'), 'fail')"/>
    </xsl:if>
    <xsl:if test="
      $toc and
      parent::dml:dml and ($toc.position eq 0) and
      (count(preceding-sibling::dml:section) eq $toc.skipped.sections)
    ">
      <xsl:call-template name="toc"/>
    </xsl:if>
    <div>
      <xsl:call-template name="common.attributes.and.children"/>
    </div>
  </xsl:template>
  <xsl:template match="dml:p">
    <p><xsl:call-template name="common.attributes.and.children"/></p>
  </xsl:template>
  
  <xsl:template match="dml:list">
    <xsl:if test="dml:item/dml:title and (@role eq 'ordered')">
        <xsl:sequence select="df:message('dml2html no has implementation for ordered definition lists.', 'warning')"/>
    </xsl:if>
    <xsl:variable name="element.name" select="
      if (dml:item/dml:title) then
        'dl'
      else if (@role eq 'ordered') then 
        'ol' 
      else 'ul'
    "/>

    <xsl:apply-templates select="dml:title" mode="self"/>
    
    <xsl:element name="{$element.name}">
      <xsl:call-template name="common.attributes"/>
      <xsl:apply-templates select="node() except dml:title" mode="self"/>
    </xsl:element>
  </xsl:template>
  
  <xsl:template match="dml:item">
    <xsl:choose>
      <xsl:when test="dml:title">
        <xsl:apply-templates select="dml:title" mode="self"/>
        <dd><xsl:apply-templates select="node() except dml:title" mode="self"/></dd>
      </xsl:when>
      <xsl:otherwise>
        <li><xsl:call-template name="common.attributes.and.children"/></li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dml:item/dml:title">
    <dt><xsl:call-template name="common.attributes.and.children"/></dt>
  </xsl:template>



  <xsl:template match="dml:example | dml:figure">
    <div>
      <xsl:call-template name="common.attributes">
        <xsl:with-param name="class.attribute" tunnel="yes" select="local-name()"/>
      </xsl:call-template>
      <xsl:call-template name="common.children"/>
    </div>
  </xsl:template>

  <xsl:template name="example.and.figure.number">
    <xsl:variable name="number">
      <xsl:call-template name="header.number"/>
      <xsl:choose>
        <xsl:when test="parent::dml:example">
          <xsl:number from="dml:section" count="dml:example" level="any" format="-1"/>
        </xsl:when>
        <xsl:when test="parent::dml:figure">
          <xsl:number from="dml:section" count="dml:figure" level="any" format="-1"/>
        </xsl:when>
      </xsl:choose>
    </xsl:variable>
    <xsl:if test="$header.numbers and ancestor::dml:*[parent::dml:dml and count(preceding-sibling::dml:section) ge $toc.skipped.sections]">
      <xsl:value-of select="
        concat(df:literal.constructor(concat(parent::*/local-name(), '.label')), ' ', $number, ': ')"/>
    </xsl:if>
  </xsl:template>

  
  <xsl:template match="dml:note">
    <xsl:variable name="role" select="
      if (@role) then 
        string-join((local-name(), @role), ' ') 
      else 
        string-join(local-name(), ' ')
    "/>
    <div>
      <xsl:call-template name="common.attributes">
        <xsl:with-param name="class.attribute" tunnel="yes" select="$role"/>
      </xsl:call-template>
      <xsl:call-template name="common.children"/>
    </div>
  </xsl:template>

  <xsl:template match="dml:object">
    <xsl:if test="@type">
      <xsl:sequence select="df:message(('@type attribute not yet implemented.'), 'warning')"/>
    </xsl:if>
    <xsl:variable name="image.mime.types" select="('image/png', 'image/gif', 'image/jpg', 'image/tiff', 'image/bmp')"/>
    <xsl:variable name="type" select="
      if (empty(@type)) then
        ''
      else if (some $i in $image.mime.types satisfies @type) then
        replace(@type, 'image/(.+)', '$1')
      else
        'object'
    "/>
    <xsl:variable name="src.attribute" select="
      if (matches(@src, $fallback.pattern)) then
        (
          replace(@src, '(/.+)\.svg$', 
          $fallback.pattern.replace), df:message(('SVG fallback to PNG.'), 'warning')
        )
      else
        @src
    "/>
    <xsl:variable name="child.elements" select="concat('(', string-join(for $i in child::* return $i/name(), ','), ')')"/>
    <xsl:variable name="alt.attribute" select="
      if (some $i in . satisfies element()) then
        (
          normalize-space(),
          df:message(('Cleaned the element nodes found as alternate content of dml:object element.', $child.elements, '.'), 'info')
        )
      else
        normalize-space()
    "/>
    <xsl:choose>
      <xsl:when test="$type eq 'object'">
        <xsl:sequence select="df:message(('dml:object has no output yet as html:object.'), 'fail')"/>
      </xsl:when>
      <xsl:otherwise>
        <img src="{$src.attribute}">
          <xsl:attribute name="alt"><xsl:value-of select="$alt.attribute"/></xsl:attribute>
        </img>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dml:quote">
    <xsl:variable name="element.name" select="
      if (
        parent::dml:cell | parent::dml:dml | parent::dml:example | parent::dml:figure |
        parent::dml:note | parent::dml:section |
        parent::dml:item[dml:example | dml:figure | dml:p | dml:title | dml:note]
      ) then
        'blockquote'
      else if (not(dml:example | dml:figure | dml:list | dml:note | dml:p | dml:title | dml:section | dml:table)) then
        'q'
      else
        df:message(('Invalid', name(), 'element. Wrong parent or children.'), 'fail')
    "/>
    <xsl:element name="{$element.name}">
      <xsl:if test="@about">
        <xsl:attribute name="cite" select="@about"/>
      </xsl:if>
      <xsl:choose>
        <xsl:when test="$quote.marks">
          <xsl:call-template name="quote.marks">
            <xsl:with-param name="quote.type" tunnel="yes" select="$element.name"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="common.attributes.and.children">
            <xsl:with-param name="quote.type" tunnel="yes" select="$element.name"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:element>
  </xsl:template>
  
  <xsl:template name="quote.marks">
    <xsl:param name="quote.type" as="xs:string" tunnel="yes"/>
    <xsl:variable name="inline.ancestors.count" select="
      count(
        ancestor-or-self::dml:quote[not(parent::dml:dml | parent::example | parent::dml:figure |
        parent::dml:note | parent::dml:section |
        parent::dml:item[dml:example | dml:figure | dml:p | dml:title | dml:note])]
      )
    "/>

    <xsl:call-template name="common.attributes"/>
    <xsl:value-of select="
      if ($quote.type eq 'q') then 
        df:quotes(., 'open', $inline.ancestors.count)
      else 
        ()
    "/>
    <xsl:call-template name="common.children"/>
    <xsl:value-of select="
      if ($quote.type eq 'q') then 
        df:quotes(., 'close', $inline.ancestors.count)
      else 
        ()
    "/>
  </xsl:template>

  <xsl:template match="dml:citation">
    <xsl:param name="quote.type" as="xs:string" tunnel="yes"/>
    <xsl:variable name="element.name" select="if ($quote.type eq 'blockquote') then 'p' else 'span'"/>
    <xsl:element name="{$element.name}">
      <xsl:call-template name="common.attributes.and.children">
        <xsl:with-param name="class.attribute" tunnel="yes" select="local-name()"/>
      </xsl:call-template>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>