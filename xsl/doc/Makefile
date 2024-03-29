include $(DOCBOOK_SVN)/releasetools/Variables.mk

XJPARSEFLAGS= -E 0 -w
FO_BUILDER=saxon
XSLTOPT=
PROCOPT=

XEP=xep
XEPFLAGS=

# TXT_MAKER is the Web browser to use for dumping a text version
# of the reference docs; text output from w3m looks better than
# that from elinks or lynx; but w3m sometimes hangs unexpectedly
# under OSX; setting GC_NPROCS=1 prevents it from hanging
TXT_MAKER = GC_NPROCS=1 w3m
TXT_MAKER_FLAGS = -dump

XMLID_TO_ID=../tools/xsl/build/xmlid-to-id.xsl

GZIP=gzip
GZIPFLAGS=

HTMLMANIFEST=HTML.manifest

PARAM_DIRS=html fo manpages roundtrip slides/fo slides/xhtml website
PI_DIRS=html fo common

PARAM_XML_FILES=$(foreach format,$(PARAM_DIRS),../$(format)/param.xml)
PI_XML_FILES=$(foreach format,$(PI_DIRS),../$(format)/pi.xml)
OTHER_XML_FILES=../common/common.xml ../common/utility.xml ../common/refentry.xml ../common/charmap.xml ../template/titlepage.xml ../fo/table.xml

DOC_SOURCE_XML_FILES=$(PARAM_XML_FILES) $(PI_XML_FILES) $(OTHER_XML_FILES)

DIRS=common fo html lib manpages pi refentry roundtrip slides template utility website

.PHONY : clean

# rule for building file with includes resolved; uses hacky
# stylesheet to transform all @xml:id instances to @id instances;
# otherwise, xsltproc reports duplicate ID errors...
%.included: %
	$(XINCLUDE) $< > $@.tmp
	$(DOCBOOK_SVN)/buildtools/saxon $@.tmp $(XMLID_TO_ID) > $@
	$(RM) $@.tmp

# build reference.pdf.gz except for snapshot and "-pre" releases
ifeq (snapshot,$(findstring snapshot,$(RELVER)))
all: fo/page.png reference.html reference.css reference.txt.gz
else
ifeq (-pre,$(findstring -pre,$(RELVER)))
all: fo/page.png reference.html reference.css reference.txt.gz
else
all: fo/page.png reference.html reference.css reference.txt.gz reference.pdf.gz
endif
endif

index.html: ../docsrc/reference.xml.included $(RSTYLE) $(DOC_SOURCE_XML_FILES)
	$(XSLT) $< $(RSTYLE)

reference.html: index.html
	cp -p $< $@

reference.css: ../docsrc/reference.css
	cp -p $< .
	for dir in $(DIRS); do cp -p $< $$dir; done

reference.fo: ../docsrc/reference.xml.included $(REFERENCEFOXSL) fo/page.png $(DOC_SOURCE_XML_FILES)
	$(DOCBOOK_SVN)/buildtools/xslt -$(FO_BUILDER) $< $(REFERENCEFOXSL) > $@

reference.pdf: reference.fo
ifeq ($(PDF_MAKER),dblatex)
	-$(DBLATEX) $(DBLATEXFLAGS) \
	  -p $(DBX_STYLE) \
	  -o $@ \
    $< 
else
ifeq ($(PDF_MAKER),xep)
	$(XEP) $(XEPFLAGS) $<
endif
endif

reference.txt.html: ../docsrc/reference.xml.included $(REFERENCETXTXSL) $(DOC_SOURCE_XML_FILES)
	$(XSLT) $< $(REFERENCETXTXSL) > $@

reference.txt: reference.txt.html
	$(TXT_MAKER) $(TXT_MAKER_FLAGS) $< > $@

reference.pdf.gz: reference.pdf
	cat $< | $(GZIP) $(GZIPFLAGS) > $@

reference.txt.gz: reference.txt
	cat $< | $(GZIP) $(GZIPFLAGS) > $@

fo/page.png: ../docsrc/page.png
	cp -p $< $@

clean:
	$(RM) reference.css
	for dir in $(DIRS); do $(RM) $$dir/reference.css; done
	$(RM) reference.html
	$(RM) reference.txt.html
	$(RM) reference.fo
	$(RM) reference.pdf
	$(RM) reference.pdf.gz
	$(RM) reference.txt.gz
	$(RM) reference.txt
	$(RM) fo/page.png
	$(RM) ../docsrc/reference.xml.included
	if [ -f $(HTMLMANIFEST) ]; then for file in $$(cat $(HTMLMANIFEST)); do $(RM) $$file; done; fi
	$(RM) $(HTMLMANIFEST)
