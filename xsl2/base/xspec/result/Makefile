VPATH=../src

SOURCES=$(wildcard ../src/*.xml)
RAWSRCS=$(subst ../src/,,$(SOURCES))
TARGETS=$(patsubst %.xml,%.html,$(RAWSRCS))

BIBCOLL=/sourceforge/docbook/xsl2/base/xspec/etc/bibliography.collection.xml
GLSCOLL=/sourceforge/docbook/xsl2/base/xspec/etc/glossary.collection.xml

all: $(TARGETS)

%.html : %.xml
	saxon $< ../../html/docbook.xsl $@ bibliography.collection=$(BIBCOLL) glossary.collection=$(GLSCOLL)
