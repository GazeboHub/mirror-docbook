#!/usr/bin/env python

# mkcat.py
# Create XML catalog with URI lookups for a collection of file
# by Tarn Weisner Burton

import os.path, sys, getopt, glob, urlparse

def print_help():
	print 'mkcat [options] pattern pattern ...'
	print
	print 'where "pattern" is shell wildcard pattern'
	print 'and options is one of'
	print
	print '    -h | --help                 : print this message'
	print '    -b[uri] | --base-uri=[uri]  : specify a base uri'
	print '    -c[name] | --catalog=[name] : name for the catalog,'
	print '                                  default is "catalog.xml"'
	sys.exit()

options, args = getopt.getopt(sys.argv[1:], 'b:h', ('base-uri=', 'help'))

base_uri = ''
catalog_name = 'catalog.xml'

for name, value in options:
	if name == '--help':
		print_help()
	elif name == '--base-uri':
		base_uri = value
		if len(base_uri) and base_uri[-1] != '/':
			base_uri = base_uri + '/'
	elif name == '--catalog':
		catalog_name = value

if not len(args):
	print_help()

catalog = open(catalog_name, 'w')

catalog.write('<catalog xmlns="urn:oasis:names:tc:entity:xmlns:xml:catalog">\n\n')

for arg in args:
	for filename in glob.glob(arg):
		filename, uri = os.path.split(filename)
		while len(filename):
			filename, part = os.path.split(filename)
			uri = urlparse.urljoin(part + '/', uri)
		name = urlparse.urljoin(base_uri, uri)
		catalog.write('\t<uri name="%s"\n\t     uri="%s"/>\n\n' % (name, uri))

catalog.write('</catalog>\n')

