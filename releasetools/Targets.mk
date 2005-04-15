# this file is a -*- makefile -*- snippet
# targets in the file are used only for release builds

# $Id$

RELEASE-NOTES.html: RELEASE-NOTES.xml
	$(XJPARSE) $<
	$(XSLT) $< $(DOC-LINK-STYLE) $@

RELEASE-NOTES.txt: RELEASE-NOTES.html
	$(BROWSER) $(BROWSER_OPTS) $< > $@

.CatalogManager.properties.example:
	cp -p $(CATALOGMANAGER) .CatalogManager.properties.example

.urilist:
	for uri in $(URILIST); do \
	echo $$uri >> .urilist; \
	done

install.sh:
	cp -p $(INSTALL_SH) install.sh

distrib: all $(DISTRIB_DEPENDS) .CatalogManager.properties.example install.sh .urilist
	$(CVS2LOG) -w
ifeq ($(DIFFVER),)
	$(MERGELOGS) > $(NEWSFILE)
else
	$(MERGELOGS) -v $(DIFFVER) > $(NEWSFILE)
endif

newversion:
ifeq ($(CVSCHECK),)
ifeq ($(DIFFVER),)
	@echo "DIFFVER must be specified."
	exit 1
else
ifeq ($(NEXTVER),$(RELVER))
	cvs tag $(TAGVER)
	$(MAKE) DIFFVER=$(DIFFVER) distrib
else
	@echo "VERSION $(RELVER) doesn't match specified version $(NEXTVER)."
	exit 1
endif
endif
else
	@echo "CVS is not up-to-date! ($(CVSCHECK))"
	exit 1
endif

freshmeat:
ifeq ($(SFRELID),)
	@echo "You must specify the sourceforge release identifier in SFRELID"
	exit 1
else
	$(XSLT) VERSION VERSION $(TMP)/fm-docbook-$(DISTRO) sf-relid=$(SFRELID)
	grep -v "<?xml" $(TMP)/fm-docbook-$(DISTRO) | freshmeat-submit $(FMGO)
endif

zip:
ifeq ($(ZIPVER),)
	@echo You must specify ZIPVER for the zip target
	exit 1
else
# normalize perms/filemodes for all files and dirs
	find . -type f | xargs chmod 0644
	find . -type d | xargs chmod 0755
# set executable bit on anything that should be executable
ifneq ($(EXECUTABLES),)
	chmod 0755 $(EXECUTABLES)
endif

# -----------------------------------------------------------------
#     Prepare *zip files for main (NON-doc) part of distro
# -----------------------------------------------------------------
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	rm -f  $(TMP)/tar.exclude
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.gz
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2
	rm -f  $(TMP)/docbook-$(DISTRO)-$(ZIPVER).zip
	umask 022; mkdir -p $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	touch $(TMP)/tar.exclude
# distro-specific excludes
	for file in $(DISTRIB_EXCLUDES); do \
	  find . -print  | grep $$file   | cut -c3- >> $(TMP)/tar.exclude; \
	done
# specific excludes for distros with docs
	if [ -d doc ]; then \
	  find . -print  | grep /doc/    | cut -c3- >> $(TMP)/tar.exclude; \
	fi
	if [ -d docsrc ]; then \
	  find . -print  | grep /docsrc/ | cut -c3- >> $(TMP)/tar.exclude; \
	fi
# global excludes
	for file in $(ZIP_EXCLUDES); do \
	  find . -print  | grep $$file   | cut -c3- >> $(TMP)/tar.exclude; \
	done
# tar up distro, then gzip/bzip/zip it
	tar cf - * .[^.]* --exclude-from $(TMP)/tar.exclude | (cd $(TMP)/docbook-$(DISTRO)-$(ZIPVER); tar xf -)
	umask 022; cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | gzip > docbook-$(DISTRO)-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | bzip2 > docbook-$(DISTRO)-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && zip -q -rpD docbook-$(DISTRO)-$(ZIPVER).zip docbook-$(DISTRO)-$(ZIPVER)
	rm -f $(TMP)/tar.exclude

# -----------------------------------------------------------------
#     Prepare *zip files for DOC part of distro (if any)
# -----------------------------------------------------------------
ifeq ($(shell test -d doc; echo $$?),0)
	rm -rf $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	rm -f  $(TMP)/tar.exclude
	rm -f  $(TMP)/docbook-$(DISTRO)-doc-$(ZIPVER).tar.gz
	rm -f  $(TMP)/docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2
	rm -f  $(TMP)/docbook-$(DISTRO)-doc-$(ZIPVER).zip
	umask 022; mkdir -p $(TMP)/docbook-$(DISTRO)-$(ZIPVER)
	touch $(TMP)/tar.exclude
# distro-specific excludes
	for file in $(DISTRIB_EXCLUDES); do \
	  find . -print  | grep $$file   | cut -c3- >> $(TMP)/tar.exclude; \
	done
# global excludes
	for file in $(ZIP_EXCLUDES); do \
	  find . -print  | grep $$file   | cut -c3- >> $(TMP)/tar.exclude; \
	done
# tar up just the doc and docsrc dirs & if an "images" dir exists,
# mv it into the doc dir
	tar cf - doc docsrc images --exclude-from $(TMP)/tar.exclude | (cd $(TMP)/docbook-$(DISTRO)-$(ZIPVER); tar xf -)
	umask 022; cd $(TMP) && \
	if [ -d docbook-$(DISTRO)-$(ZIPVER)/images ]; \
	  then mv docbook-$(DISTRO)-$(ZIPVER)/images docbook-$(DISTRO)-$(ZIPVER)/doc/; \
	fi
	umask 022; cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | gzip > docbook-$(DISTRO)-doc-$(ZIPVER).tar.gz
	umask 022; cd $(TMP) && tar cf - docbook-$(DISTRO)-$(ZIPVER) | bzip2 > docbook-$(DISTRO)-doc-$(ZIPVER).tar.bz2
	umask 022; cd $(TMP) && zip -q -rpD docbook-$(DISTRO)-doc-$(ZIPVER).zip docbook-$(DISTRO)-$(ZIPVER)
	rm -f $(TMP)/tar.exclude
endif
endif

install: zip
	-$(FTP) $(FTP_OPTS) "mput -O $(SF_UPLOAD_DIR) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).*; quit" $(SF_UPLOAD_HOST)
	$(SCP) $(SCP_OPTS) $(TMP)/docbook-$(DISTRO)-$(ZIPVER).tar.bz2 $(PROJECT_USER)@$(PROJECT_HOST):$(PROJECT_BASE)/$(DISTRO)/
	$(SSH) $(SSH_OPTS)-l $(PROJECT_USER) $(PROJECT_HOST) \
	  "(\
	   umask 002; \
	   cd $(PROJECT_BASE)/$(DISTRO); \
	   rm -rf $(ZIPVER); \
	   tar xfj docbook-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   mv docbook-$(DISTRO)-$(ZIPVER) $(ZIPVER); \
	   rm -rf docbook-$(DISTRO)-$(ZIPVER).tar.bz2; \
	   chmod -R g+w $(ZIPVER); \
	   rm -f current; \
	   ln -s $(ZIPVER) current; \
	   if [ -d $(ZIPVER)/doc ] || [ -d $(ZIPVER)/images ]; then \
	   cd $(ZIPVER)/doc; \
	   ln -s ../images; \
	   fi \
	   )"
