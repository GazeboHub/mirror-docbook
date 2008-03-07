<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xlink='http://www.w3.org/1999/xlink'
                exclude-result-prefixes="db doc f fn m u xlink"
                version="2.0">

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sourceforge.net/ for copyright
     and other information.

     ******************************************************************** -->

<!-- ============================================================ -->

<doc:template name="t:simple-xlink" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handle xlink:href attributes on inlines</refpurpose>

<refdescription>
<para>This template generates XHTML anchors for inline elements that
have xlink:href attributes.</para>

<note>
<para>Nested anchors can occur this way and this code does not, at
present, “unwrap” them as it should.</para>
</note>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which markup is being generated; the one that might
have the xlink:href attribute.</para>
</listitem>
</varlistentry>
<varlistentry><term>content</term>
<listitem>
<para>The content of the link. This defaults to the result of
calling “apply templates” with <parameter>node</parameter> as the
context item.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the node.</para>
</refreturn>
</doc:template>

<xsl:template name="t:simple-xlink">
  <xsl:param name="node" select="."/>
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:variable name="link">
    <xsl:choose>
      <xsl:when test="$node/@xlink:href
		      and (not($node/@xlink:type)
		           or $node/@xlink:type='simple')">
	<a>
	  <xsl:if test="$node/@xlink.title">
	    <xsl:attribute name="title" select="$node/@xlink:title"/>
	  </xsl:if>

	  <xsl:attribute name="href">
	    <xsl:choose>
	      <!-- if the href starts with # and does not contain an "(" -->
              <!-- or if the href starts with #xpointer(id(, it's just an ID -->
              <xsl:when test="starts-with($node/@xlink:href,'#')
                              and (not(contains($node/@xlink:href,'&#40;'))
                              or starts-with($node/@xlink:href,
			                     '#xpointer&#40;id&#40;'))">
                <xsl:variable name="idref">
                  <xsl:call-template name="xpointer-idref">
                    <xsl:with-param name="xpointer" select="$node/@xlink:href"/>
                  </xsl:call-template>
                </xsl:variable>

                <xsl:variable name="target" select="key('id',$idref)[1]"/>

                <xsl:choose>
                  <xsl:when test="not($target)">
		    <xsl:message>
		      <xsl:text>XLink to nonexistent id: </xsl:text>
		      <xsl:value-of select="$idref"/>
		    </xsl:message>
                    <xsl:text>???</xsl:text>
                  </xsl:when>
		  <xsl:otherwise>
		    <xsl:attribute name="href" select="f:href(/,$target)"/>
		  </xsl:otherwise>
		</xsl:choose>
              </xsl:when>

              <!-- otherwise it's a URI -->
              <xsl:otherwise>
		<xsl:value-of select="$node/@xlink:href"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
          <xsl:copy-of select="$content"/>
        </a>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="$content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:copy-of select="$link"/>

  <xsl:variable name="inline" select="."/>
  <xsl:variable name="id" select="@xml:id"/>

  <xsl:variable name="annotations" as="element()*">
    <xsl:sequence select="if (@annotations)
                          then key('id',tokenize(@annotations,'\s'))
			  else ()"/>
    <xsl:sequence select="if ($id)
			  then //db:annotation[tokenize(@annotates,'\s')=$id]
			  else ()"/>
  </xsl:variable>

  <xsl:for-each select="$annotations">
    <xsl:variable name="id"
		    select="concat(f:node-id(.),'-',generate-id($inline))"/>
    <a style="display: inline" onclick="show_annotation('{$id}')"
	  id="annot-{$id}-on">
      <img border="0" src="{$annotation.graphic.open}" alt="[A+]"/>
    </a>
    <a style="display: none" onclick="hide_annotation('{$id}')"
	  id="annot-{$id}-off">
      <img border="0" src="{$annotation.graphic.close}" alt="[A-]"/>
    </a>
    <div style="display: none" id="annot-{$id}">
      <xsl:apply-templates select="." mode="m:annotation"/>
    </div>
  </xsl:for-each>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-charseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles simple inline elements</refpurpose>

<refdescription>
<para>This template generates simple inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>span</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>
<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the span.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>

<u:unittests template="t:inline-charseq">
  <u:test>
    <u:context as="element()">
      <db:varname xml:id="varfoo">someVarName</db:varname>
    </u:context>
    <u:result>
      <span xmlns="http://www.w3.org/1999/xhtml"
	    class="varname" id="varfoo">someVarName</span>
    </u:result>
  </u:test>
</u:unittests>

</doc:template>

<xsl:template name="t:inline-charseq">
  <xsl:param name="content">
    <xsl:call-template name="t:simple-xlink"/>
  </xsl:param>

  <span class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:if test="db:alt">
      <xsl:attribute name="title">
	<xsl:value-of select="db:alt"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@dir">
      <xsl:attribute name="dir">
	<xsl:value-of select="@dir"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:copy-of select="$content"/>
  </span>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-monoseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles monospace inline elements</refpurpose>

<refdescription>
<para>This template generates monospace inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>tt</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>
<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the <tag>tt</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-monoseq">
  <xsl:param name="content">
    <xsl:call-template name="t:simple-xlink"/>
  </xsl:param>

  <tt class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:if test="db:alt">
      <xsl:attribute name="title">
	<xsl:value-of select="db:alt"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@dir">
      <xsl:attribute name="dir">
	<xsl:value-of select="@dir"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:copy-of select="$content"/>
  </tt>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-boldseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles bold inline elements</refpurpose>

<refdescription>
<para>This template generates bold inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>strong</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>
<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the <tag>strong</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-boldseq">
  <xsl:param name="content">
    <xsl:call-template name="t:simple-xlink"/>
  </xsl:param>

  <strong class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:if test="db:alt">
      <xsl:attribute name="title">
	<xsl:value-of select="db:alt"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@dir">
      <xsl:attribute name="dir">
	<xsl:value-of select="@dir"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:copy-of select="$content"/>
  </strong>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-italicseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles italic inline elements</refpurpose>

<refdescription>
<para>This template generates italic inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>em</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>
<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the <tag>em</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-italicseq">
  <xsl:param name="content">
    <xsl:call-template name="t:simple-xlink"/>
  </xsl:param>

  <em class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:if test="db:alt">
      <xsl:attribute name="title">
	<xsl:value-of select="db:alt"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@dir">
      <xsl:attribute name="dir">
	<xsl:value-of select="@dir"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:copy-of select="$content"/>
  </em>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-boldmonoseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles bold, monospace inline elements</refpurpose>

<refdescription>
<para>This template generates bold, monospace inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>strong</tag> with a
<tag class="attribute">class</tag> attribute and possibly an
<tag class="attribute">id</tag>.</para>

<para>If the element has an
<tag>alt</tag> element among its children, the string-value of
that element will be used as the <tag
class="attribute">title</tag> of the <tag>strong</tag>.</para>

<para>Inside the <tag>strong</tag>, it generates a <tag>tt</tag> with
a <tag class="attribute">dir</tag> attribute, if
appropriate.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-boldmonoseq">
  <xsl:param name="content">
    <xsl:call-template name="t:simple-xlink"/>
  </xsl:param>

  <strong class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:if test="db:alt">
      <xsl:attribute name="title">
	<xsl:value-of select="db:alt"/>
      </xsl:attribute>
    </xsl:if>
    <tt class="{local-name(.)}">
      <xsl:if test="@dir">
	<xsl:attribute name="dir">
	  <xsl:value-of select="@dir"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$content"/>
    </tt>
  </strong>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-italicmonoseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles italic, monospace inline elements</refpurpose>

<refdescription>
<para>This template generates italic, monospace inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>em</tag> with a
<tag class="attribute">class</tag> attribute and possibly an
<tag class="attribute">id</tag>.</para>

<para>If the element has an
<tag>alt</tag> element among its children, the string-value of
that element will be used as the <tag
class="attribute">title</tag> of the <tag>em</tag>.</para>

<para>Inside the <tag>em</tag>, it generates a <tag>tt</tag> with
a <tag class="attribute">dir</tag> attribute, if
appropriate.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-italicmonoseq">
  <xsl:param name="content">
    <xsl:call-template name="t:simple-xlink"/>
  </xsl:param>

  <em class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:if test="db:alt">
      <xsl:attribute name="title">
	<xsl:value-of select="db:alt"/>
      </xsl:attribute>
    </xsl:if>
    <tt class="{local-name(.)}">
      <xsl:if test="@dir">
	<xsl:attribute name="dir">
	  <xsl:value-of select="@dir"/>
	</xsl:attribute>
      </xsl:if>
      <xsl:copy-of select="$content"/>
    </tt>
  </em>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-superscriptseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles superscript inline elements</refpurpose>

<refdescription>
<para>This template generates superscript inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>sup</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>

<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the <tag>sup</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-superscriptseq">
  <xsl:param name="content">
    <xsl:call-template name="t:simple-xlink"/>
  </xsl:param>

  <sup>
    <xsl:call-template name="id"/>
    <xsl:if test="db:alt">
      <xsl:attribute name="title">
	<xsl:value-of select="db:alt"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@dir">
      <xsl:attribute name="dir">
        <xsl:value-of select="@dir"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:copy-of select="$content"/>
  </sup>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="t:inline-subscriptseq" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles subscript inline elements</refpurpose>

<refdescription>
<para>This template generates subscript inline markup for the context
node, assumed to be an element.</para>
<para>Specifically, it generates a <tag>sub</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> or
<tag class="attribute">dir</tag> attributes.</para>

<para>If the element has an <tag>alt</tag> element among its
children, the string-value of that element will be used as the
<tag class="attribute">title</tag> of the <tag>sub</tag>.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>content</term>
<listitem>
<para>The content of the element. This defaults to the result of
calling “apply templates” with the current context node.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="t:inline-subscriptseq">
  <xsl:param name="content">
    <xsl:call-template name="t:simple-xlink"/>
  </xsl:param>

  <sub>
    <xsl:call-template name="id"/>
    <xsl:if test="db:alt">
      <xsl:attribute name="title">
	<xsl:value-of select="db:alt"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@dir">
      <xsl:attribute name="dir">
        <xsl:value-of select="@dir"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:copy-of select="$content"/>
  </sub>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="format-tag" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Handles markup for the DocBook <tag>tag</tag> element</refpurpose>

<refdescription>
<para>This template generates markup for the context
node, assumed to be a <tag>tag</tag> element.</para>

<para>Specifically, it generates a <tag>tt</tag> with a
<tag class="attribute">class</tag> attribute. It also handles any
necessary <tag class="attribute">id</tag> attribute.</para>

<para>Depending on the value of the <tag class="attribute">class</tag>
attribute, additional generated text may be output as well.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>class</term>
<listitem>
<para>The class attribute associated with the context element. If
the context element has no <tag class="attribute">class</tag> attribute,
the default is “element”.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The result tree markup for the element.</para>
</refreturn>
</doc:template>

<xsl:template name="format-tag">
  <xsl:param name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>element</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <tt class="tag-{$class}">
    <xsl:call-template name="id"/>
    <xsl:choose>
      <xsl:when test="$class='attribute'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='attvalue'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='element'">
        <xsl:apply-templates/>
      </xsl:when>
      <xsl:when test="$class='endtag'">
        <xsl:text>&lt;/</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='genentity'">
        <xsl:text>&amp;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='numcharref'">
        <xsl:text>&amp;#</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='paramentity'">
        <xsl:text>%</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='pi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='xmlpi'">
        <xsl:text>&lt;?</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>?&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='starttag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='emptytag'">
        <xsl:text>&lt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>/&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$class='sgmlcomment'">
        <xsl:text>&lt;!--</xsl:text>
        <xsl:apply-templates/>
        <xsl:text>--&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </tt>
</xsl:template>

<u:unittests match="db:emphasis">
  <u:test>
    <u:context as="element()">
      <db:emphasis>Something emphasized</db:emphasis>
    </u:context>
    <u:result>
      <em xmlns="http://www.w3.org/1999/xhtml">Something emphasized</em>
    </u:result>
  </u:test>
  <u:test>
    <u:context as="element()">
      <db:emphasis role='strong'>Something strongly emphasized</db:emphasis>
    </u:context>
    <u:result>
      <strong xmlns="http://www.w3.org/1999/xhtml"
	      class="emphasis">Something strongly emphasized</strong>
    </u:result>
  </u:test>
</u:unittests>

<xsl:template match="db:emphasis">
  <xsl:call-template name="t:simple-xlink">
    <xsl:with-param name="content">
      <xsl:choose>
	<xsl:when test="@role='bold' or @role='strong'">
	  <strong class="{local-name(.)}">
	    <xsl:call-template name="id"/>
	    <xsl:apply-templates/>
	  </strong>
	</xsl:when>
	<xsl:otherwise>
	  <em>
	    <xsl:call-template name="id"/>
	    <xsl:if test="@role">
	      <xsl:attribute name="class">
		<xsl:value-of select="@role"/>
	      </xsl:attribute>
	    </xsl:if>
	    <xsl:apply-templates/>
	  </em>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->
<!-- HACK HACK HACK for testing framework. Delete me! -->
<!--
<u:unittests match="db:emphasis" mode="foobar">
  <u:test>
    <u:context as="element()">
      <db:emphasis>Something emphasized</db:emphasis>
    </u:context>
    <u:result>
      <b xmlns="http://www.w3.org/1999/xhtml">Something emphasized</b>
    </u:result>
  </u:test>
</u:unittests>

<xsl:template match="db:emphasis" mode="foobar">
  <b><xsl:apply-templates/></b>
</xsl:template>
-->
<!-- ============================================================ -->

<xsl:template match="db:foreignphrase">
  <xsl:call-template name="t:inline-italicseq"/>
</xsl:template>

<xsl:template match="db:phrase">
  <span>
    <xsl:call-template name="id"/>
    <xsl:if test="@lang or @xml:lang">
      <xsl:call-template name="lang-attribute"/>
    </xsl:if>
    <xsl:if test="@role">
      <xsl:attribute name="class">
	<xsl:value-of select="@role"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:call-template name="t:simple-xlink"/>
  </span>
</xsl:template>

<xsl:template match="db:lineannotation">
  <em class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="t:inline-charseq"/>
  </em>
</xsl:template>

<xsl:template match="db:trademark">
  <xsl:call-template name="t:inline-charseq">
    <xsl:with-param name="content">
      <xsl:apply-templates/>
      <xsl:choose>
	<xsl:when test="@class = 'copyright'">&#x00A9;</xsl:when>
	<xsl:when test="@class = 'registered'">&#x00AE;</xsl:when>
	<xsl:when test="@class = 'service'">
	  <sup>SM</sup>
	</xsl:when>
	<xsl:otherwise>&#x2122;</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="db:glossterm" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Template for processing glossterm elements</refpurpose>

<refdescription>
<para>The glossterm template is used to process <tag>glossterm</tag>
and <tag>firstterm</tag> elements.</para>
</refdescription>
</doc:template>

<xsl:template match="db:firstterm">
  <xsl:call-template name="db:glossterm">
    <xsl:with-param name="firstterm" select="1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:glossterm" name="db:glossterm">
  <xsl:param name="firstterm" select="0"/>

  <em class="{if ($firstterm != 0) then 'firstterm' else 'glossterm'}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:if test="db:alt">
      <xsl:attribute name="title">
	<xsl:value-of select="db:alt"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:if test="@dir">
      <xsl:attribute name="dir">
	<xsl:value-of select="@dir"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="($firstterm.only.link = 0 or $firstterm = 1) and @linkend">
	<xsl:variable name="target" select="key('id',@linkend)[1]"/>

	<a href="{f:href(/,$target)}">
	  <xsl:apply-templates/>
	</a>
      </xsl:when>

      <xsl:when test="not(@linkend)
		      and ($firstterm.only.link = 0 or $firstterm = 1)
		      and $glossterm.auto.link != 0">
	<xsl:variable name="term">
	  <xsl:choose>
	    <xsl:when test="@baseform">
	      <xsl:value-of select="normalize-space(@baseform)"/>
	    </xsl:when>
	    <xsl:otherwise>
	      <xsl:value-of select="normalize-space(.)"/>
	    </xsl:otherwise>
	  </xsl:choose>
	</xsl:variable>

	<xsl:variable name="targets"
		      select="//db:glossentry
			        [normalize-space(db:glossterm) = $term
			         or normalize-space(db:glossterm/@baseform)
				    = $term]"/>

	<xsl:variable name="target" select="$targets[1]"/>

	<xsl:choose>
	  <xsl:when test="count($targets)=0">
	    <xsl:message>
	      <xsl:text>Error: no glossentry for glossterm: </xsl:text>
	      <xsl:value-of select="."/>
	      <xsl:text>.</xsl:text>
	    </xsl:message>
	    <xsl:apply-templates/>
	  </xsl:when>
	  <xsl:otherwise>
	    <a href="{f:href(/,$target)}">
	      <xsl:apply-templates/>
	    </a>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>

      <xsl:otherwise>
	<xsl:apply-templates/>
      </xsl:otherwise>
    </xsl:choose>
  </em>
</xsl:template>

<xsl:template match="db:termdef">
  <span class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:text>[Definition: </xsl:text>
    <xsl:apply-templates/>
    <xsl:text>]</xsl:text>
  </span>
</xsl:template>

<xsl:template match="db:email">
  <xsl:call-template name="t:inline-monoseq">
    <xsl:with-param name="content">
      <xsl:text>&lt;</xsl:text>
      <a>
	<xsl:attribute name="href">
	  <xsl:text>mailto:</xsl:text>
	  <xsl:value-of select="."/>
	</xsl:attribute>
	<xsl:apply-templates/>
      </a>
      <xsl:text>&gt;</xsl:text>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="db:optional">
  <xsl:call-template name="t:inline-charseq"/>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>


