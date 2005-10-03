# $Id$

include ../../cvstools/Makefile.incl

all: docbook.rnc

docbook.rnc: ../../docbook/relaxng/docbook/docbook.rnc
	cp $< $@

../../docbook/relaxng/docbook/docbook.rnc:
	$(MAKE) -C ../../docbook/relaxng/docbook/ docbook.rnc

clean:
	$(RM) docbook.rnc
