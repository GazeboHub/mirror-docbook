<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:t="http://docbook.org/xslt/ns/template"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns="http://www.w3.org/1999/xhtml"
		exclude-result-prefixes="db doc f fn h m t xs"
                version="2.0">

<xsl:template match="db:info">
  <!-- nop -->
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:titlepage-mode"
	  xmlns="http://docbook.org/ns/docbook">
<refpurpose>Mode for formatting elements on the title page</refpurpose>

<refdescription>
<para>This mode is used to format elements on the title page.
Any element processed in this mode should generate markup appropriate
for the title page.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:set/db:info/db:title
		     |db:book/db:info/db:title
		     |db:part/db:info/db:title
		     |db:reference/db:info/db:title
		     |db:setindex/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h1>
    <xsl:next-match/>
  </h1>
</xsl:template>

<xsl:template match="db:set/db:info/db:subtitle
		     |db:book/db:info/db:subtitle
		     |db:part/db:info/db:subtitle
		     |db:reference/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:apply-templates/>
  </h2>
</xsl:template>

<xsl:template match="db:dedication/db:info/db:title
	             |db:preface/db:info/db:title
		     |db:chapter/db:info/db:title
		     |db:appendix/db:info/db:title
		     |db:colophon/db:info/db:title
		     |db:article/db:info/db:title
		     |db:bibliography/db:info/db:title
		     |db:glossary/db:info/db:title
		     |db:index/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:dedication/db:info/db:subtitle
	             |db:preface/db:info/db:subtitle
		     |db:chapter/db:info/db:subtitle
		     |db:appendix/db:info/db:subtitle
		     |db:colophon/db:info/db:subtitle
		     |db:article/db:info/db:subtitle
		     |db:bibliography/db:info/db:subtitle
		     |db:glossary/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:apply-templates/>
  </h3>
</xsl:template>

<xsl:template match="db:bibliodiv/db:info/db:title
		     |db:glossdiv/db:info/db:title
		     |db:indexdiv/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:bibliodiv/db:info/db:subtitle
		     |db:glossdiv/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <h4>
    <xsl:apply-templates/>
  </h4>
</xsl:template>

<xsl:template match="db:bibliolist/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:glosslist/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:qandaset/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h2>
    <xsl:next-match/>
  </h2>
</xsl:template>

<xsl:template match="db:qandadiv/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:task/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:tasksummary/db:info/db:title
                     |db:taskprerequisites/db:info/db:title
                     |db:taskrelated/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="200">
  <h4>
    <xsl:next-match/>
  </h4>
</xsl:template>

<xsl:template match="db:procedure/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <!-- N.B. Can't put task/procedure/info/title in preceding pattern -->
  <!-- because next-match will then catch this one... -->

  <xsl:choose>
    <xsl:when test="ancestor::db:task">
      <h4>
        <xsl:next-match/>
      </h4>
    </xsl:when>
    <xsl:otherwise>
      <h3>
        <xsl:next-match/>
      </h3>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:step/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h4>
    <xsl:next-match/>
  </h4>
</xsl:template>

<xsl:template match="db:tip/db:info/db:title
                     |db:note/db:info/db:title
                     |db:important/db:info/db:title
                     |db:warning/db:info/db:title
                     |db:caution/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <h3>
    <xsl:next-match/>
  </h3>
</xsl:template>

<xsl:template match="db:sidebar/db:info/db:title"
	      mode="m:titlepage-mode"
              priority="100">
  <div class="title">
    <xsl:next-match/>
  </div>
</xsl:template>

<xsl:template match="db:annotation/db:info/db:title"
	      mode="m:titlepage-mode"
              priority="100">
  <div class="title">
    <xsl:next-match/>
  </div>
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

<xsl:template match="db:section/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="depth"
		select="count(ancestor::db:section)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 4) then $depth else 3"/>

  <xsl:element name="h{$hlevel+3}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:sect1/db:info/db:title
                     |db:sect2/db:info/db:title
                     |db:sect3/db:info/db:title
                     |db:sect4/db:info/db:title
                     |db:sect5/db:info/db:title
                     |db:sect61/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="depth"
		select="xs:decimal(substring-after(local-name(../..), 'sect')) - 1"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>

  <xsl:element name="h{$hlevel+2}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:next-match/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:sect1/db:info/db:subtitle
                     |db:sect2/db:info/db:subtitle
                     |db:sect3/db:info/db:subtitle
                     |db:sect4/db:info/db:subtitle
                     |db:sect5/db:info/db:subtitle
                     |db:sect6/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="depth"
		select="xs:decimal(substring-after(local-name(../..), 'sect')) - 1"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 4) then $depth else 3"/>

  <xsl:element name="h{$hlevel+2}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:next-match/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:simplesect/db:info/db:title"
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

<xsl:template match="db:simplesect/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="depth"
		select="count(ancestor::db:section)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 4) then $depth else 3"/>

  <xsl:element name="h{$hlevel+3}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates/>
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

<xsl:template match="db:refsect1/db:info/db:title
                     |db:refsect2/db:info/db:title
                     |db:refsect3/db:info/db:title"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="depth"
		select="xs:decimal(substring-after(local-name(../..), 'sect')) - 1"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 5) then $depth else 4"/>

  <xsl:element name="h{$hlevel+2}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:next-match/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:refsection/db:info/db:subtitle"
	      mode="m:titlepage-mode"
	      priority="100">
  <xsl:variable name="depth"
		select="count(ancestor::db:refsection)"/>

  <xsl:variable name="hlevel"
		select="if ($depth &lt; 4) then $depth else 3"/>

  <xsl:element name="h{$hlevel+3}" namespace="http://www.w3.org/1999/xhtml">
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

<xsl:template match="db:title" mode="m:titlepage-mode">
  <xsl:apply-templates select="../.." mode="m:object-title-markup">
    <xsl:with-param name="allow-anchors" select="1"/>
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="db:copyright" mode="m:titlepage-mode">
  <p class="{local-name(.)}">
    <xsl:apply-templates select="."/> <!-- no mode -->
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

<xsl:template match="db:abstract" mode="m:titlepage-mode">
  <div class="{local-name()}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:legalnotice" mode="m:titlepage-mode">
  <div class="{local-name()}">
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="*" mode="m:titlepage-mode">
  <xsl:apply-templates select="."/>
</xsl:template>

<xsl:template match="db:authorgroup" mode="m:titlepage-mode">
  <xsl:apply-templates mode="m:titlepage-mode"/>
</xsl:template>

<xsl:template match="db:pubdate" mode="m:titlepage-mode">
  <div>
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <p>
      <xsl:choose>
        <xsl:when test=". castable as xs:dateTime">
          <xsl:value-of select="format-dateTime(xs:dateTime(.),
                                                $dateTime-format)"/>
        </xsl:when>
        <xsl:when test=". castable as xs:date">
          <xsl:value-of select="format-date(xs:date(.), $date-format)"/>
        </xsl:when>
        <xsl:when test=". castable as xs:gYearMonth">
          <xsl:value-of select="format-date(xs:date(concat(.,'-01')),
                                            $gYearMonth-format)"/>
        </xsl:when>
        <xsl:when test=". castable as xs:gYear">
          <xsl:value-of select="format-date(xs:date(concat(.,'-01-01')),
                                            $gYear-format)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </p>
  </div>
</xsl:template>

<xsl:template match="db:info/db:author
                     |db:info/db:authorgroup/db:author
                     |db:info/db:editor
                     |db:info/db:authorgroup/db:editor"
	      mode="m:titlepage-mode">
  <xsl:call-template name="t:credits.div"/>
</xsl:template>

<xsl:param name="editedby.enabled" select="1"/>

<xsl:template name="t:credits.div">
  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>

    <xsl:if test="self::db:editor[position()=1] and not($editedby.enabled = 0)">
      <h4 class="editedby">
        <xsl:value-of select="f:gentext(.,'editedby')"/>
      </h4>
    </xsl:if>

    <h3>
      <!-- use normal mode -->
      <xsl:apply-templates select="db:orgname|db:personname"/>
    </h3>
  </div>
</xsl:template>

</xsl:stylesheet>
