<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://docbook.org/ns/docbook"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		exclude-result-prefixes="db doc"
                version="2.0">

<xsl:include href="xsl2db.xsl"/>

<xsl:template match="/">
  <book>
    <info>
      <title>DocBook Stylesheet Reference Documentation</title>
    </info>
    <xsl:apply-templates select="/*/xsl:include"/>
  </book>
</xsl:template>

<xsl:template match="xsl:include">
  <xsl:variable name="doc" select="document(@href)"/>

  <xsl:if test="$doc//doc:*">
    <xsl:comment>
      <xsl:text> Stylesheet: </xsl:text>
      <xsl:value-of select="@href"/>
    </xsl:comment>
    <xsl:apply-templates select="$doc/xsl:stylesheet"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
