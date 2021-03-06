cmake_minimum_required (VERSION 2.6)

list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/cmake/vala
)

include(ValaPrecompile)

project (GCowboy)

find_package(Vala)
find_package(PkgConfig)

pkg_check_modules(GTK REQUIRED gtk+-3.0)
pkg_check_modules(GEE REQUIRED gee-1.0)
pkg_check_modules(LIBXML REQUIRED libxml-2.0)
pkg_check_modules(LIBSOUP REQUIRED libsoup-2.4)
pkg_check_modules(GIO REQUIRED gio-2.0)
pkg_check_modules(GTHREAD REQUIRED gthread-2.0)
pkg_check_modules(LIBWNCK REQUIRED libwnck-3.0)
pkg_check_modules(X11 REQUIRED gdk-x11-3.0)

add_definitions(${GTK_CFLAGS} ${GTK_CFLAGS_OTHER}
    ${GEE_CFLAGS} ${GEE_CFLAGS_OTHER}
    ${LIBXML_CFLAGS} ${LIBXML_CFLAGS_OTHER}
    ${LIBSOUP_CFLAGS} ${LIBSOUP_CFLAGS_OTHER}
    ${LIBWNCK_CFLAGS} ${LIBWNCK_CFLAGS_OTHER}
    ${GIO_CFLAGS} ${GIO_CFLAGS_OTHER}
    -w
    -DWNCK_I_KNOW_THIS_IS_UNSTABLE)
link_libraries(${GTK_LIBRARIES} ${LIBXML_LIBRARIES} ${LIBSOUP_LIBRARIES} ${GTHREAD_LIBRARIES} ${GEE_LIBRARIES} ${LIBWNCK_LIBRARIES})
link_directories(${GTK_LIBRARY_DIRS})

set(RTM_SRC
    rtm/rtm.vala
    rtm/requester.vala
    rtm/authenticator.vala
    rtm/response.vala
    rtm/frob.vala
    rtm/token.vala
    rtm/timeline.vala
    rtm/task_list.vala
    rtm/task_serie.vala
    rtm/task.vala
    src/http_proxy_interface.vala
)

set(GCOWBOY_SRC
    src/config.vala
    src/http_proxy.vala
    src/gcowboy.vala
    src/queue_message.vala
    src/queue_processor.vala
    src/dbus_server.vala
    src/rtm_wrapper.vala
    src/window_bootstrap.vala
    src/dbus_bootstrap.vala
    src/views/task_view.vala
    src/views/tasks_view.vala
    src/views/task_lists_view.vala
    src/views/notification_area_view.vala
    src/views/new_task_view.vala
    src/models/task_model.vala
    src/models/task_repository.vala
    src/models/task_list_interface.vala
    src/models/task_lists_model.vala
    src/models/standard_task_list_model.vala
    src/models/smart_task_list_model.vala
    src/models/search_task_list_model.vala
    src/controllers/search_controller.vala
)

set(GCOWBOY_SRC
    ${GCOWBOY_SRC}
)

set(RTM_TEST_SRC
    rtm/test/test.vala
    rtm/test/authenticator_test.vala
    rtm/test/response_test.vala
    rtm/test/task_test.vala
)

set(GCOWBOY_PACKAGES
    gtk+-3.0
    gee-1.0
    libxml-2.0
    libsoup-2.4
    gio-2.0
    libwnck-3.0
    gdk-x11-3.0
    gdk-x11-3.0
)

vala_precompile(VALA_GCOWBOY_C
    ${RTM_SRC}
    ${GCOWBOY_SRC}
PACKAGES
    ${GCOWBOY_PACKAGES}
OPTIONS
    --thread
    --vapidir=${CMAKE_SOURCE_DIR}/vapi/
)

add_executable(gcowboy ${VALA_GCOWBOY_C})

INSTALL(TARGETS gcowboy
    RUNTIME DESTINATION bin
)

INSTALL(DIRECTORY src/ui DESTINATION share/gcowboy
        FILES_MATCHING REGEX ".(ui|css)")
INSTALL(FILES gcowboy.desktop DESTINATION share/applications)
INSTALL(FILES gcowboy.svg DESTINATION share/icons)

set(CPACK_GENERATOR DEB)
set(CPACK_DEBIAN_PACKAGE_DEPENDS "debhelper (>= 8.0.0), cmake, valac, libgtk-3-dev, libgee-dev, libxml2-dev, libsoup2.4-dev")
set(CPACK_DEBIAN_PACKAGE_DESCRIPTION "Manage your Remember the Milk tasks from desktop app.")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Kacper Bielecki (kazjote) <kazjote@gmail.com>")
set(CPACK_DEBIAN_PACKAGE_NAME gcowboy)
set(CPACK_DEBIAN_PACKAGE_SECTION unknown)
set(CPACK_PACKAGE_VERSION_MAJOR 0)
set(CPACK_PACKAGE_VERSION_MINOR 3)
set(CPACK_PACKAGE_VERSION_PATCH 1)

set(CPACK_PACKAGING_INSTALL_PREFIX "/usr/local")

include(CPack)

if(${DEVELOPMENT})
    set(UI_PATH "src")
else(${DEVELOPMENT})
    set(UI_PATH "${CPACK_PACKAGING_INSTALL_PREFIX}/share/gcowboy")
endif(${DEVELOPMENT})

configure_file(src/config.vala.in src/config.vala)

# RTM TEST

# vala_precompile(VALA_RTM_C
#     ${RTM_SRC}
#     ${RTM_TEST_SRC}
# PACKAGES
#     ${GCOWBOY_PACKAGES}
# OPTIONS
#     --thread
# )
# 
# add_executable(rtm_test ${VALA_RTM_C})


# vim: ts=4 sw=4
