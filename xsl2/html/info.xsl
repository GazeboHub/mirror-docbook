<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2004/10/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
		exclude-result-prefixes="h f m fn db"
                version="2.0">

<!-- many info elements are handled by ../common/inlines.xsl -->

<xsl:template match="db:orgname">
  <span class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:copyright">
  <span class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>

    <xsl:text>&#160;©&#160;</xsl:text>

    <span class="years">
      <xsl:call-template name="copyright-years">
	<xsl:with-param name="years" select="db:year"/>
	<xsl:with-param name="print.ranges" select="$make.year.ranges"/>
	<xsl:with-param name="single.year.ranges"
			select="$make.single.year.ranges"/>
      </xsl:call-template>
    </span>

    <xsl:text>&#160;</xsl:text>

    <span class="holders">
      <xsl:apply-templates select="db:holder" mode="m:titlepage-mode"/>
    </span>
  </span>
</xsl:template>

</xsl:stylesheet>
