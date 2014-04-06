class QueueMessage : Object
{
    private Rtm.Authenticator _authenticator;
    private string _method;
    private RtmResponseCallback _callback;

    public signal void completed ();

    public int? list_id { get; set; }
    public string? filter { get; set; }

    public Rtm.Authenticator authenticator
    {
        get { return _authenticator; }
    }

    public string method
    {
        get { return _method; }
    }

    public RtmResponseCallback callback
    {
        get { return _callback; }
    }

    public QueueMessage (Rtm.Authenticator auth, string method, RtmResponseCallback cb)
    {
        this._authenticator = auth;
        this._method = method;
        this._callback = (response) => { cb (response); };
    }
}

// vim: ts=4 sw=4
