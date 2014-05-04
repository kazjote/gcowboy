public class QueueMessage : Object
{
    private Rtm.Authenticator _authenticator;
    private string _method;
    private MessageProcessedCallback _callback;

    public signal void completed ();

    public int? list_id { get; set; }
    public string? filter { get; set; }
    public string? name { get; set; }
    public bool parse { get; set; default = false; }
    public string? timeline { get; set; }
    public int? task_id { get; set; }
    public int? serie_id { get; set; }
    public Rtm.Response? rtm_response { get; set; }
    public QueueMessage? followup { get; set; }

    public Rtm.Authenticator authenticator
    {
        get { return _authenticator; }
    }

    public string method
    {
        get { return _method; }
    }

    public MessageProcessedCallback callback
    {
        get { return _callback; }
    }

    public QueueMessage (Rtm.Authenticator auth, string method, MessageProcessedCallback cb)
    {
        this._authenticator = auth;
        this._method = method;
        this._callback = (message) => { cb (message); };
    }
}

// vim: ts=4 sw=4
