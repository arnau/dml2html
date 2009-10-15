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
      <dml:item property="dct:modified">2009-10-06</dml:item>
      <dml:item property="dct:description">
        <p>Table of Contents for dml2fo.xsl.</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>

  <xsl:template name="toc">
    <div id="toc">
      <h2><xsl:value-of select="df:literal.constructor('toc.title')"/></h2>
      <ul>
        <xsl:apply-templates select="
          if ($debug) then
            /dml:dml/dml:section[(position() gt xs:integer($toc.skipped.sections))]
          else 
            /dml:dml/dml:section[(position() gt xs:integer($toc.skipped.sections)) and 
            not(some $i in $status.hidden.values satisfies @status)]
        " mode="toc"/>
      </ul>
    </div>
  </xsl:template>
  
  <xsl:template match="dml:section" mode="toc">
    <xsl:variable name="idref">
      <xsl:call-template name="get.idref">
        <xsl:with-param name="id.attribute" tunnel="yes" select="@xml:id"/>
      </xsl:call-template>
    </xsl:variable>
    <li>
      <xsl:apply-templates select="dml:title" mode="toc">
        <xsl:with-param name="href.attribute" tunnel="yes" select="$idref"/>
      </xsl:apply-templates>
      <xsl:if test="dml:section and (count(ancestor::dml:section) + 1 lt xs:integer($toc.depth))">
        <ul>
          <xsl:apply-templates select="
            if ($debug) then
              dml:section
            else
              dml:section[not(some $i in $status.hidden.values satisfies @status)]
          " mode="toc"/>
        </ul>
      </xsl:if>
    </li>
  </xsl:template>
  
  <xsl:template match="dml:title" mode="toc">
    <xsl:param name="href.attribute" tunnel="yes" as="xs:anyURI"/>
    <a>
      <xsl:attribute name="href" select="$href.attribute"/>
      <xsl:call-template name="common.children"/>
    </a>
  </xsl:template>
  
<!--

  <xsl:template match="dml:section" mode="toc">
    <xsl:variable name="number">
      <xsl:call-template name="header.number">
        <xsl:with-param name="format.number.type">1. </xsl:with-param>
        <xsl:with-param name="appendix.format.number.type" select="concat($appendix.format.number.type, ' ' )"/>
      </xsl:call-template>
    </xsl:variable>
    <fo:list-item xsl:use-attribute-sets="item">
      <fo:list-item-body>
        <fo:block text-align-last="justify">
          <fo:basic-link xsl:use-attribute-sets="toc.xref">
            <xsl:attribute name="internal-destination">
              <xsl:call-template name="get.id"/>
            </xsl:attribute>
            <xsl:value-of select="
              if ( @role='appendix' and xs:boolean( $appendix.format.number ) ) then
                concat( $literals/literals/appendix.prefix, ' ', $number, $appendix.separator, ' ' )
              else
                $number
            "/>
            <xsl:apply-templates select="dml:title" mode="toc"/>
          </fo:basic-link>
          <fo:leader leader-pattern="use-content">. </fo:leader>
          <fo:page-number-citation>
            <xsl:attribute name="ref-id">
              <xsl:call-template name="get.id"/>
            </xsl:attribute>
          </fo:page-number-citation>
          <xsl:if test="dml:section and ( count( ancestor::dml:section ) + 1 lt xs:integer( $toc.depth ) )">
            <xsl:choose>
              <xsl:when test="not( xs:boolean( $debug ) ) and dml:section[not( @status = $status.hidden.values )] and dml:section[@status = $status.hidden.values]">
                <fo:list-block xsl:use-attribute-sets="list.nested toc.number">
                  <xsl:apply-templates select="dml:section[not( @status = $status.hidden.values )]" mode="toc"/>
                </fo:list-block>
              </xsl:when>
              <xsl:when test="not( xs:boolean( $debug ) ) and dml:section[@status = $status.hidden.values]"/>
              <xsl:otherwise>
                <fo:list-block xsl:use-attribute-sets="list.nested toc.number">
                  <xsl:apply-templates select="dml:section" mode="toc"/>
                </fo:list-block>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:if>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>
 -->

</xsl:stylesheet>