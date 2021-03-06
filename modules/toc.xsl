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
        <p>Table of Contents for dml2fo.xsl.</p>
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

  <xsl:template name="toc">
    <div id="toc">
      <h2><xsl:value-of select="df:literal.constructor('toc.title')"/></h2>
      <ul>
        <xsl:apply-templates select="
          if ($debug) then
            /dml:dml/dml:section[(position() gt $toc.skipped.sections)]
          else 
            /dml:dml/dml:section[(position() gt $toc.skipped.sections) and 
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
      <xsl:if test="dml:section and (count(ancestor::dml:section) + 1 lt $toc.depth)">
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
    <a href="{$href.attribute}" property="dct:title">
      <span class="header-number"><xsl:call-template name="section.number"/></span>
      <xsl:call-template name="common.children">
        <xsl:with-param name="strip.links" tunnel="yes">true</xsl:with-param>
      </xsl:call-template>
    </a>
  </xsl:template>
</xsl:stylesheet>