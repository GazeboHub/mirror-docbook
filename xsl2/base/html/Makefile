include ../../cvstools/Makefile.incl
param.xsl: param.xml ../common/mkparam.xsl
	../../cvstools/saxon -8b $^ $@

clean:
	$(RM) param.xsl
