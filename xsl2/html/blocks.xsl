<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/04/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
		exclude-result-prefixes="h f m fn db"
                version="2.0">

<!-- ============================================================ -->

<xsl:template match="db:para|db:simpara">
  <xsl:param name="runin" select="()"/>
  <xsl:param name="class" select="''"/>

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
	    <xsl:choose>
	      <xsl:when test="$class = ''">
		<xsl:call-template name="class"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:attribute name="class" select="$class"/>
	      </xsl:otherwise>
	    </xsl:choose>
	    <xsl:apply-templates/>
	  </p>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <p>
	<xsl:call-template name="id"/>
	<xsl:choose>
	  <xsl:when test="$class = ''">
	    <xsl:call-template name="class"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:attribute name="class" select="$class"/>
	  </xsl:otherwise>
	</xsl:choose>

	<xsl:if test="not(empty($runin))">
	  <xsl:copy-of select="$runin"/>
	</xsl:if>

	<xsl:apply-templates/>
      </p>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:epigraph">
  <div class="{local-name(.)}">
    <xsl:apply-templates select="*[not(self::db:attribution)]"/>
    <xsl:apply-templates select="db:attribution"/>
  </div>
</xsl:template>

<xsl:template match="db:attribution">
  <div class="{local-name(.)}">
    <span class="mdash">—</span>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:ackno">
  <div class="{local-name(.)}"><xsl:apply-templates/></div>
</xsl:template>

<xsl:template match="db:blockquote">
  <blockquote>
    <xsl:if test="db:info/db:title">
      <h3>
	<xsl:apply-templates select="db:info/db:title/node()"/>
      </h3>
    </xsl:if>
    <xsl:apply-templates select="* except (db:info|db:attribution)"/>
    <xsl:apply-templates select="db:attribution"/>
  </blockquote>
</xsl:template>

</xsl:stylesheet>
