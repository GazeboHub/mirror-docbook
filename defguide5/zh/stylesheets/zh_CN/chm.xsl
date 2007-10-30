<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version='1.0'>

  <xsl:import href="../chm.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'zh_cn'"/>

  <xsl:param name="htmlhelp.encoding" select="'GB18030'"/>
  <xsl:param name="chunker.output.encoding" select="'GB18030'"/>

  <xsl:param name="htmlhelp.chm" select="'defguide5-zh_CN.chm'"/>
  <xsl:param name="htmlhelp.title">
    <xsl:text>DocBook 5.0 权威指南</xsl:text>
  </xsl:param>

</xsl:stylesheet>
