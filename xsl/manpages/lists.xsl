<?xml version='1.0'?>
<!-- vim:set sts=2 shiftwidth=2 syntax=sgml: -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'>

<xsl:template match="para[ancestor::listitem or ancestor::step]|
	             simpara[ancestor::listitem or ancestor::step]|
		     remark[ancestor::listitem or ancestor::step]">
  <xsl:call-template name="mixed-block"/>
  <xsl:text>&#10;</xsl:text>

  <xsl:if test="following-sibling::para or
	  following-sibling::simpara or
	  following-sibling::remark">
    <!-- Make sure multiple paragraphs within a list item don't -->
    <!-- merge together.                                        -->
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="simpara[ancestor::listitem or ancestor::step]|
		     remark[ancestor::listitem or ancestor::step]">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:text>&#10;</xsl:text>
  <xsl:if test="following-sibling::para or
		following-sibling::simpara or
		following-sibling::remark">
    <!-- Make sure multiple paragraphs within a list item don't -->
    <!-- merge together.                                        -->
    <xsl:text>&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="varlistentry|glossentry">
  <xsl:text>.TP&#10;</xsl:text>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="variablelist[ancestor::listitem or ancestor::step]|
	             glosslist[ancestor::listitem or ancestor::step]">
  <xsl:text>.RS&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>.RE&#10;.IP&#10;</xsl:text>
</xsl:template>

<xsl:template match="varlistentry/term|glossterm">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:text>, </xsl:text>
</xsl:template>

<xsl:template
     match="varlistentry/term[position()=last()]|glossterm[position()=last()]"
     priority="2">
  <xsl:variable name="content">
    <xsl:apply-templates/>
  </xsl:variable>
  <xsl:value-of select="normalize-space($content)"/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="varlistentry/listitem|glossdef">
  <xsl:apply-templates/>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<xsl:template match="itemizedlist/listitem">
  <xsl:text>\(bu&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:if test="following-sibling::listitem">
    <xsl:text>.TP&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="orderedlist/listitem|procedure/step">
  <xsl:number format="1."/>
  <xsl:text>&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:if test="position()!=last()">
    <xsl:text>.TP&#10;</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="itemizedlist|orderedlist|procedure">
  <xsl:text>.TP 3&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>.LP&#10;</xsl:text>
</xsl:template>

<xsl:template match="itemizedlist[ancestor::listitem or ancestor::step]|
	             orderedlist[ancestor::listitem or ancestor::step]|
		     procedure[ancestor::listitem or ancestor::step]">
  <xsl:text>.RS&#10;.TP 3&#10;</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>.LP&#10;.RE&#10;.IP&#10;</xsl:text>
</xsl:template>

<!-- for simplelist type="inline", render it as a comma-separated list -->
<xsl:template match="simplelist[@type='inline']">

  <!-- if dbchoice PI exists, use that to determine the choice separator -->
  <!-- (that is, equivalent of "and" or "or" in current locale), or literal -->
  <!-- value of "choice" otherwise -->
  <xsl:variable name="localized-choice-separator">
    <xsl:choose>
      <xsl:when test="processing-instruction('dbchoice')">
	<xsl:call-template name="select.choice.separator"/>
      </xsl:when>
      <xsl:otherwise>
	<!-- empty -->
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:for-each select="member">
    <xsl:apply-templates/>
    <xsl:choose>
      <xsl:when test="position() = last()"/> <!-- do nothing -->
      <xsl:otherwise>
	<xsl:text>, </xsl:text>
	<xsl:if test="position() = last() - 1">
	  <xsl:if test="$localized-choice-separator != ''">
	    <xsl:value-of select="$localized-choice-separator"/>
	    <xsl:text> </xsl:text>
	  </xsl:if>
	</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

<!-- if simplelist type is not inline, render it as a one-column vertical -->
<!-- list (ignoring the values of the type and columns attributes) -->
<xsl:template match="simplelist">
  <xsl:for-each select="member">
    <xsl:text>.IP&#10;</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>&#10;</xsl:text>
  </xsl:for-each>
</xsl:template>

</xsl:stylesheet>
