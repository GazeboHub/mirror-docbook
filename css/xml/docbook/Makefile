
version ?= dev
dist_dir = docbook-css-${version}
dist_tgz = ${dist_dir}.tar.gz
web_tgz = dbweb.tar.gz

# stuff to go in ${dist_tgz}
dist_files = driver.css core.css styles.css tables.css opera.css mozilla.css \
	l10n.css l10n/*.css \
	tests/index.html tests/*.x{s,m}l tests/eiffeltower.png db-bindings.xml

dist:	tests-gen
	mkdir -p ${dist_dir}
	cp -r ${dist_files} ${dist_dir}
	tar czvf ${dist_tgz} ${dist_dir}
	rm -r ${dist_dir}

clean:
	rm -r ${dist_dir} ${dist_tgz} ${web_tgz} \
	tests/inlines-gen.xml tests/localisation-gen.xml


webdist: dist
	tar czvf ${web_tgz} ${dist_tgz} index.html ${dist_files} LDP-Author-Guide/ldp-author-guide-concat.xml LDP-Author-Guide/*.jpg makecss.rb


tests-gen: tests/inlines-gen.xml tests/localisation-gen.xml

tests/inlines-gen.xml:	tests/inlines.xsl tests/inlines-source.xml
	xsltproc tests/inlines.xsl tests/inlines-source.xml > tests/inlines-gen.xml

tests/localisation-gen.xml:	tests/localisation.xsl tests/localisation-source.xml
	xsltproc tests/localisation.xsl tests/localisation-source.xml > tests/localisation-gen.xml
