include ../cvstools/Makefile.incl

TABSTYLE=.stylesheets/tabular.xsl
WEBSTYLE=.stylesheets/textonly.xsl
AUTOSTYLE=/sourceforge/docbook/website/xsl/autolayout.xsl
DEPSTYLE=/sourceforge/docbook/website/xsl/makefile-dep.xsl
AUTOLAYOUT-FILE=/sourceforge/docbook/sourceforge-webpages/autolayout.xml
DESTPATH=.
TEXTONLY=1
USETIDY=1

ifeq ($(TEXTONLY),0)
STYLESHEET=$(TABSTYLE)
include .depends.tabular
else
STYLESHEET=$(WEBSTYLE)
include .depends.textonly
endif

.PHONY : clean

all: website

autolayout.xml: layout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(XSLT) $< $(AUTOSTYLE) $@
	make depends

chunk: autolayout.xml
	$(XSLT) autolayout.xml $(STYLESHEET) -

%.html: autolayout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(XSLT) $(filter-out autolayout.xml,$^) $(STYLESHEET) $@ autolayout-file=$(AUTOLAYOUT-FILE)
ifeq ($(USETIDY),1)
	$(TIDY) -iq -latin1 -mn $@
endif

depends: autolayout.xml
	xjparse $<
	$(XSLT) $< $(DEPSTYLE) .depends.tabular
	$(XSLT) $< $(DEPSTYLE) .depends.textonly prefix=txt

realclean: clean
	rm -f autolayout.xml

