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
      <dml:item property="dct:issued">2009-09-30</dml:item>
      <dml:item property="dct:modified">2009-10-02</dml:item>
      <dml:item property="dct:description">
        <p>Templates for pml2html.</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>
  
  <!-- <xsl:strip-space elements="pml:node pml:value"/> -->
  <xsl:strip-space elements="pml:*"/>

  <xsl:template match="pml:code">
    <xsl:if test="@language">
      <xsl:sequence select="df:message(('highlighting for', @language , 'code not yet implemented.'), 'warning')"/>
    </xsl:if>
    <xsl:variable name="language" select="if (@language) then @language else ()"/>
    <xsl:choose>
      <xsl:when test="parent::dml:dml, parent::dml:section, parent::dml:example, parent::dml:item[dml:example, dml:figure, dml:p, dml:title, dml:note], parent::dml:note">
        <pre>
          <xsl:call-template name="code.template">
            <xsl:with-param name="class.attribute" tunnel="yes" select="$language"/>
          </xsl:call-template>
        </pre>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="code.template">
          <xsl:with-param name="class.attribute" tunnel="yes" select="$language"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="code.template">
    <code>
      <xsl:call-template name="common.attributes"/>
      <!-- <xsl:call-template name="code.languages"/> -->
      <xsl:call-template name="common.children"/>
    </code>
  </xsl:template>

  <xsl:template match="pml:node">
    <xsl:variable name="role" select="@role"/>
    <span>
      <xsl:call-template name="common.attributes">
        <xsl:with-param name="class.attribute" tunnel="yes" select="if ($role ne '') then $role else ()"/>
      </xsl:call-template>
      <xsl:value-of select="
        if ($role eq 'element') then
          $node.element.prefix
        else if ($role eq 'attribute') then
          $node.attribute.prefix
        else
          ()
      "/>
      <xsl:call-template name="common.children"/>
    </span>
  </xsl:template>
  
  <xsl:template match="pml:variable">
    <var>
      <xsl:call-template name="common.attributes.and.children"/>
    </var>
  </xsl:template>

  <xsl:template match="pml:param">
    <var>
      <xsl:call-template name="common.attributes.and.children">
        <xsl:with-param name="class.attribute" tunnel="yes" select="local-name()"/>
      </xsl:call-template>
      <xsl:value-of select="if (@type eq 'optional') then concat(' (', $literals/literals/param.optional.label , ')') else ()"/>
    </var>
  </xsl:template>

  <xsl:template match="pml:value">
    <xsl:variable name="quotes" select="tokenize($value.quotes, ',')"/>
    <span>
      <xsl:call-template name="common.attributes">
        <xsl:with-param name="class.attribute" tunnel="yes" select="local-name()"/>
      </xsl:call-template>
      <xsl:value-of select="if ($quotes[1]) then $quotes[1] else ()"/>
      <xsl:call-template name="common.children"/>
      <xsl:value-of select="if ($quotes[2]) then $quotes[2] else ()"/>
    </span>
  </xsl:template>


<!--
  <xsl:template name="code.languages">
    <xsl:choose>
      <xsl:when test="@language='xml'">
        <xsl:copy-of select="fnc:xml( ., xs:integer( $code.linelength ) )"/>
      </xsl:when>
      <xsl:when test="@language='css'">
        <xsl:copy-of select="fnc:css( ., xs:integer( $code.linelength ) )"/>
      </xsl:when>
      <xsl:when test="@language='ebnf'">
        <xsl:copy-of select="fnc:ebnf( ., xs:integer( $code.linelength ) )"/>
      </xsl:when>
      <xsl:when test="@language='xpath'">
        <xsl:copy-of select="fnc:xpath( ., xs:integer( $code.linelength ) )"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="context">
          <xsl:value-of select="fnc:linelength( ., xs:integer( $code.linelength ) )"/>
        </xsl:variable>
        <xsl:copy-of select="replace( $context, '(.+)\s*$', '$1' )"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="pml:node" mode="toc">
    (!- - prevent duplicate IDs in ToC - -)
    <xsl:variable name="node.prefix">
      <xsl:call-template name="get.node.prefix"/>
    </xsl:variable>
    <fo:inline xsl:use-attribute-sets="code.node">
      <xsl:if test="$node.prefix ne ''"><fo:character character="{$node.prefix}"/></xsl:if><xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="pml:node" mode="bookmark">
    (!- - prevent duplicate IDs in bookmarks - -)
    <xsl:variable name="node.prefix">
      <xsl:call-template name="get.node.prefix"/>
    </xsl:variable>
    <xsl:value-of select="$node.prefix"/><xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="pml:param">
    <fo:inline xsl:use-attribute-sets="code.param">
      <xsl:call-template name="common.attributes.and.children"/>
    </fo:inline>
    <xsl:if test="@type eq 'optional'">
      <fo:inline xsl:use-attribute-sets="em">
        <xsl:value-of select="concat( ' (', $literals/literals/param.optional.label, ')' )"/>
      </fo:inline>
    </xsl:if>

  </xsl:template>

  <xsl:template match="pml:variable">
    <fo:inline xsl:use-attribute-sets="code.variable">
      <xsl:call-template name="common.attributes.and.children"/>
    </fo:inline>
  </xsl:template>
  <xsl:template match="pml:datatype">
    <fo:inline xsl:use-attribute-sets="code.datatype">
      <xsl:call-template name="common.attributes.and.children"/>
    </fo:inline>
  </xsl:template>
 -->

</xsl:stylesheet>