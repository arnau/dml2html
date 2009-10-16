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
  
  <xsl:import href="functions/common.xsl"/>
  <xsl:import href="modules/params.xsl"/>
  <xsl:import href="modules/common.xsl"/>
  <xsl:import href="modules/inline.xsl"/>
  <xsl:import href="modules/block.xsl"/>
  <xsl:import href="modules/table.xsl"/>
  <xsl:import href="modules/toc.xsl"/>
  <xsl:import href="modules/pml2html.xsl"/>

  <dml:note>
    <dml:list>
      <dml:item property="dct:creator">Arnau Siches</dml:item>
      <dml:item property="dct:issued">2009-09-28</dml:item>
      <dml:item property="dct:modified">2009-10-12</dml:item>
      <dml:item property="dct:description">
        <p>Transforms a DML source to HTML.</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>

  <xsl:output 
    method="xhtml" 
    version="1.0" 
    encoding="utf-8" 
    indent="yes" 
    media-type="application/xhtml+xml" 
    omit-xml-declaration="no" 
    doctype-public="-//W3C//DTD XHTML+RDFa 1.0//EN" 
    doctype-system="http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd"/>

  <xsl:strip-space elements="dml:*"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dml:dml | dml:note">
    <html>
      <xsl:call-template name="common.attributes"/>
      <xsl:call-template name="head"/>
      <xsl:call-template name="body"/>
    </html>
  </xsl:template>
  
  <xsl:template name="head">
    <head>
      <xsl:apply-templates select="dml:title" mode="metadata"/>
      <xsl:call-template name="link.stylesheet"/>
    </head>
  </xsl:template>
  <xsl:template name="body">
    <body>
      <xsl:if test="$toc and ($toc.position eq -1)">
        <xsl:call-template name="toc"/>
      </xsl:if>
      <xsl:apply-templates mode="self"/>
      <xsl:if test="$toc and ($toc.position eq 1)">
        <xsl:call-template name="toc"/>
      </xsl:if>
    </body>
  </xsl:template>
  
  <xsl:template name="link.stylesheet">
    <link rel="stylesheet" type="text/css" href="{$link.stylesheet.all}" media="all"/>
  </xsl:template>
  
  
  <xsl:template match="dml:metadata"/>
  
</xsl:stylesheet>