<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:n="http://docbook.org/xslt/ns/normalize"
		xmlns:fn="http://www.w3.org/2003/11/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="f m n fn xs"
                version="2.0">

<!-- ============================================================ -->
<!-- normalize content -->

<xsl:variable name="external.glossary">
  <xsl:choose>
    <xsl:when test="$glossary.collection = ''">
      <xsl:value-of select="()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="document($glossary.collection)"
			   mode="m:cleanup"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:template match="/" mode="m:normalize">
  <xsl:apply-templates mode="m:normalize"/>
</xsl:template>

<xsl:template match="*[not(self::db:info)
		       and db:title|db:subtitle|db:titleabbrev|db:info]"
	      mode="m:normalize">
  <xsl:call-template name="n:normalize-movetitle"/>
</xsl:template>

<xsl:template name="n:normalize-movetitle">
  <xsl:copy>
    <xsl:copy-of select="@*"/>

    <xsl:choose>
      <xsl:when test="db:info">
	<xsl:apply-templates mode="m:normalize"/>
      </xsl:when>
      <xsl:when test="db:title|db:subtitle|db:titleabbrev">
	<xsl:element name="info" namespace="{$docbook-namespace}">
	  <xsl:call-template name="n:normalize-dbinfo">
	    <xsl:with-param name="copynodes"
			    select="db:title|db:subtitle|db:titleabbrev"/>
	  </xsl:call-template>
	</xsl:element>
	<xsl:apply-templates mode="m:normalize"/>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates mode="m:normalize"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:copy>
</xsl:template>

<xsl:template match="db:title|db:subtitle|db:titleabbrev" mode="m:normalize">
  <xsl:if test="parent::db:info">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="m:normalize"/>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template match="db:bibliography" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="'Bibliography'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:glossary" mode="m:normalize">
  <xsl:variable name="glossary">
    <xsl:call-template name="n:normalize-generated-title">
      <xsl:with-param name="title-key" select="'Glossary'"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$glossary/db:glossary[@role='auto']">
      <xsl:if test="not($external.glossary)">
	<xsl:message>
	  <xsl:text>Warning: processing automatic glossary </xsl:text>
	  <xsl:text>without an external glossary.</xsl:text>
	</xsl:message>
      </xsl:if>

      <xsl:element name="db:glossary">
	<xsl:for-each select="$glossary/db:glossary/@*">
	  <xsl:if test="name(.) != 'role'">
	    <xsl:copy-of select="."/>
	  </xsl:if>
	</xsl:for-each>
	<xsl:copy-of select="$glossary/db:glossary/db:info"/>

	<xsl:variable name="divs"
		      select="$glossary//db:glossary/db:glossdiv"/>

	<xsl:choose>
	  <xsl:when test="$divs and $external.glossary//db:glossdiv">
	    <xsl:apply-templates select="$external.glossary//db:glossdiv"
				 mode="m:copy-external-glossary">
	      <xsl:with-param name="terms"
			      select="//db:glossterm[not(parent::db:glossdef)]
				      |//db:firstterm"/>
	      <xsl:with-param name="divs" select="$divs"/>
	    </xsl:apply-templates>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:apply-templates select="$external.glossary//db:glossentry"
				 mode="m:copy-external-glossary">
	      <xsl:with-param name="terms"
			      select="//db:glossterm[not(parent::db:glossdef)]
				      |//db:firstterm"/>
	      <xsl:with-param name="divs" select="$divs"/>
	    </xsl:apply-templates>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy-of select="$glossary"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:index" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="'Index'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:setindex" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="'Set Index'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:abstract" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="'Abstract'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:legalnotice" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="'LegalNotice'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:note" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="'Note'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:tip" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="'Tip'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:caution" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="'Caution'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:warning" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="'Warning'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:important" mode="m:normalize">
  <xsl:call-template name="n:normalize-generated-title">
    <xsl:with-param name="title-key" select="'Important'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template name="n:normalize-generated-title">
  <xsl:param name="title-key"/>

  <xsl:choose>
    <xsl:when test="db:title|db:info/db:title">
      <xsl:call-template name="n:normalize-movetitle"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
	<xsl:copy-of select="@*"/>

	<xsl:choose>
	  <xsl:when test="db:info">
	    <xsl:apply-templates select="db:info//preceding-sibling::*"/>
	    <xsl:element name="info" namespace="{$docbook-namespace}">
	      <xsl:copy-of select="db:info/@*"/>
	      <xsl:element name="title" namespace="{$docbook-namespace}">
		<xsl:call-template name="gentext">
		  <xsl:with-param name="key" select="$title-key"/>
		</xsl:call-template>
	      </xsl:element>
	      <xsl:apply-templates select="db:info/*"/>
	    </xsl:element>
	    <xsl:apply-templates select="db:info//following-sibling::*"/>
	  </xsl:when>
	  <xsl:otherwise>
	    <xsl:variable name="node-tree">
	      <xsl:element name="title" namespace="{$docbook-namespace}">
		<xsl:call-template name="gentext">
		  <xsl:with-param name="key" select="$title-key"/>
		</xsl:call-template>
	      </xsl:element>
	    </xsl:variable>

	    <xsl:element name="info" namespace="{$docbook-namespace}">
	      <xsl:call-template name="n:normalize-dbinfo">
		<xsl:with-param name="copynodes" select="$node-tree/*"/>
	      </xsl:call-template>
	    </xsl:element>
	    <xsl:apply-templates mode="m:normalize"/>
	  </xsl:otherwise>
	</xsl:choose>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="db:info" mode="m:normalize">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:call-template name="n:normalize-dbinfo"/>
  </xsl:copy>
</xsl:template>

<xsl:template name="n:normalize-dbinfo">
  <xsl:param name="copynodes"/>

  <xsl:for-each select="$copynodes">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="m:normalize"/>
    </xsl:copy>
  </xsl:for-each>

  <xsl:if test="self::db:info">
    <xsl:apply-templates mode="m:normalize"/>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="m:normalize">
  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="m:normalize"/>
  </xsl:copy>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="m:normalize">
  <xsl:copy/>
</xsl:template>
  
<!-- ============================================================ -->
<!-- fix namespace -->

<xsl:template match="/" mode="m:fixnamespace">
  <xsl:choose>
    <xsl:when test="namespace-uri(*[1]) = $docbook-namespace">
      <xsl:copy-of select="."/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="m:fixnamespace"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="*" mode="m:fixnamespace">
  <xsl:choose>
    <xsl:when test="namespace-uri(.) = ''">
      <xsl:element name="{local-name(.)}" namespace="{$docbook-namespace}">
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="m:fixnamespace"/>
      </xsl:element>
    </xsl:when>
    <xsl:otherwise>
      <xsl:copy>
	<xsl:copy-of select="@*"/>
	<xsl:apply-templates mode="m:fixnamespace"/>
      </xsl:copy>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="comment()|processing-instruction()|text()"
	      mode="m:fixnamespace">
  <xsl:copy/>
</xsl:template>

<!-- ============================================================ -->
<!-- profile content -->

<xsl:template match="/" mode="m:profile">
  <xsl:apply-templates mode="m:profile"/>
</xsl:template>

<xsl:template match="*" mode="m:profile">
  <xsl:if test="f:profile-ok(@arch, $profile.arch)
                and f:profile-ok(@condition, $profile.condition)
                and f:profile-ok(@conformance, $profile.conformance)
                and f:profile-ok(@lang, $profile.lang)
                and f:profile-ok(@os, $profile.os)
                and f:profile-ok(@revision, $profile.revision)
                and f:profile-ok(@revisionflag, $profile.revisionflag)
                and f:profile-ok(@role, $profile.role)
                and f:profile-ok(@security, $profile.security)
                and f:profile-ok(@userlevel, $profile.userlevel)
                and f:profile-ok(@vendor, $profile.vendor)
		and f:profile-attribute-ok($profile.attribute, $profile.value)">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="m:profile"/>
    </xsl:copy>
  </xsl:if>
</xsl:template>

<xsl:template match="text()|comment()|processing-instruction()"
	      mode="m:profile">
  <xsl:copy/>
</xsl:template>

<xsl:function name="f:profile-ok" as="xs:boolean">
  <xsl:param name="attr" as="attribute()?"/>
  <xsl:param name="prof" as="xs:string?"/>

  <xsl:choose>
    <xsl:when test="not($attr) or not($prof)">
      <xsl:value-of select="true()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:variable name="node-values"
		    select="fn:tokenize($attr, $profile.separator)"/>
      <xsl:variable name="profile-values"
		    select="fn:tokenize($prof, $profile.separator)"/>

      <!--
      <xsl:message>
	<xsl:text>profile </xsl:text>
	<xsl:value-of select="name($attr)"/>
	<xsl:text>: </xsl:text>
	<xsl:value-of select="$node-values" separator=" "/>
	<xsl:text>=?=</xsl:text>
	<xsl:value-of select="$profile-values" separator=" "/>
      </xsl:message>
      -->

      <xsl:value-of select="$node-values = $profile-values"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<xsl:function name="f:profile-attribute-ok" as="xs:boolean">
  <xsl:param name="attrname" as="xs:string?"/>
  <xsl:param name="prof" as="xs:string?"/>

  <xsl:choose>
    <xsl:when test="not($attrname) or not($prof)">
      <xsl:value-of select="true()"/>
    </xsl:when>
    <xsl:when test="@*[local-name(.) = $attrname and namespace-uri(.) = '']">
      <xsl:value-of select="true()"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="f:profile-ok(@*[local-name(.) = $attrname
	                                    and namespace-uri(.) = ''],
					 $prof)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- ============================================================ -->
<!-- copy external glossary -->

<xsl:template match="db:glossdiv" mode="m:copy-external-glossary">
  <xsl:param name="terms"/>
  <xsl:param name="divs"/>

  <xsl:variable name="entries">
    <xsl:apply-templates select="db:glossentry" mode="m:copy-external-glossary">
      <xsl:with-param name="terms" select="$terms"/>
      <xsl:with-param name="divs" select="$divs"/>
    </xsl:apply-templates>
  </xsl:variable>

  <xsl:if test="$entries">
    <xsl:choose>
      <xsl:when test="$divs">
	<xsl:copy>
	  <xsl:copy-of select="@*"/>
	  <xsl:copy-of select="db:info"/>
	  <xsl:copy-of select="$entries"/>
	</xsl:copy>
      </xsl:when>
      <xsl:otherwise>
	<xsl:copy-of select="$entries"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>
</xsl:template>

<xsl:template match="db:glossentry" mode="m:copy-external-glossary">
  <xsl:param name="terms"/>
  <xsl:param name="divs"/>

  <xsl:variable name="include"
                select="for $dterm in $terms
                           return 
                              for $gterm in db:glossterm
                                 return
                                    if (string($dterm) = string($gterm)
                                        or $dterm/@baseform = string($gterm))
                                    then 'x'
                                    else ()"/>

  <xsl:if test="$include != ''">
    <xsl:copy-of select="."/>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="m:copy-external-glossary">
  <xsl:param name="terms"/>
  <xsl:param name="divs"/>

  <xsl:copy>
    <xsl:copy-of select="@*"/>
    <xsl:apply-templates mode="m:copy-external-glossary">
      <xsl:with-param name="terms" select="$terms"/>
      <xsl:with-param name="divs" select="$divs"/>
    </xsl:apply-templates>
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
