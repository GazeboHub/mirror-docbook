<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2004/10/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="h f m fn db doc xs"
                version="2.0">

<xsl:param name="formal.title.placement">
  <db:figure placement="before"/>
  <db:example placement="before"/>
  <db:equation placement="before"/>
  <db:table placement="before"/>
  <db:procedure placement="before"/>
  <db:task placement="before"/>
</xsl:param>

<!--
Formal object:

  <div class="object-wrapper">
    <div class="object">
    </div>
    <div class="title">
    </div>
  </div>
-->

<!-- ============================================================ -->

<doc:template name="formal-object" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Template for processing formal objects</refpurpose>

<refdescription>
<para>This template processes formal objects, block objects with a
title.</para>
</refdescription>
</doc:template>

<xsl:template name="formal-object">
  <xsl:param name="placement" select="'before'"/>
  <xsl:param name="class" select="local-name(.)"/>

  <div class="{$class}-wrapper">
    <xsl:call-template name="id"/>
    <xsl:choose>
      <xsl:when test="$placement = 'before'">
	<xsl:call-template name="formal-object-heading"/>
	<div class="{$class}">
	  <xsl:apply-templates/>
	</div>
        <!-- HACK: This doesn't belong inside formal.object;
	     it should be done by the table template,
	     but I want the link to be inside the DIV, so... -->
<!--
	<xsl:if test="self::db:table">
	  <xsl:call-template name="table-longdesc"/>
	</xsl:if>
-->
      </xsl:when>
      <xsl:otherwise>
	<div class="{$class}">
	  <xsl:apply-templates/>
	</div>
	<!-- HACK: This doesn't belong inside formal.object;
	     it should be done by the table template,
	     but I want the link to be inside the DIV, so... -->
<!--
	<xsl:if test="self::db:table">
	  <xsl:call-template name="table-longdesc"/>
	</xsl:if>
-->
	<xsl:call-template name="formal-object-heading"/>
      </xsl:otherwise>
    </xsl:choose>
  </div>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="formal-object-heading" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Template for processing the title of formal objects</refpurpose>

<refdescription>
<para>This template processes the title of formal objects.
</para>
</refdescription>
</doc:template>

<xsl:template name="formal-object-heading">
  <xsl:param name="object" select="."/>
  <xsl:param name="title">
    <xsl:apply-templates select="$object" mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </xsl:param>

  <div class="title">
    <xsl:copy-of select="$title"/>
  </div>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="informal-object" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Template for processing informal objects</refpurpose>

<refdescription>
<para>This template processes informal objects, block objects without a
title.</para>
</refdescription>
</doc:template>

<xsl:template name="informal-object">
  <xsl:param name="class" select="local-name(.)"/>

  <div class="{$class}-wrapper">
    <xsl:call-template name="id"/>
    <div class="{$class}">
      <xsl:apply-templates/>
      <!-- HACK: This doesn't belong inside formal.object;
	   it should be done by the table template,
	   but I want the link to be inside the DIV, so... -->
<!--
      <xsl:if test="self::db:informaltable">
	<xsl:call-template name="table-longdesc"/>
      </xsl:if>
-->
    </div>
  </div>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="semiformal-object" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Template for processing objects that are sometimes
formal, sometimes informal</refpurpose>

<refdescription>
<para>This template processes objects that are sometimes
formal, sometimes informal, by calling the appropriate template.
</para>
</refdescription>
</doc:template>

<xsl:template name="semiformal-object">
  <xsl:param name="placement" select="'before'"/>
  <xsl:param name="class" select="local-name(.)"/>

  <xsl:choose>
    <xsl:when test="db:info/db:title">
      <xsl:call-template name="formal-object">
	<xsl:with-param name="placement" select="$placement"/>
	<xsl:with-param name="class" select="$class"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="informal-object">
	<xsl:with-param name="class" select="$class"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
