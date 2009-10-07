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
      <dml:item property="dct:modified">2009-09-30</dml:item>
      <dml:item property="dct:description">
        <p>Table templates for dml2html.</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>
  
  <xsl:template match="dml:cell">
    <xsl:sequence select="df:message((name(), 'not yet implemented.'), 'warning')"/>
  </xsl:template>
  <xsl:template match="dml:group">
    <xsl:sequence select="df:message((name(), 'not yet implemented.'), 'warning')"/>
  </xsl:template>
  <xsl:template match="dml:table">
    <xsl:sequence select="df:message((name(), 'not yet implemented.'), 'warning')"/>
  </xsl:template>
  <xsl:template match="dml:summary">
    <xsl:sequence select="df:message((name(), 'not yet implemented.'), 'warning')"/>
  </xsl:template>
  
</xsl:stylesheet>