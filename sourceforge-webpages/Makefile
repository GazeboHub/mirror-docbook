PROC=saxon
PROCOPT=
TABSTYLE=.stylesheets/tabular.xsl
WEBSTYLE=.stylesheets/textonly.xsl
AUTOSTYLE=/share/doctypes/website-pages/xsl/autolayout.xsl
DEPSTYLE=/share/doctypes/website-pages/xsl/makefile-dep.xsl
DESTPATH=.
TEXTONLY=0

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
	$(PROC) $(PROCOPT) $< $(DEPSTYLE) depends.tabular
	$(PROC) $(PROCOPT) $< $(DEPSTYLE) depends.textonly prefix=txt

realclean: clean
	rm -f autolayout.xml

