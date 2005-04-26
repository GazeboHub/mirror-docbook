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

<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*"/>

<xsl:include href="expand.xsl"/>
<xsl:include href="tohtml.xsl"/>

<xsl:key name="functions" match="xsl:function" use="@name"/>
<xsl:key name="templates" match="xsl:template" use="@name"/>

<xsl:template match="/">
  <xsl:variable name="expanded">
    <xsl:apply-templates select="." mode="expand"/>
  </xsl:variable>

  <xsl:element name="xsl:stylesheet">
    <xsl:namespace name="f" select="'http://docbook.org/xslt/ns/extension'"/>
    <xsl:namespace name="db" select="'http://docbook.org/ns/docbook'"/>
    <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>

    <xsl:attribute name="version" select="'2.0'"/>

    <xsl:element name="xsl:import">
      <xsl:attribute name="href" select="base-uri(.)"/>
    </xsl:element>
    <xsl:element name="xsl:include">
      <xsl:attribute name="href" select="'tools/tohtml.xsl'"/>
    </xsl:element>

    <xsl:for-each select="$expanded//u:unittests/u:param">
      <xsl:element name="xsl:param">
	<xsl:copy-of select="@*"/>
	<xsl:copy-of select="node()"/>
      </xsl:element>
    </xsl:for-each>

    <xsl:element name="xsl:output">
      <xsl:attribute name="method" select="'xhtml'"/>
      <xsl:attribute name="indent" select="'yes'"/>
    </xsl:element>
    <xsl:element name="xsl:template">
      <xsl:attribute name="match" select="'/'"/>
      <html>
	<head>
	  <title>Unit tests for <xsl:value-of select="base-uri(.)"/></title>
	  <style type="text/css">
div.pass { background-color: #99FF99; }
div.fail { background-color: #FF9999; }
	  </style>
	</head>
	<body>
	  <h1>Unit tests for <xsl:value-of select="base-uri(.)"/></h1>
	  <xsl:apply-templates select="$expanded//u:unittests"/>
	</body>
      </html>
    </xsl:element>
  </xsl:element>
</xsl:template>

<xsl:template match="u:unittests[@function]">
  <xsl:variable name="function" select="@function"/>

  <div class="function">
    <h2>Function <xsl:value-of select="$function"/></h2>

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
	<xsl:attribute name="name" select="'call'"/>
	<xsl:value-of select="$function"/>
	<xsl:text>(</xsl:text>
	<xsl:for-each select="u:param">
	  <xsl:value-of select="concat('$var', position())"/>
	  <xsl:if test="*">/*[1]</xsl:if>
	  <xsl:if test="following-sibling::u:param">,</xsl:if>
	</xsl:for-each>
	<xsl:text>)</xsl:text>
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
	  <xsl:text>if ($result instance of node()) then deep-equal($result, $eval) else $result = $eval</xsl:text>
	</xsl:attribute>
      </xsl:element>

      <xsl:element name="xsl:variable">
	<xsl:attribute name="name" select="'outcome'"/>
	<xsl:element name="xsl:choose">
	  <xsl:element name="xsl:when">
	    <xsl:attribute name="test" select="'$ok'"/>
	    <xsl:text>Pass</xsl:text>
	  </xsl:element>
	  <xsl:element name="xsl:otherwise">
	    <xsl:text>Fail</xsl:text>
	  </xsl:element>
	</xsl:element>
      </xsl:element>

      <div class="test">
	<xsl:element name="xsl:attribute">
	  <xsl:attribute name="name" select="'class'"/>
	  <xsl:attribute name="select" select="'lower-case($outcome)'"/>
	</xsl:element>

	<div class="setup">
	  <h4>Test</h4>

	  <xsl:for-each select="u:variable">
	    <pre>
	      <xsl:apply-templates select="." mode="tohtml"/>
	    </pre>
	  </xsl:for-each>

	  <xsl:for-each select="u:param">
	    <pre>
	      <xsl:apply-templates select="." mode="tohtml">
		<xsl:with-param name="nameattr"
				select="concat('var', position())"/>
	      </xsl:apply-templates>
	    </pre>
	  </xsl:for-each>

	  <pre>
	    <xsl:element name="xsl:value-of">
	      <xsl:attribute name="select" select="'$call'"/>
	    </xsl:element>
	  </pre>
	</div>

	<div class="result">
	  <h4>Expected result</h4>

	  <pre>
	    <xsl:choose>
	      <xsl:when test="u:result/*">
		<xsl:apply-templates select="u:result/node()" mode="tohtml"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="u:result"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </pre>
	</div>

	<div class="eval">
	  <h4>Actual result</h4>

	  <pre>
	    <xsl:variable name="as" select="key('functions', $function)/@as"/>

	    <xsl:choose>
	      <xsl:when test="not($as) or contains($as, '&#41;')">
		<xsl:element name="xsl:choose">
		  <xsl:element name="xsl:when">
		    <xsl:attribute name="test"
				   select="'$eval instance of node()'"/>
		    <xsl:element name="xsl:apply-templates">
		      <xsl:attribute name="select" select="'$eval'"/>
		      <xsl:attribute name="mode" select="'tohtml'"/>
		    </xsl:element>
		  </xsl:element>
		  <xsl:element name="xsl:otherwise">
		    <xsl:text>'</xsl:text>
		    <xsl:element name="xsl:value-of">
		      <xsl:attribute name="select" select="'$eval'"/>
		    </xsl:element>
		    <xsl:text>'</xsl:text>
		  </xsl:element>
		</xsl:element>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:text>'</xsl:text>
		<xsl:element name="xsl:value-of">
		  <xsl:attribute name="select" select="'$eval'"/>
		</xsl:element>
		<xsl:text>'</xsl:text>
	      </xsl:otherwise>
	    </xsl:choose>
	  </pre>
	</div>
      </div>
    </xsl:for-each>
  </div>
</xsl:template>

<xsl:template match="u:unittests[@template]">
  <xsl:variable name="template" select="@template"/>

  <div class="function">
    <h2>Template <xsl:value-of select="$template"/></h2>

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
	<xsl:if test="key('templates', $template)/@as">
	  <xsl:attribute name="as" select="key('templates', $template)/@as"/>
	</xsl:if>

	<xsl:element name="xsl:call-template">
	  <xsl:attribute name="name" select="$template"/>
	  <xsl:for-each select="u:param">
	    <xsl:element name="xsl:with-param">
	      <xsl:copy-of select="@*"/>
	      <xsl:copy-of select="node()"/>
	    </xsl:element>
	  </xsl:for-each>
	</xsl:element>
      </xsl:element>

      <xsl:element name="xsl:variable">
	<xsl:attribute name="name" select="'ok'"/>
	<xsl:attribute name="select">
	  <xsl:text>if ($result instance of node()) then deep-equal($result, $eval) else $result = $eval</xsl:text>
	</xsl:attribute>
      </xsl:element>

      <xsl:element name="xsl:variable">
	<xsl:attribute name="name" select="'outcome'"/>
	<xsl:element name="xsl:choose">
	  <xsl:element name="xsl:when">
	    <xsl:attribute name="test" select="'$ok'"/>
	    <xsl:text>Pass</xsl:text>
	  </xsl:element>
	  <xsl:element name="xsl:otherwise">
	    <xsl:text>Fail</xsl:text>
	  </xsl:element>
	</xsl:element>
      </xsl:element>

      <div class="test">
	<xsl:element name="xsl:attribute">
	  <xsl:attribute name="name" select="'class'"/>
	  <xsl:attribute name="select" select="'lower-case($outcome)'"/>
	</xsl:element>

	<div class="setup">
	  <h4>Test</h4>

	  <pre>
	    <xsl:text>&lt;xsl:call-template name="</xsl:text>
	    <xsl:value-of select="$template"/>
	    <xsl:text>"&gt;</xsl:text>
	    <xsl:for-each select="u:param">
	      <xsl:text>&#10;</xsl:text>
	      <xsl:apply-templates select="." mode="tohtml">
		<xsl:with-param name="name" select="'xsl:with-param'"/>
		<xsl:with-param name="indent" select="'  '"/>
	      </xsl:apply-templates>
	    </xsl:for-each>
	    <xsl:text>&#10;&lt;/xsl:call-template&gt;&#10;</xsl:text>
	  </pre>
	</div>

	<div class="result">
	  <h4>Expected result</h4>

	  <pre>
	    <xsl:choose>
	      <xsl:when test="u:result/*">
		<xsl:apply-templates select="u:result/node()" mode="tohtml"/>
	      </xsl:when>
	      <xsl:otherwise>
		<xsl:value-of select="u:result"/>
	      </xsl:otherwise>
	    </xsl:choose>
	  </pre>
	</div>

	<div class="eval">
	  <h4>Actual result</h4>

	  <pre>
	    <xsl:element name="xsl:choose">
	      <xsl:element name="xsl:when">
		<xsl:attribute name="test"
			       select="'$eval instance of document-node()'"/>
doc
		<xsl:element name="xsl:apply-templates">
		  <xsl:attribute name="select" select="'$eval/*'"/>
		  <xsl:attribute name="mode" select="'tohtml'"/>
		</xsl:element>
	      </xsl:element>
	      <xsl:element name="xsl:when">
		<xsl:attribute name="test"
			       select="'$eval instance of element()'"/>
elem
		<xsl:element name="xsl:apply-templates">
		  <xsl:attribute name="select" select="'$eval'"/>
		  <xsl:attribute name="mode" select="'tohtml'"/>
		</xsl:element>
	      </xsl:element>
	      <xsl:element name="xsl:otherwise">
other
		<xsl:text>'</xsl:text>
		<xsl:element name="xsl:value-of">
		  <xsl:attribute name="select" select="'$eval'"/>
		</xsl:element>
		<xsl:text>'</xsl:text>
	      </xsl:element>
	    </xsl:element>
	  </pre>
	</div>

<!--
	<XXX>
	  <xsl:element name="xsl:copy-of">
	    <xsl:attribute name="select" select="'$result'"/>
	  </xsl:element>
	</XXX>
	<YYY>
	  <xsl:element name="xsl:copy-of">
	    <xsl:attribute name="select" select="'$eval'"/>
	  </xsl:element>
	</YYY>
-->

      </div>
    </xsl:for-each>
  </div>
</xsl:template>

</xsl:stylesheet>
