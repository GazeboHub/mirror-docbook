<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://docbook.org/ns/docbook"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
		exclude-result-prefixes="db doc u"
                version="2.0">

<xsl:key name="functions" match="xsl:function" use="@name"/>
<xsl:key name="templates" match="xsl:template" use="@name"/>

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:strip-space elements="*"/>

<xsl:template match="xsl:stylesheet">
  <reference>
    <xsl:choose>
      <xsl:when test="doc:reference">
	<xsl:apply-templates select="doc:reference"/>
      </xsl:when>
      <xsl:otherwise>
	<info>
	  <title>Reference</title>
	</info>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </reference>
</xsl:template>

<xsl:template match="doc:reference">
  <xsl:apply-templates mode="copy"/>
</xsl:template>

<xsl:template match="doc:function">
  <xsl:variable name="name" select="@name"/>

  <refentry>
    <refnamediv>
      <refname>
	<xsl:value-of select="@name"/>
      </refname>

      <xsl:apply-templates select="db:refpurpose" mode="copy"/>
    </refnamediv>

    <xsl:variable name="func"
		  select="if (following-sibling::xsl:function[1][@name=$name])
			  then following-sibling::xsl:function[1][@name=$name]
			  else key('functions', @name)"/>

    <xsl:if test="count($func) != 1">
      <xsl:message>
	<xsl:text>Warning: function </xsl:text>
	<xsl:value-of select="$name"/>
	<xsl:text> appears more than once</xsl:text>
      </xsl:message>
    </xsl:if>

    <refsynopsisdiv>
      <funcsynopsis language="xslt2-function">
	<funcprototype>
	  <funcdef>
	    <xsl:if test="$func/@as">
	      <type>
		<xsl:value-of select="$func/@as"/>
	      </type>
	    </xsl:if>
	    <function>
	      <xsl:value-of select="@name"/>
	    </function>
	  </funcdef>

	  <xsl:choose>
	    <xsl:when test="not($func/xsl:param)">
	      <void/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:for-each select="$func/xsl:param">
		<paramdef>
		  <xsl:if test="@as">
		    <type>
		      <xsl:value-of select="@as"/>
		    </type>
		  </xsl:if>
		  <parameter>
		    <xsl:value-of select="@name"/>
		  </parameter>
		</paramdef>
	      </xsl:for-each>
	    </xsl:otherwise>
	  </xsl:choose>
	</funcprototype>
      </funcsynopsis>
    </refsynopsisdiv>

    <xsl:apply-templates select="db:refdescription"/>
    <xsl:apply-templates select="db:refparameter"/>
    <xsl:apply-templates select="db:refereturn"/>
  </refentry>
</xsl:template>

<xsl:template match="db:refdescription">
  <refsection>
    <info>
      <title>Description</title>
    </info>
    <xsl:apply-templates mode="copy"/>
  </refsection>
</xsl:template>

<xsl:template match="db:refparameter">
  <refsection>
    <info>
      <title>Parameters</title>
    </info>
    <xsl:apply-templates mode="copy"/>
  </refsection>
</xsl:template>

<xsl:template match="db:refreturn">
  <refsection>
    <info>
      <title>Returns</title>
    </info>
    <xsl:apply-templates mode="copy"/>
  </refsection>
</xsl:template>

<xsl:template match="doc:template">
  <xsl:variable name="name" select="@name"/>

  <refentry>
    <refnamediv>
      <refname>
	<xsl:value-of select="@name"/>
      </refname>
      <xsl:apply-templates select="db:refpurpose" mode="copy"/>
    </refnamediv>

    <xsl:variable name="temp"
		  select="if (following-sibling::xsl:template[1][@name=$name])
			  then following-sibling::xsl:template[1][@name=$name]
			  else key('templates', @name)"/>

    <xsl:if test="count($temp) != 1">
      <xsl:message>
	<xsl:text>Warning: template </xsl:text>
	<xsl:value-of select="$name"/>
	<xsl:text> appears more than once</xsl:text>
      </xsl:message>
    </xsl:if>

    <xsl:variable name="param"
		  select="db:refparameter/db:variablelist[1]//db:term"/>

    <refsynopsisdiv>
      <funcsynopsis language="xslt2-template">
	<funcprototype>
	  <funcdef>
	    <xsl:if test="$temp/@as">
	      <type>
		<xsl:value-of select="$temp/@as"/>
	      </type>
	    </xsl:if>
	    <function>
	      <xsl:value-of select="@name"/>
	    </function>
	  </funcdef>

	  <xsl:choose>
	    <xsl:when test="not($temp/xsl:param)">
	      <void/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:for-each select="$temp/xsl:param">
		<xsl:variable name="name" select="@name"/>
		<paramdef>
		  <xsl:if test="not($param[. = $name])">
		    <xsl:attribute name="role">recursive</xsl:attribute>
		  </xsl:if>

		  <xsl:if test="@as">
		    <type>
		      <xsl:value-of select="@as"/>
		    </type>
		  </xsl:if>

		  <xsl:if test="@select">
		    <initializer role="select">
		      <xsl:value-of select="@select"/>
		    </initializer>
		  </xsl:if>

		  <xsl:if test="node()">
		    <initializer role="content">
		      <xsl:apply-templates mode="copy-stuff"/>
		    </initializer>
		  </xsl:if>

		  <parameter>
		    <xsl:value-of select="@name"/>
		  </parameter>
		</paramdef>
	      </xsl:for-each>
	    </xsl:otherwise>
	  </xsl:choose>
	</funcprototype>
      </funcsynopsis>
    </refsynopsisdiv>

    <xsl:apply-templates select="db:refdescription"/>
    <xsl:apply-templates select="db:refparameter"/>
    <xsl:apply-templates select="db:refereturn"/>
  </refentry>
</xsl:template>

<xsl:template match="doc:mode">
  <refentry>
    <refnamediv>
      <refname>
	<xsl:value-of select="@name"/>
      </refname>
      <xsl:apply-templates select="db:refpurpose" mode="copy"/>
    </refnamediv>

    <xsl:apply-templates select="db:refdescription"/>
  </refentry>
</xsl:template>

<xsl:template match="doc:*">
  <xsl:message>
    <xsl:text>Error: unexpected element: </xsl:text>
    <xsl:value-of select="name(.)"/>
  </xsl:message>
</xsl:template>

<xsl:template match="xsl:*">
  <!-- nop -->
</xsl:template>

<xsl:template match="u:*">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="copy">
  <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="copy"/>
  </xsl:element>
</xsl:template>

<xsl:template match="text()|processing-instruction()|comment()" mode="copy">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="copy-stuff">
  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="name(.)"/>

  <xsl:for-each select="@*">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:for-each>
  
  <xsl:choose>
    <xsl:when test="node()">
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates mode="copy-stuff"/>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>&gt;</xsl:text>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>/&gt;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()" mode="copy-stuff">
  <xsl:copy/>
</xsl:template>

<xsl:template match="processing-instruction()" mode="copy-stuff">
  <xsl:text>&lt;?</xsl:text>
  <xsl:copy-of select="name(.)"/>
  <xsl:copy-of select="."/>
  <xsl:text>?&gt;</xsl:text>
</xsl:template>

<xsl:template match="comment()" mode="copy-stuff">
  <xsl:text>&lt;!--</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>--&gt;</xsl:text>
</xsl:template>

</xsl:stylesheet>
