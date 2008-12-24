<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fm="http://freshmeat.net/projects/freshmeat-submit/"
                version="1.0"
                exclude-result-prefixes="fm">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/htmlhelp/htmlhelp.xsl"/>

  <xsl:param name="l10n.gentext.language" select="'en'"/>

  <xsl:param name="htmlhelp.encoding" select="'UTF-8'"/>
  <xsl:param name="chunker.output.encoding" select="'UTF-8'"/>

  <xsl:param name="saxon.character.representation" select="'native'"/>

  <!--It maybe can prevent hhc crash.-->
  <xsl:param name="suppress.navigation" select="0"/>

  <!--No adjustColumnWidths function available.-->
  <xsl:param name="use.extensions">0</xsl:param>
  <xsl:param name="tablecolumns.extension">0</xsl:param>
  <xsl:param name="callouts.extension">0</xsl:param>
  <xsl:param name="textinsert.extension">0</xsl:param>

  <xsl:param name="base.dir" select="'htmlhelp/'"/>

  <xsl:param name="VERSION" select="string(document('../../en/VERSION.xml')//fm:Version[1])"/>
  <xsl:param name="htmlhelp.chm" select="'defguide5.chm'"/>
  <xsl:param name="htmlhelp.title">
    <xsl:text>DocBook 5.0: The Definitive Guide</xsl:text>
  </xsl:param>

</xsl:stylesheet>
