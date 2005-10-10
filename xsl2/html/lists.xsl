<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/04/xpath-functions"
		xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
		xmlns:t="http://docbook.org/xslt/ns/template"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="h f m fn db doc t xs"
                version="2.0">

<xsl:template match="db:itemizedlist/db:info/db:title
		     |db:orderedlist/db:info/db:title
		     |db:variablelist/db:info/db:title
		     |db:procedure/db:info/db:title"
	      mode="m:titlepage-mode">
  <div class="title">
    <xsl:apply-templates select="../.." mode="m:object-title-markup">
      <xsl:with-param name="allow-anchors" select="1"/>
    </xsl:apply-templates>
  </div>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:itemizedlist">
  <xsl:variable name="titlepage"
		select="$titlepages/*[node-name(.)
			              = node-name(current())][1]"/>

  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <xsl:call-template name="titlepage">
      <xsl:with-param name="content" select="$titlepage"/>
    </xsl:call-template>

    <xsl:apply-templates select="*[not(self::db:info)
				   and not(self::db:listitem)]"/>

    <ul>
      <xsl:apply-templates select="db:listitem"/>
    </ul>
  </div>
</xsl:template>

<xsl:template match="db:itemizedlist/db:listitem">
  <li>
    <xsl:call-template name="id"/>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:orderedlist">
  <xsl:variable name="titlepage"
		select="$titlepages/*[node-name(.)
			              = node-name(current())][1]"/>

  <xsl:variable name="starting.number"
		select="f:orderedlist-starting-number(.)"/>

  <xsl:variable name="numeration"
		select="f:orderedlist-numeration(.)"/>

  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>

    <xsl:call-template name="titlepage">
      <xsl:with-param name="content" select="$titlepage"/>
    </xsl:call-template>

    <xsl:apply-templates select="*[not(self::db:info)
				   and not(self::db:listitem)]"/>

    <ol>
      <xsl:if test="$starting.number != 1">
	<xsl:attribute name="start" select="$starting.number"/>
      </xsl:if>
      
      <!-- If there's no inline style attribute, force the class -->
      <!-- to contain the numeration so that external CSS can work -->
      <!-- otherwise, leave the class whatever it was -->
      <xsl:call-template name="class"/>
      <xsl:if test="$inline.style.attribute = 0">
	<xsl:attribute name="class" select="$numeration"/>
      </xsl:if>

      <xsl:call-template name="style">
	<xsl:with-param name="css">
	  <xsl:text>list-style: </xsl:text>
	  <xsl:choose>
	    <xsl:when test="not($numeration)">decimal</xsl:when>
	    <xsl:when test="$numeration = 'arabic'">decimal</xsl:when>
	    <xsl:when test="$numeration = 'loweralpha'">lower-alpha</xsl:when>
	    <xsl:when test="$numeration = 'upperalpha'">upper-alpha</xsl:when>
	    <xsl:when test="$numeration = 'lowerroman'">lower-roman</xsl:when>
	    <xsl:when test="$numeration = 'upperroman'">upper-roman</xsl:when>
	    <xsl:when test="$numeration = 'loweralpha'">lower-alpha</xsl:when>
	    <xsl:otherwise>decimal</xsl:otherwise>
	  </xsl:choose>
	  <xsl:text>;</xsl:text>
	</xsl:with-param>
      </xsl:call-template>

      <xsl:apply-templates select="db:listitem"/>
    </ol>
  </div>
</xsl:template>

<xsl:template match="db:orderedlist/db:listitem">
  <li>
    <xsl:call-template name="id"/>
    <xsl:apply-templates/>
  </li>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:variablelist">
  <xsl:variable name="titlepage"
		select="$titlepages/*[node-name(.)
			              = node-name(current())][1]"/>

  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <xsl:call-template name="titlepage">
      <xsl:with-param name="content" select="$titlepage"/>
    </xsl:call-template>

    <xsl:apply-templates select="*[not(self::db:info)
				   and not(self::db:varlistentry)]"/>

    <dl>
      <xsl:apply-templates select="db:varlistentry"/>
    </dl>
  </div>
</xsl:template>

<xsl:template match="db:varlistentry">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:varlistentry/db:term">
  <dt>
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <xsl:apply-templates/>
  </dt>
</xsl:template>

<xsl:template match="db:varlistentry/db:listitem">
  <dd>
    <xsl:call-template name="id"/>
    <xsl:apply-templates/>
  </dd>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:simplelist[not(@type) or @type='vert']">
  <table class="{local-name(.)}" border="0" summary="Simple list">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <xsl:call-template name="simplelist-vert">
      <xsl:with-param name="cols" select="if (@columns) then @columns else 1"/>
    </xsl:call-template>
  </table>
</xsl:template>

<xsl:template match="db:simplelist[@type='horiz']">
  <table class="{local-name(.)}" border="0" summary="Simple list">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <xsl:call-template name="simplelist-horiz">
      <xsl:with-param name="cols" select="if (@columns) then @columns else 1"/>
    </xsl:call-template>
  </table>
</xsl:template>

<xsl:template match="db:simplelist[@type='inline']">
  <span class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="simplelist-horiz" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Process a simplelist as a row-major table</refpurpose>

<refdescription>
<para>This template processes a <tag>simplelist</tag> as a row-major
(horizontal) table.</para>
</refdescription>
</doc:template>

<xsl:template name="simplelist-horiz">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="cell" select="1"/>
  <xsl:param name="members" select="db:member"/>

  <xsl:if test="$cell &lt;= count($members)">
    <tr>
<!--
      <xsl:call-template name="tr.attributes">
        <xsl:with-param name="row" select="$members[1]"/>
        <xsl:with-param name="rownum" select="(($cell - 1) div $cols) + 1"/>
      </xsl:call-template>
-->

      <xsl:call-template name="simplelist-horiz-row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="cell" select="$cell"/>
        <xsl:with-param name="members" select="$members"/>
      </xsl:call-template>
   </tr>
    <xsl:call-template name="simplelist-horiz">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell + $cols"/>
      <xsl:with-param name="members" select="$members"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="simplelist-horiz-row" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Produce a row of a simplelist as a row-major table</refpurpose>

<refdescription>
<para>This template produces a single row in a
<tag>simplelist</tag> as a row-major
(horizontal) table.</para>
</refdescription>
</doc:template>

<xsl:template name="simplelist-horiz-row">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="cell" select="1"/>
  <xsl:param name="members" select="db:member"/>
  <xsl:param name="curcol" select="1"/>

  <xsl:if test="$curcol &lt;= $cols">
    <td>
      <xsl:choose>
        <xsl:when test="$members[position()=$cell]">
          <xsl:apply-templates select="$members[position()=$cell]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#160;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <xsl:call-template name="simplelist-horiz-row">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="curcol" select="$curcol+1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="simplelist-vert" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Process a simplelist as a column-major table</refpurpose>

<refdescription>
<para>This template processes a <tag>simplelist</tag> as a column-major
(vertical) table.</para>
</refdescription>
</doc:template>

<xsl:template name="simplelist-vert">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="cell" select="1"/>
  <xsl:param name="members" select="db:member"/>
  <xsl:param name="rows"
             select="floor((count($members)+$cols - 1) div $cols)"/>

  <xsl:if test="$cell &lt;= $rows">
    <tr>
<!--
      <xsl:call-template name="tr.attributes">
        <xsl:with-param name="row" select="$members[1]"/>
        <xsl:with-param name="rownum" select="$cell"/>
      </xsl:call-template>
-->

      <xsl:call-template name="simplelist-vert-row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="rows" select="$rows"/>
        <xsl:with-param name="cell" select="$cell"/>
        <xsl:with-param name="members" select="$members"/>
      </xsl:call-template>
    </tr>
    <xsl:call-template name="simplelist-vert">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="rows" select="$rows"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<doc:template name="simplelist-vert-row" xmlns="http://docbook.org/ns/docbook">
<refpurpose>Produce a row of a simplelist as a column-major table</refpurpose>

<refdescription>
<para>This template produces a single row in a
<tag>simplelist</tag> as a column-major
(vertical) table.</para>
</refdescription>
</doc:template>

<xsl:template name="simplelist-vert-row">
  <xsl:param name="cols" select="1"/>
  <xsl:param name="rows" select="1"/>
  <xsl:param name="cell" select="1"/>
  <xsl:param name="members" select="db:member"/>
  <xsl:param name="curcol" select="1"/>

  <xsl:if test="$curcol &lt;= $cols">
    <td>
      <xsl:choose>
        <xsl:when test="$members[position()=$cell]">
          <xsl:apply-templates select="$members[position()=$cell]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>&#160;</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </td>
    <xsl:call-template name="simplelist-vert-row">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="rows" select="$rows"/>
      <xsl:with-param name="cell" select="$cell+$rows"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="curcol" select="$curcol+1"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template match="db:member">
  <span class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:simplelist[@type='inline']/db:member">
  <span class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </span>
  <xsl:if test="following-sibling::db:member">, </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:procedure">
  <xsl:variable name="numeration" select="f:procedure-step-numeration(.)"/>

  <xsl:call-template name="t:semiformal-object">
    <xsl:with-param name="placement"
	    select="$formal.title.placement[self::db:procedure]/@placement"/>
    <xsl:with-param name="class" select="local-name(.)"/>
    <xsl:with-param name="object" as="element()">
      <div class="{local-name(.)}">
	<xsl:call-template name="id"/>
	<xsl:call-template name="class"/>

	<xsl:apply-templates
	    select="(db:step[1]/preceding-sibling::node())[not(self::db:info)]"/>

	<xsl:choose>
	  <xsl:when test="count(db:step) = 1">
	    <ul>
	      <xsl:apply-templates 
		  select="db:step[1]|db:step[1]/following-sibling::node()"/>
	    </ul>
	  </xsl:when>
	  <xsl:otherwise>
	    <ol>
	      <xsl:attribute name="type">
		<xsl:choose>
		  <xsl:when test="$numeration = 'arabic'">1</xsl:when>
		  <xsl:when test="$numeration = 'loweralpha'">a</xsl:when>
		  <xsl:when test="$numeration = 'upperalpha'">A</xsl:when>
		  <xsl:when test="$numeration = 'lowerroman'">i</xsl:when>
		  <xsl:when test="$numeration = 'upperroman'">I</xsl:when>
		  <xsl:otherwise>1</xsl:otherwise>
		</xsl:choose>
	      </xsl:attribute>
	      <xsl:apply-templates 
		  select="db:step[1]|db:step[1]/following-sibling::node()"/>
	    </ol>
	  </xsl:otherwise>
	</xsl:choose>
      </div>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:step">
  <xsl:variable name="titlepage"
		select="$titlepages/*[node-name(.)
			              = node-name(current())][1]"/>

  <li>
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>

    <div class="{local-name(.)}">
      <xsl:call-template name="titlepage">
	<xsl:with-param name="content" select="$titlepage"/>
      </xsl:call-template>

      <xsl:apply-templates select="node()[not(self::db:info)]"/>
    </div>
  </li>
</xsl:template>

<xsl:template match="db:substeps">
  <xsl:variable name="numeration" select="f:procedure-step-numeration(.)"/>

  <ol>
    <xsl:attribute name="type">
      <xsl:choose>
	<xsl:when test="$numeration = 'arabic'">1</xsl:when>
	<xsl:when test="$numeration = 'loweralpha'">a</xsl:when>
	<xsl:when test="$numeration = 'upperalpha'">A</xsl:when>
	<xsl:when test="$numeration = 'lowerroman'">i</xsl:when>
	<xsl:when test="$numeration = 'upperroman'">I</xsl:when>
	<xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </ol>
</xsl:template>

<xsl:template match="db:stepalternatives">
  <ul>
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </ul>
</xsl:template>

</xsl:stylesheet>
