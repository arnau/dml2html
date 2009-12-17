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
  exclude-result-prefixes="xs dml pml df rdf">
  
  <xsl:import href="functions/common.xsl"/>
  <xsl:import href="modules/params.xsl"/>
  <xsl:import href="modules/common.xsl"/>
  <xsl:import href="modules/inline.xsl"/>
  <xsl:import href="modules/block.xsl"/>
  <xsl:import href="modules/table.xsl"/>
  <xsl:import href="modules/toc.xsl"/>
  <xsl:import href="modules/metadata.xsl"/>
  <xsl:import href="modules/pml2html.xsl"/>

  <dml:note>
    <dml:list>
      <dml:item property="dct:creator">Arnau Siches</dml:item>
      <dml:item property="dct:created">2009-09-28</dml:item>
      <dml:item property="dct:modified">2009-12-17</dml:item>
      <dml:item property="dct:description">
        <p>Transforms a DML source to HTML.</p>
      </dml:item>
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

  <xsl:output 
    method="xhtml" 
    version="1.0" 
    encoding="utf-8" 
    indent="yes" 
    media-type="application/xhtml+xml" 
    omit-xml-declaration="no" 
    doctype-public="-//W3C//DTD XHTML+RDFa 1.0//EN" 
    doctype-system="http://www.w3.org/MarkUp/DTD/xhtml-rdfa-1.dtd"/>

  <xsl:variable name="program.name">dml2html</xsl:variable>
  <xsl:variable name="program.version">0.9</xsl:variable>

  <xsl:strip-space elements="dml:dml dml:section"/>

  <xsl:template match="/">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="dml:dml | /dml:note">
    <html>
      <xsl:call-template name="common.attributes"/>
      <xsl:call-template name="head"/>
      <xsl:call-template name="body"/>
    </html>
  </xsl:template>
  
  <xsl:template name="head">
    <head profile="http://dublincore.org/documents/2008/08/04/dc-html/">
      <xsl:call-template name="metadata"/>
      <xsl:call-template name="link.stylesheet"/>
    </head>
  </xsl:template>
  <xsl:template name="body">
    <body>
      <xsl:if test="$toc and ($toc.position eq -1)">
        <xsl:call-template name="toc"/>
      </xsl:if>
      <xsl:apply-templates mode="self"/>

      <xsl:sequence select="df:message('Footnotes are experimental and only visibles with $debug = true', 'warning')"/>
      <xsl:if test="$debug">
        <xsl:call-template name="set.footnotes"/>
      </xsl:if>

      <xsl:if test="$toc and ($toc.position eq 1)">
        <xsl:call-template name="toc"/>
      </xsl:if>
      
      <xsl:call-template name="license"/>
    </body>
  </xsl:template>
  
  <xsl:template name="link.stylesheet">
    <link rel="stylesheet" type="text/css" href="{$link.stylesheet.all}" media="all"/>
  </xsl:template>
  
  
  <xsl:template match="dml:metadata">
    <xsl:if test="$metadata.section">
      <!-- <xsl:call-template name="common.attributes.and.children"/> -->
      <dl class="metadata">
        <xsl:sequence select="df:set.metadata(df:literal.constructor('document.issued.label'), $document.issued, 'dct:issued')"/>
        <xsl:sequence select="df:set.metadata(df:literal.constructor('document.editor.label'), $document.creator, 'dct:creator')"/>
        <!-- <xsl:sequence select="df:set.metadata(df:literal.constructor('document.editor.label'), string-join(($document.creator, $document.publisher), ', '))"/> -->
        <xsl:sequence select="df:set.metadata(df:literal.constructor('document.version.label'), $document.identifier, 'dct:identifier')"/>
      </dl>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="license">
    <xsl:if test="$license.section and exists($document.rights)">
      <div id="footer" property="dct:rights">
        <xsl:apply-templates select="$document.rights"/>
      </div>
    </xsl:if>
  </xsl:template>
  
</xsl:stylesheet>