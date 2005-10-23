<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:db="http://docbook.org/ns/docbook"
		xmlns:src="http://nwalsh.com/xmlns/litprog/fragment"
		exclude-result-prefixes="src"
                version="2.0">

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:preserve-space elements="*"/>

<xsl:template match="/">
  <xsl:element name="xsl:stylesheet">
    <xsl:namespace name="db" select="'http://docbook.org/ns/docbook'"/>
    <xsl:attribute name="version" select="'2.0'"/>
    <xsl:attribute name="exclude-result-prefixes" select="'db'"/>
    <xsl:apply-templates select="//db:refentry" mode="extract"/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:refentry" mode="extract">
  <xsl:variable name="refentry"
		select="document(concat('../params/',@xml:id,'.xml'))"/>

  <xsl:apply-templates select="$refentry//src:fragment/xsl:*"/>
</xsl:template>

<xsl:template match="xsl:*">
  <xsl:element name="{name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="*">
  <xsl:element name="{name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
