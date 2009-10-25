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

  <dml:note>
    <dml:list>
      <dml:item property="dct:creator">Arnau Siches</dml:item>
      <dml:item property="dct:created">2009-10-24</dml:item>
      <dml:item property="dct:modified">2009-10-24</dml:item>
      <dml:item property="dct:description">
        <p>Metadata templates for dml2html.</p>
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

  <xsl:template name="metadata">
    <title><xsl:value-of select="$document.title"/></title>
    <xsl:sequence select="df:set.metatag('generator', string-join(($program.name, $program.version), ' '))"/>

    <xsl:sequence select="df:set.metatag('description', $document.description)"/>
    <xsl:sequence select="df:set.metatag('keywords', df:join.values($document.subject/*, ','))"/>
    <xsl:sequence select="df:set.metatag('copyright', $document.rights)"/>

    <xsl:if test="exists($document.creator) or exists($document.publisher) or exists($document.issued)">
      <xsl:sequence select="df:set.link('schema.DCTERMS', 'http://purl.org/dc/terms/')"/>
    </xsl:if>
    <xsl:sequence select="df:set.metatag('DCTERMS.creator', $document.creator)"/>
    <xsl:sequence select="df:set.metatag('DCTERMS.publisher', $document.publisher)"/>
    <xsl:sequence select="df:set.metatag('DCTERMS.issued', $document.issued)"/>

  </xsl:template>


  <xsl:function name="df:set.metatag">
    <xsl:param name="meta.name" as="xs:string"/>
    <xsl:param name="meta.content" as="item()*"/>

    <xsl:if test="exists($meta.content)">
      <meta name="{$meta.name}" content="{string-join($meta.content, ', ')}"/>
    </xsl:if>
  </xsl:function>
  <xsl:function name="df:set.link">
    <xsl:param name="link.rel" as="xs:string"/>
    <xsl:param name="link.href" as="xs:string?"/>

    <xsl:if test="exists($link.href)">
      <meta rel="{$link.rel}" content="{$link.href}"/>
    </xsl:if>
  </xsl:function>

  <xsl:function name="df:set.metadata">
    <xsl:param name="label" as="xs:string"/>
    <xsl:param name="value" as="item()*"/>
    <xsl:param name="property" as="xs:string?"/>

    <xsl:if test="exists($value)">
      <dt><xsl:value-of select="$label"/>:</dt>
      <xsl:for-each select="$value">
        <dd>
          <xsl:if test="exists($property)">
            <xsl:attribute name="property" select="$property"/>
          </xsl:if>
          <xsl:sequence select="."/>
        </dd>
      </xsl:for-each>
    </xsl:if>
  </xsl:function>


</xsl:stylesheet>