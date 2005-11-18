include ../cvstools/Makefile.incl

# note that the following variables used in this makefile are
# defined in ../cvstools/Makefile.incl
#
# * CVSROOT:     root of the docbook CVS tree on your local machine
# * WEBSITEROOT: path to the Website doctype/stylesheet distro
# * XSLT:        script for invoking XSLT engine(s)
# * TIDY:        wrapper script around the 'tidy' program
# * CVS2LOG:     script for creating changelogs
# * MERGELOGS:   script for merging changelogs

# before running make on this file, you should ensure the TEMP
# variable is defined in your environment or specified on the make
# command line

# if you want to use this makefile to install your content on a
# remote webserver, there are some other variables you will need
# to specify; read further down in the Makefile for descriptions
# of those

SCP=scp
SSH=ssh
PERL=perl
ZIP=zip

# path to the 'Created with DocBook|Slides|Website' buttons
BUTTONSROOT=$(CVSROOT)/buttons

STYLESHEETDIR=.stylesheets
TABSTYLE=$(STYLESHEETDIR)/chunk-tabular.xsl
WEBSTYLE=$(STYLESHEETDIR)/chunk-website.xsl
AUTOSTYLE=$(STYLESHEETDIR)/autolayout.xsl

AUTOLAYOUTFILE=$(shell pwd)/autolayout.xml
DESTPATH=.

# set MAKENONTAB to '1' if you want to make the non-tabular
# version of the site in addition to the normal (tabular version) 
MAKENONTAB=0
NONTABPREFIX=nontab-

# set USETIDY to '1' if you want to run all HTML content through
# 'tidy' to fix HTML errors in it, turn it into valid XHTML, and
# to indent/pretty-print it
USETIDY=0
TIDYFLAGS=-iq -latin1 -mn

# this just gets the name of the current directory (there's
# probably some better way to do this...
BASEDIR=$(shell (pwd | $(PERL) -p -e "s|.*/([^/]*)$$|\1|g"))
SITEUMASK=002

.PHONY : website graphics dist install clean distclean Changes

all: autolayout.xml website

autolayout.xml: layout.xml
	@echo
	@echo Making autolayout.xsl...
	xjparse $(filter-out autolayout.xml,$^)
	$(XSLT) $< $(AUTOSTYLE) $@

website:
	@echo
	@echo Making default \(tabular\) versions of HTML files...
	$(XSLT) autolayout.xml $(TABSTYLE) prefix="$(NONTABPREFIX)" makenontab="$(MAKENONTAB)" -
ifeq ($(MAKENONTAB),1)
	@echo
	@echo Making alternative \(non-tabular\) versions of HTML files...
	$(XSLT) autolayout.xml $(WEBSTYLE) prefix="$(NONTABPREFIX)" filename-prefix="$(NONTABPREFIX)" -
endif
ifeq ($(USETIDY),1)
	@echo
	@echo Running all HTML files through tidy...
	find . -name "*.html" -exec $(TIDY) $(TIDYFLAGS) {} 2>/dev/null \;
endif

graphics:
	@echo
	@echo Making symlinks to DocBook buttons and Website navigation icons...
	if ! test -d "graphics/navicons"; \
	then ln -s $(WEBSITEROOT)/example/graphics/navicons graphics; \
	fi
	if ! test -d "graphics/buttons"; \
	then ln -s $(BUTTONSROOT) graphics; \
	fi

Changes:
	@echo
	@echo Making 'Changes' file...
	$(CVS2LOG) -w
	$(MERGELOGS) -v none 2> /dev/null | \
	$(PERL) -p -e "s/^Changes since .*$$/Changelog for this site\n\
	-----------------------------------------------------------------------/g" \
	> Changes

dist: graphics Changes
ifeq ($(TEMP),)
	$(error You must specify a value for TEMP \(e.g., '/tmp'\))
endif
	@echo
	@echo Building list of files to exclude from upload archives...
	rm -rf $(TEMP)/$(BASEDIR)
	rm -f $(TEMP)/tar.exclude
	rm -f $(BASEDIR).tar.gz
	rm -f $(BASEDIR).zip
	mkdir $(TEMP)/$(BASEDIR)
	touch $(TEMP)/tar.exclude
	find . -follow -print  | grep /CVS$$ | cut -c3- >> $(TEMP)/tar.exclude
	find . -follow -print  | grep /CVS/ | cut -c3- >> $(TEMP)/tar.exclude
	find . -follow -print  | grep /debian/ | cut -c3- >> $(TEMP)/tar.exclude
	find . -follow -print  | grep .classes | cut -c3- >> $(TEMP)/tar.exclude
	find . -follow -type f -name "*~"  | cut -c3- >> $(TEMP)/tar.exclude
	find . -follow -type f -name ".*~"  | cut -c3- >> $(TEMP)/tar.exclude
	find . -follow -type f -name ".*.pyc"  | cut -c3- >> $(TEMP)/tar.exclude
	find . -follow -type f -name "#*"  | cut -c3- >> $(TEMP)/tar.exclude
	find . -follow -type f -name ".#*"  | cut -c3- >> $(TEMP)/tar.exclude
	find . -follow -type f -name ".*.swo"  | cut -c3- >> $(TEMP)/tar.exclude
	find . -follow -type f -name ".*.swp"  | cut -c3- >> $(TEMP)/tar.exclude
	find . -type f -name ".cvsignore"  | cut -c3- >> /tmp/tar.exclude
	find . -type f -name ".memdump"  | cut -c3- >> /tmp/tar.exclude
	find . -follow -type f -name "README.CVS"   | cut -c3- >> $(TEMP)/tar.exclude
	@echo
	@echo Making .tar.gz and .zip archive files for upload....
	cd .. && tar cfh - $(BASEDIR) --exclude-from $(TEMP)/tar.exclude | (cd $(TEMP); tar xf -)
	cd $(TEMP) && tar cf - $(BASEDIR) | gzip > $(shell pwd)/$(BASEDIR).tar.gz
	cd $(TEMP) && $(ZIP) -rpD $(shell pwd)/$(BASEDIR).zip $(BASEDIR)
	rm -rf $(TEMP)/$(BASEDIR)
# keep symlinks around if you want to be able to see linked graphics in
# your local environment
# 	if test -L "graphics/navicons"; \
# 	then rm graphics/navicons; \
# 	fi
# 	if test -L "graphics/buttons"; \
# 	then rm graphics/buttons; \
# 	fi
	rm -f $(TEMP)/tar.exclude

# to use this Makefile to install a site, you need to specify:
#
#   * SITEHOST: remote host to upload (scp) site content to
#   * SITEDIR:  directory on remote host to upload content to
#   * SITETEMP: temp directory on remote host (for untarring)
#
# you also need to have ssh/scp configured and working

install: $(BASEDIR).tar.gz $(BASEDIR).zip
ifeq ($(SITEHOST),)
	$(error You must specify a value for SITEHOST)
endif
	@echo
	@echo Installing files in $(SITEDIR) on $(SITEHOST)...
	@echo
	$(SCP) -p $? $(SITEHOST):$(SITEDIR)
	$(SSH) $(SITEHOST) "(umask $(SITEUMASK); cd $(SITEDIR); \
	cat $(BASEDIR).tar.gz | gunzip | \
	(cd $(SITETEMP); tar xf -); \
	cp -pR $(SITETEMP)/$(BASEDIR)/* $(SITETEMP)/$(BASEDIR)/.??* .; \
	rm -rvf $(SITETEMP)/$(BASEDIR) )"

clean:

distclean: clean
	rm -vf autolayout.xml .depends.tabular .depends.textonly $(BASEDIR).tar.gz $(BASEDIR).zip

# $Id$
