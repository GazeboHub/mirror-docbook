<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version="1.0">

<xsl:output method="html"/>

<xsl:param name="script.dir" select="''"/>

<xsl:param name="ua.js" select="'ua.js'"/>
<xsl:param name="xbDOM.js" select="'xbDOM.js'"/>
<xsl:param name="xbStyle.js" select="'xbStyle.js'"/>
<xsl:param name="xbCollapsibleLists.js" select="'xbCollapsibleLists.js'"/>

<xsl:param name="overlay.js" select="'overlay.js'"/>
<xsl:param name="slides.js" select="'slides.js'"/>

<xsl:template name="script-file">
  <xsl:param name="js" select="'slides.js'"/>

  <xsl:variable name="source.script.dir">
    <xsl:call-template name="dbhtml-attribute">
      <xsl:with-param name="pis" select="/processing-instruction('dbhtml')"/>
      <xsl:with-param name="attribute" select="'script-dir'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$source.script.dir != ''">
      <xsl:value-of select="$source.script.dir"/>
      <xsl:text>/</xsl:text>
    </xsl:when>
    <xsl:when test="$script.dir != ''">
      <xsl:value-of select="$script.dir"/>
      <xsl:text>/</xsl:text>
    </xsl:when>
  </xsl:choose>
  <xsl:value-of select="$js"/>
</xsl:template>

<xsl:template name="ua.js">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:param name="language" select="'JavaScript1.2'"/>
  <script language="{$language}">
    <xsl:attribute name="src">
      <xsl:call-template name="script-file">
        <xsl:with-param name="js" select="$ua.js"/>
      </xsl:call-template>
    </xsl:attribute>
  </script>
</xsl:template>

<xsl:template name="xbDOM.js">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:param name="language" select="'JavaScript1.2'"/>
  <script language="{$language}">
    <xsl:attribute name="src">
      <xsl:call-template name="script-file">
        <xsl:with-param name="js" select="$xbDOM.js"/>
      </xsl:call-template>
    </xsl:attribute>
  </script>
</xsl:template>

<xsl:template name="xbStyle.js">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:param name="language" select="'JavaScript1.2'"/>
  <script language="{$language}">
    <xsl:attribute name="src">
      <xsl:call-template name="script-file">
        <xsl:with-param name="js" select="$xbStyle.js"/>
      </xsl:call-template>
    </xsl:attribute>
  </script>
</xsl:template>

<xsl:template name="xbCollapsibleLists.js">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:param name="language" select="'JavaScript1.2'"/>
  <script language="{$language}">
    <xsl:attribute name="src">
      <xsl:call-template name="script-file">
        <xsl:with-param name="js" select="$xbCollapsibleLists.js"/>
      </xsl:call-template>
    </xsl:attribute>
  </script>
</xsl:template>

<xsl:template name="overlay.js">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:param name="language" select="'JavaScript1.2'"/>
  <script language="{$language}">
    <xsl:attribute name="src">
      <xsl:call-template name="script-file">
        <xsl:with-param name="js" select="$overlay.js"/>
      </xsl:call-template>
    </xsl:attribute>
  </script>
</xsl:template>

<xsl:template name="slides.js">
  <!-- Danger Will Robinson: template shadows parameter -->
  <xsl:param name="language" select="'JavaScript1.2'"/>
  <script language="{$language}">
    <xsl:attribute name="src">
      <xsl:call-template name="script-file">
        <xsl:with-param name="js" select="$slides.js"/>
      </xsl:call-template>
    </xsl:attribute>
  </script>
</xsl:template>

</xsl:stylesheet>
