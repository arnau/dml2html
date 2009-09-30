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
      <dml:item property="dct:modified">2009-09-29</dml:item>
      <dml:item property="dct:description">
        <p>Common templates library for dml2html.</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>

  <xsl:template name="common.children">
    <xsl:apply-templates/>
  </xsl:template>
  <xsl:template name="common.attributes">
    <xsl:param name="class.attribute" as="xs:string?" tunnel="yes"/>
    <xsl:if test="@class or $class.attribute">
      <xsl:attribute name="class" select="(@class, if ($class.attribute) then $class.attribute else ())"/>
    </xsl:if>
    <xsl:if test="@dir">
      <xsl:attribute name="dir" select="@dir"/>
    </xsl:if>
    
    <xsl:if test="@href">
      <xsl:sequence select="df:message(('@href attribute not yet implemented.'), 'warning')"/>
    </xsl:if>

    <xsl:if test="@status">
      <xsl:sequence select="df:message(('@status attribute not yet implemented.'), 'warning')"/>
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

    <xsl:if test="@xml:id">
      <xsl:attribute name="id" select="@xml:id"/>
    </xsl:if>
    
    <xsl:if test="@xml:base and $output.type eq 'xml'">
      <xsl:attribute name="xml:base" select="@xml:base"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="common.attributes.and.children">
    <xsl:call-template name="common.attributes"/>
    <xsl:call-template name="common.children"/>
  </xsl:template>
</xsl:stylesheet>