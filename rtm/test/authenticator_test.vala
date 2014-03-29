void add_authenticator_tests () {

    Test.add_func ("/rtm/authenticator/can be created", () => {
        var proxy = new HttpProxyMock ();

        new Rtm.Authenticator (proxy, "secret", "apikey");
    });

    Test.add_func ("/rtm/authenticator/reauthenticate", () => {
        var proxy = new HttpProxyMock ();

        var url_prefix = "https://api.rememberthemilk.com/services";
        var expected_frob_url = url_prefix +
            "/rest/?api_key=apikey&method=rtm.auth.getFrob&" +
            "api_sig=6afaba7e19337121f1e90cabb6a877ef";
        var expected_auth_url = "https://www.rememberthemilk.com/services" +
            "/auth/?api_key=apikey&frob=secretfrob&perms=write&" +
            "api_sig=95d16832a9f08639bb5c4ace414ade6d";
        var expected_token_url = url_prefix +
            "/rest/?api_key=apikey&frob=secretfrob&method=rtm.auth.getToken&" +
            "api_sig=5894461ad08c977233c923d784a9866c";

        proxy.recordAnswer (expected_frob_url, "<rsp stat='ok'><frob>secretfrob</frob></rsp>");
        proxy.recordAnswer (expected_token_url, """
            <rsp stat='ok'>
                <auth>
                  <token>Token</token>
                </auth>
            </rsp>""");

        var authenticator = new Rtm.Authenticator (proxy, "secret", "apikey");

        var authorization_url = "";
        authenticator.authorization.connect((t, url) => {
            authorization_url = url;
        });

        var token = "";
        authenticator.authenticated.connect((t, _token) => {
            token = _token;
        });

        authenticator.reauthenticate ();

        assert (proxy.getRecordedQueries ().get (0) == expected_frob_url);
        assert (authorization_url == expected_auth_url);
        assert (proxy.getRecordedQueries ().get (1) == expected_token_url);
        assert (token == "Token");
    });
}

// vim: ts=4 sw=4
