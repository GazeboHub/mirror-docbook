<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:cvs="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS"
                exclude-result-prefixes="html cvs"
                version='1.0'>

<xsl:import href="http://docbook.sourceforge.net/release/website/2.4.1/xsl/chunk-website.xsl"/>

<!-- ==================================================================== -->

<xsl:template name="webpage.footer">
  <xsl:variable name="page" select="."/>
  <xsl:variable name="rcsdate" select="$page/config[@param='rcsdate']/@value"/>
  <xsl:variable name="title" select="$page/head/title[1]"/>
  <xsl:variable name="footers" select="$page/config[@param='footer']
                                       |$page/config[@param='footlink']"/>
  <xsl:variable name="tocentry" select="$autolayout//*[@id=$page/@id]"/>
  <xsl:variable name="toc" select="($tocentry/ancestor-or-self::toc[1]
                                   | $autolayout//toc[1])[last()]"/>

  <div class="navfoot">
    <xsl:if test="$footer.hr != 0"><hr/></xsl:if>
    <table width="100%" border="0" summary="Footer navigation">
      <tr>
        <td width="33%" align="left">
          <a
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
        </td>
        <td width="34%" align="center">
          <xsl:message>
            <xsl:value-of select="$toc/@id"/>
            <xsl:text>=</xsl:text>
            <xsl:value-of select="$page/@id"/>
          </xsl:message>
          <xsl:choose>
            <xsl:when test="not($toc)">
              <xsl:message>
                <xsl:text>Cannot determine TOC for </xsl:text>
                <xsl:value-of select="$page/@id"/>
              </xsl:message>
            </xsl:when>
            <xsl:when test="$toc/@id = $page/@id">
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
        <td width="33%" align="right">
          <span class="footdate">
            <!-- rcsdate = "$Date$" -->
            <!-- timeString = "dow mon dd hh:mm:ss TZN yyyy" -->
            <xsl:variable name="timeString" select="cvs:localTime($rcsdate)"/>
            <xsl:text>Updated: </xsl:text>
            <xsl:value-of select="substring($timeString, 1, 3)"/>
            <xsl:text>, </xsl:text>
            <xsl:value-of select="substring($timeString, 9, 2)"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="substring($timeString, 5, 3)"/>
            <xsl:text> </xsl:text>
            <xsl:value-of select="substring($timeString, 25, 4)"/>
          </span>
        </td>
      </tr>
    </table>
  </div>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="html:*">
  <xsl:element name="{name(.)}" namespace="">
    <xsl:apply-templates select="@*" mode="copy"/>
    <xsl:apply-templates/>
  </xsl:element>
</xsl:template>

</xsl:stylesheet>
