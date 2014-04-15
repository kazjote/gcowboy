valac \
    --pkg gtk+-3.0 \
    --pkg gee-1.0 \
    --pkg libxml-2.0 \
    rtm/test/test.vala \
    rtm/test/authenticator_test.vala \
    rtm/test/response_test.vala \
    rtm/rtm.vala \
    rtm/requester.vala \
    rtm/authenticator.vala \
    rtm/response.vala \
    rtm/frob.vala \
    rtm/token.vala \
    rtm/timeline.vala \
    rtm/task_list.vala \
    rtm/task_serie.vala \
    rtm/task.vala \
    src/http_proxy_interface.vala \
    --Xcc=-w \
    -o test_rtm && \
GCOWBOY_ENV=test ./test_rtm

# vim: ts=4 sw=4
