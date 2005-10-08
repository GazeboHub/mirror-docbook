<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/04/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
		exclude-result-prefixes="doc h f m fn db ghost"
                version="2.0">

<xsl:import href="../common/verbatim.xsl"/>

<xsl:template match="db:programlistingco">
  <xsl:variable name="cleanedup" as="element()">
    <xsl:apply-templates select="." mode="m:verbatim-phase-1"/>
  </xsl:variable>

  <xsl:apply-templates select="$cleanedup/db:programlisting"
		       mode="m:verbatim"/>
</xsl:template>

<xsl:template match="db:programlisting|db:address|db:screen|db:synopsis">
  <xsl:variable name="cleanedup" as="element()">
    <xsl:apply-templates select="." mode="m:verbatim-phase-1"/>
  </xsl:variable>

  <xsl:apply-templates select="$cleanedup" mode="m:verbatim"/>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:verbatim" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for processing normalized verbatim elements</refpurpose>

<refdescription>
<para>This mode is used to format normalized verbatim elements.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:programlisting|db:screen|db:synopsis"
	      mode="m:verbatim">

  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <pre>
      <xsl:apply-templates/>
    </pre>
  </div>
</xsl:template>

<xsl:template match="db:address"
	      mode="m:verbatim">

  <div class="{local-name(.)}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="ghost:co">
  <xsl:text>(</xsl:text>
  <xsl:value-of select="@number"/>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="ghost:linenumber">
  <span class="linenumber">
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="ghost:linenumber-separator">
  <span class="linenumber-separator">
    <xsl:apply-templates/>
  </span>
</xsl:template>

</xsl:stylesheet>
