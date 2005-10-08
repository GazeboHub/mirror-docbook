<?xml version="1.0" encoding="utf-8"?>
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
                xmlns:xlink='http://www.w3.org/1999/xlink'
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f ghost h m t u xlink xs"
                version="2.0">

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sourceforge.net/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:param name="callout.graphics" select="1"/>
<xsl:param name="callout.graphics.path" select="'images/callouts/'"/>
<xsl:param name="callout.graphics.number.limit" select="15"/>
<xsl:param name="callout.graphics.extension" select="'.png'"/>
<xsl:param name="callout.unicode" select="0"/>
<xsl:param name="callout.unicode.start.character" select="10102"/>
<xsl:param name="callout.unicode.number.limit" select="10"/>

<!-- ============================================================ -->

<xsl:template match="db:co">
  <!-- Support a single linkend in HTML -->
  <xsl:variable name="targets" select="$input/key('id', @linkends)"/>
  <xsl:variable name="target" select="$targets[1]"/>
  <xsl:choose>
    <xsl:when test="$target">
      <a href="{f:href($input,$target)}">
        <xsl:if test="@id">
          <xsl:attribute name="name">
            <xsl:value-of select="@id"/>
          </xsl:attribute>
        </xsl:if>
        <xsl:apply-templates select="." mode="m:callout-bug"/>
      </a>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="anchor"/>
      <xsl:apply-templates select="." mode="m:callout-bug"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:coref">
  <!-- tricky; this relies on the fact that we can process the "co" that's -->
  <!-- "over there" as if it were "right here" -->
  <xsl:variable name="co" select="key('id', @linkend)"/>
  <xsl:choose>
    <xsl:when test="not($co)">
      <xsl:message>
        <xsl:text>Error: coref link is broken: </xsl:text>
        <xsl:value-of select="@linkend"/>
      </xsl:message>
    </xsl:when>
    <xsl:when test="local-name($co) != 'co'">
      <xsl:message>
        <xsl:text>Error: coref doesn't point to a co: </xsl:text>
        <xsl:value-of select="@linkend"/>
      </xsl:message>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="$co"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:co" mode="m:callout-bug">
  <xsl:call-template name="t:callout-bug">
    <xsl:with-param name="conum">
      <xsl:number count="db:co"
                  level="any"
                  from="db:programlisting|db:screen|db:literallayout|db:synopsis"
                  format="1"/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="t:callout-bug">
  <xsl:param name="conum" select='1' as="xs:integer"/>

  <xsl:choose>
    <xsl:when test="$callout.graphics != 0
                    and $conum &lt;= $callout.graphics.number.limit">
      <img src="{$callout.graphics.path}{$conum}{$callout.graphics.extension}"
           alt="{$conum}" border="0"/>
    </xsl:when>
    <xsl:when test="$callout.unicode != 0
                    and $conum &lt;= $callout.unicode.number.limit">
      <xsl:choose>
        <xsl:when test="$callout.unicode.start.character = 10102">
          <xsl:choose>
            <xsl:when test="$conum = 1">&#10102;</xsl:when>
            <xsl:when test="$conum = 2">&#10103;</xsl:when>
            <xsl:when test="$conum = 3">&#10104;</xsl:when>
            <xsl:when test="$conum = 4">&#10105;</xsl:when>
            <xsl:when test="$conum = 5">&#10106;</xsl:when>
            <xsl:when test="$conum = 6">&#10107;</xsl:when>
            <xsl:when test="$conum = 7">&#10108;</xsl:when>
            <xsl:when test="$conum = 8">&#10109;</xsl:when>
            <xsl:when test="$conum = 9">&#10110;</xsl:when>
            <xsl:when test="$conum = 10">&#10111;</xsl:when>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
          <xsl:message>
            <xsl:text>Don't know how to generate Unicode callouts </xsl:text>
            <xsl:text>when $callout.unicode.start.character is </xsl:text>
            <xsl:value-of select="$callout.unicode.start.character"/>
          </xsl:message>
          <xsl:text>(</xsl:text>
          <xsl:value-of select="$conum"/>
          <xsl:text>)</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$conum"/>
      <xsl:text>)</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:calloutlist">
  <xsl:variable name="titlepage"
		select="$titlepages/*[node-name(.)
			              = node-name(current())][1]"/>

  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <xsl:call-template name="titlepage">
      <xsl:with-param name="content" select="$titlepage"/>
    </xsl:call-template>

    <xsl:apply-templates select="*[not(self::db:info)
				   and not(self::db:callout)]"/>

    <dl>
      <xsl:apply-templates select="db:callout"/>
    </dl>
  </div>
</xsl:template>

<xsl:template match="db:callout">
  <dt>
    <xsl:call-template name="id"/>
    <xsl:for-each select="tokenize(@arearefs,'\s')">
      <xsl:variable name="target" select="key('id',.,$input)[1]"/>

      <xsl:choose>
	<xsl:when test="count($target)=0">
	  <xsl:message>
	    <xsl:text>Error? callout points to non-existent id: </xsl:text>
	    <xsl:value-of select="."/>
	  </xsl:message>
	  <xsl:text>???</xsl:text>
	</xsl:when>
	<xsl:when test="$target/self::db:co">
	  <a href="{f:href($input,$target)}">
	    <xsl:apply-templates select="$target" mode="m:callout-bug"/>
	  </a>
	  <xsl:text> </xsl:text>
	</xsl:when>
	<xsl:when test="$target/self::db:areaset">
	  <xsl:text>FIXME: support areaset</xsl:text>
	</xsl:when>
	<xsl:when test="$target/self::db:area">
	  <xsl:text>FIXME: support area</xsl:text>
	</xsl:when>
        <xsl:otherwise>
	  <xsl:message>
	    <xsl:text>Error? callout points to </xsl:text>
	    <xsl:value-of select="name($target)"/>
	  </xsl:message>
	  <xsl:text>???</xsl:text>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>
  </dt>
  <dd>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

</xsl:stylesheet>