<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
		exclude-result-prefixes="f m fn db"
                version="2.0">

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://nwalsh.com/docbook/xsl/ for copyright
     and other information.

     ******************************************************************** -->

<xsl:template name="simple.xlink">
  <xsl:param name="content">
    <xsl:apply-templates/>
  </xsl:param>

  <xsl:copy-of select="$content"/>
</xsl:template>

<xsl:template name="inline.charseq">
  <xsl:param name="content">
    <xsl:call-template name="simple.xlink"/>
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

<xsl:template name="inline.monoseq">
  <xsl:param name="content">
    <xsl:call-template name="simple.xlink"/>
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

<xsl:template name="inline.boldseq">
  <xsl:param name="content">
    <xsl:call-template name="simple.xlink"/>
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

<xsl:template name="inline.italicseq">
  <xsl:param name="content">
    <xsl:call-template name="simple.xlink"/>
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

<xsl:template name="inline.boldmonoseq">
  <xsl:param name="content">
    <xsl:call-template name="simple.xlink"/>
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

<xsl:template name="inline.italicmonoseq">
  <xsl:param name="content">
    <xsl:call-template name="simple.xlink"/>
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

<xsl:template name="inline.superscriptseq">
  <xsl:param name="content">
    <xsl:call-template name="simple.xlink"/>
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

<xsl:template name="inline.subscriptseq">
  <xsl:param name="content">
    <xsl:call-template name="simple.xlink"/>
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

<xsl:template name="format.sgmltag">
  <xsl:param name="class">
    <xsl:choose>
      <xsl:when test="@class">
        <xsl:value-of select="@class"/>
      </xsl:when>
      <xsl:otherwise>element</xsl:otherwise>
    </xsl:choose>
  </xsl:param>

  <tt class="sgmltag-{$class}">
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

<xsl:template match="db:emphasis">
  <xsl:call-template name="simple.xlink">
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

<xsl:template match="db:foreignphrase">
  <em class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:if test="@lang or @xml:lang">
      <xsl:call-template name="language.attribute"/>
    </xsl:if>
    <xsl:call-template name="inline.italicseq"/>
  </em>
</xsl:template>

<xsl:template match="db:phrase">
  <span>
    <xsl:call-template name="id"/>
    <xsl:if test="@lang or @xml:lang">
      <xsl:call-template name="language.attribute"/>
    </xsl:if>
    <xsl:if test="@role">
      <xsl:attribute name="class">
	<xsl:value-of select="@role"/>
      </xsl:attribute>
    </xsl:if>

    <xsl:call-template name="simple.xlink"/>
  </span>
</xsl:template>

<xsl:template match="db:lineannotation">
  <em class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="inline.charseq"/>
  </em>
</xsl:template>

<xsl:template match="db:trademark">
  <xsl:call-template name="inline.charseq">
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

<xsl:template match="db:firstterm">
  <xsl:call-template name="glossterm">
    <xsl:with-param name="firstterm" select="1"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="glossterm" name="glossterm">
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

	<a href="{f:href($target)}">
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
	    <a href="{f:href($target)}">
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

<xsl:template match="db:email">
  <xsl:call-template name="inline.monoseq">
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
  <xsl:call-template name="inline.charseq"/>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>


