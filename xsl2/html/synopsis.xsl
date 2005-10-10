<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:f="http://docbook.org/xslt/ns/extension"
                xmlns:fn="http://www.w3.org/2005/04/xpath-functions"
                xmlns:h="http://www.w3.org/1999/xhtml"
                xmlns:m="http://docbook.org/xslt/ns/mode"
                xmlns:t="http://docbook.org/xslt/ns/template"
		exclude-result-prefixes="db doc f fn h m t"
                version="2.0">

<xsl:include href="oosynopsis.xsl"/>

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
	  xmlns="http://docbook.org/ns/docbook">
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

  <xsl:if test="following-sibling::db:paramdef">, </xsl:if>
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
	  xmlns="http://docbook.org/ns/docbook">
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

    <xsl:if test="db:initializer[@role='select']">
      <xsl:text> select="</xsl:text>
      <xsl:value-of select="db:initializer"/>
      <xsl:text>"</xsl:text>
    </xsl:if>

    <xsl:if test="db:type">
      <xsl:text> as="</xsl:text>
      <xsl:value-of select="db:type"/>
      <xsl:text>"</xsl:text>
    </xsl:if>

    <xsl:choose>
      <xsl:when test="db:initializer[@role='content']">
	<xsl:text>&gt;</xsl:text>
	<xsl:copy-of select="db:initializer[@role='content']/node()"/>
	<xsl:text>&lt;/xsl:with-param&gt;</xsl:text>
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>/&gt;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
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

<!-- ============================================================ -->
<!-- The following definitions match those given in the reference
     documentation for DocBook V3.0
-->

<xsl:variable name="arg.choice.opt.open.str">[</xsl:variable>
<xsl:variable name="arg.choice.opt.close.str">]</xsl:variable>
<xsl:variable name="arg.choice.req.open.str">{</xsl:variable>
<xsl:variable name="arg.choice.req.close.str">}</xsl:variable>
<xsl:variable name="arg.choice.plain.open.str"><xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="arg.choice.plain.close.str"><xsl:text> </xsl:text></xsl:variable>
<xsl:variable name="arg.choice.def.open.str">[</xsl:variable>
<xsl:variable name="arg.choice.def.close.str">]</xsl:variable>
<xsl:variable name="arg.rep.repeat.str">...</xsl:variable>
<xsl:variable name="arg.rep.norepeat.str"></xsl:variable>
<xsl:variable name="arg.rep.def.str"></xsl:variable>
<xsl:variable name="arg.or.sep"> | </xsl:variable>
<xsl:variable name="cmdsynopsis.hanging.indent">4pi</xsl:variable>

<xsl:template match="db:cmdsynopsis">
  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<xsl:template match="db:cmdsynopsis/db:command">
  <xsl:if test="preceding-sibling::*[1]">
    <br/>
  </xsl:if>
  <xsl:call-template name="inline-monoseq"/>
  <xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="db:group|db:arg" name="t:group-or-arg">
  <xsl:variable name="choice" select="@choice"/>
  <xsl:variable name="rep" select="@rep"/>
  <xsl:variable name="sepchar">
    <xsl:choose>
      <xsl:when test="ancestor-or-self::*/@sepchar">
        <xsl:value-of select="ancestor-or-self::*/@sepchar"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text> </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:if test="position()>1">
    <xsl:value-of select="$sepchar"/>
  </xsl:if>

  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <xsl:value-of select="$arg.choice.plain.open.str"/>
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.open.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.open.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.open.str"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:apply-templates/>

  <xsl:choose>
    <xsl:when test="$rep='repeat'">
      <xsl:value-of select="$arg.rep.repeat.str"/>
    </xsl:when>
    <xsl:when test="$rep='norepeat'">
      <xsl:value-of select="$arg.rep.norepeat.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.rep.def.str"/>
    </xsl:otherwise>
  </xsl:choose>

  <xsl:choose>
    <xsl:when test="$choice='plain'">
      <xsl:value-of select="$arg.choice.plain.close.str"/>
    </xsl:when>
    <xsl:when test="$choice='req'">
      <xsl:value-of select="$arg.choice.req.close.str"/>
    </xsl:when>
    <xsl:when test="$choice='opt'">
      <xsl:value-of select="$arg.choice.opt.close.str"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$arg.choice.def.close.str"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:group/db:arg">
  <xsl:variable name="choice" select="@choice"/>
  <xsl:variable name="rep" select="@rep"/>
  <xsl:if test="position()>1">
    <xsl:value-of select="$arg.or.sep"/>
  </xsl:if>
  <xsl:call-template name="t:group-or-arg"/>
</xsl:template>

<xsl:template match="db:sbr">
  <br/>
</xsl:template>

<xsl:template match="db:synopfragmentref">
  <xsl:variable name="target" select="key('id',@linkend)"/>
  <xsl:variable name="snum">
    <xsl:apply-templates select="$target" mode="m:synopfragment.number"/>
  </xsl:variable>

  <span class="{local-name(.)}">
    <a href="#{@linkend}">
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$snum"/>
      <xsl:text>)</xsl:text>
    </a>
    <xsl:text>&#160;</xsl:text>
    <xsl:apply-templates/>
  </span>
</xsl:template>

<xsl:template match="db:synopfragment" mode="m:synopfragment.number">
  <xsl:number format="1"/>
</xsl:template>

<xsl:template match="db:synopfragment">
  <div class="{local-name(.)}">
    <xsl:call-template name="id"/>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates select="." mode="m:synopfragment.number"/>
    <xsl:text>)</xsl:text>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
  </div>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
