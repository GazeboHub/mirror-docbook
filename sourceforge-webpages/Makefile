PROC=saxon
PROCOPT=
STYLESHEET=.stylesheets/tabular.xsl
#STYLESHEET=.stylesheets/textonly.xsl
CHUNK-TAB=/share/doctypes/website-pages/xsl/chunk-tabular.xsl
CHUNK-WEB=/share/doctypes/website-pages/xsl/chunk-website.xsl
AUTOSTYLE=/share/doctypes/website-pages/xsl/autolayout.xsl
DEPSTYLE=/share/doctypes/website-pages/xsl/makefile-dep.xsl
DESTPATH=.

.PHONY : clean

all: website

autolayout.xml: layout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(PROC) $(PROCOPT) $< $(AUTOSTYLE) $@

chunk-tabular: autolayout.xml
	$(PROC) $(PROCOPT) layout.xml $(CHUNK-TAB) - output-root=$(DESTPATH)

chunk-website: autolayout.xml
	$(PROC) $(PROCOPT) layout.xml $(CHUNK-WEB) - output-root=$(DESTPATH)

%.html: autolayout.xml
	xjparse $(filter-out autolayout.xml,$^)
	$(PROC) $(PROCOPT) $(filter-out autolayout.xml,$^) $(STYLESHEET) $@
	tidy -iq -latin1 -mn $@

depends: autolayout.xml
	xjparse $<
	$(PROC) $(PROCOPT) $< $(DEPSTYLE) Makefile.dep

realclean: clean
	rm -f autolayout.xml

include Makefile.dep
