<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:ghost="http://docbook.org/docbook-ng/ephemeral"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="doc f ghost h m u xs"
                version="2.0">

<xsl:param name="callout.defaultcolumn" select="40"/>
<xsl:param name="verbatim.trim.blank.lines" select="1"/>

<xsl:param name="linenumbering.everyNth" select="2"/>
<xsl:param name="linenumbering.width" select="3"/>
<xsl:param name="linenumbering.separator" select="' | '"/>
<xsl:param name="linenumbering.padchar" select="' '"/>

<xsl:strip-space elements="*"/>

<!-- ============================================================ -->

<xsl:template match="db:programlistingco" mode="m:verbatim">
  <xsl:variable name="areas-unsorted" as="element()*">
    <xsl:apply-templates select="db:areaspec"/>
  </xsl:variable>

  <xsl:variable name="areas" as="element()*">
    <xsl:for-each select="$areas-unsorted">
      <xsl:sort data-type="number" select="@ghost:line"/>
      <xsl:sort data-type="number" select="@ghost:col"/>
      <xsl:sort data-type="number" select="@ghost:number"/>
      <xsl:if test="@ghost:line">
	<xsl:copy-of select="."/>
      </xsl:if>
    </xsl:for-each>
  </xsl:variable>

  <xsl:variable name="pl-empty-tags" as="node()*">
    <xsl:apply-templates select="db:programlisting/node()"
			 mode="m:pl-empty-tags"/>
  </xsl:variable>

  <xsl:variable name="pl-no-lb" as="node()*">
    <xsl:apply-templates select="$pl-empty-tags"
			 mode="m:pl-no-lb"/>
  </xsl:variable>

  <xsl:variable name="pl-no-wrap-lb" as="node()*">
    <xsl:call-template name="nowrap">
      <xsl:with-param name="nowrap" select="xs:QName('ghost:br')"/>
      <xsl:with-param name="content" select="$pl-no-lb"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="pl-lines" as="element(ghost:line)*">
    <xsl:call-template name="wrap-lines">
      <xsl:with-param name="nodes" select="$pl-no-wrap-lb"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="pl-callouts" as="element(ghost:line)*">
    <xsl:apply-templates select="$pl-lines" mode="m:pl-callouts">
      <xsl:with-param name="areas" select="$areas"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:variable name="pl-removed-lines" as="node()*">
    <xsl:apply-templates select="$pl-callouts"
			 mode="m:pl-restore-lines"/>
  </xsl:variable>

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:copy-of select="db:areaspec"/>
    <db:programlisting>
      <xsl:copy-of select="db:programlisting/@*"/>
      <xsl:apply-templates select="$pl-removed-lines"
			   mode="m:pl-cleanup"/>
    </db:programlisting>
    <xsl:copy-of select="db:calloutlist"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="db:programlisting|db:screen|db:synopsis
                     |db:literallayout|db:address" mode="m:verbatim">

  <xsl:variable name="pl-empty-tags" as="node()*">
    <xsl:apply-templates mode="m:pl-empty-tags"/>
  </xsl:variable>

  <xsl:variable name="pl-no-lb" as="node()*">
    <xsl:apply-templates select="$pl-empty-tags"
			 mode="m:pl-no-lb"/>
  </xsl:variable>

  <xsl:variable name="pl-no-wrap-lb" as="node()*">
    <xsl:call-template name="nowrap">
      <xsl:with-param name="nowrap" select="xs:QName('ghost:br')"/>
      <xsl:with-param name="content" select="$pl-no-lb"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="pl-lines" as="element(ghost:line)*">
    <xsl:call-template name="wrap-lines">
      <xsl:with-param name="nodes" select="$pl-no-wrap-lb"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="pl-removed-lines" as="node()*">
    <xsl:apply-templates select="$pl-lines"
			 mode="m:pl-restore-lines"/>
  </xsl:variable>

  <xsl:variable name="result" as="element()">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="$pl-lines"
			   mode="m:pl-restore-lines"/>
    </xsl:copy>
  </xsl:variable>

  <xsl:apply-templates select="$result" mode="m:pl-cleanup"/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="m:pl-cleanup">
  <xsl:variable name="id" select="@xml:id"/>
  <xsl:copy>
    <xsl:copy-of select="@*[name(.) != 'xml:id'
      and namespace-uri(.) != 'http://docbook.org/docbook-ng/ephemeral']"/>
    <xsl:if test="@xml:id and not(preceding::*[@xml:id = $id])">
      <xsl:attribute name="xml:id" select="$id"/>
    </xsl:if>

    <xsl:apply-templates mode="m:pl-cleanup"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="m:pl-cleanup">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="ghost:line" mode="m:pl-restore-lines">
  <xsl:variable name="linenumber" select="position()"/>

  <xsl:if test="true()">
    <xsl:choose>
      <xsl:when test="$linenumber = 1
		      or $linenumber mod $linenumbering.everyNth = 0">
	<xsl:variable name="numwidth"
		      select="string-length(string($linenumber))"/>
	<xsl:if test="$numwidth &lt; $linenumbering.width">
	  <xsl:value-of select="f:pad($linenumbering.width - $numwidth,
				      $linenumbering.padchar)"/>
	</xsl:if>
	<xsl:value-of select="$linenumber"/>
	<xsl:value-of select="$linenumbering.separator"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:value-of select="f:pad($linenumbering.width,
			            $linenumbering.padchar)"/>
	<xsl:value-of select="$linenumbering.separator"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="ghost:end">
      <xsl:call-template name="restore-wrap">
	<xsl:with-param name="nodes" select="node()"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="node()"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template name="restore-wrap">
  <xsl:param name="nodes" select="node()"/>

  <xsl:choose>
    <xsl:when test="not($nodes)"/>
    <xsl:when test="$nodes[1] instance of element()
                    and $nodes[1]/@ghost:id">
      <xsl:variable name="id" select="$nodes[1]/@ghost:id"/>
      <xsl:variable name="end" select="$nodes[self::ghost:end[@idref=$id]][1]"/>
      <xsl:variable name="endpos"
		    select="f:find-element-in-sequence($nodes, $end, 2)"/>

      <xsl:element name="{name($nodes[1])}"
		   namespace="{namespace-uri($nodes[1])}">
	<xsl:copy-of select="$nodes[1]/@*"/>
	<xsl:call-template name="restore-wrap">
	  <xsl:with-param name="nodes"
			  select="subsequence($nodes, 2, $endpos - 2)"/>
	</xsl:call-template>
      </xsl:element>
      <xsl:call-template name="restore-wrap">
	<xsl:with-param name="nodes"
			select="subsequence($nodes, $endpos+1)"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$nodes[1]"/>
      <xsl:call-template name="restore-wrap">
	<xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:function name="f:find-element-in-sequence" as="xs:integer">
  <xsl:param name="nodes" as="node()*"/>
  <xsl:param name="target" as="element()"/>
  <xsl:param name="start" as="xs:integer"/>

  <xsl:choose>
    <xsl:when test="$start &gt; count($nodes)">0</xsl:when>
    <xsl:when test="$nodes[$start] is $target">
      <xsl:value-of select="$start"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="f:find-element-in-sequence($nodes, $target,
			                               $start+1)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<xsl:template match="ghost:line" mode="m:pl-callouts">
  <xsl:param name="areas" as="element()*"/>
  <xsl:param name="linenumber" select="position()"/>

  <xsl:choose>
    <xsl:when test="$areas[@ghost:line = $linenumber]">
      <xsl:call-template name="addcallouts">
	<xsl:with-param name="areas" select="$areas[@ghost:line = $linenumber]"/>
	<xsl:with-param name="line" select="."/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="."/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="addcallouts">
  <xsl:param name="areas" as="element(db:area)*"/>
  <xsl:param name="line" as="element(ghost:line)"/>

  <xsl:variable name="newline" as="element(ghost:line)">
    <ghost:line>
      <xsl:call-template name="addcallout">
	<xsl:with-param name="area" select="$areas[1]"/>
	<xsl:with-param name="nodes" select="$line/node()"/>
      </xsl:call-template>
    </ghost:line>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="count($areas) = 1">
      <xsl:copy-of select="$newline"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="addcallouts">
	<xsl:with-param name="areas" select="$areas[position() &gt; 1]"/>
	<xsl:with-param name="line" select="$newline"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="addcallout">
  <xsl:param name="area" as="element(db:area)"/>
  <xsl:param name="nodes" as="node()*"/>
  <xsl:param name="pos" as="xs:integer" select="1"/>
  
  <xsl:choose>
    <xsl:when test="not($nodes)">
      <xsl:if test="$pos &lt; $area/@ghost:col">
	<xsl:value-of select="f:pad(xs:integer($area/@ghost:col) - $pos, ' ')"/>
	<xsl:apply-templates select="$area" mode="m:insert-callout"/>
      </xsl:if>
    </xsl:when>
    <xsl:when test="$nodes[1] instance of text()">
      <xsl:choose>
	<xsl:when test="$pos = $area/@ghost:col">
	  <xsl:apply-templates select="$area" mode="m:insert-callout"/>
	  <xsl:copy-of select="$nodes"/>
	</xsl:when>
	<xsl:when test="string-length($nodes[1]) = 1">
	  <xsl:copy-of select="$nodes[1]"/>
	  <xsl:call-template name="addcallout">
	    <xsl:with-param name="area" select="$area"/>
	    <xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
	    <xsl:with-param name="pos" select="$pos+1"/>
	  </xsl:call-template>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="substring($nodes[1], 1, 1)"/>
	  <xsl:variable name="rest" as="text()">
	    <xsl:value-of select="substring($nodes[1], 2)"/>
	  </xsl:variable>
	  <xsl:call-template name="addcallout">
	    <xsl:with-param name="area" select="$area"/>
	    <xsl:with-param name="nodes"
			    select="($rest, $nodes[position() &gt; 1])"/>
	    <xsl:with-param name="pos" select="$pos+1"/>
	  </xsl:call-template>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$nodes[1]"/>
      <xsl:call-template name="addcallout">
	<xsl:with-param name="area" select="$area"/>
	<xsl:with-param name="nodes" select="$nodes[position() &gt; 1]"/>
	<xsl:with-param name="pos" select="$pos"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:area" mode="m:insert-callout">
  <ghost:co number="{@ghost:number}" xml:id="{@xml:id}"/>
</xsl:template>

<xsl:function name="f:pad">
  <xsl:param name="count" as="xs:integer"/>
  <xsl:param name="char" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="$count &gt; 4">
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="f:pad($count - 4, $char)"/>
    </xsl:when>
    <xsl:when test="$count &gt; 3">
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="f:pad($count - 3, $char)"/>
    </xsl:when>
    <xsl:when test="$count &gt; 2">
      <xsl:value-of select="$char"/>
      <xsl:value-of select="$char"/>
      <xsl:value-of select="f:pad($count - 2, $char)"/>
    </xsl:when>
    <xsl:when test="$count &gt; 1">
      <xsl:value-of select="$char"/>
      <xsl:value-of select="f:pad($count - 1, $char)"/>
    </xsl:when>
    <xsl:when test="$count &gt; 0">
      <xsl:value-of select="$char"/>
    </xsl:when>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<xsl:template name="wrap-lines">
  <xsl:param name="nodes" as="node()*" required="yes"/>

  <xsl:variable name="br" as="element()">
    <ghost:br/>
  </xsl:variable>

  <xsl:variable name="wrapnodes" as="node()*">
    <xsl:choose>
      <xsl:when test="$verbatim.trim.blank.lines = 0">
	<xsl:choose>
	  <xsl:when test="$nodes[last()][self::ghost:br]">
	    <!-- because group-by will not form a group after the last one -->
	    <xsl:sequence select="($nodes, $br)"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:sequence select="$nodes"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:when>
      <xsl:otherwise>
	<xsl:sequence select="f:trim-trailing-br($nodes)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:for-each-group select="$wrapnodes" group-ending-with="ghost:br">
    <ghost:line>
      <xsl:for-each select="current-group()">
	<xsl:if test="not(self::ghost:br)">
	  <xsl:copy-of select="."/>
	</xsl:if>
      </xsl:for-each>
    </ghost:line>
  </xsl:for-each-group>
</xsl:template>

<!-- ============================================================ -->

<xsl:function name="f:trim-trailing-br" as="node()*">
  <xsl:param name="nodes" as="node()*"/>

  <xsl:choose>
    <xsl:when test="$nodes[last()][self::ghost:br]">
      <xsl:sequence select="f:trim-trailing-br($nodes[position() &lt; last()])"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:sequence select="$nodes"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<xsl:template match="db:programlisting" mode="m:pl-no-wrap-lb">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:call-template name="nowrap">
      <xsl:with-param name="nowrap" select="xs:QName('ghost:br')"/>
      <xsl:with-param name="content" select="node()"/>
    </xsl:call-template>
  </xsl:copy>
</xsl:template>

<xsl:template name="nowrap">
  <xsl:param name="nowrap" as="xs:QName"/>
  <xsl:param name="content" as="node()*"/>
  <xsl:param name="stack" as="element()*" select="()"/>

  <xsl:choose>
    <xsl:when test="not($content)"/>
    <xsl:when test="$content[1] instance of element()
                    and node-name($content[1]) = $nowrap">
      <xsl:call-template name="close-stack">
	<xsl:with-param name="stack" select="$stack"/>
      </xsl:call-template>
      <xsl:copy-of select="$content[1]"/>
      <xsl:call-template name="open-stack">
	<xsl:with-param name="stack" select="$stack"/>
      </xsl:call-template>
      <xsl:call-template name="nowrap">
	<xsl:with-param name="nowrap" select="$nowrap"/>
	<xsl:with-param name="content" select="$content[position() &gt; 1]"/>
	<xsl:with-param name="stack" select="$stack"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$content[1][self::ghost:end]">
      <xsl:copy-of select="$content[1]"/>
      <xsl:call-template name="nowrap">
	<xsl:with-param name="nowrap" select="$nowrap"/>
	<xsl:with-param name="content" select="$content[position() &gt; 1]"/>
	<xsl:with-param name="stack" select="$stack[position() &lt; last()]"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:when test="$content[1] instance of element()">
      <xsl:copy-of select="$content[1]"/>
      <xsl:call-template name="nowrap">
	<xsl:with-param name="nowrap" select="$nowrap"/>
	<xsl:with-param name="content" select="$content[position() &gt; 1]"/>
	<xsl:with-param name="stack" select="($stack, $content[1])"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$content[1]"/>
      <xsl:call-template name="nowrap">
	<xsl:with-param name="nowrap" select="$nowrap"/>
	<xsl:with-param name="content" select="$content[position() &gt; 1]"/>
	<xsl:with-param name="stack" select="$stack"/>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="close-stack">
  <xsl:param name="stack" as="element()*" select="()"/>

  <xsl:if test="$stack">
    <ghost:end idref="{$stack[1]/@ghost:id}"/>
    <xsl:call-template name="close-stack">
      <xsl:with-param name="stack" select="$stack[position() &lt; last()]"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="open-stack">
  <xsl:param name="stack" as="element()*" select="()"/>

  <xsl:if test="$stack">
    <xsl:copy-of select="$stack[1]"/>
    <xsl:call-template name="open-stack">
      <xsl:with-param name="stack" select="$stack[position() &gt; 1]"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="m:pl-no-lb">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="m:pl-no-lb"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="text()"
	      mode="m:pl-no-lb">
  <xsl:analyze-string select="." regex="\n">
    <xsl:matching-substring>
      <ghost:br/>
    </xsl:matching-substring>
    <xsl:non-matching-substring>
      <xsl:value-of select="."/>
    </xsl:non-matching-substring>
  </xsl:analyze-string>
</xsl:template>

<xsl:template match="comment()|processing-instruction()"
	      mode="m:pl-no-lb">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="m:pl-empty-tags">
  <xsl:element name="{name(.)}" namespace="{namespace-uri(.)}">
    <xsl:copy-of select="@*"/>
    <xsl:attribute name="ghost:id" select="generate-id()"/>
  </xsl:element>
  <xsl:apply-templates mode="m:pl-empty-tags"/>
  <ghost:end idref="{generate-id()}"/>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="m:pl-empty-tags">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="db:areaspec|db:areaset">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="db:areaspec/db:area">
  <db:area>
    <xsl:copy-of select="@*[name(.) != 'coords']"/>
    <xsl:if test="(not(@units)
		   or @units='linecolumn'
		   or @units='linecolumnpair')">
      <xsl:choose>
	<xsl:when test="not(contains(normalize-space(@coords), ' '))">
	  <xsl:attribute name="ghost:line" select="normalize-space(@coords)"/>
	  <xsl:attribute name="ghost:col" select="$callout.defaultcolumn"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:variable name="toks"
			select="tokenize(normalize-space(@coords), ' ')"/>
	  <xsl:attribute name="ghost:line" select="$toks[1]"/>
	  <xsl:attribute name="ghost:col" select="$toks[2]"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:attribute name="ghost:number"
		   select="count(preceding-sibling::db:area
                                 |preceding-sibling::db:areaset)+1"/>
  </db:area>
</xsl:template>

<xsl:template match="db:areaset/db:area">
  <db:area>
    <xsl:copy-of select="@*[name(.) != 'coords']"/>
    <xsl:attribute name="xml:id" select="parent::db:areaset/@xml:id"/>
    <xsl:if test="(not(@units)
		   or @units='linecolumn'
		   or @units='linecolumnpair')">
      <xsl:choose>
	<xsl:when test="not(contains(normalize-space(@coords), ' '))">
	  <xsl:attribute name="ghost:line" select="normalize-space(@coords)"/>
	  <xsl:attribute name="ghost:col" select="$callout.defaultcolumn"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:variable name="toks"
			select="tokenize(normalize-space(@coords), ' ')"/>
	  <xsl:attribute name="ghost:line" select="$toks[1]"/>
	  <xsl:attribute name="ghost:col" select="$toks[2]"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:attribute name="ghost:number"
		   select="count(parent::db:areaset/preceding-sibling::db:area
                             |parent::db:areaset/preceding-sibling::db:areaset)
			   + 1"/>
  </db:area>
</xsl:template>

</xsl:stylesheet>
