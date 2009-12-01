all: html

COVERAGE=

.PHONY: html

html: htmltests.xml
	xspec /sourceforge/docbook/xsl2/base/xspec/$< $(COVERAGE)
