<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f h m t xs"
                version="2.0">

<xsl:param name="formal.title.placement" as="element()*">
  <db:figure placement="before"/>
  <db:example placement="before"/>
  <db:equation placement="before"/>
  <db:table placement="before"/>
  <db:procedure placement="before"/>
  <db:task placement="before"/>
</xsl:param>

<!-- ============================================================ -->

<doc:template name="t:formal-object" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Template for processing formal objects</refpurpose>

<refdescription>
<para>This template processes formal objects, block objects with a
title.</para>
</refdescription>
</doc:template>

<xsl:template name="t:formal-object">
  <xsl:param name="placement" select="'before'"/>
  <xsl:param name="class" select="local-name(.)"/>
  <xsl:param name="object" as="element()*" required="yes"/>

  <div class="{$class}-wrapper">
    <xsl:call-template name="id"/>
    <xsl:choose>
      <xsl:when test="$placement = 'before'">
	<xsl:call-template name="t:formal-object-heading"/>
	<xsl:sequence select="$object"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:sequence select="$object"/>
	<xsl:call-template name="t:formal-object-heading"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:formal-object-heading"
	      xmlns="http://docbook.org/docbook-ng">
<refpurpose>Template for processing the title of formal objects</refpurpose>

<refdescription>
<para>This template processes the title of formal objects.
</para>
</refdescription>
</doc:template>

<xsl:template name="t:formal-object-heading">
  <xsl:param name="object" select="."/>
  <xsl:param name="title">
    <xsl:apply-templates select="$object" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </xsl:param>

  <div class="title">
    <xsl:sequence select="$title"/>
  </div>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:informal-object" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Template for processing informal objects</refpurpose>

<refdescription>
<para>This template processes informal objects, block objects without a
title.</para>
</refdescription>
</doc:template>

<xsl:template name="t:informal-object">
  <xsl:param name="class" select="local-name(.)"/>
  <xsl:param name="object" as="element()*" required="yes"/>

  <div class="{$class}-wrapper">
    <xsl:call-template name="id"/>
    <xsl:sequence select="$object"/>
  </div>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:semiformal-object" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Template for processing objects that are sometimes
formal, sometimes informal</refpurpose>

<refdescription>
<para>This template processes objects that are sometimes
formal, sometimes informal, by calling the appropriate template.
</para>
</refdescription>
</doc:template>

<xsl:template name="t:semiformal-object">
  <xsl:param name="placement" select="'before'"/>
  <xsl:param name="class" select="local-name(.)"/>
  <xsl:param name="object" as="element()*" required="yes"/>

  <xsl:choose>
    <xsl:when test="db:info/db:title">
      <xsl:call-template name="t:formal-object">
	<xsl:with-param name="placement" select="$placement"/>
	<xsl:with-param name="class" select="$class"/>
	<xsl:with-param name="object" select="$object"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="t:informal-object">
	<xsl:with-param name="class" select="$class"/>
	<xsl:with-param name="object" select="$object"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
