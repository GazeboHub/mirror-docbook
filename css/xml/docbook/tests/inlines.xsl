<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:eg="http://www.badgers-in-foil.co.uk/projects/docbooc-css/tests/examples"
                xmlns="http://www.oasis-open.org/docbook/xml/4.1.2/docbookx.dtd"
		version="1.0">

  <xsl:output method="xml" indent="yes"/>
  <xsl:preserve-space elements="*"/>


  <xsl:template match="/*">
    <xsl:processing-instruction name="xml-stylesheet">href="../driver.css" type="text/css"</xsl:processing-instruction>
    <article>
      <title><xsl:value-of select="@title"/></title>
      <xsl:for-each select="eg:example">
        <xsl:call-template name="example"/>
      </xsl:for-each>
    </article>
  </xsl:template>

  <xsl:template name="example">
    <section>
      <title><xsl:value-of select="@title"/></title>
      <xsl:if test="eg:description">
      	<para><xsl:copy-of select="eg:description/node()"/></para>
      </xsl:if>
      <programlisting><xsl:apply-templates mode="highlight" select="eg:body/node()"/></programlisting>

      <para><xsl:copy-of select="eg:body/*|eg:body/text()"/></para>
    </section>
  </xsl:template>

  <xsl:template match="processing-instruction()" mode="highlight">
    &lt;?<xsl:value-of select="name(.)"/>?&gt;
  </xsl:template>
  <xsl:template match="comment()" mode="highlight">&lt;!--<xsl:value-of select="."/>--&gt;</xsl:template>
  <xsl:template match="text()" mode="highlight">
    <xsl:copy/>
  </xsl:template>
  <xsl:template match="node()" mode="highlight">
    <xsl:call-template name="tag"/>
  </xsl:template>

  <xsl:template name="tag">
    <xsl:choose>
      <!-- look for child content TODO: comments, others? -->
      <xsl:when test="./*|./text()">
        <xsl:call-template name="start-tag"/>
        <xsl:apply-templates mode="highlight"/>
        <xsl:call-template name="end-tag"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="empty-tag"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>


  <xsl:template name="start-tag">&lt;<xsl:value-of select="name(.)"/><xsl:call-template name="attrs"/>&gt;</xsl:template>
  <xsl:template name="end-tag">&lt;/<xsl:value-of select="name(.)"/>&gt;</xsl:template>
  <xsl:template name="empty-tag">&lt;<xsl:value-of select="name(.)"/><xsl:call-template name="attrs"/>/&gt;</xsl:template>

  <xsl:template name="attrs">
    <xsl:for-each select="@*">
      <xsl:text> </xsl:text>
      <xsl:value-of select="name(.)"/>="<xsl:value-of select="."/>"
    </xsl:for-each>
  </xsl:template>


</xsl:stylesheet>
