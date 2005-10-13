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
		exclude-result-prefixes="h f m fn db t doc"
                version="2.0">

<xsl:param name="root.filename" select="'index'"/>
<xsl:param name="html.ext" select="'.html'"/>
<xsl:param name="use.id.as.filename" select="0"/>

<xsl:param name="dateTime-format" select="'[D01] [MNn,*-3] [Y0001]'"/>
<xsl:param name="date-format" select="'[D01] [MNn,*-3] [Y0001]'"/>
<xsl:param name="gYearMonth-format" select="'[MNn,*-3] [Y0001]'"/>
<xsl:param name="gYear-format" select="'[Y0001]'"/>

<xsl:param name="docbook.css"
	   select="'/sourceforge/docbook/xsl2/html/default.css'"/>
<xsl:param name="docbook.css.inline" select="0"/>

<xsl:param name="toc.list.type">dl</xsl:param>
<xsl:param name="manual.toc" select="''"/>
<xsl:param name="bridgehead.in.toc" select="0"/>
<xsl:param name="toc.section.depth">2</xsl:param>
<xsl:param name="toc.max.depth">8</xsl:param>
<xsl:param name="autotoc.label.separator" select="'. '"/>
<xsl:param name="annotate.toc" select="1"/>

<xsl:param name="refentry.separator" select="1"/>
<xsl:param name="refentry.generate.name" select="1"/>
<xsl:param name="refentry.generate.title" select="1"/>

<xsl:param name="make.year.ranges" select="1"/>
<xsl:param name="make.single.year.ranges" select="1"/>

<xsl:param name="component.label.includes.part.label" select="0"/>
<xsl:param name="section.label.includes.component.label" select="1"/>
<xsl:param name="qanda.inherit.numeration" select="1"/>
<xsl:param name="label.from.part" select="1"/>

<!-- ==================================================================== -->

<xsl:param name="part.autolabel" select="1"/>
<xsl:param name="preface.autolabel" select="1"/>
<xsl:param name="chapter.autolabel" select="1"/>
<xsl:param name="appendix.autolabel" select="1"/>
<xsl:param name="qandadiv.autolabel" select="1"/>
<xsl:param name="section.autolabel" select="1"/>
<xsl:param name="xref.label-title.separator" select="' '"/>
<xsl:param name="xref.label-page.separator" select="' '"/>
<xsl:param name="xref.title-page.separator" select="' '"/>
<xsl:param name="insert.xref.page.number" select="1"/>
<xsl:param name="formal.procedures" select="1"/>
<xsl:param name="xref.with.number.and.title" select="1"/>
<xsl:param name="qanda.defaultlabel" select="'number'"/>

<xsl:param name="orderedlist.numeration.styles"
	   select="('arabic',
		    'loweralpha', 'lowerroman',
                    'upperalpha', 'upperroman')"/>

<xsl:param name="procedure.step.numeration.styles"
	   select="('arabic',
		    'loweralpha', 'lowerroman',
                    'upperalpha', 'upperroman')"/>

<xsl:param name="persistent.generated.ids" select="1"/>

<xsl:param name="bibliography.numbered" select="1"/>

<xsl:param name="bibliography.collection"
	   select="'/home/ndw/.bibliography.xml'"/>

<xsl:param name="glossary.collection"
	   select="'/sourceforge/docbook/xsl2/gloss.xml'"/>

<xsl:param name="glossentry.show.acronym" select="'primary'"/>
<xsl:param name="glossterm.auto.link" select="1"/>
<xsl:param name="firstterm.only.link" select="0"/>

<xsl:param name="inline.style.attribute" select="1"/>

<xsl:param name="titlepage.templates" select="'titlepages.xml'"/>

<xsl:param name="l10n.gentext.default.language" select="'en'"/>
<xsl:param name="l10n.gentext.language" select="''"/>
<xsl:param name="l10n.gentext.use.xref.language" select="0"/>

<xsl:param name="l10n.xml" select="document('../common/l10n.xml')"/>
<xsl:param name="local.l10n.xml" select="document('')"/>

<xsl:param name="docbook-namespace" select="'http://docbook.org/ns/docbook'"/>

<xsl:param name="punct.honorific" select="'.'"/>
<xsl:param name="author.othername.in.middle" select="0"/>

<xsl:param name="itemizedlist.numeration.symbols"
	   select="('disc', 'round')"/>

<xsl:param name="root.elements">
  <db:appendix/>
  <db:article/>
  <db:bibliography/>
  <db:book/>
  <db:chapter/>
  <db:colophon/>
  <db:dedication/>
  <db:glossary/>
  <db:index/>
  <db:part/>
  <db:preface/>
  <db:refentry/>
  <db:reference/>
  <db:sect1/>
  <db:section/>
  <db:set/>
  <db:setindex/>
</xsl:param>

<xsl:param name="autolabel.elements">
  <db:appendix/>
  <db:chapter/>
</xsl:param>

<xsl:param name="section.autolabel.max.depth" select="4"/>

<xsl:param name="rootid"/>

<!-- Indexing related parameters -->
<xsl:param name="index.on.role" select="0"/>
<xsl:param name="index.on.type" select="0"/>
<xsl:param name="generate.index" select="1"/>
<xsl:param name="index.prefer.titleabbrev" select="0"/>

<!-- Profiling parameters -->
<xsl:param name="profile.arch" select="()"/>
<xsl:param name="profile.condition" select="'online'"/>
<xsl:param name="profile.conformance" select="()"/>
<xsl:param name="profile.lang" select="()"/>
<xsl:param name="profile.os" select="()"/>
<xsl:param name="profile.revision" select="()"/>
<xsl:param name="profile.revisionflag" select="()"/>
<xsl:param name="profile.role" select="()"/>
<xsl:param name="profile.security" select="()"/>
<xsl:param name="profile.userlevel" select="()"/>
<xsl:param name="profile.vendor" select="()"/>
<xsl:param name="profile.attribute" select="()"/>
<xsl:param name="profile.value" select="()"/>
<xsl:param name="profile.separator" select="';'"/>

</xsl:stylesheet>
