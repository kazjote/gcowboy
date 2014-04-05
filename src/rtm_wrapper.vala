public delegate void RtmResponseCallback (Rtm.Response response);

public class RtmPostback : Object
{
    public delegate void Postback ();

    private Postback _postback;

    public Postback postback { get { return _postback; } }

    public RtmPostback (RtmResponseCallback callback, Rtm.Response response)
    {
        _postback = () => { callback (response); };
    }
}

public class RtmWrapper : Object
{
    private Rtm.Authenticator authenticator;
    private AsyncQueue<QueueMessage> _queue;
    private QueueProcessor _queue_processor;

    public signal void authorization (string url);
    public signal void authenticated (string token);

    public RtmWrapper (AsyncQueue<RtmPostback> postbacks)
    {
        this.authenticator = new Rtm.Authenticator (new HttpProxy (), "5792b9b6adbc3847", "7dfc8cb9f7985d712e355ee4526d5c88");

        authenticator.authorization.connect((t, url) => {
            authorization (url);
        });

        authenticator.authenticated.connect((t, token) => {
            authenticated (token);
        });

        this._queue = new AsyncQueue<QueueMessage> ();
        this._queue_processor = new QueueProcessor (_queue, postbacks);
        this._queue_processor.run ();
    }

    public void authenticate (RtmResponseCallback callback)
    {
        var message = new QueueMessage (authenticator, "authenticate", callback);
        _queue.push (message);
    }

    public void get_lists (RtmResponseCallback callback)
    {
        var message = new QueueMessage (authenticator, "getList", callback);
        _queue.push(message);
    }

    public void get_tasks
}

// vim: ts=4 sw=4
