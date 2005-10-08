<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:u="http://nwalsh.com/xsl/unittests#"
                xmlns:f="http://docbook.org/xslt/ns/extension"
		version="2.0">

<xsl:param name="show.borders" select="0"/>

<xsl:template match="/" mode="tohtml">
  <xsl:apply-templates mode="tohtml"/>
</xsl:template>

<xsl:template match="*" mode="tohtml">
  <xsl:param name="rootdepth" select="2"/>
  <xsl:variable name="depth" select="count(ancestor::*) - $rootdepth"/>

  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="name(.)"/>

  <xsl:for-each select="@*">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name(.)"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
  </xsl:for-each>
  <xsl:choose>
    <xsl:when test="node()">
      <xsl:text>&gt;</xsl:text>

      <xsl:value-of select="if (*) then f:indent-html('.',$depth) else ''"/>

      <xsl:apply-templates mode="tohtml"/>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="name(.)"/>
      <xsl:text>&gt;</xsl:text>

      <xsl:value-of select="if (following-sibling::*)
			    then f:indent-html(',',$depth - 1)
			    else f:indent-html(',',$depth - 2)"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:text>/&gt;</xsl:text>
      <xsl:value-of select="if (following-sibling::*)
			    then f:indent-html(';',$depth - 1)
			    else f:indent-html(';',$depth - 2)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="u:param" mode="tohtml" priority="100">
  <xsl:param name="nameattr"/>

  <xsl:choose>
    <xsl:when test="@select and not(*)">
      <pre>
	<xsl:text>$</xsl:text>
	<xsl:value-of select="$nameattr"/>
	<xsl:text> ::= </xsl:text>
	<xsl:value-of select="@select"/>
      </pre>
    </xsl:when>
    <xsl:when test="* or @*">
      <table border="{$show.borders}">
	<tr>
	  <td align="left" valign="top">
	    <code>
	      <xsl:text>$</xsl:text>
	      <xsl:value-of select="$nameattr"/>
	      <xsl:text>&#xa0;::=&#xa0;</xsl:text>
	    </code>
	  </td>
	  <td align="left" valign="top">
	    <pre>
	      <xsl:apply-templates mode="tohtml">
		<xsl:with-param name="rootdepth" select="3"/>
	      </xsl:apply-templates>
	    </pre>
	  </td>
	</tr>
      </table>
    </xsl:when>
    <xsl:otherwise>
      <pre>
	<xsl:text>$</xsl:text>
	<xsl:value-of select="$nameattr"/>
	<xsl:text> ::= </xsl:text>
	<xsl:text>'</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>'</xsl:text>
      </pre>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="u:variable" mode="tohtml" priority="100">
  <table border="{$show.borders}">
    <tr>
      <td align="left" valign="top">
	<code>
	  <xsl:text>$</xsl:text>
	  <xsl:value-of select="@name"/>
	  <xsl:text>&#xa0;::=&#xa0;</xsl:text>
	</code>
      </td>
      <td align="left" valign="top">
	<pre>
	  <xsl:apply-templates mode="tohtml">
	    <xsl:with-param name="rootdepth" select="3"/>
	  </xsl:apply-templates>
	</pre>
      </td>
    </tr>
  </table>
</xsl:template>

<xsl:template match="comment()" mode="tohtml">
  <xsl:text>&lt;!--</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>--&gt;</xsl:text>
</xsl:template>

<xsl:template match="processing-instruction()" mode="tohtml">
  <xsl:text>&lt;?</xsl:text>
  <xsl:value-of select="."/>
  <xsl:text>?&gt;</xsl:text>
</xsl:template>

<xsl:template match="text()" mode="tohtml">
  <xsl:value-of select="."/>
</xsl:template>

<xsl:function name="f:indent-html">
  <xsl:param name="char"/>
  <xsl:param name="depth"/>

  <xsl:text>&#10;</xsl:text>
  <xsl:value-of select="for $p in (1 to $depth) return '  '"/>
</xsl:function>

</xsl:stylesheet>
