<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="db doc f fn m xs"
                version="2.0">

<!-- ============================================================ -->

<doc:template name="person-name" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Formats a personal name</refpurpose>

<refdescription>
<para>This template formats a personal name. It supports several styles
that may be specified with a <tag class="attribute">role</tag> attribute
on the element (<tag>personname</tag>, <tag>author</tag>, <tag>editor</tag>,
and <tag>othercredit</tag>) or with the locale.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node containing the personal name.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted personal name.</para>
</refreturn>
</doc:template>

<xsl:template name="person-name">
  <!-- Formats a personal name. Handles corpauthor as a special case. -->
  <xsl:param name="node" select="."/>

  <xsl:variable name="style">
    <xsl:choose>
      <xsl:when test="$node/@role">
        <xsl:value-of select="$node/@role"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="gentext-template">
          <xsl:with-param name="context" select="'styles'"/>
          <xsl:with-param name="name" select="'person-name'"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <!-- the personname element is a specialcase -->
    <xsl:when test="$node/self::db:personname">
      <xsl:call-template name="person-name">
        <xsl:with-param name="node" select="$node/db:personname"/>
      </xsl:call-template>
    </xsl:when>

    <!-- handle corpauthor as a special case...-->
    <xsl:when test="$node/self::db:corpauthor">
      <xsl:apply-templates select="$node"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$style = 'family-given'">
          <xsl:call-template name="person-name-family-given">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$style = 'last-first'">
          <xsl:call-template name="person-name-last-first">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="person-name-first-last">
            <xsl:with-param name="node" select="$node"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="person-name-family-given"
	      xmlns="http://docbook.org/docbook-ng">
<refpurpose>Formats a personal name in the “family given” style</refpurpose>

<refdescription>
<para>This template formats a personal name in the “family given” style.
It is generally called by <function role="template">person-name</function>
template.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node containing the personal name.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted personal name.</para>
</refreturn>
</doc:template>

<xsl:template name="person-name-family-given">
  <xsl:param name="node" select="."/>

  <!-- The family-given style applies a convention for identifying given -->
  <!-- and family names in locales where it may be ambiguous -->
  <xsl:apply-templates select="$node//db:surname[1]"/>

  <xsl:if test="$node//db:surname and $node//db:firstname">
    <xsl:text> </xsl:text>
  </xsl:if>

  <xsl:apply-templates select="$node//db:firstname[1]"/>

  <xsl:text> [FAMILY Given]</xsl:text>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="person-name-last-first"
	      xmlns="http://docbook.org/docbook-ng">
<refpurpose>Formats a personal name in the “last, first” style</refpurpose>

<refdescription>
<para>This template formats a personal name in the “last, first” style.
It is generally called by <function role="template">person-name</function>
template.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node containing the personal name.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted personal name.</para>
</refreturn>
</doc:template>

<xsl:template name="person-name-last-first">
  <xsl:param name="node" select="."/>

  <xsl:apply-templates select="$node//db:surname[1]"/>

  <xsl:if test="$node//db:surname and $node//db:firstname">
    <xsl:text>, </xsl:text>
  </xsl:if>

  <xsl:apply-templates select="$node//db:firstname[1]"/>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="person-name-first-last"
	      xmlns="http://docbook.org/docbook-ng">
<refpurpose>Formats a personal name in the “first last” style</refpurpose>

<refdescription>
<para>This template formats a personal name in the “first last” style.
It is generally called by <function role="template">person-name</function>
template.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node containing the personal name.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted personal name.</para>
</refreturn>
</doc:template>

<xsl:template name="person-name-first-last">
  <xsl:param name="node" select="."/>

  <xsl:if test="$node//db:honorific">
    <xsl:apply-templates select="$node//db:honorific[1]"/>
    <xsl:value-of select="$punct.honorific"/>
  </xsl:if>

  <xsl:if test="$node//db:firstname">
    <xsl:if test="$node//db:honorific">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$node//db:firstname[1]"/>
  </xsl:if>

  <xsl:if test="$node//db:othername and $author.othername.in.middle != 0">
    <xsl:if test="$node//db:honorific or $node//db:firstname">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$node//db:othername[1]"/>
  </xsl:if>

  <xsl:if test="$node//db:surname">
    <xsl:if test="$node//db:honorific or $node//db:firstname
                  or ($node//db:othername and $author.othername.in.middle != 0)">
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="$node//db:surname[1]"/>
  </xsl:if>

  <xsl:if test="$node//db:lineage">
    <xsl:text>, </xsl:text>
    <xsl:apply-templates select="$node//db:lineage[1]"/>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="person-name-list"
	      xmlns="http://docbook.org/docbook-ng">
<refpurpose>Formats a list of personal names</refpurpose>

<refdescription>
<para>This template formats a list of personal names, for example in
an <tag>authorgroup</tag>.</para>
<para>The list of names is assumed to be in the current context node.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node containing the personal name.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The formatted personal name.</para>
</refreturn>
</doc:template>

<xsl:template name="person-name-list">
  <!-- Return a formatted string representation of the contents of
       the current element. The current element must contain one or
       more AUTHORs, CORPAUTHORs, OTHERCREDITs, and/or EDITORs.

       John Doe
     or
       John Doe and Jane Doe
     or
       John Doe, Jane Doe, and A. Nonymous
  -->
  <xsl:param name="person.list"
             select="db:author|db:corpauthor|db:othercredit|db:editor"/>
  <xsl:param name="person.count" select="count($person.list)"/>
  <xsl:param name="count" select="1"/>

  <xsl:choose>
    <xsl:when test="$count &gt; $person.count"></xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="person-name">
        <xsl:with-param name="node" select="$person.list[position()=$count]"/>
      </xsl:call-template>

      <xsl:choose>
        <xsl:when test="$person.count = 2 and $count = 1">
          <xsl:call-template name="gentext-template">
            <xsl:with-param name="context" select="'authorgroup'"/>
            <xsl:with-param name="name" select="'sep2'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$person.count &gt; 2 and $count+1 = $person.count">
          <xsl:call-template name="gentext-template">
            <xsl:with-param name="context" select="'authorgroup'"/>
            <xsl:with-param name="name" select="'seplast'"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:when test="$count &lt; $person.count">
          <xsl:call-template name="gentext-template">
            <xsl:with-param name="context" select="'authorgroup'"/>
            <xsl:with-param name="name" select="'sep'"/>
          </xsl:call-template>
        </xsl:when>
      </xsl:choose>

      <xsl:call-template name="person-name-list">
        <xsl:with-param name="person.list" select="$person.list"/>
        <xsl:with-param name="person.count" select="$person.count"/>
        <xsl:with-param name="count" select="$count+1"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="xpointer-idref"
	      xmlns="http://docbook.org/docbook-ng">
<refpurpose>Returns the ID portion of an XPointer</refpurpose>

<refdescription>
<para>The <function role="template">xpointer-idref</function> template
returns the
ID portion of an XPointer which is a pointer to an ID within the current
document, or the empty string if it is not.</para>

<para>In other words, <function>xpointer-idref</function> returns
<quote>foo</quote> when passed either <literal>#foo</literal>
or <literal>#xpointer(id('foo'))</literal>, otherwise it returns
the empty string.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>xpointer</term>
<listitem>
<para>The string containing the XPointer.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>The ID portion of the XPointer or an empty string.</para>
</refreturn>
</doc:template>

<xsl:template name="xpointer-idref">
  <xsl:param name="xpointer">http://...</xsl:param>
  <xsl:choose>
    <xsl:when test="starts-with($xpointer, '#xpointer(id(')">
      <xsl:variable name="rest"
		    select="substring-after($xpointer, '#xpointer(id(')"/>
      <xsl:variable name="quote" select="substring($rest, 1, 1)"/>
      <xsl:value-of select="substring-before(substring-after($xpointer, $quote),
			                     $quote)"/>
    </xsl:when>
    <xsl:when test="starts-with($xpointer, '#')">
      <xsl:value-of select="substring-after($xpointer, '#')"/>
    </xsl:when>
    <!-- otherwise it's a pointer to some other document -->
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:number" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for inserting element labels (numbers)</refpurpose>

<refdescription>
<para>This mode is used to insert numbers for numbered elements.
Any element processed in this mode should generate its number.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:qandadiv" mode="m:number">
  <xsl:number level="multiple" from="db:qandaset" format="1."/>
</xsl:template>

<xsl:template match="db:qandaentry" mode="m:number">
  <xsl:choose>
    <xsl:when test="ancestor::db:qandadiv">
      <xsl:number level="single" from="db:qandadiv" format="1."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:number level="single" from="db:qandaset" format="1."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:step" mode="m:number">
  <xsl:param name="rest" select="''"/>
  <xsl:param name="recursive" select="1"/>
  <xsl:variable name="format" select="f:procedure-step-numeration(.)"/>

  <xsl:variable name="num">
    <xsl:choose>
      <xsl:when test="$format = 'arabic'">
	<xsl:number count="db:step" format="1"/>
      </xsl:when>
      <xsl:when test="$format = 'loweralpha'">
	<xsl:number count="db:step" format="a"/>
      </xsl:when>
      <xsl:when test="$format = 'lowerroman'">
	<xsl:number count="db:step" format="i"/>
      </xsl:when>
      <xsl:when test="$format = 'upperalpha'">
	<xsl:number count="db:step" format="A"/>
      </xsl:when>
      <xsl:when test="$format = 'upperroman'">
	<xsl:number count="db:step" format="I"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:number count="db:step" format="i"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$recursive != 0 and ancestor::db:step">
      <xsl:apply-templates select="ancestor::db:step[1]" mode="m:number">
	<xsl:with-param name="rest" select="concat('.', $num, $rest)"/>
      </xsl:apply-templates>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat($num, $rest)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="copyright-years" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Print a set of years with collapsed ranges</refpurpose>

<refdescription>
<para>This template prints a list of year elements with consecutive
years printed as a range. In other words:</para>

<screen><![CDATA[<year>1992</year>
<year>1993</year>
<year>1994</year>]]></screen>

<para>is printed <quote>1992-1994</quote>, whereas:</para>

<screen><![CDATA[<year>1992</year>
<year>1994</year>]]></screen>

<para>is printed <quote>1992, 1994</quote>.</para>

<para>This template assumes that all the year elements contain only
decimal year numbers, that the elements are sorted in increasing
numerical order, that there are no duplicates, and that all the years
are expressed in full <quote>century+year</quote>
(<quote>1999</quote> not <quote>99</quote>) notation.</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>years</term>
<listitem>
<para>The initial set of year elements.</para>
</listitem>
</varlistentry>
<varlistentry><term>print.ranges</term>
<listitem>
<para>If non-zero, multi-year ranges are collapsed. If zero, all years
are printed discretely.</para>
</listitem>
</varlistentry>
<varlistentry><term>single.year.ranges</term>
<listitem>
<para>If non-zero, two consecutive years will be printed as a range,
otherwise, they will be printed discretely. In other words, a single
year range is <quote>1991-1992</quote> but discretely it's
<quote>1991, 1992</quote>.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>This template returns the formatted list of years.</para>
</refreturn>
</doc:template>

<xsl:template name="copyright-years">
  <xsl:param name="years"/>
  <xsl:param name="print.ranges" select="1"/>
  <xsl:param name="single.year.ranges" select="0"/>
  <xsl:param name="firstyear" select="0"/>
  <xsl:param name="nextyear" select="0"/>

  <!--
  <xsl:message terminate="no">
    <xsl:text>CY: </xsl:text>
    <xsl:value-of select="count($years)"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$firstyear"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$nextyear"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$print.ranges"/>
    <xsl:text>, </xsl:text>
    <xsl:value-of select="$single.year.ranges"/>
    <xsl:text> (</xsl:text>
    <xsl:value-of select="$years[1]"/>
    <xsl:text>)</xsl:text>
  </xsl:message>
  -->

  <xsl:choose>
    <xsl:when test="$print.ranges = 0 and count($years) &gt; 0">
      <xsl:choose>
        <xsl:when test="count($years) = 1">
          <xsl:apply-templates select="$years[1]" mode="titlepage.mode"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="$years[1]" mode="titlepage.mode"/>
          <xsl:text>, </xsl:text>
          <xsl:call-template name="copyright-years">
            <xsl:with-param name="years"
                            select="$years[position() &gt; 1]"/>
            <xsl:with-param name="print.ranges" select="$print.ranges"/>
            <xsl:with-param name="single.year.ranges"
                            select="$single.year.ranges"/>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="count($years) = 0">
      <xsl:variable name="lastyear" select="$nextyear - 1"/>
      <xsl:choose>
        <xsl:when test="$firstyear = 0">
          <!-- there weren't any years at all -->
        </xsl:when>
        <xsl:when test="$firstyear = $lastyear">
          <xsl:value-of select="$firstyear"/>
        </xsl:when>
        <xsl:when test="$single.year.ranges = 0
                        and $lastyear = $firstyear + 1">
          <xsl:value-of select="$firstyear"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$lastyear"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$firstyear"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="$lastyear"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$firstyear = 0">
      <xsl:call-template name="copyright-years">
        <xsl:with-param name="years"
                        select="$years[position() &gt; 1]"/>
        <xsl:with-param name="firstyear" select="$years[1]"/>
        <xsl:with-param name="nextyear" select="$years[1] + 1"/>
        <xsl:with-param name="print.ranges" select="$print.ranges"/>
        <xsl:with-param name="single.year.ranges"
                        select="$single.year.ranges"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$nextyear = $years[1]">
      <xsl:call-template name="copyright-years">
        <xsl:with-param name="years"
                        select="$years[position() &gt; 1]"/>
        <xsl:with-param name="firstyear" select="$firstyear"/>
        <xsl:with-param name="nextyear" select="$nextyear + 1"/>
        <xsl:with-param name="print.ranges" select="$print.ranges"/>
        <xsl:with-param name="single.year.ranges"
                        select="$single.year.ranges"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <!-- we have years left, but they aren't in the current range -->
      <xsl:choose>
        <xsl:when test="$nextyear = $firstyear + 1">
          <xsl:value-of select="$firstyear"/>
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:when test="$single.year.ranges = 0
                        and $nextyear = $firstyear + 2">
          <xsl:value-of select="$firstyear"/>
          <xsl:text>, </xsl:text>
          <xsl:value-of select="$nextyear - 1"/>
          <xsl:text>, </xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$firstyear"/>
          <xsl:text>-</xsl:text>
          <xsl:value-of select="$nextyear - 1"/>
          <xsl:text>, </xsl:text>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:call-template name="copyright-years">
        <xsl:with-param name="years"
                        select="$years[position() &gt; 1]"/>
        <xsl:with-param name="firstyear" select="$years[1]"/>
        <xsl:with-param name="nextyear" select="$years[1] + 1"/>
        <xsl:with-param name="print.ranges" select="$print.ranges"/>
        <xsl:with-param name="single.year.ranges"
                        select="$single.year.ranges"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
