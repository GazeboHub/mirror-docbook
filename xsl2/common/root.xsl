<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
		exclude-result-prefixes="f m fn"
                version="2.0">

<xsl:key name="id" match="*" use="@id|@xml:id"/>

<xsl:template match="/">
  <xsl:variable name="cleanup">
    <xsl:apply-templates select="." mode="m:cleanup"/>
  </xsl:variable>

  <xsl:apply-templates select="$cleanup" mode="m:root"/>
</xsl:template>
  
<xsl:template match="/" mode="m:cleanup">
  <!--
  <xsl:message>
    <xsl:text>Cleaning up </xsl:text>
    <xsl:value-of select="fn:base-uri(.)"/>
  </xsl:message>
  -->

  <xsl:variable name="fixedns">
    <xsl:apply-templates mode="m:fixnamespace"/>
  </xsl:variable>

  <xsl:variable name="profiled">
    <xsl:apply-templates select="$fixedns" mode="m:profile"/>
  </xsl:variable>

  <xsl:apply-templates select="$profiled" mode="m:normalize"/>
</xsl:template>

<xsl:template match="/" mode="m:root">
  <xsl:choose>
    <!-- if there's a rootid, start there -->
    <xsl:when test="$rootid != ''">
      <xsl:variable name="root" select="key('id', $rootid)"/>

      <xsl:choose>
	<xsl:when test="not($root)">
	  <xsl:message terminate="yes">
	    <xsl:text>ID '</xsl:text>
	    <xsl:value-of select="$rootid"/>
	    <xsl:text>' not found in document.</xsl:text>
	  </xsl:message>
	</xsl:when>

	<xsl:when test="not($root.elements/*[fn:node-name(.)
			                     = fn:node-name($root)])">
	  <xsl:call-template name="m:root-terminate">
	    <xsl:with-param name="rootid" select="$rootid"/>
	  </xsl:call-template>
	</xsl:when>

	<xsl:otherwise>
	  <xsl:apply-templates select="$root" mode="m:root"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>

    <!-- Otherwise, process the document root element -->
    <xsl:otherwise>
      <xsl:variable name="root" select="*[1]"/>
      <xsl:choose>
	<xsl:when test="not($root.elements/*[fn:node-name(.)
			                     = fn:node-name($root)])">
	  <xsl:call-template name="m:root-terminate"/>
	</xsl:when>

	<xsl:otherwise>
	  <xsl:apply-templates select="$root" mode="m:root"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="m:root-terminate">
  <xsl:param name="rootid"/>

  <xsl:message terminate="yes">
    <xsl:text>Error: document root element </xsl:text>
    <xsl:if test="$rootid">
      <xsl:text>($rootid=</xsl:text>
      <xsl:value-of select="$rootid"/>
      <xsl:text>) </xsl:text>
    </xsl:if>

    <xsl:text>must be one of the following elements: </xsl:text>
    <xsl:value-of select="for $elem in $root.elements/*[position() &lt; last()]
			  return local-name($elem)" separator=", "/>
    <xsl:text>, or </xsl:text>
    <xsl:value-of select="local-name($root.elements/*[last()])"/>
    <xsl:text>.</xsl:text>
  </xsl:message>
</xsl:template>

</xsl:stylesheet>
