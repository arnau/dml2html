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
      <dml:item property="dct:created">2009-09-30</dml:item>
      <dml:item property="dct:modified">2009-10-23</dml:item>
      <dml:item property="dct:description">
        <p>Templates for pml2html.</p>
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
  
  <!-- <xsl:strip-space elements="pml:node pml:value"/> -->
  <xsl:strip-space elements="pml:*"/>

  <xsl:template match="pml:code">
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
      <xsl:call-template name="code.languages"/>
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
      <xsl:call-template name="common.children.with.href"/>
    </span>
  </xsl:template>
  
  <xsl:template match="pml:datatype">
    <code>
      <xsl:call-template name="common.attributes.and.children">
        <xsl:with-param name="class.attribute" tunnel="yes" select="local-name()"/>
      </xsl:call-template>
    </code>
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
      <xsl:value-of select="
        if (@type eq 'optional') then
          concat(' (', df:literal.constructor('param.optional.label') , ')')
        else
        ()
      "/>
    </var>
  </xsl:template>

  <xsl:template match="pml:value">
    <xsl:variable name="quotes" select="tokenize($value.quotes, ',')"/>
    <code>
      <xsl:call-template name="common.attributes">
        <xsl:with-param name="class.attribute" tunnel="yes" select="local-name()"/>
      </xsl:call-template>
      <xsl:value-of select="if ($quotes[1]) then $quotes[1] else ()"/>
      <xsl:call-template name="common.children"/>
      <xsl:value-of select="if ($quotes[2]) then $quotes[2] else ()"/>
    </code>
  </xsl:template>


  <xsl:template name="code.languages">
    <xsl:choose>
      <xsl:when test="@language eq 'xml'">
        <xsl:copy-of select="df:xml(., $code.linelength)"/>
      </xsl:when>
      <xsl:when test="@language eq 'css'">
        <xsl:copy-of select="df:css(., $code.linelength)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:if test="@language">
          <xsl:sequence select="df:message(('highlighting for', @language , 'code not yet implemented.'), 'warning')"/>
        </xsl:if>
        <!-- <xsl:variable name="context">
          <xsl:value-of select="df:linelength(., $code.linelength)"/>
        </xsl:variable>
        <xsl:copy-of select="replace($context, '(.+)\s*$', '$1')"/> -->
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
    <!-- <xsl:choose>
      <xsl:when test="@language='ebnf'">
        <xsl:copy-of select="df:ebnf(., $code.linelength)"/>
      </xsl:when>
      <xsl:when test="@language='xpath'">
        <xsl:copy-of select="df:xpath(., $code.linelength)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="context">
          <xsl:value-of select="df:linelength(., $code.linelength)"/>
        </xsl:variable>
        <xsl:copy-of select="replace($context, '(.+)\s*$', '$1')"/>
      </xsl:otherwise>
    </xsl:choose> -->
  </xsl:template>

</xsl:stylesheet>