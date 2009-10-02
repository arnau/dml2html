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
      <dml:item property="dct:issued">2009-09-28</dml:item>
      <dml:item property="dct:modified">2009-09-29</dml:item>
      <dml:item property="dct:description">
        <p>Common templates library for dml2html.</p>
      </dml:item>
      <dml:item property="dct:license">
        <!-- todo -->
      </dml:item>
    </dml:list>
  </dml:note>
  
  <xsl:template name="common.children">
    <xsl:choose>
      <xsl:when test="@href">
        <xsl:call-template name="href.controller"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template name="common.attributes">
    <xsl:param name="class.attribute" as="xs:string?" tunnel="yes"/>
    <xsl:if test="@class or $class.attribute">
      <xsl:attribute name="class" select="(@class, if ($class.attribute) then $class.attribute else ())"/>
    </xsl:if>
    <xsl:if test="@dir">
      <xsl:attribute name="dir" select="@dir"/>
    </xsl:if>
    
    <xsl:if test="@status">
      <xsl:sequence select="df:message(('@status attribute not yet implemented.'), 'warning')"/>
    </xsl:if>
    
    <xsl:if test="@xml:lang">
      <xsl:choose>
        <xsl:when test="$output.type eq 'xml'">
          <xsl:attribute name="xml:lang" select="@xml:lang"/>
        </xsl:when>
        <xsl:when test="$output.type eq 'html'">
          <xsl:attribute name="lang" select="@xml:lang"/>
        </xsl:when>
        <xsl:when test="$output.type eq 'xhtml'">
          <xsl:attribute name="xml:lang" select="@xml:lang"/>
          <xsl:attribute name="lang" select="@xml:lang"/>
        </xsl:when>
      </xsl:choose>
    </xsl:if>

    <xsl:if test="@xml:id">
      <xsl:attribute name="id" select="@xml:id"/>
    </xsl:if>
    
    <xsl:if test="@xml:base and $output.type eq 'xml'">
      <xsl:attribute name="xml:base" select="@xml:base"/>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="href.controller">
    <xsl:variable name="href" select="@href"/>
    <xsl:variable name="first.char" select="substring( $href, 1, 1 )"/>
    <xsl:variable name="idref" select="substring-after( $href, '#' )"/>
    <xsl:variable name="element.name" select="id( $idref )/local-name()"/>

    <xsl:choose>
      <xsl:when test="dml:cell | dml:dml | dml:example | dml:figure | dml:group | dml:item | dml:list | dml:note | dml:p | dml:section | dml:summary | dml:table | dml:title">
        <xsl:sequence select="df:message(('Block elements cannot be child of', name(), 'element when it has @href attribute.'),'fail')"/>
      </xsl:when>
      <xsl:when test="($first.char eq '#') and not( id( $idref ) )">
        <xsl:choose>
          <xsl:when test="xs:boolean( $debug )">
            <span class="xref.error">
              <xsl:apply-templates/> (xref error)
            </span>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <a href="{$href}">
          <xsl:apply-templates/>
        </a>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- 
<xsl:template name="common.children">
  <xsl:variable name="href" select="@href"/>
  <xsl:variable name="first.char" select="substring( $href, 1, 1 )"/>
  <xsl:variable name="idref" select="substring-after( $href, '#' )"/>
  <xsl:variable name="element.name" select="id( $idref )/local-name()"/>
  <xsl:choose>
    <xsl:when test="not( id( $idref ) ) and $first.char eq '#'">
      <xsl:choose>
        <xsl:when test="xs:boolean( $debug )">
          <fo:inline xsl:use-attribute-sets="xref.error">
            <xsl:apply-templates/> (xref error)
          </fo:inline>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="//dml:note[( @role eq 'footnote' ) and ( @xml:id eq $idref )] and $href">
      <xsl:call-template name="xref.footnote">
        <xsl:with-param name="idref" select="$idref"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$href">
      <fo:basic-link xsl:use-attribute-sets="toc.xref">
        <xsl:choose>
          <xsl:when test="$first.char eq '#'">
            <xsl:attribute name="internal-destination" select="$idref"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:attribute name="external-destination" select="$href"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
      </fo:basic-link>
      <fo:inline xsl:use-attribute-sets="xref">
        <xsl:text> (</xsl:text>
        <xsl:choose>
          <xsl:when test="$first.char eq '#'">
            <xsl:if test="xs:boolean( $header.numbers ) and id( $idref )[ancestor-or-self::dml:*[parent::dml:dml and count( preceding-sibling::dml:section ) ge xs:integer( $toc.skipped.sections )]]">
              <xsl:for-each select="id( $idref )">
                <xsl:variable name="number">
                  <xsl:call-template name="header.number"/>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="$element.name eq 'table'">
                    <xsl:value-of select="concat( $literals/literals/table.label, ' ', $number )"/>
                    <xsl:number from="dml:section" count="dml:table" level="any" format="-1"/>
                  </xsl:when>
                  <xsl:when test="$element.name eq 'figure'">
                    <xsl:value-of select="concat( $literals/literals/figure.label, ' ', $number )"/>
                    <xsl:number from="dml:section" count="dml:figure" level="any" format="-1"/>
                  </xsl:when>
                  <xsl:when test="$element.name eq 'example'">
                    <xsl:value-of select="concat( $literals/literals/example.label, ' ', $number )"/>
                    <xsl:number from="dml:section" count="dml:example" level="any" format="-1"/>
                  </xsl:when>
                  <xsl:when test="id( $idref )/ancestor-or-self::*[@role='appendix']">
                    <xsl:value-of select="concat( $literals/literals/appendix.prefix, ' ', $number )"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:value-of select="concat( $literals/literals/section, ' ', $number )"/>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
              <xsl:text>, </xsl:text>
            </xsl:if>
            <xsl:value-of select="concat( $literals/literals/page/@abbr, ' ' )"/>
            <fo:page-number-citation ref-id="{$idref}"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$href"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:text>)</xsl:text>
      </fo:inline>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
-->


  <xsl:template name="common.attributes.and.children">
    <xsl:call-template name="common.attributes"/>
    <xsl:call-template name="common.children"/>
  </xsl:template>
</xsl:stylesheet>