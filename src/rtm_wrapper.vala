public class RtmWrapper : Object
{
    private Rtm.Authenticator authenticator;

    public signal void authorization (string url);
    public signal void authenticated (string token);

    public RtmWrapper ()
    {
        this.authenticator = new Rtm.Authenticator (new HttpProxy (), "5792b9b6adbc3847", "7dfc8cb9f7985d712e355ee4526d5c88");

        authenticator.authorization.connect((t, url) => {
            authorization (url);
        });

        authenticator.authenticated.connect((t, token) => {
            authenticated (token);
        });
    }

    public void authenticate ()
    {
        authenticator.reauthenticate ();
    }
}

// vim: ts=4 sw=4
