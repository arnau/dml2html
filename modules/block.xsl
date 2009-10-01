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
      <dml:item property="dct:modified">2009-10-01</dml:item>
      <dml:item property="dct:description">
        <p>Transforms a DML source to HTML.</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>
  
  <xsl:template match="dml:dml/dml:title" mode="metadata">
    <title><xsl:call-template name="common.attributes.and.children"/></title>
  </xsl:template>
  <xsl:template match="*[self::dml:example, self::dml:figure]/dml:title">
    <p property="dct:title">
      <xsl:call-template name="common.attributes.and.children"/>
    </p>
  </xsl:template>
  <xsl:template match="dml:title">
    <xsl:variable name="header" select="concat('h', count(ancestor::*))"/>
    <xsl:element name="{$header}">
      <xsl:call-template name="common.attributes.and.children"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dml:section">
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

    <xsl:apply-templates select="dml:title"/>
    <xsl:element name="{$element.name}">
      <xsl:call-template name="common.attributes"/>
      <xsl:apply-templates select="* except dml:title"/>
    </xsl:element>
  </xsl:template>
  <xsl:template match="dml:item">
    <xsl:choose>
      <xsl:when test="dml:title">
        <dt>
          <xsl:call-template name="common.attributes"/>
          <xsl:apply-templates select="dml:title/node()"/>
        </dt>
        <dd><xsl:apply-templates select="* except dml:title"/></dd>
      </xsl:when>
      <xsl:otherwise>
        <li><xsl:call-template name="common.attributes.and.children"/></li>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dml:example | dml:figure">
    <div>
      <xsl:call-template name="common.attributes">
        <xsl:with-param name="class.attribute" tunnel="yes" select="local-name()"/>
      </xsl:call-template>
      <xsl:call-template name="common.children"/>
    </div>
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
    <xsl:sequence select="df:message((name(), 'not yet implemented.'), 'warning')"/>
  </xsl:template>

  <xsl:template match="dml:quote">
    <xsl:variable name="element.name" select="
      if (
        parent::dml:cell | parent::dml:dml | parent::dml:example | parent::dml:figure |
        parent::dml:note | parent::dml:section |
        parent::dml:item[dml:example | dml:figure | dml:p | dml:title | dml:note]
      ) then
        'blockquote'
      else if (dml:example | dml:figure | dml:list | dml:note | dml:p | dml:title | dml:section | dml:table) then
        df:message(('Invalid', name(), 'element. Wrong parent or children.'), 'fail')
      else
        'q'
    "/>
    <xsl:variable name="inline.ancestors.count" select="
      count(
        ancestor-or-self::dml:quote[not(parent::dml:dml | parent::example | parent::dml:figure |
        parent::dml:note | parent::dml:section |
        parent::dml:item[dml:example | dml:figure | dml:p | dml:title | dml:note])]
      )
    "/>

    <xsl:element name="{$element.name}">
      <xsl:if test="@about">
        <xsl:attribute name="cite" select="@about"/>
      </xsl:if>
      <xsl:call-template name="common.attributes.and.children">
        <xsl:with-param name="quote.type" tunnel="yes" select="$element.name"/>
      </xsl:call-template>
    </xsl:element>
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