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
      <dml:item property="dct:modified">2009-10-23</dml:item>
      <dml:item property="dct:description">
        <p>Table templates for dml2html.</p>
      </dml:item>
      <dml:item property="dct:license" about="http://www.gnu.org/licenses/gpl-3.0.html">Copyright 2009 Arnau Siches</dml:item>
    </dml:list>
  </dml:note>

  <xsl:template match="dml:table">
    <table>
      <xsl:sequence select="
        if (@scope) then
          df:message('@scope attribute is not yet implemented. Fallback to @scope=row', 'warning')
        else
          df:message('@scope attribute is required for dml:table element. Fallback to @scope=row', 'warning')
      "/>
      <xsl:call-template name="set.summary"/>
      <xsl:call-template name="common.attributes.and.children"/>
    </table>
  </xsl:template>

  <xsl:template name="set.summary">
    <xsl:if test="dml:summary">
      <xsl:variable name="child.elements" select="concat('(', string-join(for $i in dml:summary/* return $i/name(), ','), ')')"/>
      <xsl:attribute name="summary" select="
        if (some $i in dml:summary/* satisfies element()) then
          (
            normalize-space(dml:summary),
            df:message(('Cleaned the children element nodes found in dml:summary element.', $child.elements, '.'), 'info')
          )
        else
          normalize-space(dml:summary)
      "/>
    </xsl:if>
  </xsl:template>
  <xsl:template match="dml:summary"/>

  <xsl:template match="dml:table/dml:title">
    <caption>
      <xsl:call-template name="common.attributes"/>
      <xsl:call-template name="element.number"/>
      <xsl:call-template name="common.children"/>
    </caption>
  </xsl:template>
  
  <xsl:template match="dml:group">
    <xsl:choose>
      <xsl:when test="@role eq 'header'">
        <thead><xsl:call-template name="common.attributes.and.children"/></thead>
      </xsl:when>
      <xsl:when test="@role eq 'footer'">
        <tfoot><xsl:call-template name="common.attributes.and.children"/></tfoot>
      </xsl:when>
      <xsl:when test="parent::dml:table">
        <tbody><xsl:call-template name="common.attributes.and.children"/></tbody>
      </xsl:when>
      <xsl:otherwise>
        <tr><xsl:call-template name="common.attributes.and.children"/></tr>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="dml:group/dml:title">
    <th>
      <xsl:call-template name="common.attributes.and.children"/>
    </th>
  </xsl:template>

  <xsl:template match="dml:cell">
    <td>
      <xsl:call-template name="common.attributes.and.children"/>
    </td>
  </xsl:template>

</xsl:stylesheet>