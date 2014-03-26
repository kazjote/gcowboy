public delegate void RtmResponseCallback ();

public class RtmWrapper : Object
{
    private Rtm.Authenticator authenticator;
    private AsyncQueue<QueueMessage> _queue;
    private QueueProcessor _queue_processor;

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

        this._queue = new AsyncQueue<QueueMessage> ();
        this._queue_processor = new QueueProcessor (_queue);
        this._queue_processor.run ();
    }

    public void authenticate (RtmResponseCallback callback)
    {
        var message = new QueueMessage (authenticator, "authenticate", callback);
        _queue.push (message);
    }
}

// vim: ts=4 sw=4
