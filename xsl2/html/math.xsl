<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns="http://www.w3.org/1999/xhtml"
		xmlns:h="http://www.w3.org/1999/xhtml"
		xmlns:f="http://docbook.org/xslt/ns/extension"
		xmlns:m="http://docbook.org/xslt/ns/mode"
		xmlns:fn="http://www.w3.org/2005/04/xpath-functions"
		xmlns:db="http://docbook.org/docbook-ng"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
		exclude-result-prefixes="h f m fn db doc xs"
                version="2.0">

<xsl:template match="db:equation">
  <xsl:variable name="nname" select="node-name(.)"/>
  <xsl:variable name="param.placement"
		select="$formal.title.placement
			/*[node-name(.)=$nname][1]/@placement"/>

  <xsl:variable name="placement"
		select="if ($param.placement != '')
                        then $param.placement
			else 'before'"/>

  <xsl:call-template name="semiformal-object">
    <xsl:with-param name="placement" select="$placement"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="db:mathphrase">
  <span>
    <xsl:call-template name="id"/>
    <xsl:call-template name="class"/>
    <xsl:apply-templates/>
  </span>
</xsl:template>

</xsl:stylesheet>
