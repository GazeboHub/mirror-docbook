<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f fn h m t u xlink xs"
                version="2.0">

<!-- ============================================================ -->

<doc:mode name="m:insert-title-markup" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting title markup</refpurpose>

<refdescription>
<para>This mode is used to insert title markup. Any element processed
in this mode should generate its title.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-title-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="title"/>

  <xsl:choose>
    <xsl:when test="$purpose = 'xref' and db:info/db:titleabbrev">
      <xsl:apply-templates select="." mode="m:titleabbrev-markup"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:chapter|db:appendix" mode="m:insert-title-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="title"/>

  <xsl:choose>
    <xsl:when test="$purpose = 'xref'">
      <i>
        <xsl:copy-of select="$title"/>
      </i>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-subtitle-markup" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting subtitle markup</refpurpose>

<refdescription>
<para>This mode is used to insert subtitle markup. Any element processed
in this mode should generate its subtitle.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-subtitle-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="subtitle"/>

  <xsl:copy-of select="$subtitle"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-label-markup" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting label markup</refpurpose>

<refdescription>
<para>This mode is used to insert label markup. Any element processed
in this mode should generate its label (number).</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-label-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="label"/>

  <xsl:copy-of select="$label"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-pagenumber-markup"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting page number markup</refpurpose>

<refdescription>
<para>This mode is used to insert page number markup. Any element processed
in this mode should generate its page number.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-pagenumber-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="pagenumber"/>

  <xsl:copy-of select="$pagenumber"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-direction-markup"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for inserting “direction” markup</refpurpose>

<refdescription>
<para>This mode is used to insert “direction”. Any element processed
in this mode should generate its direction number. The direction is
calculated from a reference and a referent (above or below, for example).</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-direction-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="direction"/>

  <xsl:copy-of select="$direction"/>
</xsl:template>

</xsl:stylesheet>
