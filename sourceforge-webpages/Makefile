# $Id$
include ../buildtools/Makefile.incl

ZIP=zip
ZIP_FLAGS=-rpD 

SCP=scp
SCP_FLAGS=-pr

SSH=ssh
SSH_FLAGS=

PERL=perl

TEMP=/tmp

SITEHOST=docbook.sf.net
SITEDIR=/home/groups/d/do/docbook/htdocs/
SITETEMP=/tmp
SF_USERNAME ?= $(shell sed 's/^:.\+:\([^@]\+\)@.\+$$/\1/' CVS/Root)

BASEDIR=$(shell (pwd | $(PERL) -p -e "s|.*/([^/]*)$$|\1|g"))
SITEUMASK=002

all: dist install

Changes:
	@echo
	@echo Making 'Changes' file...
	$(CVS2LOG) -w
	$(MERGELOGS) -v none 2> /dev/null | \
	$(PERL) -p -e "s/^Changes since .*$$/Changelog for this site\n\
	-----------------------------------------------------------------------/g" \
	> Changes

dist: Changes
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
	cd $(TEMP) && $(ZIP) $(ZIP_FLAGS) $(shell pwd)/$(BASEDIR).zip $(BASEDIR)
	$(RM) -r $(TEMP)/$(BASEDIR)
	$(RM) $(TEMP)/tar.exclude

install: $(BASEDIR).tar.gz $(BASEDIR).zip
ifeq ($(SITEHOST),)
	$(error You must specify a value for SITEHOST)
endif
	@echo
	@echo Installing files in $(SITEDIR) on $(SITEHOST)...
	@echo
	$(SCP) $(SCP_FLAGS) $? $(SF_USERNAME)@$(SITEHOST):$(SITEDIR)
	$(SSH) $(SSH_FLAGS) -l $(SF_USERNAME) $(SITEHOST) "(umask $(SITEUMASK); cd $(SITEDIR); \
	cat $(BASEDIR).tar.gz | gunzip | \
	(cd $(SITETEMP); tar xf -); \
	cp -pR $(SITETEMP)/$(BASEDIR)/* $(SITETEMP)/$(BASEDIR)/.??* .; \
	rm -rvf $(SITETEMP)/$(BASEDIR) )"

clean:
	$(RM) $(BASEDIR).tar.gz
	$(RM) Changes
