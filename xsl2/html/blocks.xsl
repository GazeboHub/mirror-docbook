<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2004/10/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
		exclude-result-prefixes="h f m fn db"
                version="2.0">

<xsl:template match="db:para|db:simpara">
  <xsl:choose>
    <xsl:when test="parent::db:listitem
		    and not(preceding-sibling::*)
		    and not(@role)">
      <xsl:variable name="list"
		    select="(ancestor::db:orderedlist
			     |ancestor::db:itemizedlist
			     |ancestor::db:variablelist)[last()]"/>
      <xsl:choose>
	<xsl:when test="$list/@spacing='compact'">
	  <xsl:call-template name="anchor"/>
	  <xsl:apply-templates/>
	</xsl:when>
	<xsl:otherwise>
	  <p>
	    <xsl:call-template name="id"/>
	    <xsl:call-template name="class"/>
	    <xsl:apply-templates/>
	  </p>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <p>
	<xsl:call-template name="id"/>
	<xsl:call-template name="class"/>
	<xsl:apply-templates/>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:figure|db:example">
  <xsl:variable name="titlepage"
		select="$titlepages/*[fn:node-name(.)
			              = fn:node-name(current())][1]"/>
  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <xsl:call-template name="titlepage">
      <xsl:with-param name="content" select="$titlepage"/>
    </xsl:call-template>

    <xsl:apply-templates select="*[not(self::db:info)]"/>
  </div>
</xsl:template>

<xsl:template match="db:epigraph">
  <div class="{local-name(.)}">
      <xsl:apply-templates select="*[not(self::db:attribution)]"/>
      <xsl:if test="db:attribution">
        <div class="attribution">
          <span>—<xsl:apply-templates select="db:attribution"/></span>
        </div>
      </xsl:if>
  </div>
</xsl:template>

<xsl:template match="db:attribution">
  <span class="{local-name(.)}"><xsl:apply-templates/></span>
</xsl:template>

<xsl:template match="db:ackno">
  <div class="{local-name(.)}"><xsl:apply-templates/></div>
</xsl:template>

</xsl:stylesheet>
