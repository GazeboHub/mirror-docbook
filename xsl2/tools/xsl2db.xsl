<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://docbook.org/docbook-ng"
		xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		exclude-result-prefixes="db doc"
                version="2.0">

<xsl:key name="functions" match="xsl:function" use="@name"/>
<xsl:key name="templates" match="xsl:template" use="@name"/>

<xsl:output method="xml" encoding="utf-8" indent="yes"/>

<xsl:strip-space elements="*"/>

<xsl:template match="xsl:stylesheet">
  <reference>
    <xsl:choose>
      <xsl:when test="doc:reference">
	<xsl:copy-of select="doc:reference/*"/>
	<xsl:apply-templates/>
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
  <!-- nop -->
</xsl:template>

<xsl:template match="doc:function">
  <refentry>
    <refnamediv>
      <refname>
	<xsl:value-of select="@name"/>
      </refname>
      <xsl:copy-of select="db:refpurpose"/>
    </refnamediv>

    <xsl:variable name="func" select="key('functions', @name)"/>

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

    <refsection>
      <info>
	<title>Description</title>
      </info>
      <xsl:copy-of select="db:refdescription/*"/>
    </refsection>

    <xsl:if test="db:refparameter">
      <refsection>
	<info>
	  <title>Parameters</title>
	</info>
	<xsl:copy-of select="db:refparameter/*"/>
      </refsection>
    </xsl:if>

    <xsl:if test="db:refreturn">
      <refsection>
	<info>
	  <title>Returns</title>
	</info>
	<xsl:copy-of select="db:refreturn/*"/>
      </refsection>
    </xsl:if>
  </refentry>
</xsl:template>

<xsl:template match="doc:template">
  <refentry>
    <refnamediv>
      <refname>
	<xsl:value-of select="@name"/>
      </refname>
      <xsl:copy-of select="db:refpurpose"/>
    </refnamediv>

    <xsl:variable name="temp" select="key('templates', @name)"/>
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

    <refsection>
      <info>
	<title>Description</title>
      </info>
      <xsl:copy-of select="db:refdescription/*"/>
    </refsection>

    <xsl:if test="db:refparameter">
      <refsection>
	<info>
	  <title>Parameters</title>
	</info>
	<xsl:copy-of select="db:refparameter/*"/>
      </refsection>
    </xsl:if>

    <xsl:if test="db:refreturn">
      <refsection>
	<info>
	  <title>Returns</title>
	</info>
	<xsl:copy-of select="db:refreturn/*"/>
      </refsection>
    </xsl:if>
  </refentry>
</xsl:template>

<xsl:template match="doc:mode">
  <refentry>
    <refnamediv>
      <refname>
	<xsl:value-of select="@name"/>
      </refname>
      <xsl:copy-of select="db:refpurpose"/>
    </refnamediv>

    <refsection>
      <info>
	<title>Description</title>
      </info>
      <xsl:copy-of select="db:refdescription/*"/>
    </refsection>
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

</xsl:stylesheet>
