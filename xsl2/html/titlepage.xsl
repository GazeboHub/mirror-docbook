<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
		exclude-result-prefixes="h f m fn db"
                version="2.0">

<xsl:template match="db:info">
  <!-- nop -->
</xsl:template>

<!-- Don't use unions in matches because there's a bug in Saxon 8.1.1! -->

<xsl:template match="db:set/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h1>
    <xsl:next-match/>
  </h1>
</xsl:template>

<xsl:template match="db:book/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h1>
    <xsl:next-match/>
  </h1>
</xsl:template>

<xsl:template match="db:part/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h1>
    <xsl:next-match/>
  </h1>
</xsl:template>

<xsl:template match="db:chapter/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:appendix/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:preface/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:bibliography/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:bibliodiv/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:glossary/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:glossdiv/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:section/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="depth"
		select="count(ancestor::db:section)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>
  
  <xsl:element name="h{$hlevel+2}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:attribute name="depth" select="$depth"/>
    <xsl:next-match/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:figure/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:orderedlist/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:itemizedlist/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:title" mode="m:titlepage-mode">
  <xsl:apply-templates select="../.." mode="m:object.title.markup">
    <xsl:with-param name="allow-anchors" select="1"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-mode">
  <xsl:apply-templates select="."/>
</xsl:template>

</xsl:stylesheet>
