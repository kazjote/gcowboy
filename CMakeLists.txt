cmake_minimum_required (VERSION 2.6)

list(APPEND CMAKE_MODULE_PATH
    ${CMAKE_SOURCE_DIR}/cmake
)

find_package(Vala REQUIRED)
include(${VALA_USE_FILE})

project (GCowboy)

find_package(PkgConfig)

pkg_check_modules(GTK REQUIRED gtk+-3.0)
pkg_check_modules(GEE REQUIRED gee-1.0)
pkg_check_modules(LIBXML REQUIRED libxml-2.0)
pkg_check_modules(LIBSOUP REQUIRED libsoup-2.4)
pkg_check_modules(GIO REQUIRED gio-2.0)
pkg_check_modules(GTHREAD REQUIRED gthread-2.0)

add_definitions(${GTK_CFLAGS} ${GTK_CFLAGS_OTHER}
    ${GEE_CFLAGS} ${GEE_CFLAGS_OTHER}
    ${LIBXML_CFLAGS} ${LIBXML_CFLAGS_OTHER}
    ${LIBSOUP_CFLAGS} ${LIBSOUP_CFLAGS_OTHER}
    ${GIO_CFLAGS} ${GIO_CFLAGS_OTHER} -w)
link_libraries(${GTK_LIBRARIES} ${LIBXML_LIBRARIES} ${LIBSOUP_LIBRARIES} ${GTHREAD_LIBRARIES} ${GEE_LIBRARIES})
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
    src/http_proxy.vala
    src/gcowboy.vala
    src/queue_message.vala
    src/queue_processor.vala
    src/rtm_wrapper.vala
    src/views/task.vala
    src/views/task_list.vala
    src/views/task_list_list.vala
    src/views/notification_area_view.vala
    src/views/new_task_view.vala
    src/models/task_model.vala
    src/models/task_repository.vala
    src/models/task_list_interface.vala
    src/models/task_lists_model.vala
    src/models/standard_task_list_model.vala
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
)

vala_precompile(VALA_GCOWBOY_C
    ${RTM_SRC}
    ${GCOWBOY_SRC}
PACKAGES
    ${GCOWBOY_PACKAGES}
OPTIONS
    --thread
)

add_executable(gcowboy ${VALA_GCOWBOY_C})

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
