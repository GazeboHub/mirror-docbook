<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
		exclude-result-prefixes="h f m fn db t xs"
                version="2.0">

<xsl:template name="titlepage">
  <xsl:param name="side" select="'recto'" as="xs:string"/>
  <xsl:param name="info" select="db:info/*" as="element()*"/>
  <xsl:param name="optional" select="1"/>
  <xsl:param name="content"/>

  <xsl:if test="$info or $optional = 0">
    <xsl:choose>
      <xsl:when test="$content instance of document-node()">
	<xsl:apply-templates select="$content" mode="m:titlepage-templates">
	  <xsl:with-param name="side" select="$side" tunnel="yes"/>
	  <xsl:with-param name="node" select="." tunnel="yes"/>
	  <xsl:with-param name="info" select="$info" tunnel="yes"/>
	</xsl:apply-templates>
      </xsl:when>
      <xsl:when test="$content instance of element()">
	<xsl:apply-templates select="$content/*" mode="m:titlepage-templates">
	  <xsl:with-param name="side" select="$side" tunnel="yes"/>
	  <xsl:with-param name="node" select="." tunnel="yes"/>
	  <xsl:with-param name="info" select="$info" tunnel="yes"/>
	</xsl:apply-templates>
      </xsl:when>
      <xsl:when test="fn:empty($content)">
	<xsl:message>
	  <xsl:text>Empty $content in titlepage template (for </xsl:text>
	  <xsl:value-of select="name(.)"/>
	  <xsl:text>).</xsl:text>
	</xsl:message>
      </xsl:when>
      <xsl:otherwise>
	<xsl:message>
	  <xsl:text>Unexpected $content in titlepage template (for </xsl:text>
	  <xsl:value-of select="name(.)"/>
	  <xsl:text>).</xsl:text>
	</xsl:message>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="db:*" mode="m:titlepage-templates" priority="1000">
  <xsl:param name="side" tunnel="yes"/>
  <xsl:param name="node" tunnel="yes"/>
  <xsl:param name="info" tunnel="yes"/>

  <xsl:variable name="this" select="."/>
  <xsl:variable name="content" select="$info[f:node-matches($this,.)]"/>

  <xsl:choose>
    <xsl:when test="@t:named-template">
      <xsl:if test="$content or (@t:force and @t:force != 0)">
	<xsl:call-template name="titlepage-templates">
          <xsl:with-param name="template" select="@t:named-template"
			  tunnel="yes"/>
	  <xsl:with-param name="content" select="$content" tunnel="yes"/>
	  <xsl:with-param name="this" select="$this" tunnel="yes"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:when>
    <xsl:otherwise>
      <!-- $content may be empty -->
      <xsl:apply-templates select="$content" mode="m:titlepage-mode"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-templates">
  <xsl:element name="{local-name(.)}" namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="m:titlepage-templates"/>
  </xsl:element>
</xsl:template>

<xsl:function name="f:node-matches" as="xs:boolean">
  <xsl:param name="template-node" as="element()"/>
  <xsl:param name="document-node" as="element()"/>

  <xsl:choose>
    <xsl:when test="fn:node-name($template-node) = fn:node-name($document-node)">
      <xsl:variable name="attrMatch">
	<xsl:for-each select="$template-node/@*[namespace-uri(.) = '']">
	  <xsl:variable name="aname" select="local-name(.)"/>
	  <xsl:variable name="attr"
			select="$document-node/@*[local-name(.) = $aname]"/>
	  <xsl:choose>
            <xsl:when test="$attr = .">1</xsl:when>
	    <xsl:otherwise>0</xsl:otherwise>
          </xsl:choose>
        </xsl:for-each>
      </xsl:variable>

      <xsl:choose>
	<xsl:when test="not(contains($attrMatch, '0'))">
	  <xsl:value-of select="f:user-node-matches($template-node,
				                    $document-node)"/>
	</xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="false()"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="false()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="f:user-node-matches" as="xs:boolean">
  <xsl:param name="template-node" as="element()"/>
  <xsl:param name="document-node" as="element()"/>
  <xsl:value-of select="true()"/>
</xsl:function>

<xsl:template name="titlepage-templates">
  <xsl:param name="side" tunnel="yes"/>
  <xsl:param name="node" tunnel="yes"/>
  <xsl:param name="info" tunnel="yes"/>
  <xsl:param name="template" tunnel="yes"/>
  <xsl:param name="content" tunnel="yes"/>
  <xsl:param name="this" tunnel="yes"/>

  <xsl:choose>
    <xsl:when test="false() and $template = 'component.title'">
      <!-- xsl:call-template name="component.title"/ -->
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="user-titlepage-templates"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="user-titlepage-templates">
  <!-- nop -->
</xsl:template>

</xsl:stylesheet>
