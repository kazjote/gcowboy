void add_authenticator_tests () {

    Test.add_func ("/rtm/authenticator/can be created", () => {
        var proxy = new HttpProxyMock ();

        new Authenticator (proxy, "secret", "apikey");
    });

    Test.add_func ("/rtm/authenticator/reauthenticate", () => {
        var proxy = new HttpProxyMock ();

        var url_prefix = "http://www.rememberthemilk.com/services";
        var expected_frob_url = url_prefix +
            "/rest?api_key=apikey&method=rtm.auth.getFrob&" +
            "api_sig=6afaba7e19337121f1e90cabb6a877ef";
        var expected_auth_url = url_prefix +
            "/auth?api_key=apikey&frob=secretfrob&perms=read,write&" +
            "api_sig=6310b201878d273a990e9cbf9a472da7";
        var expected_token_url = url_prefix +
            "/rest?api_key=apikey&frob=secretfrob&method=rtm.auth.getToken&" +
            "api_sig=5894461ad08c977233c923d784a9866c";

        proxy.recordAnswer (expected_frob_url, "<rsp stat='ok'><frob>secretfrob</frob></rsp>");
        proxy.recordAnswer (expected_token_url, """
            <rsp stat='ok'>
                <auth>
                  <token>Token</token>
                </auth>
            </rsp>""");

        var authenticator = new Authenticator (proxy, "secret", "apikey");

        var authorization_url = "";
        authenticator.authorization.connect((t, url) => {
            authorization_url = url;
        });

        authenticator.reauthenticate ();

        assert (proxy.getRecordedQueries ().get (0) == expected_frob_url);
        assert (authorization_url == expected_auth_url);
        assert (proxy.getRecordedQueries ().get (1) == expected_token_url);
    });
}

// vim: ts=4 sw=4
