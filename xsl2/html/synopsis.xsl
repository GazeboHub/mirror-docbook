<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
		exclude-result-prefixes="db doc f fn h m t"
                version="2.0">

<xsl:template match="db:refsynopsis">
  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>
    
<xsl:template match="db:funcsynopsis">
  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:funcprototype">
  <xsl:choose>
    <xsl:when test="../@language='xslt2-function'">
      <xsl:apply-templates select="." mode="m:funcprototype-xslt2-function"/>
    </xsl:when>
    <xsl:when test="../@language='xslt2-template'">
      <xsl:apply-templates select="." mode="m:funcprototype-xslt2-template"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:message>Unknown language (<xsl:value-of select="../@language"/>) on db:funcsynopsis.</xsl:message>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:funcprototype-xslt2-function"
	  xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for formatting XSLT 2.0 function prototypes</refpurpose>

<refdescription>
<para>This mode is used to format XSLT 2.0 function prototypes.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:funcprototype" mode="m:funcprototype-xslt2-function">
  <xsl:apply-templates select="db:funcdef/db:function"
		       mode="m:funcprototype-xslt2-function"/>
  <xsl:text>(</xsl:text>
  <xsl:apply-templates select="db:paramdef" mode="m:funcprototype-xslt2-function"/>
  <xsl:text>)</xsl:text>
  <xsl:if test="db:funcdef/db:type">
    <xsl:text> as </xsl:text>
    <xsl:apply-templates select="db:funcdef/db:type"
			 mode="m:funcprototype-xslt2-function"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:function" mode="m:funcprototype-xslt2-function">
  <strong class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates mode="m:funcprototype-xslt2-function"/>
  </strong>
</xsl:template>

<xsl:template match="db:type" mode="m:funcprototype-xslt2-function">
  <em class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates mode="m:funcprototype-xslt2-function"/>
  </em>
</xsl:template>

<xsl:template match="db:paramdef" mode="m:funcprototype-xslt2-function">
  <xsl:apply-templates select="db:parameter"
		       mode="m:funcprototype-xslt2-function"/>
  <xsl:if test="db:type">
    <xsl:text> as </xsl:text>
    <xsl:apply-templates select="db:type"
			 mode="m:funcprototype-xslt2-function"/>
  </xsl:if>
</xsl:template>

<xsl:template match="db:parameter" mode="m:funcprototype-xslt2-function">
  <span class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates mode="m:funcprototype-xslt2-function"/>
  </span>
</xsl:template>

<!-- ============================================================ -->

<doc:mode name="m:funcprototype-xslt2-template"
	  xmlns="http://docbook.org/docbook-ng">
<refpurpose>Mode for formatting XSLT 2.0 named templates</refpurpose>

<refdescription>
<para>This mode is used to format XSLT 2.0 named templates.</para>
</refdescription>
</doc:mode>

<xsl:template match="db:funcprototype" mode="m:funcprototype-xslt2-template">
  <pre class="{local-name(.)}">
    <xsl:call-template name="id"/>

    <xsl:text>&lt;xsl:call-template name="</xsl:text>
    <xsl:value-of select="db:funcdef/db:function"/>
    <xsl:text>"</xsl:text>
    <xsl:if test="db:funcdef/db:type">
      <xsl:text> as="</xsl:text>
      <xsl:value-of select="db:funcdef/db:type"/>
      <xsl:text>"</xsl:text>
    </xsl:if>
    <xsl:text>&gt;&#10;</xsl:text>

    <xsl:apply-templates select="db:paramdef"
			 mode="m:funcprototype-xslt2-template"/>

    <xsl:text>&lt;/xsl:call-template&gt;</xsl:text>
  </pre>
</xsl:template>

<xsl:template match="db:paramdef" mode="m:funcprototype-xslt2-template">
  <xsl:variable name="with-param">
    <xsl:text>&lt;xsl:with-param name="</xsl:text>
    <xsl:value-of select="db:parameter"/>
    <xsl:text>"</xsl:text>
    <xsl:if test="db:type">
      <xsl:text> as="</xsl:text>
      <xsl:value-of select="db:funcdef/db:type"/>
      <xsl:text>"</xsl:text>
    </xsl:if>
    <xsl:text>/&gt;</xsl:text>
  </xsl:variable>

  <xsl:text>   </xsl:text>
  <xsl:choose>
    <xsl:when test="@role = 'recursive'">
      <i>
	<xsl:copy-of select="$with-param"/>
      </i>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$with-param"/>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:text>&#10;</xsl:text>
</xsl:template>

</xsl:stylesheet>
