<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="h f m fn db doc t xs"
                version="2.0">

<xsl:key name="tdoc" match="doc:template" use="@name"/>
<xsl:key name="fdoc" match="doc:function" use="@name"/>
<xsl:key name="mdoc" match="doc:mode" use="@name"/>

<xsl:template match="/">
  <xsl:variable name="expanded">
    <xsl:apply-templates select="/" mode="expand"/>
  </xsl:variable>

  <xsl:for-each-group select="$expanded//xsl:template[@mode]"
		      group-by="@mode">
    <xsl:if test="not($expanded/key('mdoc', current-grouping-key()))">
      <xsl:message>
	<xsl:text>Mode </xsl:text>
	<xsl:value-of select="current-grouping-key()"/>
	<xsl:text> in </xsl:text>
	<xsl:value-of select="current-group()[1]/ancestor::xsl:module[1]/@href"/>
	<xsl:text>: no documentation.</xsl:text>
      </xsl:message>
    </xsl:if>
  </xsl:for-each-group>

  <xsl:apply-templates select="$expanded/*"/>
</xsl:template>

<xsl:template match="xsl:template[@name and not(@match)]" priority="100">
  <xsl:if test="not(key('tdoc', @name))">
    <xsl:message>
      <xsl:text>Template </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text> in </xsl:text>
      <xsl:value-of select="ancestor::xsl:module[1]/@href"/>
      <xsl:text>: no documentation.</xsl:text>
    </xsl:message>
  </xsl:if>
</xsl:template>

<xsl:template match="xsl:function[@name]" priority="100">
  <xsl:if test="not(key('fdoc', @name))">
    <xsl:message>
      <xsl:text>Function </xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text> in </xsl:text>
      <xsl:value-of select="ancestor::xsl:module[1]/@href"/>
      <xsl:text>: no documentation.</xsl:text>
    </xsl:message>
  </xsl:if>
</xsl:template>

<xsl:template match="*">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="/" mode="expand">
  <xsl:apply-templates mode="expand"/>
</xsl:template>

<xsl:template match="xsl:include|xsl:import" mode="expand" priority="100">
  <xsl:variable name="stylesheet" select="document(@href, .)"/>
  <xsl:element name="module" namespace="http://www.w3.org/1999/XSL/Transform">
    <xsl:attribute name="href" select="@href"/>
    <xsl:apply-templates select="$stylesheet/xsl:stylesheet/node()
				 |$stylesheet/xsl:transform/node()"
			 mode="expand"/>
  </xsl:element>
</xsl:template>

<xsl:template match="*" mode="expand">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="expand"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="text()" mode="expand">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
