<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc u xs"
                version="2.0">

<xsl:output method="xml" indent="no"/>

<xsl:include href="expand.xsl"/>

<xsl:template match="/">
  <xsl:variable name="expanded">
    <xsl:apply-templates select="." mode="expand"/>
  </xsl:variable>

  <xsl:element name="xsl:stylesheet">
    <xsl:namespace name="f" select="'http://docbook.org/xslt/ns/extension'"/>
    <xsl:namespace name="db" select="'http://docbook.org/docbook-ng'"/>
    <xsl:element name="xsl:import">
      <xsl:attribute name="href" select="base-uri(.)"/>
    </xsl:element>

    <xsl:for-each select="$expanded//u:unittests/u:param">
      <xsl:element name="xsl:param">
	<xsl:copy-of select="@*"/>
	<xsl:copy-of select="node()"/>
      </xsl:element>
    </xsl:for-each>

    <xsl:element name="xsl:output">
      <xsl:attribute name="method" select="'text'"/>
    </xsl:element>
    <xsl:element name="xsl:template">
      <xsl:attribute name="match" select="'/'"/>
      <xsl:apply-templates select="$expanded//u:unittests"/>
    </xsl:element>
  </xsl:element>
</xsl:template>

<xsl:template match="u:unittests[@function]">
  <xsl:variable name="function" select="@function"/>

  <xsl:for-each select="u:test">
    <xsl:for-each select="u:variable">
      <xsl:element name="xsl:variable">
	<xsl:copy-of select="@*"/>
	<xsl:copy-of select="node()"/>
      </xsl:element>
    </xsl:for-each>
    <xsl:for-each select="u:param">
      <xsl:element name="xsl:variable">
	<xsl:copy-of select="@*"/>
	<xsl:attribute name="name" select="concat('var', position())"/>
	<xsl:copy-of select="node()"/>
      </xsl:element>
    </xsl:for-each>

    <xsl:element name="xsl:variable">
      <xsl:attribute name="name" select="'result'"/>
      <xsl:choose>
	<xsl:when test="u:result/*">
	  <xsl:copy-of select="u:result/node()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="select" select="u:result"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>

    <xsl:element name="xsl:variable">
      <xsl:attribute name="name" select="'eval'"/>
      <xsl:attribute name="select">
	<xsl:value-of select="$function"/>
	<xsl:text>(</xsl:text>
	<xsl:for-each select="u:param">
	  <xsl:value-of select="concat('$var', position())"/>
	  <xsl:if test="*">/*[1]</xsl:if>
	  <xsl:if test="following-sibling::u:param">,</xsl:if>
	</xsl:for-each>
	<xsl:text>)</xsl:text>
      </xsl:attribute>
    </xsl:element>

    <xsl:element name="xsl:variable">
      <xsl:attribute name="name" select="'ok'"/>
      <xsl:attribute name="select">
	<xsl:text>if ($result instance of element()) then deep-equal($result, $eval) else $result = $eval</xsl:text>
      </xsl:attribute>
    </xsl:element>

    <xsl:element name="xsl:choose">
      <xsl:element name="xsl:when">
	<xsl:attribute name="test" select="'$ok'"/>
	<xsl:text>Pass: </xsl:text>
      </xsl:element>
      <xsl:element name="xsl:otherwise">
	<xsl:text>FAIL: </xsl:text>
      </xsl:element>
    </xsl:element>

    <xsl:value-of select="$function"/>
    <xsl:text>(</xsl:text>
    <xsl:for-each select="u:param">
      <xsl:choose>
	<xsl:when test="@select">
	  <xsl:value-of select="@select"/>
	</xsl:when>
	<xsl:when test="*">*</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="."/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:if test="following-sibling::u:param">,</xsl:if>
    </xsl:for-each>
    <xsl:text>) = </xsl:text>
    <xsl:element name="xsl:value-of">
      <xsl:attribute name="select" select="'$eval'"/>
    </xsl:element>

    <xsl:element name="xsl:if">
      <xsl:attribute name="test" select="'not($ok)'"/>
      <xsl:text> instead of </xsl:text>
      <xsl:element name="xsl:value-of">
	<xsl:attribute name="select" select="'$result'"/>
      </xsl:element>
    </xsl:element>

    <xsl:element name="xsl:text">
      <xsl:text>&#10;</xsl:text>
    </xsl:element>
  </xsl:for-each>
</xsl:template>

<xsl:template match="u:unittests[@template]">
  <xsl:variable name="template" select="@template"/>

  <xsl:for-each select="u:test">
    <xsl:for-each select="u:variable">
      <xsl:element name="xsl:variable">
	<xsl:copy-of select="@*"/>
	<xsl:copy-of select="node()"/>
      </xsl:element>
    </xsl:for-each>

    <xsl:element name="xsl:variable">
      <xsl:attribute name="name" select="'result'"/>
      <xsl:choose>
	<xsl:when test="u:result/*">
	  <xsl:copy-of select="u:result/node()"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:attribute name="select" select="u:result"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:element>

    <xsl:element name="xsl:variable">
      <xsl:attribute name="name" select="'eval'"/>

      <xsl:element name="xsl:call-template">
	<xsl:attribute name="name" select="$template"/>
	<xsl:for-each select="u:param">
	  <xsl:element name="xsl:with-param">
	    <xsl:copy-of select="@*"/>
	    <xsl:copy-of select="node()"/>
	  </xsl:element>
	</xsl:for-each>
<!--
	    <xsl:message>t: <xsl:value-of select="@select"/></xsl:message>
	    <xsl:attribute name="name" select="@name"/>
	    <xsl:choose>
	      <xsl:when test="*">
		<xsl:copy-of select="node()"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:attribute name="select" select="."/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </xsl:element>
	</xsl:for-each>
-->
      </xsl:element>
    </xsl:element>

    <xsl:element name="xsl:variable">
      <xsl:attribute name="name" select="'ok'"/>
      <xsl:attribute name="select">
	<xsl:text>if ($result instance of element()) then deep-equal($result, $eval) else $result = $eval</xsl:text>
      </xsl:attribute>
    </xsl:element>

    <xsl:element name="xsl:choose">
      <xsl:element name="xsl:when">
	<xsl:attribute name="test" select="'$ok'"/>
	<xsl:text>Pass: </xsl:text>
      </xsl:element>
      <xsl:element name="xsl:otherwise">
	<xsl:text>FAIL: </xsl:text>
      </xsl:element>
    </xsl:element>

    <xsl:value-of select="$template"/>
    <xsl:text> with-params: </xsl:text>
    <xsl:for-each select="u:param">
      <xsl:choose>
	<xsl:when test="*">*</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="."/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:if test="following-sibling::u:param">,</xsl:if>
    </xsl:for-each>
    <xsl:text> = </xsl:text>

    <xsl:element name="xsl:choose">
      <xsl:element name="xsl:when">
	<xsl:attribute name="test" select="'$eval/*'"/>
	<xsl:text>*</xsl:text>
      </xsl:element>
      <xsl:element name="xsl:otherwise">
	<xsl:element name="xsl:value-of">
	  <xsl:attribute name="select" select="'$eval'"/>
	</xsl:element>
      </xsl:element>
    </xsl:element>

    <xsl:element name="xsl:if">
      <xsl:attribute name="test" select="'not($ok)'"/>
      <xsl:text> instead of </xsl:text>
      <xsl:element name="xsl:choose">
	<xsl:element name="xsl:when">
	  <xsl:attribute name="test" select="'$result/*'"/>
	  <xsl:text>*</xsl:text>
	</xsl:element>
	<xsl:element name="xsl:otherwise">
	  <xsl:element name="xsl:value-of">
	    <xsl:attribute name="select" select="'$result'"/>
	  </xsl:element>
	</xsl:element>
      </xsl:element>
    </xsl:element>

    <xsl:element name="xsl:text">
      <xsl:text>&#10;</xsl:text>
    </xsl:element>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
