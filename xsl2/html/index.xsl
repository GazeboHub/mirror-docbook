<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/04/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:t="http://docbook.org/xslt/ns/template"
		exclude-result-prefixes="h f m fn db t"
                version="2.0">

<xsl:template match="db:index">
  <xsl:variable name="recto"
		select="$titlepages/*[node-name(.) = node-name(current())
			              and @t:side='recto'][1]"/>
  <xsl:variable name="verso"
		select="$titlepages/*[node-name(.) = node-name(current())
			              and @t:side='verso'][1]"/>

  <div class="{local-name(.)}">
    <xsl:call-template name="id">
      <xsl:with-param name="force" select="1"/>
    </xsl:call-template>
    <xsl:call-template name="titlepage">
      <xsl:with-param name="content" select="$recto"/>
    </xsl:call-template>

    <xsl:if test="not(empty($verso))">
      <xsl:call-template name="titlepage">
	<xsl:with-param name="content" select="$verso"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:apply-templates/>

    <!-- Empty index element indicates that index should be generated automatically -->
    <xsl:if test="not(db:indexentry) and not(db:indexdiv)">
      <xsl:call-template name="generate-index">
	<xsl:with-param name="scope" select="ancestor::*[last()]"/>
      </xsl:call-template>
    </xsl:if>
  </div>
</xsl:template>

<xsl:template match="db:indexterm">
  <a class="indexterm" name="{f:node-id(.)}"/>
</xsl:template>

<xsl:template match="db:primary|db:secondary|db:tertiary|db:see|db:seealso">
</xsl:template>

<!-- FIXME: add templates to handle manually created index -->

</xsl:stylesheet>
