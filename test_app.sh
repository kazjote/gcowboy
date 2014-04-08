valac \
    --pkg gtk+-3.0 \
    --pkg gee-1.0 \
    --pkg libxml-2.0 \
    --pkg libsoup-2.4 \
    --pkg gio-2.0 \
    rtm/rtm.vala \
    rtm/requester.vala \
    rtm/authenticator.vala \
    rtm/response.vala \
    rtm/frob.vala \
    rtm/token.vala \
    rtm/task_list.vala \
    rtm/task_serie.vala \
    rtm/task.vala \
    src/http_proxy_interface.vala \
    src/http_proxy.vala \
    src/gcowboy.vala \
    src/queue_message.vala \
    src/queue_processor.vala \
    src/rtm_wrapper.vala \
    src/views/task.vala \
    src/views/task_list.vala \
    src/models/task.vala \
    src/models/task_repository.vala \
    --Xcc=-w \
    --thread \
    -g \
    -o test_app && \
./test_app

# vim: ts=4 sw=4
