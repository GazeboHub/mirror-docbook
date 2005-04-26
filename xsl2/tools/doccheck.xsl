<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:ex="http://nwalsh.com/xsl/exceptions"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:fn="http://www.w3.org/2004/10/xpath-functions"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="h f m ex fn db doc t u xs"
                version="2.0">

<xsl:include href="expand.xsl"/>

<xsl:key name="tdoc" match="doc:template" use="@name"/>
<xsl:key name="fdoc" match="doc:function" use="@name"/>
<xsl:key name="mdoc" match="doc:mode" use="@name"/>
<xsl:key name="mxsl" match="xsl:template[@mode]" use="@mode"/>
<xsl:key name="ftst" match="u:unittests[@function]" use="@function"/>
<xsl:key name="ttst" match="u:unittests[@template]" use="@template"/>

<xsl:template match="/">
  <xsl:variable name="expanded">
    <xsl:apply-templates select="/" mode="expand"/>
  </xsl:variable>

  <xsl:result-document href="expanded.xml" method="xml" indent="yes">
    <xsl:copy-of select="$expanded"/>
  </xsl:result-document>

  <xsl:variable name="exceptions">
    <xsl:for-each-group select="$expanded//xsl:template[@mode]"
			group-by="@mode">
      <xsl:if test="not($expanded/key('mdoc', current-grouping-key()))
		    and not(starts-with(current-grouping-key(), 'mp:'))">
	<ex:mode exception="no documentation"
		 name="{current-grouping-key()}"
		 href="{current-group()[1]/ancestor::xsl:module[1]/@href}"/>
      </xsl:if>
      <xsl:if test="contains(current-grouping-key(), '.')">
	<ex:mode exception="dot in mode"
		 name="{current-grouping-key()}"
		 href="{current-group()[1]/ancestor::xsl:module[1]/@href}"/>
      </xsl:if>
    </xsl:for-each-group>

    <xsl:apply-templates select="$expanded/*"/>
  </xsl:variable>

  <xsl:for-each-group select="$exceptions/*"
		      group-by="@href">
    <xsl:message>
      <xsl:text>In </xsl:text>
      <xsl:value-of select="current-group()[1]/@href"/>
    </xsl:message>

    <xsl:for-each select="current-group()">
      <xsl:message>
	<xsl:text>   </xsl:text>
	<xsl:value-of select="local-name(.)"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="@name"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="@exception"/>
      </xsl:message>
    </xsl:for-each>
  </xsl:for-each-group>
</xsl:template>

<xsl:template match="xsl:template[@name]" priority="100">
  <xsl:if test="not(key('tdoc', @name))
		and not(starts-with(@name, 'tp:'))">
    <ex:template exception="no documentation"
		 name="{@name}"
		 href="{ancestor::xsl:module[1]/@href}"/>
  </xsl:if>
  <xsl:if test="contains(@name, '.')">
    <ex:template exception="dot in template name"
		 name="{@name}"
		 href="{ancestor::xsl:module[1]/@href}"/>
  </xsl:if>
  <xsl:if test="not(key('ttst', @name))">
    <ex:template exception="no unit test"
		 name="{@name}"
		 href="{ancestor::xsl:module[1]/@href}"/>
  </xsl:if>
</xsl:template>

<xsl:template match="xsl:function[@name]" priority="100">
  <xsl:if test="not(key('fdoc', @name)) and not(starts-with(@name,'fp:'))">
    <ex:function exception="no documentation"
		 name="{@name}"
		 href="{ancestor::xsl:module[1]/@href}"/>
  </xsl:if>
  <xsl:if test="not(key('ftst', @name))">
    <ex:template exception="no unit test"
		 name="{@name}"
		 href="{ancestor::xsl:module[1]/@href}"/>
  </xsl:if>
</xsl:template>

<xsl:template match="xsl:apply-templates[@mode]" priority="100">
  <xsl:if test="not(key('mxsl', @mode))">
    <ex:apply-templates exception="no mode"
			name="{@mode}"
			href="{ancestor::xsl:module[1]/@href}"/>
  </xsl:if>
</xsl:template>

<xsl:template match="*">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()">
  <!-- nop -->
</xsl:template>

</xsl:stylesheet>
