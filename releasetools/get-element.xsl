<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>
  <!-- ********************************************************************
       $Id$
       ******************************************************************** -->

  <xsl:output method="text"/>
  <xsl:param name="element"/>

  <xsl:template match="/">
    <xsl:value-of select="//*[local-name() = $element]"/>
  </xsl:template>

</xsl:stylesheet>