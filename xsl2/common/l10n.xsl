<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                exclude-result-prefixes="f l"
                version='2.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     This file contains localization templates (for internationalization)
     ******************************************************************** -->

<xsl:param name="localization.xml" select="'../common/l10n.xml'"/>
<xsl:variable name="localization.data" select="doc($localization.xml)"/>

<xsl:variable name="localization">
  <xsl:call-template name="user.localization.data"/>
  <xsl:copy-of select="$localization.data/l:i18n/l:l10n"/>
</xsl:variable>

<xsl:template name="user.localization.data">
  <!-- nop -->
</xsl:template>

<xsl:template name="l10n.language">
  <xsl:param name="target" select="."/>
  <xsl:param name="xref-context" select="false()"/>

  <xsl:variable name="mc-language">
    <xsl:choose>
      <xsl:when test="$l10n.gentext.language != ''">
        <xsl:value-of select="$l10n.gentext.language"/>
      </xsl:when>

      <xsl:when test="$xref-context or $l10n.gentext.use.xref.language != 0">
        <!-- can't do this one step: attributes are unordered! -->
        <xsl:variable name="lang-scope"
                      select="$target/ancestor-or-self::*
                              [@lang or @xml:lang][last()]"/>
        <xsl:variable name="lang-attr"
                      select="($lang-scope/@lang | $lang-scope/@xml:lang)[1]"/>
        <xsl:choose>
          <xsl:when test="string($lang-attr) = ''">
            <xsl:value-of select="$l10n.gentext.default.language"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lang-attr"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>

      <xsl:otherwise>
        <!-- can't do this one step: attributes are unordered! -->
        <xsl:variable name="lang-scope"
                      select="$target/ancestor-or-self::*
                              [@lang or @xml:lang][last()]"/>
        <xsl:variable name="lang-attr"
                      select="($lang-scope/@lang | $lang-scope/@xml:lang)[1]"/>

        <xsl:choose>
          <xsl:when test="string($lang-attr) = ''">
            <xsl:value-of select="$l10n.gentext.default.language"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lang-attr"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="language" select="translate($mc-language,
                                        'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
                                        'abcdefghijklmnopqrstuvwxyz')"/>

  <xsl:variable name="adjusted.language">
    <xsl:choose>
      <xsl:when test="contains($language,'-')">
        <xsl:value-of select="substring-before($language,'-')"/>
        <xsl:text>_</xsl:text>
        <xsl:value-of select="substring-after($language,'-')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$language"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$l10n.xml/l:i18n/l:l10n[@language=$adjusted.language]">
      <xsl:value-of select="$adjusted.language"/>
    </xsl:when>
    <!-- try just the lang code without country -->
    <xsl:when test="$l10n.xml/l:i18n/l:l10n[@language=substring-before($adjusted.language,'_')]">
      <xsl:value-of select="substring-before($adjusted.language,'_')"/>
    </xsl:when>
    <!-- or use the default -->
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>No localization exists for "</xsl:text>
        <xsl:value-of select="$adjusted.language"/>
        <xsl:text>" or "</xsl:text>
        <xsl:value-of select="substring-before($adjusted.language,'_')"/>
        <xsl:text>". Using default "</xsl:text>
        <xsl:value-of select="$l10n.gentext.default.language"/>
        <xsl:text>".</xsl:text>
      </xsl:message>
      <xsl:value-of select="$l10n.gentext.default.language"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="language.attribute">
  <xsl:param name="node" select="."/>

  <xsl:variable name="language">
    <xsl:choose>
      <xsl:when test="$l10n.gentext.language != ''">
        <xsl:value-of select="$l10n.gentext.language"/>
      </xsl:when>

      <xsl:otherwise>
        <!-- can't do this one step: attributes are unordered! -->
        <xsl:variable name="lang-scope"
                      select="$node/ancestor-or-self::*
                              [@lang or @xml:lang][last()]"/>
        <xsl:variable name="lang-attr"
                      select="($lang-scope/@lang | $lang-scope/@xml:lang)[1]"/>

        <xsl:choose>
          <xsl:when test="string($lang-attr) = ''">
            <xsl:value-of select="$l10n.gentext.default.language"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="$lang-attr"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="$language != ''">
    <xsl:attribute name="lang">
      <xsl:value-of select="$language"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<xsl:template name="gentext">
  <xsl:param name="key" select="local-name(.)"/>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>

  <xsl:variable name="l10n.gentext"
		select="($localization
			 //l:l10n[@language=$lang]
			 /l:gentext[@key=$key])[1]"/>

  <xsl:choose>
    <xsl:when test="$l10n.gentext">
      <xsl:value-of select="$l10n.gentext/@text"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>No "</xsl:text>
        <xsl:value-of select="$lang"/>
        <xsl:text>" localization of "</xsl:text>
        <xsl:value-of select="$key"/>
        <xsl:text>" exists</xsl:text>
        <xsl:choose>
          <xsl:when test="$lang = 'en'">
             <xsl:text>.</xsl:text>
          </xsl:when>
          <xsl:otherwise>
             <xsl:text>; using "en".</xsl:text>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:message>
      <xsl:value-of select="($localization
			    //l:l10n[@language='en']
			    /l:gentext[@key=$key])[1]/@text"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="gentext.template">
  <xsl:param name="context" select="'default'"/>
  <xsl:param name="name" select="'default'"/>
  <xsl:param name="origname" select="$name"/>
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>

  <xsl:variable name="localization.nodes"
		select="$localization//l:l10n[@language=$lang]"/>

  <xsl:if test="not($localization.nodes)">
    <xsl:message>
      <xsl:text>No "</xsl:text>
      <xsl:value-of select="$lang"/>
      <xsl:text>" localization exists.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="context.nodes"
                select="$localization.nodes/l:context[@name=$context]"/>

  <xsl:if test="not($context.nodes)">
    <xsl:message>
      <xsl:text>No context named "</xsl:text>
      <xsl:value-of select="$context"/>
      <xsl:text>" exists in the "</xsl:text>
      <xsl:value-of select="$lang"/>
      <xsl:text>" localization.</xsl:text>
    </xsl:message>
  </xsl:if>

  <xsl:variable name="template.node"
                select="($context.nodes/l:template[@name=$name
                                                   and @style
                                                   and @style=$xrefstyle]
                        |$context.nodes/l:template[@name=$name
                                                   and not(@style)])[1]"/>

  <xsl:choose>
    <xsl:when test="$template.node/@text">
      <xsl:value-of select="$template.node/@text"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
	<xsl:when test="contains($name, '/')">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="name" select="substring-after($name, '/')"/>
            <xsl:with-param name="origname" select="$origname"/>
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="referrer" select="$referrer"/>
            <xsl:with-param name="lang" select="$lang"/>
          </xsl:call-template>
        </xsl:when>
	<xsl:otherwise>
          <xsl:message>
	    <xsl:text>No template for "</xsl:text>
            <xsl:value-of select="$origname"/>
            <xsl:text>" (or any of its leaves) exists
in the context named "</xsl:text>
            <xsl:value-of select="$context"/>
            <xsl:text>" in the "</xsl:text>
            <xsl:value-of select="$lang"/>
            <xsl:text>" localization.</xsl:text>
          </xsl:message>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="gentext.template.exists">
  <xsl:param name="context" select="'default'"/>
  <xsl:param name="name" select="'default'"/>
  <xsl:param name="origname" select="$name"/>
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="referrer"/>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>

  <xsl:variable name="localization.nodes"
		select="$localization//l:l10n[@language=$lang]"/>

  <xsl:variable name="context.nodes"
                select="$localization.nodes/l:context[@name=$context]"/>

  <xsl:variable name="template.node"
                select="($context.nodes/l:template[@name=$name
                                                   and @style
                                                   and @style=$xrefstyle]
                        |$context.nodes/l:template[@name=$name
                                                   and not(@style)])[1]"/>

  <xsl:choose>
    <xsl:when test="$template.node/@text">1</xsl:when>
    <xsl:otherwise>
      <xsl:choose>
	<xsl:when test="contains($name, '/')">
          <xsl:call-template name="gentext.template">
            <xsl:with-param name="context" select="$context"/>
            <xsl:with-param name="name" select="substring-after($name, '/')"/>
            <xsl:with-param name="origname" select="$origname"/>
            <xsl:with-param name="purpose" select="$purpose"/>
            <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
            <xsl:with-param name="referrer" select="$referrer"/>
            <xsl:with-param name="lang" select="$lang"/>
          </xsl:call-template>
        </xsl:when>
	<xsl:otherwise>0</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="gentext.dingbat">
  <xsl:param name="dingbat">bullet</xsl:param>
  <xsl:param name="lang">
    <xsl:call-template name="l10n.language"/>
  </xsl:param>

  <xsl:value-of select="f:dingbat(., $dingbat, $lang)"/>
</xsl:template>

<xsl:template name="gentext.startquote">
  <xsl:value-of select="f:dingbat(., 'startquote')"/>
</xsl:template>

<xsl:template name="gentext.endquote">
  <xsl:value-of select="f:dingbat(., 'endquote')"/>
</xsl:template>

<xsl:template name="gentext.nestedstartquote">
  <xsl:value-of select="f:dingbat(., 'nestedstartquote')"/>
</xsl:template>

<xsl:template name="gentext.nestedendquote">
  <xsl:value-of select="f:dingbat(., 'nestedendquote')"/>
</xsl:template>

</xsl:stylesheet>

