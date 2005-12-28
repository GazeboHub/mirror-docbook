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
<xsl:key name="mtemplates" match="xsl:template[@match]"
	 use="concat(@match,',',@mode,',',@priority)"/>

<xsl:param name="basename" select="''"/>

<xsl:template match="/">
  <xsl:variable name="expanded">
    <xsl:apply-templates select="." mode="expand"/>
  </xsl:variable>

  <xsl:variable name="paramtests" select="$expanded//u:unittests[u:param]"/>
  <xsl:variable name="plaintests" select="$expanded//u:unittests
                                          except $paramtests"/>

  <u:manifest>
    <u:title>
      <xsl:text>Unit tests for </xsl:text>
      <xsl:value-of select="base-uri(.)"/>
    </u:title>

    <xsl:if test="$plaintests">
      <u:test fn="{concat($basename,'test0')}"/>
      <xsl:call-template name="writetests">
	<xsl:with-param name="tests" select="$plaintests"/>
	<xsl:with-param name="fn" select="concat($basename,'test0.xsl')"/>
      </xsl:call-template>
    </xsl:if>

    <xsl:for-each select="$paramtests">
      <u:test fn="{concat($basename,'test', position())}"/>
      <xsl:call-template name="writetests">
	<xsl:with-param name="tests" select="."/>
	<xsl:with-param name="fn"
			select="concat($basename,'test', position(), '.xsl')"/>
      </xsl:call-template>
    </xsl:for-each>
  </u:manifest>
</xsl:template>

<xsl:template name="writetests">
  <xsl:param name="fn" select="unittests.xsl"/>
  <xsl:param name="tests" select="()"/>

  <xsl:result-document method="xml" href="{$fn}" indent="yes">
    <xsl:element name="xsl:stylesheet">
      <xsl:namespace name="f" select="'http://docbook.org/xslt/ns/extension'"/>
      <xsl:namespace name="db" select="'http://docbook.org/ns/docbook'"/>
      <xsl:namespace name="xs" select="'http://www.w3.org/2001/XMLSchema'"/>
      <xsl:namespace name="doc" select="'http://nwalsh.com/xsl/documentation/1.0'"/>
      <xsl:namespace name="fp" select="'http://docbook.org/xslt/ns/extension/private'"/>
      <xsl:namespace name="l" select="'http://docbook.sourceforge.net/xmlns/l10n/1.0'"/>
      <xsl:namespace name="m" select="'http://docbook.org/xslt/ns/mode'"/>
      <xsl:namespace name="u" select="'http://nwalsh.com/xsl/unittests#'"/>
      <xsl:attribute name="version" select="'2.0'"/>

      <xsl:element name="xsl:import">
	<xsl:attribute name="href" select="'file:/sourceforge/docbook/xsl2/html/docbook.xsl'"/>
      </xsl:element>

      <xsl:element name="xsl:include">
	<xsl:attribute name="href" select="'file:/sourceforge/docbook/xsl2/tools/tohtml.xsl'"/>
      </xsl:element>

      <xsl:for-each select="$tests/u:param">
	<xsl:element name="xsl:param">
	  <xsl:copy-of select="@*"/>
	  <xsl:copy-of select="node()"/>
	</xsl:element>
      </xsl:for-each>

      <xsl:element name="xsl:output">
	<xsl:attribute name="method" select="'xhtml'"/>
	<xsl:attribute name="indent" select="'no'"/>
      </xsl:element>
      <xsl:element name="xsl:template">
	<xsl:attribute name="match" select="'/'"/>
	<div>
	  <xsl:apply-templates select="$tests"/>
	</div>
      </xsl:element>
      
      <xsl:apply-templates select="$tests//u:context"
			   mode="write-context-templates"/>

    </xsl:element>
  </xsl:result-document>
</xsl:template>

<xsl:template match="u:unittests[@function]">
  <xsl:variable name="function" select="@function"/>

  <div class="function">
    <h2>Function <xsl:value-of select="$function"/></h2>

    <xsl:for-each select="u:param">
      <xsl:apply-templates select="." mode="tohtml">
	<xsl:with-param name="nameattr" select="@name"/>
      </xsl:apply-templates>
    </xsl:for-each>

    <xsl:for-each select="u:test">
      <xsl:variable name="id" select="generate-id()"/>

      <xsl:if test="u:context">
	<xsl:element name="xsl:variable">
	  <xsl:attribute name="name" select="concat($id,'-context')"/>
	  <xsl:copy-of select="u:context/node()"/>
	</xsl:element>
      </xsl:if>

      <xsl:for-each select="u:variable">
	<xsl:element name="xsl:variable">
	  <xsl:copy-of select="@*"/>
	  <xsl:copy-of select="node()"/>
	</xsl:element>
      </xsl:for-each>

      <xsl:for-each select="u:param">
	<xsl:element name="xsl:variable">
	  <xsl:for-each select="@*">
	    <xsl:if test="name(.) != 'select' or not(parent::*/node())">
	      <xsl:copy-of select="."/>
	    </xsl:if>
	  </xsl:for-each>
	  <xsl:attribute name="name" select="concat('var', position())"/>
	  <xsl:copy-of select="node()"/>
	</xsl:element>
      </xsl:for-each>

      <xsl:element name="xsl:variable">
	<xsl:attribute name="name" select="'result'"/>
	<xsl:if test="u:result/@as">
	  <xsl:attribute name="as" select="u:result/@as"/>
	</xsl:if>
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
	  <xsl:choose>
	    <xsl:when test="@select">
	      <xsl:if test="not(starts-with(@select,'/'))">/</xsl:if>
	      <xsl:value-of select="@select"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:if test="*">/*[1]</xsl:if>
	    </xsl:otherwise>
	  </xsl:choose>
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
	    <xsl:if test="*">
	      <xsl:choose>
		<xsl:when test="@select">
		  <xsl:if test="not(starts-with(@select,'/'))">/</xsl:if>
		  <xsl:value-of select="@select"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:text>/*[1]</xsl:text>
		</xsl:otherwise>
	      </xsl:choose>
	    </xsl:if>
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
	    <xsl:apply-templates select="." mode="tohtml"/>
	  </xsl:for-each>

	  <xsl:for-each select="u:param">
	    <xsl:apply-templates select="." mode="tohtml">
	      <xsl:with-param name="nameattr"
			      select="concat('var', position())"/>
	    </xsl:apply-templates>
	  </xsl:for-each>

	  <pre>
	    <xsl:element name="xsl:value-of">
	      <xsl:attribute name="select" select="'$call'"/>
	    </xsl:element>
	  </pre>
	</div>

	<xsl:element name="xsl:choose">
	  <xsl:element name="xsl:when">
	    <xsl:attribute name="test" select="'$ok'"/>
	    <div class="result">
	      <h4>Result</h4>

	      <xsl:choose>
		<xsl:when test="u:result/*">
		  <xsl:apply-templates select="u:result/node()" mode="tohtml"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="u:result"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </div>
	  </xsl:element>
	  <xsl:element name="xsl:otherwise">
	    <div class="result">
	      <h4>Expected result</h4>

	      <xsl:choose>
		<xsl:when test="u:result/*">
		  <xsl:apply-templates select="u:result/node()" mode="tohtml"/>
		</xsl:when>
		<xsl:otherwise>
		  <xsl:value-of select="u:result"/>
		</xsl:otherwise>
	      </xsl:choose>
	    </div>

	    <div class="eval">
	      <h4>Actual result</h4>

	      <pre>
		<xsl:variable name="as"
			      select="key('functions', $function)/@as"/>

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
	  </xsl:element>
	</xsl:element>
      </div>
    </xsl:for-each>
  </div>
</xsl:template>

<xsl:template match="u:unittests[@template]">
  <xsl:variable name="template" select="@template"/>

  <div class="function">
    <h2>Template <xsl:value-of select="$template"/></h2>

    <xsl:for-each select="u:param">
      <xsl:apply-templates select="." mode="tohtml">
	<xsl:with-param name="nameattr" select="@name"/>
      </xsl:apply-templates>
    </xsl:for-each>

    <xsl:for-each select="u:test">
      <xsl:variable name="id" select="generate-id()"/>

      <xsl:if test="u:context">
	<xsl:element name="xsl:variable">
	  <xsl:attribute name="name" select="concat($id,'-context')"/>
	  <xsl:if test="u:context/@as">
	    <xsl:attribute name="as" select="u:context/@as"/>
	  </xsl:if>
	  <xsl:copy-of select="u:context/node()"/>
	</xsl:element>
      </xsl:if>

      <xsl:for-each select="u:variable">
	<xsl:element name="xsl:variable">
	  <xsl:copy-of select="@*"/>
	  <xsl:copy-of select="node()"/>
	</xsl:element>
      </xsl:for-each>

      <xsl:element name="xsl:variable">
	<xsl:attribute name="name" select="'result'"/>
	<xsl:if test="u:result/@as">
	  <xsl:attribute name="as" select="u:result/@as"/>
	</xsl:if>
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

	<xsl:choose>
	  <xsl:when test="u:context">
	    <xsl:element name="xsl:apply-templates">
	      <xsl:attribute name="select" select="concat('$',$id,'-context')"/>
	      <xsl:attribute name="mode" select="$id"/>
	    </xsl:element>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:element name="xsl:call-template">
	      <xsl:attribute name="name" select="$template"/>
	      <xsl:for-each select="u:param">
		<xsl:element name="xsl:with-param">
		  <xsl:copy-of select="@*"/>
		  <xsl:copy-of select="node()"/>
		</xsl:element>
	      </xsl:for-each>
	    </xsl:element>
	  </xsl:otherwise>
	</xsl:choose>
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

	  <xsl:if test="u:context">
	    <h5>Context</h5>
	    <pre>
	      <xsl:apply-templates select="u:context" mode="tohtml"/>
	    </pre>
	  </xsl:if>

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
	    <xsl:variable name="as" select="key('templates', $template)/@as"/>

	    <xsl:choose>
	      <xsl:when test="not($as) or contains($as, '&#41;')">
		<xsl:element name="xsl:choose">
		  <xsl:element name="xsl:when">
		    <xsl:attribute name="test"
				   select="'$eval instance of document-node()'"/>
		    <xsl:element name="xsl:apply-templates">
		      <xsl:attribute name="select" select="'$eval/*'"/>
		      <xsl:attribute name="mode" select="'tohtml'"/>
		    </xsl:element>
		  </xsl:element>
		  <xsl:element name="xsl:when">
		    <xsl:attribute name="test"
				   select="'$eval instance of element()'"/>
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

<xsl:template match="u:unittests[@match]">
  <xsl:variable name="templates"
		select="key('mtemplates',
			    concat(@match,',',@mode,',',@priority))"/>

  <xsl:variable name="template" select="$templates[1]"/>

  <div class="function">
    <h2>Match Template <xsl:value-of select="$template/@match"/></h2>

    <xsl:for-each select="u:param">
      <xsl:apply-templates select="." mode="tohtml">
	<xsl:with-param name="nameattr" select="@name"/>
      </xsl:apply-templates>
    </xsl:for-each>

    <xsl:for-each select="u:test">
      <xsl:variable name="id" select="generate-id()"/>

      <xsl:if test="u:context">
	<xsl:element name="xsl:variable">
	  <xsl:attribute name="name" select="concat($id,'-context')"/>
	  <xsl:if test="u:context/@as">
	    <xsl:attribute name="as" select="u:context/@as"/>
	  </xsl:if>
	  <xsl:copy-of select="u:context/node()"/>
	</xsl:element>
      </xsl:if>

      <xsl:element name="xsl:variable">
	<xsl:attribute name="name" select="'result'"/>
	<xsl:if test="u:result/@as">
	  <xsl:attribute name="as" select="u:result/@as"/>
	</xsl:if>
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

	<xsl:choose>
	  <xsl:when test="u:context">
	    <xsl:element name="xsl:apply-templates">
	      <xsl:attribute name="select" select="concat('$',$id,'-context')"/>
	      <xsl:attribute name="mode" select="$id"/>
	    </xsl:element>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:message terminate="yes">
	      <xsl:text>Match templates require context.</xsl:text>
	    </xsl:message>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:element>

      <xsl:element name="xsl:variable">
	<xsl:attribute name="name" select="'ok'"/>
	<xsl:attribute name="select">
	  <xsl:text>if ($result instance of node()) then deep-equal($result, $eval) else $result = $eval</xsl:text>
	</xsl:attribute>
      </xsl:element>

      <xsl:element name="xsl:variable">
	<xsl:attribute name="name" select="'outcome'"/>
	<xsl:choose>
	  <xsl:when test="count($templates) != 1">Unknown</xsl:when>
	  <xsl:otherwise>
	    <xsl:element name="xsl:choose">
	      <xsl:element name="xsl:when">
		<xsl:attribute name="test" select="'$ok'"/>
		<xsl:text>Pass</xsl:text>
	      </xsl:element>
	      <xsl:element name="xsl:otherwise">
		<xsl:text>Fail</xsl:text>
	      </xsl:element>
	    </xsl:element>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:element>

      <div class="test">
	<xsl:element name="xsl:attribute">
	  <xsl:attribute name="name" select="'class'"/>
	  <xsl:attribute name="select" select="'lower-case($outcome)'"/>
	</xsl:element>

	<div class="setup">
	  <h4>Test</h4>

	  <xsl:if test="u:context">
	    <h5>
	      <xsl:text>Context</xsl:text>
	      <xsl:if test="u:context/@as">
		<xsl:text> </xsl:text>
		<xsl:value-of select="u:context/@as"/>
	      </xsl:if>
	    </h5>
	    <pre>
	      <xsl:apply-templates select="u:context/node()" mode="tohtml"/>
	    </pre>
	  </xsl:if>

	  <pre>
	    <xsl:text>Apply template with match=</xsl:text>
	    <xsl:value-of select="$template/@match"/>
	    <xsl:if test="$template/@mode">
	      <xsl:text>, mode=</xsl:text>
	      <xsl:value-of select="$template/@mode"/>
	    </xsl:if>
	    <xsl:if test="$template/@priority">
	      <xsl:text>, priority=</xsl:text>
	      <xsl:value-of select="$template/@priority"/>
	    </xsl:if>
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

	  <xsl:choose>
	    <xsl:when test="count($templates) != 1">
	      <pre>
		<xsl:text>Indeterminate; </xsl:text>
		<xsl:value-of select="count($templates)"/>
		<xsl:text> template(s) match.</xsl:text>
	      </pre>
	    </xsl:when>
	    <xsl:otherwise>
	      <pre>
		<xsl:variable name="as"
			      select="key('templates', $template)/@as"/>

		<xsl:choose>
		  <xsl:when test="not($as) or contains($as, '&#41;')">
		    <xsl:element name="xsl:choose">
		      <xsl:element name="xsl:when">
			<xsl:attribute name="test"
				       select="'$eval instance of document-node()'"/>
			<xsl:element name="xsl:apply-templates">
			  <xsl:attribute name="select" select="'$eval/*'"/>
			  <xsl:attribute name="mode" select="'tohtml'"/>
			</xsl:element>
		      </xsl:element>
		      <xsl:element name="xsl:when">
			<xsl:attribute name="test"
				       select="'$eval instance of element()'"/>
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
	    </xsl:otherwise>
	  </xsl:choose>
	</div>
      </div>
    </xsl:for-each>
  </div>
</xsl:template>

<xsl:template match="u:context[ancestor::u:unittests[@match]]"
	      mode="write-context-templates"
	      priority="100">
  <xsl:variable name="id" select="generate-id(..)"/>
  <xsl:variable name="ut" select="ancestor::u:unittests"/>
  <xsl:variable name="template"
		select="key('mtemplates',
			concat($ut/@match,',',$ut/@mode,',',$ut/@priority))"/>

  <xsl:element name="xsl:template">
    <xsl:attribute name="match" select="'node()'"/>
    <xsl:attribute name="mode" select="$id"/>
    <xsl:copy-of select="$template[1]/node()"/>
  </xsl:element>
</xsl:template>

<xsl:template match="u:context"
	      mode="write-context-templates">
  <xsl:variable name="id" select="generate-id(..)"/>

  <xsl:element name="xsl:template">
    <xsl:attribute name="match" select="'node()'"/>
    <xsl:attribute name="mode" select="$id"/>
    <xsl:element name="xsl:call-template">
      <xsl:attribute name="name" select="ancestor::u:unittests/@template"/>
    </xsl:element>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
