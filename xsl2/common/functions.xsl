<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
                xmlns:l="http://docbook.sourceforge.net/xmlns/l10n/1.0"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="db doc f fn l m xs"
                version="2.0">

<doc:reference xmlns="http://docbook.org/docbook-ng">
<info>
<title>Common Functions Reference</title>
<author>
  <personname>
    <surname>Walsh</surname>
    <firstname>Norman</firstname>
  </personname>
</author>
<copyright><year>2004</year>
<holder>Norman Walsh</holder>
</copyright>
<releaseinfo role="cvs">
$Id$
</releaseinfo>
</info>

<partintro>
<section><title>Introduction</title>

<para>This is technical reference documentation for the DocBook XSL
Stylesheets; it documents (some of) the parameters, templates, and
other elements of the stylesheets.</para>

<para>This is not intended to be <quote>user</quote> documentation.
It is provided for developers writing customization layers for the
stylesheets, and for anyone who's interested in <quote>how it
works</quote>.</para>

<para>Although I am trying to be thorough, this documentation is known
to be incomplete. Don't forget to read the source, too :-)</para>
</section>
</partintro>
</doc:reference>

<!-- ============================================================ -->

<doc:function name="f:node-id" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Returns an ID for the specified node</refpurpose>

<refdescription>
<para>This function returns the <tag class="attribute">id</tag> or
<tag class="attribute">xml:id</tag> of the specified node. If the
node does not have an ID, the XSLT
<function>fn:generate-id()</function> function is used to create one.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which an ID will be generated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>Returns the ID.</para>
</refreturn>
</doc:function>

<xsl:function name="f:node-id" as="xs:string">
  <xsl:param name="node" as="node()"/>
  
  <xsl:choose>
    <xsl:when test="$node/@xml:id">
      <xsl:value-of select="$node/@xml:id"/>
    </xsl:when>
    <xsl:when test="$node/@id">
      <xsl:value-of select="$node/@id"/>
    </xsl:when>
    <xsl:when test="$persistent.generated.ids != 0">
      <xsl:variable name="xpid" select="f:xptr-id($node)"/>
      <xsl:choose>
	<xsl:when test="$xpid = '' or $node/key('id', $xpid)">
	  <xsl:value-of select="generate-id($node)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="$xpid"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="generate-id($node)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="f:xptr-id" as="xs:string">
  <xsl:param name="node" as="element()"/>

  <xsl:choose>
    <xsl:when test="$node/@xml:id">
      <xsl:value-of select="$node/@xml:id"/>
    </xsl:when>
    <xsl:when test="$node/@id">
      <xsl:value-of select="$node/@id"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of>
	<xsl:choose>
	  <xsl:when test="not($node/parent::*)">R.</xsl:when>
	  <xsl:otherwise>
	    <xsl:value-of select="concat(f:xptr-id($node/parent::*), '.')"/>
	  </xsl:otherwise>
	</xsl:choose>
	<xsl:value-of select="count($node/preceding-sibling::*)+1"/>
      </xsl:value-of>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:orderedlist-starting-number"
	      xmlns="http://docbook.org/docbook-ng">
<refpurpose>Returns the number of the first item in an ordered list</refpurpose>

<refdescription>
<para>This function returns the number of the first item in an
<tag>orderedlist</tag>.
</para>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>list</term>
<listitem>
<para>The <tag>orderedlist</tag> element for which the starting number
is to be determined.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>Returns the starting list number.</para>
</refreturn>
</doc:function>

<xsl:function name="f:orderedlist-starting-number" as="xs:integer">
  <xsl:param name="list" as="element(db:orderedlist)"/>

  <xsl:variable name="pi-start"
		select="f:pi($list/processing-instruction('db-xsl'), 'start')"/>

  <xsl:choose>
    <xsl:when test="$pi-start">
      <xsl:value-of select="$pi-start cast as xs:integer"/>
    </xsl:when>
    <xsl:when test="not($list/@continuation = 'continues')">
      <xsl:value-of select="1"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="prevlist"
		    select="$list/preceding::db:orderedlist[1]"/>
      <xsl:choose>
	<xsl:when test="count($prevlist) = 0">
	  <xsl:value-of select="1"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:variable name="prevlength" select="count($prevlist/db:listitem)"/>
	  <xsl:variable name="prevstart"
			select="f:orderedlist-starting-number($prevlist)"/>
	  <xsl:value-of select="$prevstart + $prevlength"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:param name="orderedlist.numeration.styles"
	   select="('arabic',
		    'loweralpha', 'lowerroman',
                    'upperalpha', 'upperroman')"/>

<xsl:function name="f:next-orderedlist-numeration" as="xs:string">
  <xsl:param name="numeration" as="xs:string"/>

  <xsl:variable name="pos" select="fn:index-of($orderedlist.numeration.styles,
                                               $numeration)[1]"/>

  <xsl:choose>
    <xsl:when test="not($pos)">
      <xsl:value-of select="$orderedlist.numeration.styles[1]"/>
    </xsl:when>
    <xsl:when test="fn:subsequence($orderedlist.numeration.styles,$pos+1,1)">
      <xsl:value-of select="fn:subsequence($orderedlist.numeration.styles,
			                   $pos+1,1)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$orderedlist.numeration.styles[1]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="f:orderedlist-numeration" as="xs:string">
  <xsl:param name="list" as="element(db:orderedlist)"/>

  <xsl:choose>
    <xsl:when test="$list/@numeration">
      <xsl:value-of select="$list/@numeration"/>
    </xsl:when>
    <xsl:when test="$list/ancestor::db:orderedlist">
      <xsl:variable name="prevnumeration"
		    select="f:orderedlist-numeration($list/ancestor::db:orderedlist[1])"/>
      <xsl:value-of select="f:next-orderedlist-numeration($prevnumeration)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$orderedlist.numeration.styles[1]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="f:orderedlist-item-number" as="xs:integer">
  <xsl:param name="node" as="element(db:listitem)"/>

  <xsl:choose>
    <xsl:when test="$node/@override">
      <xsl:value-of select="$node/@override"/>
    </xsl:when>

    <xsl:when test="$node/preceding-sibling::db:listitem">
      <xsl:value-of select="f:orderedlist-item-number($node/preceding-sibling::db:listitem[1]) + 1"/>
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="f:orderedlist-starting-number(parent::db:orderedlist)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="f:next-itemizedlist-symbol" as="xs:string">
  <xsl:param name="symbol"/>

  <xsl:variable name="pos" select="fn:index-of($itemizedlist.numeration.symbols,
                                               $symbol)[1]"/>

  <xsl:choose>
    <xsl:when test="not($pos)">
      <xsl:value-of select="$itemizedlist.numeration.symbols[1]"/>
    </xsl:when>
    <xsl:when test="fn:subsequence($itemizedlist.numeration.symbols,$pos+1,1)">
      <xsl:value-of select="fn:subsequence($itemizedlist.numeration.symbols,
			                   $pos+1,1)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$itemizedlist.numeration.symbols[1]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="f:itemizedlist-symbol" as="xs:string">
  <xsl:param name="node" as="element(db:listitem)"/>

  <xsl:choose>
    <xsl:when test="$node/@mark">
      <xsl:value-of select="$node/@mark"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:choose>
        <xsl:when test="$node/ancestor::itemizedlist">
	  <xsl:value-of select="f:next-itemizedlist-symbol(f:itemized-list-symbol($node/ancestor::db:itemizedlist[1]))"/>
	</xsl:when>
        <xsl:otherwise>
	  <xsl:value-of select="f:next-itemizedlist-symbol('default')"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<xsl:function name="f:pi" as="xs:string?">
  <xsl:param name="pis" as="processing-instruction()*"/>
  <xsl:param name="attribute" as="xs:string"/>

  <xsl:choose>
    <xsl:when test="not($pis)"/>
    <xsl:otherwise>
      <xsl:variable name="pivalue">
	<xsl:value-of select="concat(' ', normalize-space($pis[1]))"/>
      </xsl:variable>

      <xsl:choose>
	<xsl:when test="contains($pivalue,concat(' ', $attribute, '='))">
	  <xsl:variable name="rest"
			select="substring-after($pivalue,
				                concat(' ', $attribute,'='))"/>
	  <xsl:variable name="quote" select="substring($rest,1,1)"/>
	  <xsl:value-of select="substring-before(substring($rest,2),$quote)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:value-of select="f:pi($pis[position() &gt; 1], $attribute)"/>
	</xsl:otherwise>
      </xsl:choose>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<xsl:function name="f:dingbat" as="xs:string">
  <xsl:param name="context" as="node()"/>
  <xsl:param name="dingbat" as="xs:string"/>

  <xsl:variable name="lang">
    <xsl:call-template name="l10n.language">
      <xsl:with-param name="target" select="$context"/>
      <xsl:with-param name="xref-context" select="false()"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:value-of select="f:dingbat($context, $dingbat, $lang)"/>
</xsl:function>

<xsl:function name="f:dingbat" as="xs:string">
  <xsl:param name="context" as="node()"/>
  <xsl:param name="dingbat" as="xs:string"/>
  <xsl:param name="lang" as="xs:string"/>

  <xsl:variable name="l10n.dingbat"
                select="($localization
			 //l:l10n[@language=$lang]
			 /l:dingbat[@key=$dingbat])[1]"/>

  <xsl:choose>
    <xsl:when test="$l10n.dingbat">
      <xsl:value-of select="$l10n.dingbat/@text"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>No "</xsl:text>
        <xsl:value-of select="$lang"/>
        <xsl:text>" localization of dingbat </xsl:text>
        <xsl:value-of select="$dingbat"/>
        <xsl:text> exists; using "en".</xsl:text>
      </xsl:message>
      <xsl:value-of select="($localization
			     //l:l10n[@language='en']
			     /l:dingbat[@key=$dingbat])[1]"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<doc:function name="f:xpath-location" xmlns="http://docbook.org/docbook-ng">
<refpurpose>Returns a pseudo-XPath expression locating the specified node</refpurpose>

<refdescription>
<para>This function returns a psuedo-XPath expression that navigates from
the root of the document to the specified node.</para>

<warning>
<para>The XPath returned
uses only the <function>local-name</function> of the node so it relies
on the default namespace. For a mixed-namespace document, this may simply
be impossible.</para>
</warning>
</refdescription>

<refparameter>
<variablelist>
<varlistentry><term>node</term>
<listitem>
<para>The node for which a pseudo-XPath will be generated.</para>
</listitem>
</varlistentry>
</variablelist>
</refparameter>

<refreturn>
<para>Returns the pseudo-XPath.</para>
</refreturn>
</doc:function>

<xsl:function name="f:xpath-location" as="xs:string">
  <xsl:param name="node" as="element()"/>

  <xsl:value-of select="f:xpath-location($node, '')"/>
</xsl:function>

<xsl:function name="f:xpath-location" as="xs:string">
  <xsl:param name="node" as="element()"/>
  <xsl:param name="path" as="xs:string"/>

  <xsl:variable name="next.path">
    <xsl:value-of select="local-name($node)"/>
    <xsl:if test="$path != ''">/</xsl:if>
    <xsl:value-of select="$path"/>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$node/parent::*">
      <xsl:value-of select="f:xpath-location($node/parent::*, $next.path)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="concat('/', $next.path)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ====================================================================== -->

<xsl:function name="f:is-component" as="xs:boolean">
  <xsl:param name="node" as="element()"/>

  <xsl:value-of select="if ($node/self::db:appendix
			    | $node/self::db:article
			    | $node/self::db:chapter
			    | $node/self::db:preface
			    | $node/self::db:bibliography
			    | $node/self::db:glossary
			    | $node/self::db:index)
			then true()
			else false()"/>
</xsl:function>

<!-- ====================================================================== -->

<xsl:function name="f:is-section" as="xs:boolean">
  <xsl:param name="node" as="element()"/>

  <xsl:value-of select="if ($node/self::db:section
			    | $node/self::db:sect1
			    | $node/self::db:sect2
			    | $node/self::db:sect3
			    | $node/self::db:sect4
			    | $node/self::db:sect5
			    | $node/self::db:refsect1
			    | $node/self::db:refsect2
			    | $node/self::db:refsect3
			    | $node/self::db:simplesect)
			 then true()
			 else false()"/>
</xsl:function>

<!-- ============================================================ -->

<xsl:function name="f:label-this-section" as="xs:boolean">
  <xsl:param name="section" as="element()"/>

  <xsl:choose>
    <xsl:when test="f:section-level($section)
		    &lt;= $section.autolabel.max.depth">
      <xsl:value-of select="$section.autolabel != 0"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="false()"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<xsl:function name="f:section-level" as="xs:integer">
  <xsl:param name="node" as="element()"/>

  <xsl:choose>
    <xsl:when test="$node/self::db:sect1">1</xsl:when>
    <xsl:when test="$node/self::db:sect2">2</xsl:when>
    <xsl:when test="$node/self::db:sect3">3</xsl:when>
    <xsl:when test="$node/self::db:sect4">4</xsl:when>
    <xsl:when test="$node/self::db:sect5">5</xsl:when>
    <xsl:when test="$node/self::db:section">
      <xsl:choose>
	<xsl:when test="$node/../../../../../../db:section">6</xsl:when>
        <xsl:when test="$node/../../../../../db:section">5</xsl:when>
        <xsl:when test="$node/../../../../db:section">4</xsl:when>
        <xsl:when test="$node/../../../db:section">3</xsl:when>
        <xsl:when test="$node/../../db:section">2</xsl:when>
	<xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$node/self::db:refsect1 or
                    $node/self::db:refsect2 or
                    $node/self::db:refsect3 or
                    $node/self::db:refsection or
                    $node/self::db:refsynopsisdiv">
      <xsl:value-of select="f:refentry-section-level($node)"/>
    </xsl:when>
    <xsl:when test="$node/self::db:simplesect">
      <xsl:choose>
        <xsl:when test="$node/../../db:sect1">2</xsl:when>
        <xsl:when test="$node/../../db:sect2">3</xsl:when>
        <xsl:when test="$node/../../db:sect3">4</xsl:when>
        <xsl:when test="$node/../../db:sect4">5</xsl:when>
        <xsl:when test="$node/../../db:sect5">5</xsl:when>
        <xsl:when test="$node/../../db:section">
          <xsl:choose>
            <xsl:when test="$node/../../../../../db:section">5</xsl:when>
            <xsl:when test="$node/../../../../db:section">4</xsl:when>
            <xsl:when test="$node/../../../db:section">3</xsl:when>
            <xsl:otherwise>2</xsl:otherwise>
          </xsl:choose>
        </xsl:when>
        <xsl:otherwise>1</xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<xsl:function name="f:qanda-section-level" as="xs:integer">
  <xsl:param name="node" as="element()"/>

  <xsl:variable name="section"
		select="($node/ancestor::db:section
			 |$node/ancestor::db:simplesect
                         |$node/ancestor::db:sect5
                         |$node/ancestor::db:sect4
                         |$node/ancestor::db:sect3
                         |$node/ancestor::db:sect2
                         |$node/ancestor::db:sect1
                         |$node/ancestor::db:refsect3
                         |$node/ancestor::db:refsect2
                         |$node/ancestor::db:refsect1)[last()]"/>

  <xsl:choose>
    <xsl:when test="count($section) = 0">1</xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="f:section-level($section) + 1"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->

<!-- Finds the total section depth of a section in a refentry -->
<xsl:function name="f:refentry-section-level" as="xs:integer">
  <xsl:param name="node" as="element()"/>

  <xsl:variable name="RElevel"
		select="f:refentry-level($node/ancestor::db:refentry[1])"/>

  <xsl:variable name="levelinRE" as="xs:integer">
    <xsl:choose>
      <xsl:when test="$node/self::db:refsynopsisdiv">1</xsl:when>
      <xsl:when test="$node/self::db:refsect1">1</xsl:when>
      <xsl:when test="$node/self::db:refsect2">2</xsl:when>
      <xsl:when test="$node/self::db:refsect3">3</xsl:when>
      <xsl:when test="$node/self::db:refsection">
        <xsl:choose>
          <xsl:when test="$node/../../../../../db:refsection">5</xsl:when>
          <xsl:when test="$node/../../../../db:refsection">4</xsl:when>
          <xsl:when test="$node/../../../db:refsection">3</xsl:when>
          <xsl:when test="$node/../../db:refsection">2</xsl:when>
          <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:variable>

  <xsl:value-of select="$levelinRE + $RElevel"/>
</xsl:function>

<!-- ============================================================ -->

<!-- Finds the section depth of a refentry -->
<xsl:function name="f:refentry-level" as="xs:integer">
  <xsl:param name="node" as="element()"/>

  <xsl:variable name="container"
                select="($node/ancestor::db:section
                         | $node/ancestor::db:sect1
			 | $node/ancestor::db:sect2
			 | $node/ancestor::db:sect3
			 | $node/ancestor::db:sect4
			 | $node/ancestor::db:sect5)[last()]"/>

  <xsl:choose>
    <xsl:when test="$container">
      <xsl:value-of select="f:section-level($container) + 1"/>
    </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
  </xsl:choose>
</xsl:function>

</xsl:stylesheet>
