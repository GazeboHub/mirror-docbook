<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
		xmlns:t="http://docbook.org/xslt/ns/template"
		exclude-result-prefixes="h f m fn db t"
                version="2.0">

<xsl:variable name="titlepages.data" select="doc($titlepage.templates)"/>

<xsl:variable name="titlepages">
  <xsl:call-template name="user.titlepage.templates"/>
  <xsl:copy-of select="$titlepages.data/t:titlepages/*"/>
</xsl:variable>

<xsl:template name="user.titlepage.templates">
  <!-- nop -->
</xsl:template>

</xsl:stylesheet>
