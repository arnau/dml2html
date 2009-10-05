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
      <dml:item property="dct:modified">2009-10-05</dml:item>
      <dml:item property="dct:description">
        <p>Common templates library for dml2html.</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>
  
  <xsl:template name="common.children">
    <xsl:choose>
      <xsl:when test="@href">
        <xsl:call-template name="href.controller">
          <xsl:with-param name="href.attribute" tunnel="yes" select="@href"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="common.attributes">
    <xsl:param name="class.attribute" as="xs:string?" tunnel="yes"/>
    <xsl:if test="@class or $class.attribute">
      <xsl:attribute name="class" select="(@class, if ($class.attribute) then $class.attribute else ())"/>
    </xsl:if>
    <xsl:if test="@dir">
      <xsl:attribute name="dir" select="@dir"/>
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
      <xsl:sequence select="df:message('@xml:base attribute is a non-tested feature.','warning')"/>
      <xsl:attribute name="xml:base" select="@xml:base"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="href.controller">
    <xsl:param name="href.attribute" tunnel="yes" as="xs:anyURI"/>
    <xsl:variable name="first.char" select="substring( $href.attribute, 1, 1 )"/>
    <xsl:variable name="idref" select="substring-after( $href.attribute, '#' )"/>
    
    <xsl:choose>
      <xsl:when test="dml:cell | dml:dml | dml:example | dml:figure | dml:group | dml:item | dml:list | dml:note | dml:p | dml:section | dml:summary | dml:table | dml:title">
        <xsl:sequence select="df:message(('Block elements cannot be child of', name(), 'element when it has @href attribute.'),'fail')"/>
      </xsl:when>
      <xsl:when test="($first.char eq '#') and not( id( $idref ) )">
        <xsl:choose>
          <xsl:when test="xs:boolean( $debug )">
            <span class="xref.error">
              <xsl:apply-templates/> (xref error)
            </span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$href.attribute}">
          <xsl:apply-templates/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="common.attributes.and.children">
    <xsl:call-template name="common.attributes"/>
    <xsl:call-template name="common.children"/>
  </xsl:template>
</xsl:stylesheet>