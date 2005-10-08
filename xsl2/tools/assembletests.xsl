<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db doc h u xs"
                version="2.0">

<xsl:output method="html" indent="no"/>

<xsl:template match="u:manifest">
  <xsl:variable name="tests" as="element()*">
    <xsl:apply-templates select="u:test"/>
  </xsl:variable>

  <html>
    <head>
      <title><xsl:value-of select="u:title"/></title>
      <style type="text/css">
div.pass { background-color: #99FF99; }
div.fail { background-color: #FF9999; }
div.unknown { background-color: #FFFF99; }
      </style>
    </head>
    <body>
      <h1>
	<xsl:value-of select="u:title"/>
      </h1>

      <h3>Contents</h3>
      <dl>
	<xsl:for-each select="$tests">
	  <dt>
	    <a href="#{generate-id(h:h2[1])}">
	      <xsl:value-of select="h:h2"/>
	    </a>

	    <xsl:text> (</xsl:text>
	    <xsl:value-of select="count(.//*[@class='fail'])"/>
	    <xsl:text> failed, </xsl:text>

	    <xsl:if test=".//*[@class='unknown']">
	      <xsl:value-of select="count(.//*[@class='unknown'])"/>
	      <xsl:text> indeterminate, </xsl:text>
	    </xsl:if>

	    <xsl:value-of select="count(.//*[@class='pass'])"/>
	    <xsl:text> passed</xsl:text>
	    <xsl:text>)</xsl:text>
	  </dt>
	</xsl:for-each>
      </dl>

      <xsl:apply-templates select="$tests" mode="html"/>
    </body>
  </html>

  <xsl:message>
    <xsl:value-of select="count($tests//*[@class='fail'])"/>
    <xsl:text> failed, </xsl:text>
    
    <xsl:if test="$tests//*[@class='unknown']">
      <xsl:value-of select="count($tests//*[@class='unknown'])"/>
      <xsl:text> indeterminate, </xsl:text>
    </xsl:if>

    <xsl:value-of select="count($tests//*[@class='pass'])"/>
    <xsl:text> passed</xsl:text>
  </xsl:message>
</xsl:template>

<xsl:template match="u:test">
  <xsl:variable name="test" select="document(concat(@fn,'.xml'), .)"/>
  <xsl:copy-of select="$test/h:div/*"/>
</xsl:template>

<xsl:template match="h:h2" mode="html" priority="100">
  <xsl:element name="{local-name(.)}">
    <xsl:copy-of select="@*"/>
    <a name="{generate-id(.)}"/>
    <xsl:apply-templates mode="html"/>
  </xsl:element>
</xsl:template>

<xsl:template match="*" mode="html">
  <xsl:element name="{local-name(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="html"/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
