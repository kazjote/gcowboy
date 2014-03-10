void add_authenticator_tests () {

    Test.add_func ("/rtm/authenticator/can be created", () => {
        var proxy = new HttpProxyMock ();
        var requester = new Requester (proxy, "abcd");

        var authenticator = new Authenticator (requester);
    });

    Test.add_func ("/rtm/authenticator/reauthenticate")
    {
    }
}

// vim: ts=4 sw=4
