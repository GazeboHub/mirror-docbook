<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:scvs="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS"
                xmlns:xcvs="com.nwalsh.xalan.CVS"
                exclude-result-prefixes="html scvs xcvs"
                version='1.0'>

<xsl:import href="http://docbook.sourceforge.net/release/website/2.4.1/xsl/chunk-tabular.xsl"/>

<xsl:param name="admon.style" select="''"/>
<xsl:param name="admon.graphics" select="1"/>
<xsl:param name="admon.graphics.path">graphics/</xsl:param>
<xsl:param name="admon.graphics.extension">.gif</xsl:param>

<xsl:param name="prefix"></xsl:param>
<xsl:param name="makenontab"></xsl:param>

<xsl:param name="toc.spacer.graphic" select="1"/>
<xsl:param name="toc.spacer.text">&#160;&#160;&#160;</xsl:param>
<xsl:param name="toc.spacer.image">graphics/blank.gif</xsl:param>
<xsl:param name="toc.pointer.graphic" select="1"/>
<xsl:param name="toc.pointer.text">&#160;&gt;&#160;</xsl:param>
<xsl:param name="toc.pointer.image">graphics/arrow.gif</xsl:param>
<xsl:param name="toc.blank.graphic" select="1"/>
<xsl:param name="toc.blank.text">&#160;&#160;&#160;</xsl:param>
<xsl:param name="toc.blank.image">graphics/blank.gif</xsl:param>

<xsl:param name="textbgcolor">white</xsl:param>
<xsl:param name="navbgcolor">#00A5A5</xsl:param>
<xsl:param name="navtocwidth">220</xsl:param>
<xsl:param name="navbodywidth"></xsl:param>
<xsl:param name="nav.table.summary">Navigation table; see text only version for non-tabular alternative</xsl:param>

<xsl:attribute-set name="table.properties">
  <xsl:attribute name="border">0</xsl:attribute>
  <xsl:attribute name="cellpadding">5</xsl:attribute>
  <xsl:attribute name="cellspacing">0</xsl:attribute>
  <xsl:attribute name="width">100%</xsl:attribute>
</xsl:attribute-set>

<!-- ==================================================================== -->

<!-- default Website stylesheet puts <hr> after navhead; remove it -->
<xsl:template name="home.navhead.separator">
  <div class="home_navhead_separator">&#160;</div>
</xsl:template>

<xsl:template name="home.navhead">
  <xsl:text>&#160;</xsl:text>
  <a href="http://docbook.org/wiki/moin.cgi/DocBook" target="_top">
    <img src="./graphics/created-with-docbook-button.png"
        alt="DocBook" border="0"/>
  </a>
  <xsl:text>&#160;</xsl:text>
  <!-- Yes, the ampersand is double escaped in the URL below -->
  <a href="http://sourceforge.net" target="_top">
    <img src="http://sourceforge.net/sflogo.php?group_id=21935&amp;amp;type=1"
         height="31" width="88" alt="SourceForge" border="0"/>
  </a>
  <xsl:text>&#160;</xsl:text>
  <a href="http://www.oasis-open.org/" target="_top">
    <img src="graphics/oasis.png" alt="OASIS" border="0"/>
  </a>
  <xsl:text>&#160;</xsl:text>
  <a href="http://www.oreilly.com/" target="_top">
    <img src="graphics/oreilly.png" alt="O'Reilly &amp; Associates" border="0"/>
  </a>
</xsl:template>

<xsl:template name="home.navhead.upperright">
  <!-- add link to non-tab version if $makenontab specified --> 
  <xsl:if test="$makenontab='1'">
    <a href="{$prefix}index.html">Text&#160;Only</a>
  </xsl:if>
</xsl:template>

<xsl:template name="home.navhead.cell">
  <td width="90%" valign="middle" align="left">
    <xsl:call-template name="home.navhead"/>
  </td>
</xsl:template>

<xsl:template name="home.navhead.upperright.cell">
  <td width="10%" valign="middle" align="right">
    <xsl:call-template name="home.navhead.upperright"/>
  </td>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template name="webpage.footer"/>

<xsl:template name="webpage.table.footer">
  <xsl:variable name="page" select="."/>
  <xsl:variable name="id" select="$page/@id"/>
  <xsl:variable name="rcsdate" select="$page/config[@param='rcsdate']/@value"/>
  <xsl:variable name="title">
    <xsl:value-of select="$page/head/title[1]"/>
  </xsl:variable>
  <xsl:variable name="footers" select="$page/config[@param='footer']
                                       |$page/config[@param='footlink']"/>

  <tr>
    <td width="{$navtocwidth}" bgcolor="{$navbgcolor}">&#160;</td>
    <td><hr/></td>
  </tr>

  <tr>
    <td width="{$navtocwidth}" bgcolor="{$navbgcolor}"
        valign="top" align="left">
        <p><a
          href="http://docbook.org/wiki/moin.cgi/DocBook"
        ><img border="0"
            alt="DocBook"
            src="http://docbook.sourceforge.net/graphics/created-with-docbook-black.png"
          /></a>&#160;<a
           href="http://xmlsoft.org/XSLT/"
          ><img border="0"
            alt="Libxslt"
            src="http://docbook.sourceforge.net/graphics/created-with-libxslt.png"
          /></a>
          </p>
          <p>
      <span class="footdate">
        <!-- rcsdate = "$Date$" -->
        <!-- timeString = "dow mon dd hh:mm:ss TZN yyyy" -->
        <xsl:variable name="timeString">
          <xsl:choose>
            <xsl:when test="function-available('scvs:localTime')">
              <xsl:value-of select="scvs:localTime($rcsdate)"/>
            </xsl:when>
            <xsl:when test="function-available('xcvs:localTime')">
              <xsl:value-of select="xcvs:localTime($rcsdate)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$rcsdate"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>

        <xsl:text>Updated: </xsl:text>
        <xsl:value-of select="substring($timeString, 1, 3)"/>
        <xsl:text>, </xsl:text>
        <xsl:value-of select="substring($timeString, 9, 2)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring($timeString, 5, 3)"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="substring($timeString, 25, 4)"/>
      </span>
      </p>
    </td>

    <td valign="top" align="center">
      <xsl:variable name="tocentry" select="$autolayout//*[@id=$id]"/>
      <xsl:variable name="toc"
                    select="($tocentry/ancestor-or-self::toc[1]
                            | $autolayout//toc[1])[last()]"/>

      <xsl:choose>
        <xsl:when test="not($toc)">
          <xsl:message>
            <xsl:text>Cannot determine TOC for </xsl:text>
            <xsl:value-of select="$id"/>
          </xsl:message>
        </xsl:when>
        <xsl:when test="$toc/@id = $id">
          <!-- nop; this is the home page -->
        </xsl:when>
        <xsl:otherwise>
          <span class="foothome">
            <a>
              <xsl:attribute name="href">
                <xsl:call-template name="homeuri"/>
              </xsl:attribute>
              <xsl:text>Home</xsl:text>
            </a>
            <xsl:if test="$footers">
              <xsl:text> | </xsl:text>
            </xsl:if>
          </span>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:apply-templates select="$footers" mode="footer.link.mode"/>
    </td>
  </tr>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="html:*">
  <xsl:element name="{name(.)}" namespace="">
    <xsl:apply-templates select="@*" mode="copy"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
