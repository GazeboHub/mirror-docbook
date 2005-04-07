<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		version="2.0">

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

<xsl:template match="text()|comment()|processing-instruction()" mode="expand">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
