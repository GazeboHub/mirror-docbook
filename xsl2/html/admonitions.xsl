<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2004/10/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="h f m fn db xs"
                version="2.0">

<xsl:variable name="admon.graphics" select="0"/>
<xsl:variable name="admon.graphics.path" select="'../xsl/images/'"/>
<xsl:variable name="admon.graphics.extension" select="'.png'"/>

<xsl:template match="db:note|db:important|db:warning|db:caution|db:tip">
  <xsl:choose>
    <xsl:when test="$admon.graphics != 0">
      <xsl:apply-templates select="." mode="m:graphical-admonition"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="titlepage"
		    select="$titlepages/*[fn:node-name(.)
			                  = fn:node-name(current())][1]"/>
      <div class="{f:admonition-class(.)}">
	<xsl:call-template name="id"/>
	<xsl:call-template name="class"/>

	<xsl:if test="db:info/db:title">
	  <div class="admon-title">
	    <xsl:call-template name="titlepage">
	      <xsl:with-param name="content" select="$titlepage"/>
	    </xsl:call-template>
	  </div>
	</xsl:if>

	<xsl:apply-templates select="*[not(self::db:info)]"/>
      </div>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:note|db:important|db:warning|db:caution|db:tip"
	      mode="m:graphical-admonition">
  <xsl:variable name="titlepage"
		select="$titlepages/*[fn:node-name(.)
			              = fn:node-name(current())][1]"/>

  <xsl:variable name="admon.type">
    <xsl:choose>
      <xsl:when test="self::db:note">Note</xsl:when>
      <xsl:when test="self::db:warning">Warning</xsl:when>
      <xsl:when test="self::db:caution">Caution</xsl:when>
      <xsl:when test="self::db:tip">Tip</xsl:when>
      <xsl:when test="self::db:important">Important</xsl:when>
      <xsl:otherwise>Note</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="alt">
    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="$admon.type"/>
    </xsl:call-template>
  </xsl:variable>

  <div class="{f:admonition-class(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <div class="admon-title">
      <span class="admon-graphic">
	<img alt="{$alt}">
	  <xsl:attribute name="src">
	    <xsl:call-template name="admon.graphic"/>
	  </xsl:attribute>
	</img>
      </span>

      <xsl:if test="db:info/db:title">
	<span class="admon-title-text">
	  <xsl:call-template name="titlepage">
	    <xsl:with-param name="content" select="$titlepage"/>
	  </xsl:call-template>
	</span>
      </xsl:if>
    </div>

    <div class="admon-text">
      <xsl:apply-templates/>
    </div>
  </div>
</xsl:template>

<xsl:template name="admon.graphic">
  <xsl:param name="node" select="."/>
  <xsl:value-of select="$admon.graphics.path"/>
  <xsl:choose>
    <xsl:when test="local-name($node)='note'">note</xsl:when>
    <xsl:when test="local-name($node)='warning'">warning</xsl:when>
    <xsl:when test="local-name($node)='caution'">caution</xsl:when>
    <xsl:when test="local-name($node)='tip'">tip</xsl:when>
    <xsl:when test="local-name($node)='important'">important</xsl:when>
    <xsl:otherwise>note</xsl:otherwise>
  </xsl:choose>
  <xsl:value-of select="$admon.graphics.extension"/>
</xsl:template>

<xsl:function name="f:admonition-class" as="xs:string">
  <xsl:param name="node" as="element()"/>

  <!-- If you want different classes for each admonition type...
  <xsl:value-of select="local-name($node)"/>
  -->

  <xsl:value-of select="'admonition'"/>
</xsl:function>

</xsl:stylesheet>
