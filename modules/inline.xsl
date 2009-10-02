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
      <dml:item property="dct:issued">2009-09-29</dml:item>
      <dml:item property="dct:modified">2009-09-30</dml:item>
      <dml:item property="dct:description">
        <p>Inline templates for dml2html.</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>
  
  <xsl:template match="dml:abbr">
    <abbr>
      <xsl:if test="@about">
        <xsl:sequence select="df:message(('abbr[@about] not fully implemented'), 'warning')"/>
      </xsl:if>
      <xsl:if test="@content or @about">
        <xsl:attribute name="title" select="
          if (@content) then
            @content
          else if (unparsed-text-available(@about)) then
            unparsed-text(@about)
          else
            df:message(('Source problems in abbr[@about] attribute'), 'fail')
        "/>
      </xsl:if>
      <xsl:call-template name="common.attributes.and.children"/>
    </abbr>
  </xsl:template>
  
  <xsl:template match="dml:em">
    <xsl:variable name="element.name" select="if (@role) then 'strong' else 'em'"/>
    <xsl:element name="{$element.name}">
      <xsl:call-template name="common.attributes.and.children"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="dml:span">
    <xsl:choose>
      <xsl:when test="@href">
        <xsl:call-template name="common.attributes.and.children"/>
      </xsl:when>
      <xsl:otherwise>
        <span>
          <xsl:call-template name="common.attributes.and.children"/>
        </span>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dml:sub | dml:sup">
    <xsl:element name="{local-name()}">
      <xsl:call-template name="common.attributes.and.children"/>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>