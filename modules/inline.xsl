<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="2.0" xml:lang="en"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns="http://www.w3.org/1999/xhtml"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:dml="http://purl.oclc.org/NET/dml/1.0/"
  xmlns:pml="http://purl.oclc.org/NET/pml/1.0/"
  xmlns:dct="http://purl.org/dc/terms/"
  xmlns:df="dml:functions"
  exclude-result-prefixes="xs dml pml df">
  
  <dml:note>
    <dml:list>
      <dml:item property="dct:creator">Arnau Siches</dml:item>
      <dml:item property="dct:created">2009-09-29</dml:item>
      <dml:item property="dct:modified">2009-12-22</dml:item>
      <dml:item property="dct:description">
        <p>Inline templates for dml2html.</p>
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
        <xsl:call-template name="common.children"/>
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