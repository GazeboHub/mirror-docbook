<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2004/10/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:xlink='http://www.w3.org/1999/xlink'
		exclude-result-prefixes="db doc f fn h m xlink"
                version="2.0">

<!-- ============================================================ -->

<xsl:template match="db:link">
  <a href="{@xlink:href}">
    <xsl:call-template name="class"/>
    <xsl:if test="db:alt">
      <xsl:attribute name="title" select="db:alt[1]"/>
    </xsl:if>
    <xsl:apply-templates/>
  </a>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:insert-title-markup" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for inserting title markup</refpurpose>

<refdescription>
<para>This mode is used to insert title markup. Any element processed
in this mode should generate its title.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-title-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="title"/>

  <xsl:choose>
    <xsl:when test="$purpose = 'xref' and db:info/db:titleabbrev">
      <xsl:apply-templates select="." mode="m:titleabbrev-markup"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:chapter|db:appendix" mode="m:insert-title-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="title"/>

  <xsl:choose>
    <xsl:when test="$purpose = 'xref'">
      <i>
        <xsl:copy-of select="$title"/>
      </i>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$title"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-subtitle-markup" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for inserting subtitle markup</refpurpose>

<refdescription>
<para>This mode is used to insert subtitle markup. Any element processed
in this mode should generate its subtitle.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-subtitle-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="subtitle"/>

  <xsl:copy-of select="$subtitle"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-label-markup" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for inserting label markup</refpurpose>

<refdescription>
<para>This mode is used to insert label markup. Any element processed
in this mode should generate its label (number).</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-label-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="label"/>

  <xsl:copy-of select="$label"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-pagenumber-markup"
	  xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for inserting page number markup</refpurpose>

<refdescription>
<para>This mode is used to insert page number markup. Any element processed
in this mode should generate its page number.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-pagenumber-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="pagenumber"/>

  <xsl:copy-of select="$pagenumber"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-direction-markup"
	  xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for inserting “direction” markup</refpurpose>

<refdescription>
<para>This mode is used to insert “direction”. Any element processed
in this mode should generate its direction number. The direction is
calculated from a reference and a referent (above or below, for example).</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-direction-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="direction"/>

  <xsl:copy-of select="$direction"/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:insert-olink-docname-markup"
	  xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for inserting <tag>olink</tag> document name markup</refpurpose>

<refdescription>
<para>This mode is used to insert <tag>olink</tag> document name markup.
Any element processed in this mode should generate its document name.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:insert-olink-docname-markup">
  <xsl:param name="purpose"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="docname"/>

  <span class="olinkdocname">
    <xsl:copy-of select="$docname"/>
  </span>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode name="m:xref-to-prefix"
	  xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for inserting cross reference prefixes</refpurpose>

<refdescription>
<para>This mode is used to insert prefixes before a cross reference.
Any element processed in this mode should generate the prefix appropriate
to cross references to that element.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:biblioentry|db:bibliomixed" mode="m:xref-to-prefix"
	      priority="100">
  <xsl:text>[</xsl:text>
</xsl:template>

<xsl:template match="*" mode="m:xref-to-prefix"/>

<!-- ==================================================================== -->

<doc:mode name="m:xref-to-suffix"
	  xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for inserting cross reference suffixes</refpurpose>

<refdescription>
<para>This mode is used to insert suffixes after a cross reference.
Any element processed in this mode should generate the suffix appropriate
to cross references to that element.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:biblioentry|db:bibliomixed" mode="m:xref-to-suffix"
	      priority="100">
  <xsl:text>]</xsl:text>
</xsl:template>

<xsl:template match="*" mode="m:xref-to-suffix"/>

<!-- ==================================================================== -->

<doc:mode name="m:xref-to"
	  xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for inserting cross references</refpurpose>

<refdescription>
<para>This mode is used to insert cross references.
Any element processed in this mode should generate the text of a
cross references to that element.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:if test="$verbose">
    <xsl:message>
      <xsl:text>Don't know what gentext to create for xref to: "</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>", ("</xsl:text>
      <xsl:value-of select="@id"/>
      <xsl:text>")</xsl:text>
    </xsl:message>
  </xsl:if>
  <xsl:text>???</xsl:text>
</xsl:template>

<xsl:template match="db:title" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <!-- if you xref to a title, xref to the parent... -->
  <xsl:apply-templates select="parent::*[2]" mode="m:xref-to">
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:abstract|db:authorblurb|db:personblurb|db:bibliodiv
		     |db:bibliomset|db:biblioset|db:blockquote|db:calloutlist
		     |db:caution|db:colophon|db:constraintdef|db:formalpara
		     |db:glossdiv|db:important|db:indexdiv|db:itemizedlist
		     |db:legalnotice|db:lot|db:msg|db:msgexplan|db:msgmain
		     |db:msgrel|db:msgset|db:msgsub|db:note|db:orderedlist
		     |db:partintro|db:productionset|db:qandadiv
		     |db:refsynopsisdiv|db:segmentedlist|db:set|db:setindex
		     |db:sidebar|db:tip|db:toc|db:variablelist|db:warning"
              mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <!-- catch-all for things with (possibly optional) titles -->
  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:author|db:editor|db:othercredit|db:personname"
	      mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:call-template name="person-name"/>
</xsl:template>

<xsl:template match="db:authorgroup" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:call-template name="person-name-list"/>
</xsl:template>

<xsl:template match="db:figure|db:example|db:table|db:equation" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:procedure" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:cmdsynopsis" mode="m:xref-to">
  <xsl:apply-templates select="(.//db:command)[1]" mode="m:xref"/>
</xsl:template>

<xsl:template match="db:funcsynopsis" mode="m:xref-to">
  <xsl:apply-templates select="(.//db:function)[1]" mode="m:xref"/>
</xsl:template>

<xsl:template match="db:dedication|db:preface
		     |db:chapter|db:appendix|db:article" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:bibliography" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:biblioentry|db:bibliomixed" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:variable name="context" select="(ancestor::db:bibliography
				       |ancestor::db:bibliolist)[last()]"/>

  <!-- handles both biblioentry and bibliomixed -->
  <xsl:choose>
    <xsl:when test="$bibliography.numbered != 0">
      <xsl:choose>
	<xsl:when test="$context/self::db:bibliography">
	  <xsl:number from="db:bibliography"
		      count="db:biblioentry|db:bibliomixed"
		      level="any" format="1"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:number from="db:bibliolist"
		      count="db:biblioentry|db:bibliomixed"
		      level="any" format="1"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="*[1]/self::db:abbrev">
      <xsl:apply-templates select="*[1]"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="@id"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:glossary" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:glossentry" mode="m:xref-to">
  <xsl:choose>
    <xsl:when test="$glossentry.show.acronym = 'primary'">
      <xsl:choose>
        <xsl:when test="db:acronym|db:abbrev">
          <xsl:apply-templates select="(db:acronym|db:abbrev)[1]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="db:glossterm[1]" mode="m:xref-to"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="db:glossterm[1]" mode="m:xref-to"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:glossterm" mode="m:xref-to">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:index" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:listitem" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:section|db:simplesect
                     |db:sect1|db:sect2|db:sect3|db:sect4|db:sect5
                     |db:refsect1|db:refsect2|db:refsect3|db:refsection"
	      mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
  <!-- FIXME: What about "in Chapter X"? -->
</xsl:template>

<xsl:template match="db:bridgehead" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
  <!-- FIXME: What about "in Chapter X"? -->
</xsl:template>

<xsl:template match="db:qandaset" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:qandadiv" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>
  <xsl:param name="verbose" select="1"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
    <xsl:with-param name="verbose" select="$verbose"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:qandaentry" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="db:question[1]" mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:question|db:answer" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:part|db:reference" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:refentry" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:choose>
    <xsl:when test="db:refmeta/db:refentrytitle">
      <xsl:apply-templates select="db:refmeta/db:refentrytitle"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="db:refnamediv/db:refname[1]"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="db:refmeta/db:manvolnum"/>
</xsl:template>

<xsl:template match="db:refnamediv" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="db:refname[1]" mode="m:xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:refname" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:step" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:call-template name="gentext">
    <xsl:with-param name="key" select="'Step'"/>
  </xsl:call-template>
  <xsl:text> </xsl:text>
  <xsl:apply-templates select="." mode="m:number"/>
</xsl:template>

<xsl:template match="db:varlistentry" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="db:term[1]" mode="m:xref-to">
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:varlistentry/db:term" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <!-- to avoid the comma that will be generated if there are several terms -->
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:co" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <!-- FIXME:
  <xsl:apply-templates select="." mode="m:callout-bug"/>
  -->
  <xsl:text>???</xsl:text>
</xsl:template>

<xsl:template match="db:book" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:apply-templates select="." mode="m:object-xref-markup">
    <xsl:with-param name="purpose" select="'xref'"/>
    <xsl:with-param name="xrefstyle" select="$xrefstyle"/>
    <xsl:with-param name="referrer" select="$referrer"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:para" mode="m:xref-to">
  <xsl:param name="referrer"/>
  <xsl:param name="xrefstyle"/>

  <xsl:variable name="context" select="(ancestor::db:simplesect
                                       |ancestor::db:section
                                       |ancestor::db:sect1
                                       |ancestor::db:sect2
                                       |ancestor::db:sect3
                                       |ancestor::db:sect4
                                       |ancestor::db:sect5
                                       |ancestor::db:refsection
                                       |ancestor::db:refsect1
                                       |ancestor::db:refsect2
                                       |ancestor::db:refsect3
                                       |ancestor::db:chapter
                                       |ancestor::db:appendix
                                       |ancestor::db:preface
                                       |ancestor::db:partintro
                                       |ancestor::db:dedication
                                       |ancestor::db:colophon
                                       |ancestor::db:bibliography
                                       |ancestor::db:index
                                       |ancestor::db:glossary
                                       |ancestor::db:glossentry
                                       |ancestor::db:listitem
                                       |ancestor::db:varlistentry)[last()]"/>

  <xsl:apply-templates select="$context" mode="m:xref-to"/>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:xref" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for inserting markup in an xref</refpurpose>

<refdescription>
<para>This mode is (sometimes) used when generating cross references.
Any element processed
in this mode should generate markup appropriate to appear in a
cross-reference.</para>
</refdescription>
</doc:mode>

<xsl:template match="title" mode="m:xref">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="command" mode="m:xref">
  <xsl:call-template name="inline-boldseq"/>
</xsl:template>

<xsl:template match="function" mode="m:xref">
  <xsl:call-template name="inline-monoseq"/>
</xsl:template>

</xsl:stylesheet>
