## Process this file with automake to produce Makefile.in
## Created by Anjuta

SUBDIRS = src \
	rtm \
	rtm/test

gcowboydocdir = ${prefix}/doc/gcowboy
gcowboydoc_DATA = \
	README\
	COPYING\
	AUTHORS\
	ChangeLog\
	INSTALL\
	NEWS


EXTRA_DIST = $(gcowboydoc_DATA)

# Remove doc directory on uninstall
uninstall-local:
	-rm -r $(gcowboydocdir)
