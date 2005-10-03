# $Id$

include ../cvstools/Makefile.incl
include ../releasetools/Variables.mk

DISTRO=xsl2

# value of DISTRIB_DEPENDS is a space-separated list of any
# targets for this distro's "distrib" target to depend on
DISTRIB_DEPENDS =

# value of ZIP_EXCLUDES is a space-separated list of any file or
# directory names (shell wildcards OK) that should be excluded
# from the zip file and tarball for the release
DISTRIB_EXCLUDES = \./NOTES extensions/saxon/build/

# value of DISTRIB_PACKAGES is a space-separated list of any
# directory names that should be packaged as separate zip/tar
# files for the release
DISTRIB_PACKAGES =

# to make sure that executable bit is retained after packaging,
# you need to explicitly list any executable files here
DISTRIB_EXECUTABLES = 

# list of pathname+URIs to test for catalog support
URILIST = \
./\ http://docbook.sourceforge.net/release/xsl2/current/

DIRS=common extensions schemas

.PHONY: distrib clean $(NEWSFILE)

all: base

base:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) -C $$i"; $(MAKE) -C $$i; \
		fi \
	done

clean:
	for i in $(DIRS) __bogus__; do \
		if [ $$i != __bogus__ ] ; then \
			echo "$(MAKE) clean -C $$i"; $(MAKE) clean -C $$i; \
		fi \
	done

include ../releasetools/Targets.mk
