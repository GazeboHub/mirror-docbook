<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2004/10/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="db doc f fn h m xs"
                version="2.0">

<!-- ============================================================ -->

<doc:template name="id" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Returns an “id” attribute if appropriate</refpurpose>

<refdescription>
<para>This template returns an attribute named “id” if the specified
node has an <tag class="attribute">id</tag>
(or <tag class="attribute">xml:id</tag>) attribute or if the
<parameter>force</parameter> parameter is non-zero.</para>
<para>A <parameter>conditional</parameter> attribute also exists,
but its use is deprecated and it may be removed in the future.</para>
<para>Until <parameter>conditional</parameter> is removed, an ID is
forced if <emphasis>either</emphasis> <parameter>force</parameter> is non-zero
<emphasis>or</emphasis> <parameter>conditional</parameter> is zero.</para>

<para>If an ID is generated, it's value is <function>f:node-id()</function>.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which an ID should be generated. It defaults to
the context item.</para>
</listitem>
</varlistentry>
<varlistentry><term>force</term>
<listitem>
<para>To force an “id” attribute to be generated, even if the node does
not have an ID, make this parameter non-zero. It defaults to 0.</para>
</listitem>
</varlistentry>
<varlistentry><term>conditional</term>
<listitem>
<para>To force an “id” attribute to be generated, even if the node does
not have an ID, make this parameter zero. It defaults to 1.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>An “id” attribute or nothing.</para>
</refreturn>
</doc:template>

<xsl:template name="id">
  <xsl:param name="node" select="."/>
  <xsl:param name="force" select="0"/>
  <xsl:param name="conditional" select="1"/> <!-- deprecated! -->

  <xsl:if test="($force != 0 or $conditional = 0) or (@id or @xml:id)">
    <xsl:attribute name="id" select="f:node-id($node)"/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="anchor" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Returns an XHTML anchor if appropriate</refpurpose>

<refdescription>
<para>This template returns an XHTML anchor
(<tag class="starttag">a</tag>) if the specified
node has an <tag class="attribute">id</tag>
(or <tag class="attribute">xml:id</tag>) attribute or if the
<parameter>force</parameter> parameter is non-zero.</para>

<para>If an anchor is generated, it's <tag class="attribute">id</tag>
value is <function>f:node-id()</function>.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which an anchor should be generated. It defaults to
the context item.</para>
</listitem>
</varlistentry>
<varlistentry><term>force</term>
<listitem>
<para>To force an anchor to be generated, even if the node does
not have an ID, make this parameter non-zero. It defaults to 0.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>An XHTML anchor or nothing.</para>
</refreturn>
</doc:template>

<xsl:template name="anchor">
  <xsl:param name="node" select="."/>
  <xsl:param name="force" select="0"/>

  <xsl:if test="$force != 0 or (@id or @xml:id)">
    <a name="{f:node-id($node)}" id="{f:node-id($node)}"/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="class" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Returns an “class” attribute if appropriate</refpurpose>

<refdescription>
<para>This template returns an attribute named “class” if the specified
node has an <tag class="attribute">role</tag> attribute or if the
<parameter>force</parameter> parameter is non-zero.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which an class attribute should be generated. It defaults to
the context item.</para>
</listitem>
</varlistentry>
<varlistentry><term>force</term>
<listitem>
<para>To force a “class” attribute to be generated, even if the node does
not have a <tag class="attribute">role</tag>,
make this parameter non-zero. It defaults to 0.</para>
</listitem>
</varlistentry>
<varlistentry><term>default-role</term>
<listitem>
<para>The default role that will be used if the attribute is forced
and the node has no <tag class="attribute">role</tag>.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>An “class” attribute or nothing.</para>
</refreturn>
</doc:template>

<xsl:template name="class">
  <xsl:param name="node" select="."/>
  <xsl:param name="force" select="0"/>
  <xsl:param name="default-role"/>

  <xsl:variable name="role"
		select="if ($node/@role) then $node/@role else $default-role"/>

  <xsl:if test="$force != 0 or $node/@role">
    <xsl:attribute name="class" select="$role"/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="style" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Returns a “style” attribute if appropriate</refpurpose>

<refdescription>
<para>This template returns an attribute named “style” if the
global parameter <parameter>inline.style.attribute</parameter> is non-zero
and a CSS style is specified.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>css</term>
<listitem>
<para>The CSS style to apply.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>A “style” attribute or nothing.</para>
</refreturn>
</doc:template>

<xsl:template name="style">
  <xsl:param name="css"/>

  <xsl:if test="$inline.style.attribute != 0 and $css">
    <xsl:attribute name="style">
      <xsl:value-of select="$css"/>
    </xsl:attribute>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->

<xsl:template name="css-style">
  <xsl:choose>
    <xsl:when test="$docbook.css.inline = 0">
      <link rel="stylesheet" type="text/css" href="{$docbook.css}"/>
    </xsl:when>
    <xsl:otherwise>
      <style type="text/css">
	<xsl:copy-of select="unparsed-text($docbook.css, 'us-ascii')"/>
      </style>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ====================================================================== -->

<doc:function name="f:href" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Returns a URI for the node</refpurpose>

<refdescription>
<para>This function returns a URI suitable for use in a hypertext link
for the specified node.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which a URI will be generated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The hypertext anchor URI for the node.</para>
</refreturn>
</doc:function>

<xsl:function name="f:href" as="xs:string">
  <xsl:param name="node" as="element()"/>
  <xsl:value-of select="concat('#', f:node-id($node))"/>
</xsl:function>

<!-- ====================================================================== -->

<doc:mode name="m:strip-anchors" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for stripping anchors from XHTML</refpurpose>

<refdescription>
<para>This mode performs an identity transform except that all XHTML
anchors (<tag>a</tag>) elements are removed. The content of each anchor
is preserved, only the wrapping <tag>a</tag> is stripped away.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:strip-anchors">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="m:strip-anchors"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="h:a" mode="m:strip-anchors" priority="100">
  <xsl:apply-templates mode="m:strip-anchors"/>
</xsl:template>

<xsl:template match="text()|comment()|processing-instruction()"
	      mode="m:strip-anchors">
  <xsl:copy/>
</xsl:template>

</xsl:stylesheet>
