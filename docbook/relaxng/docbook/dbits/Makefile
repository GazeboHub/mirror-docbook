include _header.mak

SRCS = dbits.rnc

BINARY = dbits.rnd

all:: dbits.rng dbits.rnc

clean:: ; rm -f dbits.rng dbits.rnc

$(_OUTTOP)/its/dbits.rng: its/its20.rnc its/its20-types.rnc \
             src/annotations.rnc src/bibliography.rnc \
             src/callouts.rnc src/calstbl.rnc \
             src/docbook.rnc src/ebnf.rnc src/glossary.rnc \
             src/hier.rnc src/htmltbl.rnc \
             src/index.rnc src/math.rnc src/mathml.rnc \
             src/msgset.rnc src/pool.rnc src/qandaset.rnc \
             src/refentry.rnc src/refsect1.rnc src/sect1.rnc \
             src/svg.rnc src/tasks.rnc src/toc.rnc \
             docbookxi/xinclude.rnc src/xlink.rnc

include _footer.mak

dbits.rng: $(basename $(dbits_BINARY)).rnx
	$(XSLTPROC) --output $@ $(TOOLS)/removedoc.xsl $<

dbits.rnc: dbits.rng
	$(RUNTRANG) $< $@

