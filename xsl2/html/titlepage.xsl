<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="db doc f fn h m"
                version="2.0">

<xsl:template match="db:info">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:titlepage-mode"
	  xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for formatting elements on the title page</refpurpose>

<refdescription>
<para>This mode is used to format elements on the title page.
Any element processed in this mode should generate markup appropriate
for the title page.</para>
</refdescription>
</doc:mode>


<!-- Don't use unions in matches because there's a bug in Saxon 8.1.1! -->

<xsl:template match="db:set/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h1>
    <xsl:next-match/>
  </h1>
</xsl:template>

<xsl:template match="db:book/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h1>
    <xsl:next-match/>
  </h1>
</xsl:template>

<xsl:template match="db:part/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h1>
    <xsl:next-match/>
  </h1>
</xsl:template>

<xsl:template match="db:reference/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h1>
    <xsl:next-match/>
  </h1>
</xsl:template>

<xsl:template match="db:dedication/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:preface/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>


<xsl:template match="db:chapter/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:appendix/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:colophon/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:article/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:bibliography/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:bibliodiv/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:glossary/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:glossdiv/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:section/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="depth"
		select="count(ancestor::db:section)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>
  
  <xsl:element name="h{$hlevel+2}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:next-match/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:refsection/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="depth"
		select="count(ancestor::db:refsection)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>
  
  <xsl:element name="h{$hlevel+2}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:next-match/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:figure/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:orderedlist/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:itemizedlist/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:title" mode="m:titlepage-mode">
  <xsl:apply-templates select="../.." mode="m:object-title-markup">
    <xsl:with-param name="allow-anchors" select="1"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:copyright" mode="m:titlepage-mode">
  <p class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <xsl:call-template name="gentext">
      <xsl:with-param name="key" select="'Copyright'"/>
    </xsl:call-template>
    <xsl:text>&#160;©&#160;</xsl:text>
    <span class="years">
      <xsl:call-template name="copyright-years">
	<xsl:with-param name="years" select="db:year"/>
	<xsl:with-param name="print.ranges" select="$make.year.ranges"/>
	<xsl:with-param name="single.year.ranges"
			select="$make.single.year.ranges"/>
      </xsl:call-template>
    </span>
    <xsl:text>&#160;</xsl:text>
    <span class="holders">
      <xsl:apply-templates select="db:holder" mode="m:titlepage-mode"/>
    </span>
  </p>
</xsl:template>

<xsl:template match="db:year" mode="m:titlepage-mode">
  <span class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:holder" mode="m:titlepage-mode">
  <span class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </span>
  <xsl:if test="following-sibling::db:holder">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="db:releaseinfo" mode="m:titlepage-mode">
  <p class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates mode="m:titlepage-mode"/>
  </p>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-mode">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="db:info/db:author" mode="m:titlepage-mode">
  <h3>
    <xsl:apply-templates select="."/>
  </h3>
</xsl:template>

</xsl:stylesheet>
