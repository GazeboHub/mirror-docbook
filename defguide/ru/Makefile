include ../../buildtools/Makefile.incl

SSTITLEPG=stylesheets/html-titlepage.xsl
SSCHUNK=stylesheets/chunk.xsl
SSFO=stylesheets/tdgfo.xsl

SOURCE=tdg.xml
MEMORY=100000000
BASEDIR=../html/
ROOTID=
FORESULT=chunk.fo

FMGO=-N

ifeq ($(SOURCE),tdgex.xml)
  STYLEOPT=output.type=unexpanded
  HTMLEXT=-x.html
else
  STYLEOPT=
  HTMLEXT=.html
endif

ifeq ($(ROOTID),)
  ROOTIDPARAM=
else
  ROOTIDPARAM=rootid=$(ROOTID)
endif

ifeq ($(XSLT),xsltproc)
  MEMORYOPT=
else
  MEMORYOPT=-m $(MEMORY)
endif

all: chunks

test:
	xjparse $(SOURCE)

tdg.xml: bookinfo.xml
	xsltproc --output $@ stylesheets/identity.xsl book.xml

tdgex.xml: bookinfo.xml
	xsltproc --output $@ stylesheets/identity.xsl unexbook.xml

bookinfo.xml: VERSION.xml
	$(XSLT) $< $< $@

chunks: $(SSTITLEPG)
	$(XSLT) $(MEMORYOPT) $(SOURCE) $(SSCHUNK) /dev/null base.dir=$(BASEDIR) html.ext=$(HTMLEXT) $(STYLEOPT)
	$(XSLT) $(MEMORYOPT) $(SOURCE) $(SSCHUNK) /dev/null base.dir=$(BASEDIR) html.ext=$(HTMLEXT) rootid=index $(STYLEOPT)

chunk: $(SSTITLEPG)
	$(XSLT) $(MEMORYOPT) $(SOURCE) $(SSCHUNK) /dev/null base.dir=$(BASEDIR) html.ext=$(HTMLEXT) $(ROOTIDPARAM) $(STYLEOPT)

index: $(SSTITLEPG)
	$(XSLT) $(MEMORYOPT) $(SOURCE) $(SSCHUNK) /dev/null base.dir=$(BASEDIR) html.ext=$(HTMLEXT) rootid=index

stylesheets/html-titlepage.xsl: stylesheets/html-titlepage.xml
	$(XSLT) $< ../../xsl/template/titlepage.xsl $@

fochunks:
	$(XSLT) $(MEMORYOPT) $(SOURCE) $(SSFO) partI.fo rootid=docbook-intro $(STYLEOPT)
	$(XSLT) $(MEMORYOPT) $(SOURCE) $(SSFO) partII.fo rootid=docbook-reference $(STYLEOPT)
	$(XSLT) $(MEMORYOPT) $(SOURCE) $(SSFO) partIII.fo rootid=docbook-apps $(STYLEOPT)

fochunk:
	$(XSLT) $(MEMORYOPT) $(SOURCE) $(SSFO) $(FORESULT) $(ROOTIDPARAM) $(STYLEOPT)

%.pdf: %.fo
	xep $<

tdg.fo: tdg.xml
	$(XSLT) $(MEMORYOPT) $< $(SSFO) $@ $(ROOTIDPARAM) $(STYLEOPT)

tdg.pdf: tdg.fo
	xep $< $@

clean:
	rm -f tdg.{html,fo,pdf} tdg.xml tdgex.xml

freshmeat:
	$(XSLT) VERSION.xml VERSION.xml /tmp/fm-docbook-tdg freshmeat=1
	grep -v "<?xml" /tmp/fm-docbook-tdg | freshmeat-submit $(FMGO)
