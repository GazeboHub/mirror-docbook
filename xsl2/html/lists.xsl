<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="h f m fn db xs"
                version="2.0">

<xsl:template match="db:itemizedlist">
  <xsl:variable name="titlepage"
		select="$titlepages/*[fn:node-name(.)
			              = fn:node-name(current())][1]"/>

  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <xsl:call-template name="titlepage">
      <xsl:with-param name="content" select="$titlepage"/>
    </xsl:call-template>

    <xsl:apply-templates select="*[not(self::db:info)
				   and not(self::db:listitem)]"/>

    <ul>
      <xsl:apply-templates select="db:listitem"/>
    </ul>
  </div>
</xsl:template>

<xsl:template match="db:orderedlist">
  <xsl:variable name="titlepage"
		select="$titlepages/*[fn:node-name(.)
			              = fn:node-name(current())][1]"/>

  <xsl:variable name="starting.number"
		select="f:orderedlist-starting-number(.)"/>

  <xsl:variable name="numeration"
		select="f:orderedlist-numeration(.)"/>

  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>

    <xsl:call-template name="titlepage">
      <xsl:with-param name="content" select="$titlepage"/>
    </xsl:call-template>

    <xsl:apply-templates select="*[not(self::db:info)
				   and not(self::db:listitem)]"/>

    <ol>
      <xsl:if test="$starting.number != 1">
	<xsl:attribute name="start" select="$starting.number"/>
      </xsl:if>
      
      <!-- If there's no inline style attribute, force the class -->
      <!-- to contain the numeration so that external CSS can work -->
      <!-- otherwise, leave the class whatever it was -->
      <xsl:call-template name="class"/>
      <xsl:if test="$inline.style.attribute = 0">
	<xsl:attribute name="class" select="$numeration"/>
      </xsl:if>

      <xsl:call-template name="style">
	<xsl:with-param name="css">
	  <xsl:text>list-style: </xsl:text>
	  <xsl:choose>
	    <xsl:when test="not($numeration)">decimal</xsl:when>
	    <xsl:when test="$numeration = 'arabic'">decimal</xsl:when>
	    <xsl:when test="$numeration = 'loweralpha'">lower-alpha</xsl:when>
	    <xsl:when test="$numeration = 'upperalpha'">upper-alpha</xsl:when>
	    <xsl:when test="$numeration = 'lowerroman'">lower-roman</xsl:when>
	    <xsl:when test="$numeration = 'upperroman'">upper-roman</xsl:when>
	    <xsl:when test="$numeration = 'loweralpha'">lower-alpha</xsl:when>
	    <xsl:otherwise>decimal</xsl:otherwise>
	  </xsl:choose>
	  <xsl:text>;</xsl:text>
	</xsl:with-param>
      </xsl:call-template>

      <xsl:apply-templates select="db:listitem"/>
    </ol>
  </div>
</xsl:template>

<xsl:template match="db:listitem">
  <li>
    <xsl:call-template name="id"/>
    <xsl:apply-templates/>
  </li>
</xsl:template>

</xsl:stylesheet>
