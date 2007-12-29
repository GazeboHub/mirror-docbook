<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:exsl="http://exslt.org/common"
                xmlns:ng="http://docbook.org/docbook-ng"
                xmlns:db="http://docbook.org/ns/docbook"
                exclude-result-prefixes="exsl"
                version='1.0'>

<!-- ********************************************************************
     $Id$
     ********************************************************************

     This file is part of the XSL DocBook Stylesheet distribution.
     See ../README or http://docbook.sf.net/release/xsl/current/ for
     copyright and other information.

     ******************************************************************** -->

<!-- * This file contains named templates related to things other than -->
<!-- * just assembling the actual text of the main text flow of each man -->
<!-- * page. This "other" stuff currently amounts to these steps: -->
<!-- * -->
<!-- *  - get contents of the "map" used to convert special characters -->
<!-- *  - output boilerplate messages -->
<!-- *  - escape backslash, dot, dash, and apostrophe characters -->
<!-- *  - convert non-breaking spaces -->
<!-- *  - add a comment to top part of roff source of each page -->
<!-- *  - make a .TH title line (for controlling page header/footer) -->
<!-- *  - set hyphenation, alignment, indent & line-breaking defaults -->
<!-- *  - "prepare" the complete man page contents for final output -->
<!-- *  - write the actual man file to the filesystem -->
<!-- *  - write any "stub" pages to the filesystem -->
<!-- * -->
<!-- * The templates in this file are actually called only once per -->
<!-- * each Refentry; they are just in a separate file for the purpose -->
<!-- * of keeping things modular. -->

<!-- ==================================================================== -->

<xsl:preserve-space elements="*"/>

<xsl:strip-space elements="
abstract affiliation anchor answer appendix area areaset areaspec
artheader article audiodata audioobject author authorblurb authorgroup
beginpage bibliodiv biblioentry bibliography biblioset blockquote book
bookbiblio bookinfo callout calloutlist caption caution chapter
citerefentry cmdsynopsis co collab colophon colspec confgroup
copyright dedication docinfo editor entrytbl epigraph equation
example figure footnote footnoteref formalpara funcprototype
funcsynopsis glossary glossdef glossdiv glossentry glosslist graphicco
group highlights imagedata imageobject imageobjectco important index
indexdiv indexentry indexterm informalequation informalexample
informalfigure informaltable inlineequation inlinemediaobject
itemizedlist itermset keycombo keywordset legalnotice listitem lot
mediaobject mediaobjectco menuchoice msg msgentry msgexplan msginfo
msgmain msgrel msgset msgsub msgtext note objectinfo
orderedlist othercredit part partintro preface printhistory procedure
programlistingco publisher qandadiv qandaentry qandaset question
refentry reference refmeta refnamediv refsection refsect1 refsect1info refsect2
refsect2info refsect3 refsect3info refsynopsisdiv refsynopsisdivinfo
revhistory revision row sbr screenco screenshot sect1 sect1info sect2
sect2info sect3 sect3info sect4 sect4info sect5 sect5info section
sectioninfo seglistitem segmentedlist seriesinfo set setindex setinfo
shortcut sidebar simplelist simplesect spanspec step subject
subjectset substeps synopfragment table tbody textobject tfoot tgroup
thead tip toc tocchap toclevel1 toclevel2 toclevel3 toclevel4
toclevel5 tocpart varargs variablelist varlistentry videodata
videoobject void warning subjectset

classsynopsis
constructorsynopsis
destructorsynopsis
fieldsynopsis
methodparam
methodsynopsis
ooclass
ooexception
oointerface
simplemsgentry
manvolnum

db:abstract db:affiliation db:anchor db:answer db:appendix db:area db:areaset db:areaspec
db:artheader db:article db:audiodata db:audioobject db:author db:authorblurb db:authorgroup
db:beginpage db:bibliodiv db:biblioentry db:bibliography db:biblioset db:blockquote db:book
db:bookbiblio db:bookinfo db:callout db:calloutlist db:caption db:caution db:chapter
db:citerefentry db:cmdsynopsis db:co db:collab db:colophon db:colspec db:confgroup
db:copyright db:dedication db:docinfo db:editor db:entrytbl db:epigraph db:equation
db:example db:figure db:footnote db:footnoteref db:formalpara db:funcprototype
db:funcsynopsis db:glossary db:glossdef db:glossdiv db:glossentry db:glosslist db:graphicco
db:group db:highlights db:imagedata db:imageobject db:imageobjectco db:important db:index
db:indexdiv db:indexentry db:indexterm db:informalequation db:informalexample
db:informalfigure db:informaltable db:inlineequation db:inlinemediaobject
db:itemizedlist db:itermset db:keycombo db:keywordset db:legalnotice db:listitem db:lot
db:mediaobject db:mediaobjectco db:menuchoice db:msg db:msgentry db:msgexplan db:msginfo
db:msgmain db:msgrel db:msgset db:msgsub db:msgtext db:note db:objectinfo
db:orderedlist db:othercredit db:part db:partintro db:preface db:printhistory db:procedure
db:programlistingco db:publisher db:qandadiv db:qandaentry db:qandaset db:question
db:refentry db:reference db:refmeta db:refnamediv db:refsection db:refsect1 db:refsect1info
db:refsect2
db:refsect2info db:refsect3 db:refsect3info db:refsynopsisdiv db:refsynopsisdivinfo
db:revhistory db:revision db:row db:sbr db:screenco db:screenshot db:sect1 db:sect1info db:sect2
db:sect2info db:sect3 db:sect3info db:sect4 db:sect4info db:sect5 db:sect5info db:section
db:sectioninfo db:seglistitem db:segmentedlist db:seriesinfo db:set db:setindex db:setinfo
db:shortcut db:sidebar db:simplelist db:simplesect db:spanspec db:step db:subject
db:subjectset db:substeps db:synopfragment db:table db:tbody db:textobject db:tfoot db:tgroup
db:thead db:tip db:toc db:tocchap db:toclevel1 db:toclevel2 db:toclevel3 db:toclevel4
db:toclevel5 db:tocpart db:varargs db:variablelist db:varlistentry db:videodata
db:videoobject db:void db:warning db:subjectset

db:classsynopsis
db:constructorsynopsis
db:destructorsynopsis
db:fieldsynopsis
db:methodparam
db:methodsynopsis
db:ooclass
db:ooexception
db:oointerface
db:simplemsgentry
db:manvolnum
"/>

<!-- ==================================================================== -->
<!-- * Get character map contents -->
<!-- ==================================================================== -->

  <xsl:variable name="man.charmap.contents">
    <xsl:if test="$man.charmap.enabled != 0">
      <xsl:call-template name="read-character-map">
        <xsl:with-param name="use.subset" select="$man.charmap.use.subset"/>
        <xsl:with-param name="subset.profile" select="$man.charmap.subset.profile"/>
        <xsl:with-param name="uri">
          <xsl:choose>
            <xsl:when test="$man.charmap.uri != ''">
              <xsl:value-of select="$man.charmap.uri"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="'../manpages/charmap.groff.xsl'"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:if>
  </xsl:variable>

<!-- ==================================================================== -->

<xsl:template name="root.messages">
  <xsl:param name="refname"/>
  <!-- redefine this any way you'd like to output messages -->
  <!-- DO NOT OUTPUT ANYTHING FROM THIS TEMPLATE -->
  <!-- Example:
  <xsl:if test="//foo">
    <xsl:call-template name="log.message">
      <xsl:with-param name="level">Warn</xsl:with-param>
      <xsl:with-param name="source" select="$refname"/>
      <xsl:with-param name="context-desc">
        <xsl:text>limitation</xsl:text>
      </xsl:with-param>
      <xsl:with-param name="message">
        <xsl:text>Output for foo element is not yet supported.</xsl:text>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
  -->
</xsl:template>

<!-- ==================================================================== -->
<!-- * Escape roff special chars -->
<!-- ==================================================================== -->

<!-- ******************************************************************** -->
<!-- *  -->
<!-- * The backslash, dot, dash, and apostrophe (\, ., -, ') characters -->
<!-- * have special meaning for roff, so before we do any other -->
<!-- * processing, we must escape those characters where they appear in -->
<!-- * the source content. -->
<!-- *  -->
<!-- * Here we also deal with replacing U+00a0 (non-breaking space) with -->
<!-- * its roff equivalent -->
<!-- *  -->
<!-- ******************************************************************** -->

<xsl:template match="//refentry//text()">
  <xsl:call-template name="escape.roff.specials">
    <xsl:with-param name="content">
      <xsl:value-of select="."/>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="escape.roff.specials">
  <xsl:param name="content"/>
  <xsl:call-template name="convert.nobreak-space">
    <xsl:with-param name="content">
      <xsl:call-template name="escape.apostrophe">
        <xsl:with-param name="content">
          <xsl:call-template name="escape.dash">
            <xsl:with-param name="content">
              <xsl:call-template name="escape.dot">
                <xsl:with-param name="content">
                  <xsl:call-template name="escape.backslash">
                    <xsl:with-param name="content" select="$content"/>
                  </xsl:call-template>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="escape.backslash">
  <xsl:param name="content"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target">\</xsl:with-param>
    <!-- * we use "\e" instead of "\\" because the groff docs say -->
    <!-- * that's the correct thing to do; also because testing -->
    <!-- * shows that "\\" doesn't always work as expected; for -->
    <!-- * example, "\\" within a table seems to mess things up -->
    <xsl:with-param name="replacement">\e</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="escape.dot">
  <xsl:param name="content"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target">.</xsl:with-param>
    <xsl:with-param name="replacement">\.</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="escape.dash">
  <xsl:param name="content"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target">-</xsl:with-param>
    <xsl:with-param name="replacement">\-</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="escape.apostrophe">
  <xsl:param name="content"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target">'</xsl:with-param>
    <xsl:with-param name="replacement">\'</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="convert.nobreak-space">
  <xsl:param name="content"/>
  <xsl:call-template name="string.subst">
    <xsl:with-param name="string" select="$content"/>
    <xsl:with-param name="target">&#x00a0;</xsl:with-param>
    <!-- * A no-break space can be written two ways in roff; the -->
    <!-- * difference, according to the "Page Motions" node in the -->
    <!-- * groff info page, is: -->
    <!-- *  -->
    <!-- *   "\ " = -->
    <!-- *   An unbreakable and unpaddable (i.e. not expanded -->
    <!-- *   during filling) space. -->
    <!-- *  -->
    <!-- *   "\~" = -->
    <!-- *   An unbreakable space that stretches like a normal -->
    <!-- *   inter-word space when a line is adjusted."  -->
    <!-- *  -->
    <!-- * Unfortunately, roff seems to do some weird things with -->
    <!-- * long lines that only have words separated by "\~" -->
    <!-- * spaces, so it's safer just to stick with the "\ " space -->
    <xsl:with-param name="replacement">\ </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<!-- * top.comment generates a comment containing metadata for the man -->
<!-- * page; for example, Author, Generator, and Date information -->

  <xsl:template name="top.comment">
    <xsl:param name="info"/>
    <xsl:param name="date"/>
    <xsl:param name="title"/>
    <xsl:param name="manual"/>
    <xsl:param name="source"/>
    <xsl:text>.\"     Title: </xsl:text>
    <xsl:call-template name="replace.dots.and.dashes">
      <xsl:with-param name="content" select="$title"/>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\"    Author: </xsl:text>
    <xsl:call-template name="replace.dots.and.dashes">
      <xsl:with-param name="content">
        <xsl:call-template name="make.roff.metadata.author">
          <xsl:with-param name="info" select="$info"/>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\" Generator: DocBook </xsl:text>
    <xsl:value-of select="$DistroTitle"/>
    <xsl:text> v</xsl:text>
    <xsl:call-template name="replace.dots.and.dashes">
      <xsl:with-param name="content" select="$VERSION"/>
    </xsl:call-template>
    <xsl:text> &lt;http://docbook.sf.net/></xsl:text>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\"      Date: </xsl:text>
    <xsl:call-template name="replace.dots.and.dashes">
      <xsl:with-param name="content" select="$date"/>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\"    Manual: </xsl:text>
    <xsl:call-template name="replace.dots.and.dashes">
      <xsl:with-param name="content" select="$manual"/>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\"    Source: </xsl:text>
    <xsl:call-template name="replace.dots.and.dashes">
      <xsl:with-param name="content" select="$source"/>
    </xsl:call-template>
    <xsl:text>&#10;</xsl:text>
    <xsl:text>.\"</xsl:text>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

<!-- ==================================================================== -->

  <xsl:template name="TH.title.line">

    <!-- * The exact way that .TH contents are displayed is system- -->
    <!-- * dependent; it varies somewhat between OSes and roff -->
    <!-- * versions. Below is a description of how Linux systems with -->
    <!-- * a modern groff seem to render .TH contents. -->
    <!-- * -->
    <!-- *   title(section)  extra3  title(section)  <- page header -->
    <!-- *   extra2          extra1  title(section)  <- page footer-->
    <!-- * -->
    <!-- * Or, using the names with which the man(7) man page refers -->
    <!-- * to the various fields: -->
    <!-- * -->
    <!-- *   title(section)  manual  title(section)  <- page header -->
    <!-- *   source          date    title(section)  <- page footer-->
    <!-- * -->
    <!-- * Note that while extra1, extra2, and extra3 are all (nominally) -->
    <!-- * optional, in practice almost all pages include an "extra1" -->
    <!-- * field, which is, universally, a date (in some form), and it is -->
    <!-- * always rendered in the same place (the middle footer position) -->
    <!-- * -->
    <!-- * Here are a couple of examples of real-world man pages that -->
    <!-- * have somewhat useful page headers/footers: -->
    <!-- * -->
    <!-- *   gtk-options(7)    GTK+ User's Manual   gtk-options(7) -->
    <!-- *   GTK+ 1.2              2003-10-20       gtk-options(7) -->
    <!-- * -->
    <!-- *   svgalib(7)       Svgalib User Manual       svgalib(7) -->
    <!-- *   Svgalib 1.4.1      16 December 1999        svgalib(7) -->
    <!-- * -->
    <xsl:param name="title"/>
    <xsl:param name="section"/>
    <xsl:param name="extra1"/>
    <xsl:param name="extra2"/>
    <xsl:param name="extra3"/>

    <xsl:call-template name="mark.subheading"/>
    <!-- * Note that we generate quotes around _every_ field in the -->
    <!-- * .TH title line, including the "title" and "section" -->
    <!-- * fields. That is because we use the contents of those "as -->
    <!-- * is", unchanged from the DocBook source; and DTD-based -->
    <!-- * validation does not provide a way to constrain them to be -->
    <!-- * "space free" -->
    <xsl:text>.TH "</xsl:text>
    <xsl:call-template name="string.upper">
      <xsl:with-param name="string">
        <xsl:choose>
          <xsl:when test="$man.th.title.max.length != ''">
            <xsl:value-of
                select="normalize-space(substring($title, 1, $man.th.title.max.length))"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="normalize-space($title)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:text>" "</xsl:text>
    <xsl:value-of select="normalize-space($section)"/>
    <xsl:text>" "</xsl:text>
    <xsl:if test="$man.th.extra1.suppress = 0">
      <!-- * there is no max.length for the extra1 field; the reason -->
      <!-- * is, it is almost always a date, and it is not possible -->
      <!-- * to truncate dates without changing their meaning -->
      <xsl:value-of select="normalize-space($extra1)"/>
    </xsl:if>
    <xsl:text>" "</xsl:text>
    <xsl:if test="$man.th.extra2.suppress = 0">
      <xsl:choose>
        <!-- * if max.length is non-empty, use value to truncate field -->
        <xsl:when test="$man.th.extra2.max.length != ''">
          <xsl:value-of
              select="normalize-space(substring($extra2, 1, $man.th.extra2.max.length))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($extra2)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:text>" "</xsl:text>
    <xsl:if test="$man.th.extra3.suppress = 0">
      <xsl:choose>
        <!-- * if max.length is non-empty, use value to truncate field -->
        <xsl:when test="$man.th.extra3.max.length != ''">
          <xsl:value-of
              select="normalize-space(substring($extra3, 1, $man.th.extra3.max.length))"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="normalize-space($extra3)"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
    <xsl:text>"&#10;</xsl:text>
    <xsl:call-template name="mark.subheading"/>
  </xsl:template>

  <!-- ============================================================== -->

  <xsl:template name="set.default.formatting">
    <!-- * Set default hyphenation, justification, indentation and -->
    <!-- * line-breaking -->
    <!-- * -->
    <!-- * If the value of man.hypenate is zero (the default), then -->
    <!-- * disable hyphenation (".nh" = "no hyphenation") -->
    <xsl:if test="$man.hyphenate = 0">
      <xsl:text>.\" disable hyphenation&#10;</xsl:text>
      <xsl:text>.nh&#10;</xsl:text>
    </xsl:if>
    <!-- * If the value of man.justify is zero (the default), then -->
    <!-- * disable justification (".ad l" means "adjust to left only") -->
    <xsl:if test="$man.justify = 0">
      <xsl:text>.\" disable justification</xsl:text>
      <xsl:text> (adjust text to left margin only)&#10;</xsl:text>
      <xsl:text>.ad l&#10;</xsl:text>
    </xsl:if>
    <xsl:if test="not($man.indent.refsect = 0)">
      <xsl:text>.\" store initial "default indentation value"&#10;</xsl:text>
      <xsl:text>.nr zq \n(IN&#10;</xsl:text>
      <xsl:text>.\" adjust default indentation&#10;</xsl:text>
      <xsl:text>.nr IN </xsl:text>
      <xsl:value-of select="$man.indent.width"/>
      <xsl:text>&#10;</xsl:text>
      <xsl:text>.\" adjust indentation of SS headings&#10;</xsl:text>
      <xsl:text>.nr SN \n(IN&#10;</xsl:text>
    </xsl:if>
    <!-- * Unless the value of man.break.after.slash is zero (the -->
    <!-- * default), tell groff that it is OK to break a line -->
    <!-- * after a slash when needed. -->
    <xsl:if test="$man.break.after.slash != 0">
      <xsl:text>.\" enable line breaks after slashes&#10;</xsl:text>
      <xsl:text>.cflags 4 /&#10;</xsl:text>
    </xsl:if>
  </xsl:template>

  <!-- ================================================================== -->

  <!-- * The prepare.manpage.contents template is called after all -->
  <!-- * other processing has been done, before serializing the -->
  <!-- * result of all the other processing. It basically works on -->
  <!-- * the result as one big string. -->
  <xsl:template name="prepare.manpage.contents">
    <xsl:param name="content" select="''"/>

    <!-- * If user has provided a "local" string-substitution map to -->
    <!-- * be applied /before/ the standard string-substitution map, -->
    <!-- * apply it. -->
    <xsl:variable name="pre.adjusted.content">
      <xsl:choose>
        <xsl:when test="$man.string.subst.map.local.pre">
          <!-- * normalized value of man.string.subst.map.local.pre -->
          <!-- * is non-empty, so get contents of map and apply them -->
          <xsl:call-template name="apply-string-subst-map">
            <xsl:with-param name="content" select="$content"/>
            <xsl:with-param name="map.contents"
                            select="exsl:node-set($man.string.subst.map.local.pre)/*"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- * value of man.string.subst.map.local.pre is empty, -->
          <!-- * so just copy original contents -->
          <xsl:value-of select="$content"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- * Apply standard string-substitution map. The main purpose -->
    <!-- * of this map is to escape certain characters that have -->
    <!-- * special meaning in roff, and to replace certain characters -->
    <!-- * used within the stylesheet internally to represent roff -->
    <!-- * markup characters. -->
    <xsl:variable name="adjusted.content">
      <xsl:call-template name="apply-string-subst-map">
        <xsl:with-param name="content" select="$pre.adjusted.content"/>
        <xsl:with-param name="map.contents"
                        select="exsl:node-set($man.string.subst.map)/*"/>
      </xsl:call-template>
    </xsl:variable>

    <!-- * If user has provided a "local" string-substitution map to -->
    <!-- * be applied /after/ the standard string-substitution map, -->
    <!-- * apply it. -->
    <xsl:variable name="post.adjusted.content">
      <xsl:choose>
        <xsl:when test="$man.string.subst.map.local.post">
          <!-- * normalized value of man.string.subst.map.local.post -->
          <!-- * is non-empty, so get contents of map and apply them -->
          <xsl:call-template name="apply-string-subst-map">
            <xsl:with-param name="content" select="$adjusted.content"/>
            <xsl:with-param name="map.contents"
                            select="exsl:node-set($man.string.subst.map.local.post)/*"/>
          </xsl:call-template>
        </xsl:when>
        <xsl:otherwise>
          <!-- * value of man.string.subst.map.local.post is empty, -->
          <!-- * so just copy original contents -->
          <xsl:value-of select="$adjusted.content"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

    <!-- * Optionally, apply a character map to replace Unicode -->
    <!-- * symbols and special characters. -->
    <xsl:choose>
      <xsl:when test="$man.charmap.enabled != 0">
        <xsl:call-template name="apply-character-map">
          <xsl:with-param name="content" select="$post.adjusted.content"/>
          <xsl:with-param name="map.contents"
                          select="exsl:node-set($man.charmap.contents)/*"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <!-- * if we reach here, value of $man.charmap.enabled is zero, -->
        <!-- * so we just pass the adjusted contents through "as is" -->
        <xsl:value-of select="$adjusted.content"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- ================================================================== -->
  
  <xsl:template name="write.man.file">
    <xsl:param name="name"/>
    <xsl:param name="section"/>
    <xsl:param name="lang"/>
    <xsl:param name="content"/>
    <xsl:param name="filename">
      <xsl:call-template name="make.adjusted.man.filename">
        <xsl:with-param name="name" select="$name"/>
        <xsl:with-param name="section" select="$section"/>
        <xsl:with-param name="lang" select="$lang"/>
      </xsl:call-template>
    </xsl:param>
    <xsl:call-template name="write.text.chunk">
      <xsl:with-param name="filename" select="$filename"/>
      <xsl:with-param name="suppress-context-node-name" select="1"/>
      <xsl:with-param name="quiet" select="$man.output.quietly"/>
      <xsl:with-param
          name="message-prolog"
          >Note: </xsl:with-param>
      <xsl:with-param name="encoding" select="$man.output.encoding"/>
      <xsl:with-param name="content" select="$content"/>
    </xsl:call-template>
  </xsl:template>

  <!-- ============================================================== -->

  <!-- * A "stub" is sort of alias for another file, intended to be read -->
  <!-- * and expanded by soelim(1); it's simply a file whose complete -->
  <!-- * contents are just a single line of the following form: -->
  <!-- * -->
  <!-- *  .so manX/realname.X -->
  <!-- * -->
  <!-- * "realname" is a name of another man-page file. That .so line is -->
  <!-- * basically a roff "include" statement.  When the man command finds -->
  <!-- * it, it calls soelim(1) and includes and displays the contents of -->
  <!-- * the manX/realqname.X file. -->
  <!-- * -->
  <!-- * If a refentry has multiple refnames, we generate a "stub" page for -->
  <!-- * each refname found, except for the first one. -->
  <xsl:template name="write.stubs">
    <xsl:param name="first.refname"/>
    <xsl:param name="section"/>
    <xsl:param name="lang"/>
    <xsl:for-each select="refnamediv/refname">
      <xsl:if test=". != $first.refname">
        <xsl:call-template name="write.text.chunk">
          <xsl:with-param name="filename">
            <xsl:call-template name="make.adjusted.man.filename">
              <xsl:with-param name="name" select="."/>
              <xsl:with-param name="section" select="$section"/>
              <xsl:with-param name="lang" select="$lang"/>
            </xsl:call-template>
          </xsl:with-param>
          <xsl:with-param name="quiet" select="$man.output.quietly"/>
          <xsl:with-param name="suppress-context-node-name" select="1"/>
          <xsl:with-param name="message-prolog">Note: </xsl:with-param>
          <xsl:with-param name="message-epilog"> (soelim stub)</xsl:with-param>
          <xsl:with-param name="content">
            <xsl:value-of select="concat('.so man', $section, '/')"/>
            <xsl:call-template name="make.adjusted.man.filename">
              <xsl:with-param name="name" select="$first.refname"/>
              <xsl:with-param name="section" select="$section"/>
            </xsl:call-template>
            <xsl:text>&#10;</xsl:text>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <!-- ============================================================== -->

  <!-- *  A manifest file is useful for doing "make clean" during -->
  <!-- *  builds and for other purposes. When we make the manifest -->
  <!-- *  file, we need to include in it a filename for each man-page -->
  <!-- *  generated, including any "stub" pages. -->
  <xsl:template name="generate.manifest">
    <xsl:variable name="filelist">
      <xsl:for-each select="//refentry">
        <!-- * all refname instances in a Refentry inherit their section -->
        <!-- * numbers from the parent Refentry; so we only need to get -->
        <!-- * the section once per Refentry, not once per Refname -->
        <xsl:variable name="section">
          <xsl:call-template name="get.refentry.section">
            <xsl:with-param name="quiet" select="1"/>
          </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="lang">
          <xsl:call-template name="l10n.language"/>
        </xsl:variable>
        <xsl:for-each select="refnamediv/refname">
          <xsl:call-template name="make.adjusted.man.filename">
            <xsl:with-param name="name" select="."/>
            <xsl:with-param name="section" select="$section"/>
            <xsl:with-param name="lang" select="$lang"/>
          </xsl:call-template>
          <xsl:text>&#10;</xsl:text>
        </xsl:for-each>
      </xsl:for-each>
    </xsl:variable>

    <!-- * we write the manifest file once per document, not once per -->
    <!-- * Refentry -->
    <xsl:call-template name="write.text.chunk">
      <xsl:with-param name="filename">
        <xsl:value-of select="$man.output.manifest.filename"/>
      </xsl:with-param>
      <xsl:with-param name="quiet" select="1"/>
      <xsl:with-param name="message-prolog">Note: </xsl:with-param>
      <xsl:with-param name="message-epilog"> (manifest file)</xsl:with-param>
      <xsl:with-param name="content">
        <xsl:value-of select="$filelist"/>
      </xsl:with-param>
    </xsl:call-template>
    <xsl:if test="$man.output.quietly = 0">
      <xsl:message><xsl:text>&#10;</xsl:text></xsl:message>
    </xsl:if>
  </xsl:template>

</xsl:stylesheet>
