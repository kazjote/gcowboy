valac \
    --pkg gtk+-3.0 \
    --pkg gee-1.0 \
    --pkg libxml-2.0 \
    rtm/rtm.vala \
    rtm/requester.vala \
    rtm/authenticator.vala \
    rtm/response.vala \
    rtm/frob.vala \
    rtm/token.vala \
    src/http_proxy_interface.vala \
    src/gcowboy.vala \
    --Xcc=-w \
    -o test_app && \
./test_app

# vim: ts=4 sw=4
