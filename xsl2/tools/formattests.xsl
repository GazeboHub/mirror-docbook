<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db doc h u xs"
                version="2.0">

<xsl:template match="u:variable" mode="tohtml">
  <xsl:param name="indent" select="''"/>
  <xsl:call-template name="dumpelement">
    <xsl:with-param name="name" select="'xsl:variable'"/>
    <xsl:with-param name="indent" select="$indent"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="u:param" mode="tohtml">
  <xsl:param name="indent" select="''"/>
  <xsl:param name="name" select="'xsl:variable'"/>
  <xsl:param name="nameattr"/>

  <xsl:call-template name="dumpelement">
    <xsl:with-param name="name" select="$name"/>
    <xsl:with-param name="nameattr" select="$nameattr"/>
    <xsl:with-param name="indent" select="$indent"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="*" name="dumpelement" mode="tohtml">
  <xsl:param name="name" select="name(.)"/>
  <xsl:param name="nameattr" select="''"/>
  <xsl:param name="indent" select="''"/>

  <xsl:value-of select="$indent"/>
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="$name"/>
  
  <xsl:if test="$nameattr != ''">
    <xsl:text> name="</xsl:text>
    <xsl:value-of select="$nameattr"/>
    <xsl:text>"</xsl:text>
  </xsl:if>

  <xsl:for-each select="@*">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:for-each>

  <xsl:choose>
    <xsl:when test="*">
      <xsl:text>&gt;</xsl:text>
      <xsl:for-each select="node()">
	<xsl:text>&#10;</xsl:text>
	<xsl:apply-templates select="." mode="tohtml">
	  <xsl:with-param name="indent" select="concat($indent, '  ')"/>
	</xsl:apply-templates>
      </xsl:for-each>
      <xsl:text>&#10;</xsl:text>
      <xsl:value-of select="$indent"/>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:when>
    <xsl:when test="node()">
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates mode="tohtml"/>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="$name"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>/&gt;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()" mode="tohtml">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
