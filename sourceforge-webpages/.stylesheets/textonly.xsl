<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:html='http://www.w3.org/1999/xhtml'
                xmlns:cvs="http://nwalsh.com/xslt/ext/com.nwalsh.saxon.CVS"
                exclude-result-prefixes="html cvs"
                version='1.0'>

<xsl:import href="/share/doctypes/website-pages/xsl/chunk-website.xsl"/>

<!-- ==================================================================== -->

<xsl:template name="webpage.footer">
  <xsl:variable name="page" select="."/>
  <xsl:variable name="rcsdate" select="$page/config[@param='rcsdate']/@value"/>
  <xsl:variable name="title">
    <xsl:value-of select="$page/head/title[1]"/>
  </xsl:variable>
  <xsl:variable name="footers" select="$page/config[@param='footer']"/>

  <div class="navfoot">
    <xsl:if test="$footer.hr != 0"><hr/></xsl:if>
    <table width="100%" border="0" summary="Footer navigation">
      <tr>

        <td width="33%" align="left">
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
        <td width="34%" align="center">
          <span class="foothome">
            <a>
              <xsl:variable name="id" select="$page/@id"/>
              <xsl:variable name="tocentry"
                            select="$autolayout//*[@id=$id]"/>
              <xsl:attribute name="href">
                <xsl:call-template name="root-rel-path"/>
                <xsl:value-of select="$tocentry/ancestor::toc/@filename"/>
              </xsl:attribute>
              <xsl:text>Home</xsl:text>
            </a>
          </span>

          <xsl:apply-templates select="$footers" mode="footer.link.mode"/>
        </td>
        <td width="33%" align="right">&#160;</td>
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
