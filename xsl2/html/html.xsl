<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/04/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
                exclude-result-prefixes="db doc f fn h m t u xs"
                version="2.0">

<xsl:param name="html.stylesheet" select="''"/>
<xsl:param name="html.stylesheet.type" select="''"/>
<xsl:param name="link.mailto.url" select="''"/>
<xsl:param name="html.base" select="''"/>
<xsl:param name="VERSION" select="'0.0.1'"/>
<xsl:param name="generate.meta.abstract" select="0"/>
<xsl:param name="draft.mode" select="'maybe'"/>
<xsl:param name="draft.watermark.image" select="''"/>
<xsl:param name="inherit.keywords" select="0"/>

<!-- ============================================================ -->

<doc:template name="id" xmlns="http://docbook.org/ns/docbook">
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

<doc:template name="anchor" xmlns="http://docbook.org/ns/docbook">
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

<u:unittests template="anchor">
  <u:test>
    <u:param name="node" as="element()">
      <db:para xml:id="foo"/>
    </u:param>
    <u:result>
      <a name="foo" id="foo" xmlns="http://www.w3.org/1999/xhtml"/>
    </u:result>
  </u:test>
</u:unittests>

</doc:template>

<xsl:template name="anchor">
  <xsl:param name="node" select="."/>
  <xsl:param name="force" select="0"/>

  <xsl:if test="$force != 0 or ($node/@id or $node/@xml:id)">
    <a name="{f:node-id($node)}" id="{f:node-id($node)}"/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="class" xmlns="http://docbook.org/ns/docbook">
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

<doc:template name="style" xmlns="http://docbook.org/ns/docbook">
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

<doc:template name="css-style" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for inserting CSS stylesheet</refpurpose>

<refdescription>
<para>This template is used to insert the CSS stylesheet associated
with the result document. If <parameter>docbook.css.inline</parameter> is
false (0), a link is inserted to the stylesheet, otherwise, the text
of the stylesheet is inserted directly.</para>
</refdescription>
</doc:template>

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

<doc:template name="javascript" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for inserting Javascript</refpurpose>

<refdescription>
<para>T.B.D.</para>
</refdescription>
</doc:template>

<xsl:template name="javascript">
  <xsl:if test="//db:annotation">
    <script type="text/javascript" src="{$annotation.js}"/>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->

<doc:function name="f:href" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns a URI for the node</refpurpose>

<refdescription>
<para>This function returns a URI suitable for use in a hypertext link
for the specified node.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>context</term>
<listitem>
<para>The context in which the link will be used. (This is necessary
when chunking.)</para>
</listitem>
</varlistentry>
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

<u:unittests function="f:href">
  <u:test>
    <u:param select="/"/>
    <u:param>
      <para id="foo"/>
    </u:param>
    <u:result>'#foo'</u:result>
  </u:test>
  <u:test>
    <u:variable name="mydoc">
      <db:book>
	<db:title>Some Title</db:title>
	<db:chapter>
	  <db:title>Some Chapter Title</db:title>
	  <db:para>My para.</db:para>
	</db:chapter>
      </db:book>
    </u:variable>
    <u:param select="$mydoc"/>
    <u:param select="$mydoc//db:chapter[1]"/>
    <u:result>'#R.1.2'</u:result>
  </u:test>
</u:unittests>

</doc:function>

<xsl:function name="f:href" as="xs:string">
  <xsl:param name="context" as="node()"/>
  <xsl:param name="node" as="element()"/>
  <xsl:value-of select="concat('#', f:node-id($node))"/>
</xsl:function>

<!-- ====================================================================== -->

<doc:function name="f:href-target-uri" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Returns a URI for the node</refpurpose>

<refdescription>
<para>This function returns a URI suitable for use in a hypertext link
for the specified node.</para>
<note>
<para>The difference between <function>href-target-uri</function> and
<function>href</function> is only apparent when chunking is used.
</para>
</note>
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

<u:unittests function="f:href-target-uri">
  <u:test>
    <u:param>
      <para id="foo"/>
    </u:param>
    <u:result>'#foo'</u:result>
  </u:test>
  <u:test>
    <u:variable name="mydoc">
      <db:book>
	<db:title>Some Title</db:title>
	<db:chapter>
	  <db:title>Some Chapter Title</db:title>
	  <db:para>My para.</db:para>
	</db:chapter>
      </db:book>
    </u:variable>
    <u:param select="$mydoc//db:chapter[1]"/>
    <u:result>'#R.1.2'</u:result>
  </u:test>
</u:unittests>

</doc:function>

<xsl:function name="f:href-target-uri" as="xs:string">
  <xsl:param name="node" as="element()"/>
  <xsl:value-of select="concat('#', f:node-id($node))"/>
</xsl:function>

<!-- ====================================================================== -->

<doc:mode name="m:strip-anchors" xmlns="http://docbook.org/ns/docbook">
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

<xsl:template match="h:sup[@class='footnote']"
	      mode="m:strip-anchors" priority="100">
  <!-- strip it -->
</xsl:template>

<xsl:template match="text()|comment()|processing-instruction()"
	      mode="m:strip-anchors">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template name="t:user-preroot">
  <!-- Pre-root output, can be used to output comments and PIs. -->
  <!-- This must not output any element content! -->
</xsl:template>

<xsl:template name="t:system-head-content">
  <xsl:param name="node" select="."/>

  <!-- system.head.content is like user.head.content, except that
       it is called before head.content. This is important because it
       means, for example, that <style> elements output by system-head-content
       have a lower CSS precedence than the users stylesheet. -->
</xsl:template>

<xsl:template name="t:user-head-content">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="t:user-header-navigation">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="t:user-header-content">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="t:user-footer-content">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="t:user-footer-navigation">
  <xsl:param name="node" select="."/>
</xsl:template>

<xsl:template name="t:head-content">
  <xsl:param name="node" select="."/>
  <xsl:param name="title">
    <xsl:apply-templates select="$node" mode="m:object-title-markup"/>
  </xsl:param>

  <title>
    <xsl:value-of select="$title"/>
  </title>

  <xsl:if test="$html.stylesheet != ''">
    <xsl:for-each select="tokenize($html.stylesheet, '\s+')">
      <link rel="stylesheet" href="{.}">
	<xsl:if test="$html.stylesheet.type != ''">
	  <xsl:attribute name="type">
	    <xsl:value-of select="$html.stylesheet.type"/>
	  </xsl:attribute>
	</xsl:if>
      </link>
    </xsl:for-each>
  </xsl:if>

  <xsl:if test="$link.mailto.url != ''">
    <link rev="made"
          href="{$link.mailto.url}"/>
  </xsl:if>

  <xsl:if test="$html.base != ''">
    <base href="{$html.base}"/>
  </xsl:if>

  <meta name="generator" content="DocBook XSL 2.0 Stylesheets V{$VERSION}"/>

  <xsl:if test="$generate.meta.abstract != 0 and db:info/db:abstract">
    <meta name="description">
      <xsl:attribute name="content">
	<xsl:for-each select="db:info/db:abstract[1]/*">
	  <xsl:value-of select="."/>
	  <xsl:if test="position() &lt; last()">
	    <xsl:text> </xsl:text>
	  </xsl:if>
	</xsl:for-each>
      </xsl:attribute>
    </meta>
  </xsl:if>

  <xsl:if test="($draft.mode = 'yes'
		 or ($draft.mode = 'maybe' and
		     ancestor-or-self::*[@status][1]/@status = 'draft'))
		and $draft.watermark.image != ''">
    <style type="text/css"><xsl:text>
body { background-image: url('</xsl:text>
<xsl:value-of select="$draft.watermark.image"/><xsl:text>');
       background-repeat: no-repeat;
       background-position: top left;
       /* The following properties make the watermark "fixed" on the page. */
       /* I think that's just a bit too distracting for the reader... */
       /* background-attachment: fixed; */
       /* background-position: center center; */
     }</xsl:text>
    </style>
  </xsl:if>

  <xsl:apply-templates select="." mode="m:head-keywords-content"/>
</xsl:template>

<xsl:template match="*" mode="m:head-keywords-content">
  <xsl:apply-templates select="db:info/db:keywordset" mode="m:html-header"/>
  <xsl:if test="$inherit.keywords != 0 and parent::*">
    <xsl:apply-templates select="parent::*" mode="m:head-keywords-content"/>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
