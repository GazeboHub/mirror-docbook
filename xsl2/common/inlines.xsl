<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
		exclude-result-prefixes="f m fn"
                version="2.0">

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ==================================================================== -->
<!-- some special cases -->

<xsl:template match="db:alt">
  <!-- nop -->
</xsl:template>

<xsl:template match="db:personname">
  <xsl:call-template name="inline.charseq">
    <xsl:with-param name="content">
      <xsl:call-template name="person.name"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:author">
  <xsl:call-template name="inline.charseq">
    <xsl:with-param name="content">
      <xsl:call-template name="person.name"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:editor">
  <xsl:call-template name="inline.charseq">
    <xsl:with-param name="content">
      <xsl:call-template name="person.name"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:othercredit">
  <xsl:call-template name="inline.charseq">
    <xsl:with-param name="content">
      <xsl:call-template name="person.name"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:authorinitials">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:accel">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:action">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:application">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:classname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:exceptionname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:interfacename">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:methodname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:command">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="db:computeroutput">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:constant">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:database">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:errorcode">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:errorname">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:errortype">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:errortext">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:envar">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:filename">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:function">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:function/db:parameter" priority="2">
  <xsl:call-template name="inline.italicmonoseq"/>
  <xsl:if test="following-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:function/db:replaceable" priority="2">
  <xsl:call-template name="inline.italicmonoseq"/>
  <xsl:if test="following-sibling::*">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:guibutton">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:guiicon">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:guilabel">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:guimenu">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:guimenuitem">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:guisubmenu">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:hardware">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:interface">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:interfacedefinition">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:keycap">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="db:keycode">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:keysym">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:literal">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:code">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:medialabel">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="db:shortcut">
  <xsl:call-template name="inline.boldseq"/>
</xsl:template>

<xsl:template match="db:mousebutton">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:option">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:package">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:parameter">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="db:property">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:prompt">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:replaceable" priority="1">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="db:returnvalue">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:structfield">
  <xsl:call-template name="inline.italicmonoseq"/>
</xsl:template>

<xsl:template match="db:structname">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:symbol">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:systemitem">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:token">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:type">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:userinput">
  <xsl:call-template name="inline.boldmonoseq"/>
</xsl:template>

<xsl:template match="db:abbrev">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:acronym">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:citerefentry">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:citetitle">
  <xsl:choose>
    <xsl:when test="@pubwork = 'article'">
      <xsl:call-template name="gentext.startquote"/>
      <xsl:call-template name="inline.charseq"/>
      <xsl:call-template name="gentext.endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="inline.italicseq"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:markup">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:quote">
  <xsl:variable name="depth" select="count(ancestor::db:quote)"/>
  <xsl:choose>
    <xsl:when test="$depth mod 2 = 0">
      <xsl:call-template name="gentext.startquote"/>
      <xsl:call-template name="inline.charseq"/>
      <xsl:call-template name="gentext.endquote"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext.nestedstartquote"/>
      <xsl:call-template name="inline.charseq"/>
      <xsl:call-template name="gentext.nestedendquote"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:varname">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:wordasword">
  <xsl:call-template name="inline.italicseq"/>
</xsl:template>

<xsl:template match="db:superscript">
  <xsl:call-template name="inline.superscriptseq"/>
</xsl:template>

<xsl:template match="db:subscript">
  <xsl:call-template name="inline.subscriptseq"/>
</xsl:template>

<xsl:template match="db:sgmltag|db:tag">
  <xsl:call-template name="format.sgmltag"/>
</xsl:template>

<xsl:template match="db:keycombo">
  <xsl:variable name="action" select="@action"/>
  <xsl:variable name="joinchar">
    <xsl:choose>
      <xsl:when test="$action='seq'"><xsl:text> </xsl:text></xsl:when>
      <xsl:when test="$action='simul'">+</xsl:when>
      <xsl:when test="$action='press'">-</xsl:when>
      <xsl:when test="$action='click'">-</xsl:when>
      <xsl:when test="$action='double-click'">-</xsl:when>
      <xsl:when test="$action='other'"></xsl:when>
      <xsl:otherwise>-</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  <xsl:for-each select="*">
    <xsl:if test="position()>1">
      <xsl:value-of select="$joinchar"/>
    </xsl:if>
    <xsl:apply-templates select="."/>
  </xsl:for-each>
</xsl:template>

<xsl:template match="db:uri">
  <xsl:call-template name="inline.monoseq"/>
</xsl:template>

<xsl:template match="db:citation">
  <!-- todo: biblio-citation-check -->
  <xsl:text>[</xsl:text>
  <xsl:call-template name="inline.charseq"/>
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="db:productname">
  <xsl:call-template name="inline.charseq"/>
  <xsl:if test="@class">
    <xsl:call-template name="dingbat">
      <xsl:with-param name="dingbat" select="@class"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="db:productnumber">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:pob|db:street|db:city|db:state
		     |db:postcode|db:country|db:otheraddr">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<xsl:template match="db:phone|db:fax">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- in Addresses, for example -->
<xsl:template match="db:honorific|db:firstname|db:surname
		     |db:lineage|db:othername">
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:beginpage">
  <!-- does nothing; this *is not* markup to force a page break. -->
</xsl:template>

</xsl:stylesheet>
