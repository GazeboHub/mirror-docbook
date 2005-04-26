<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:ghost="http://docbook.org/ns/docbook/ephemeral"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f ghost h m t u xs"
                version="2.0">

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:param name="chunker.output.method" select="'xhtml'"/>
<xsl:param name="chunker.output.encoding" select="'utf-8'"/>
<xsl:param name="chunker.output.indent" select="'no'"/>
<xsl:param name="chunker.output.omit-xml-declaration" select="'no'"/>
<xsl:param name="chunker.output.standalone" select="'no'"/>
<xsl:param name="chunker.output.doctype-public" select="''"/>
<xsl:param name="chunker.output.doctype-system" select="''"/>
<xsl:param name="chunker.output.media-type" select="''"/>
<xsl:param name="chunker.output.cdata-section-elements" select="''"/>

<!-- ==================================================================== -->

<xsl:template name="t:write-chunk">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="quiet" select="0"/>

  <xsl:param name="method" select="$chunker.output.method"/>
  <xsl:param name="encoding" select="$chunker.output.encoding"/>
  <xsl:param name="indent" select="$chunker.output.indent"/>
  <xsl:param name="omit-xml-declaration"
             select="$chunker.output.omit-xml-declaration"/>
  <xsl:param name="standalone" select="$chunker.output.standalone"/>
  <xsl:param name="doctype-public" select="$chunker.output.doctype-public"/>
  <xsl:param name="doctype-system" select="$chunker.output.doctype-system"/>
  <xsl:param name="media-type" select="$chunker.output.media-type"/>
  <xsl:param name="cdata-section-elements"
             select="$chunker.output.cdata-section-elements"/>

  <xsl:param name="content"/>

  <xsl:if test="$quiet = 0">
    <xsl:message>
      <xsl:text>Writing </xsl:text>
      <xsl:value-of select="$filename"/>
      <xsl:if test="name(.) != ''">
        <xsl:text> for </xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:if test="@id">
          <xsl:text>(</xsl:text>
          <xsl:value-of select="@id"/>
          <xsl:text>)</xsl:text>
        </xsl:if>
      </xsl:if>
    </xsl:message>
  </xsl:if>

  <xsl:result-document href="{$filename}"
		       method="{$method}"
		       encoding="{$encoding}"
		       indent="{$indent}"
		       omit-xml-declaration="{$omit-xml-declaration}"
		       cdata-section-elements="{$cdata-section-elements}"
		       media-type="{$media-type}"
		       doctype-public="{$doctype-public}"
		       doctype-system="{$doctype-system}"
		       standalone="{$standalone}">
    <xsl:sequence select="$content"/>
  </xsl:result-document>
</xsl:template>

<xsl:template name="t:write-text-chunk">
  <xsl:param name="filename" select="''"/>
  <xsl:param name="quiet" select="0"/>
  <xsl:param name="method" select="'text'"/>
  <xsl:param name="encoding" select="$chunker.output.encoding"/>
  <xsl:param name="media-type" select="$chunker.output.media-type"/>
  <xsl:param name="content"/>

  <xsl:call-template name="t:write-chunk">
    <xsl:with-param name="filename" select="$filename"/>
    <xsl:with-param name="quiet" select="$quiet"/>
    <xsl:with-param name="method" select="$method"/>
    <xsl:with-param name="encoding" select="$encoding"/>
    <xsl:with-param name="indent" select="'no'"/>
    <xsl:with-param name="omit-xml-declaration" select="'no'"/>
    <xsl:with-param name="standalone" select="'no'"/>
    <xsl:with-param name="doctype-public"/>
    <xsl:with-param name="doctype-system"/>
    <xsl:with-param name="media-type" select="$media-type"/>
    <xsl:with-param name="cdata-section-elements"/>
    <xsl:with-param name="content" select="$content"/>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
