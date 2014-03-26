## Process this file with automake to produce Makefile.in

AM_CPPFLAGS = \
	-DPACKAGE_LOCALE_DIR=\""$(localedir)"\" \
	-DPACKAGE_SRC_DIR=\""$(srcdir)"\" \
	-DPACKAGE_DATA_DIR=\""$(pkgdatadir)"\" \
	$(GCOWBOY_CFLAGS) $(GEE_CFLAGS)

AM_CFLAGS =\
	 -Wall\
	 -g \
	 $(GEE_CFLAGS)

bin_PROGRAMS = test

test_SOURCES = \
	test.vala \
	authenticator_test.vala \
  ../rtm.vala \
	../requester.vala \
	../authenticator.vala \
	../response.vala \
	../frob.vala \
	../../src/http_proxy_interface.vala

test_VALAFLAGS =  \
	--pkg gtk+-3.0 --pkg gee-1.0 --pkg libxml-2.0

test_LDFLAGS = \
	-Wl,--export-dynamic,$(GEE_LIBS)

test_LDADD = $(GCOWBOY_LIBS)

