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

librtm_a_SOURCES = \
	rtm.vala http_proxy_interface.vala requester.vala authenticator.vala

lib_LIBRARIES=librtm.a

librtm_a_VALAFLAGS =  \
	--pkg gtk+-3.0 --pkg gee-1.0
