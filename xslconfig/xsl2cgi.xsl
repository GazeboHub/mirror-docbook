<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version="1.0">

<xsl:import href="../html/docbook.xsl"/>

<xsl:strip-space elements="xsl:param"/>

<xsl:output method="html"
            indent="yes"/>

<xsl:template match="xsl:*"/>

<xsl:template match="/">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="xsl:stylesheet">
  <html>
    <head>
      <title>Stylesheet Customization Form</title>
    </head>
    <body bgcolor="#FFFFFF" text="#000000">
      <h1>Stylesheet Customization Form</h1>
      <p>[BETA TEST]</p>
      <p>This form builds a custom stylesheet driver based on the options
      you choose.</p>
      <form action="/cgi-bin/xslcustomizer" method="post">
        <p><b>Path to docbook.xsl</b> &#8212; Path to the DocBook stylesheet
        to which the generated customization layer applies.</p>
        <p><input type="text" value="http://nwalsh.com/xsl/docbook/html/docbook.xsl" name="base.stylesheet" size="60"/></p>
         <p>This is the path name that will be used in the xsl:import
         statement that is used at the top of this customization layer.</p>

         <xsl:apply-templates select="xsl:param"/>
         <hr/>
         <input type="submit" value="Build Customization Layer"/>
      </form>
    </body>
  </html>
</xsl:template>

<xsl:template match="xsl:param[@doc:type]">
  <xsl:variable name="name" select="@name"/>
  <xsl:variable name="rawvalue">
    <xsl:choose>
      <xsl:when test="@select">
        <xsl:value-of select="@select"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="value">
    <xsl:value-of select="$rawvalue"/>
  </xsl:variable>

  <xsl:variable name="desc" select="//doc:param[@name=$name][1]"/>

  <hr/>

  <xsl:choose>
    <xsl:when test="@doc:type='string'">
      <p>
        <b><xsl:value-of select="@name"/></b>
        <xsl:apply-templates select="$desc/refpurpose"/>
      </p>
      <p>
        <input type="text" value="{$value}" name="{@name}" size="60"/>
      </p>
    </xsl:when>
    <xsl:when test="@doc:type='uri'">
      <p>
        <b><xsl:value-of select="@name"/></b>
        <xsl:apply-templates select="$desc/refpurpose"/>
      </p>
      <p>
        <input type="text" value="{$value}" name="{@name}" size="60"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@doc:type"/>
        <xsl:text>)</xsl:text>
      </p>
    </xsl:when>
    <xsl:when test="@doc:type='length'">
      <p>
        <b><xsl:value-of select="@name"/></b>
        <xsl:apply-templates select="$desc/refpurpose"/>
      </p>
      <p>
        <input type="text" value="{$value}" name="{@name}" size="60"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@doc:type"/>
        <xsl:text>)</xsl:text>
      </p>
    </xsl:when>
    <xsl:when test="@doc:type='boolean'">
      <p>
        <input type="checkbox" value="1" name="{@name}">
          <xsl:if test="$value != '' and $value != '0'">
            <xsl:attribute name="checked">on</xsl:attribute>
          </xsl:if>
        </input>
        <xsl:text> </xsl:text>
        <b><xsl:value-of select="@name"/></b>
        <xsl:apply-templates select="$desc/refpurpose"/>
      </p>
    </xsl:when>
    <xsl:when test="@doc:type='integer'">
      <p>
        <b><xsl:value-of select="@name"/></b>
        <xsl:apply-templates select="$desc/refpurpose"/>
      </p>
      <p>
        <input type="text" value="{$value}" name="{@name}"
               size="5" maxlength="15"/>
        <xsl:text> (</xsl:text>
        <xsl:value-of select="@doc:type"/>
        <xsl:text>)</xsl:text>
      </p>
    </xsl:when>
    <xsl:when test="@doc:type='list'">
      <p>
        <b><xsl:value-of select="@name"/></b>
        <xsl:text>: </xsl:text>
        <select name="{@name}" size="1">
          <xsl:call-template name="options">
            <xsl:with-param name="list" select="@doc:list"/>
            <xsl:with-param name="selected" select="$value"/>
          </xsl:call-template>
        </select>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="$value"/>
        <xsl:text>)</xsl:text>
        <xsl:text> </xsl:text>
        <xsl:apply-templates select="$desc/refpurpose"/>
      </p>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>
        <xsl:text>Unexpected doc:type=</xsl:text>
        <xsl:value-of select="@doc:type"/>
      </xsl:message>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:apply-templates select="$desc/refdescription/*"/>
</xsl:template>

<xsl:template name="options">
  <xsl:param name="list" select="''"/>
  <xsl:param name="selected" select="''"/>

  <xsl:variable name="value">
    <xsl:choose>
      <xsl:when test="substring-before($list,' ')">
        <xsl:value-of select="substring-before($list,' ')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$list"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="substring-before($list,' ')">
      <option value="{substring-before($list,' ')}">
        <xsl:if test="$selected=$value">
          <xsl:attribute name="selected">selected</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="substring-before($list,' ')"/>
      </option>
      <xsl:call-template name="options">
        <xsl:with-param name="list"
                        select="substring-after($list, ' ')"/>
        <xsl:with-param name="selected" select="$selected"/>
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <option value="{$list}">
        <xsl:if test="$selected=$value">
          <xsl:attribute name="selected">selected</xsl:attribute>
        </xsl:if>
        <xsl:value-of select="$list"/>
      </option>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
