PROC=saxon
PROCOPT=
TABSTYLE=.stylesheets/tabular.xsl
WEBSTYLE=.stylesheets/textonly.xsl
AUTOSTYLE=/sourceforge/docbook/website/xsl/autolayout.xsl
DEPSTYLE=/sourceforge/docbook/website/xsl/makefile-dep.xsl
AUTOLAYOUT-FILE=/sourceforge/docbook/sourceforge-webpages/autolayout.xml
DESTPATH=.
TEXTONLY=0
USETIDY=1

ifeq ($(TEXTONLY),0)
STYLESHEET=$(TABSTYLE)
include depends.tabular
else
STYLESHEET=$(WEBSTYLE)
include depends.textonly
endif

.PHONY : clean

all: website

autolayout.xml: layout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(PROC) $(PROCOPT) $< $(AUTOSTYLE) $@
	make depends

chunk: autolayout.xml
	$(PROC) $(PROCOPT) autolayout.xml $(STYLESHEET) -

%.html: autolayout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(PROC) $(PROCOPT) $(filter-out autolayout.xml,$^) $(STYLESHEET) $@ autolayout-file=$(AUTOLAYOUT-FILE)
ifeq ($(USETIDY),1)
	tidy -iq -latin1 -mn $@
endif

depends: autolayout.xml
	xjparse $<
	$(PROC) $(PROCOPT) $< $(DEPSTYLE) depends.tabular
	$(PROC) $(PROCOPT) $< $(DEPSTYLE) depends.textonly prefix=txt

realclean: clean
	rm -f autolayout.xml

