public delegate void MessageProcessedCallback (QueueMessage message);

public class RtmWrapper : Object
{
    private Rtm.Authenticator authenticator;
    private AsyncQueue<QueueMessage> _request_queue;
    private QueueProcessor _queue_processor;

    public signal void authorization (string url);
    public signal void authenticated (string token);

    public RtmWrapper (AsyncQueue<QueueMessage> response_queue)
    {
        this.authenticator = new Rtm.Authenticator (new HttpProxy (), "5792b9b6adbc3847", "7dfc8cb9f7985d712e355ee4526d5c88");

        authenticator.authorization.connect((t, url) => {
            authorization (url);
        });

        authenticator.authenticated.connect((t, token) => {
            authenticated (token);
        });

        this._request_queue = new AsyncQueue<QueueMessage> ();
        this._queue_processor = new QueueProcessor (_request_queue, response_queue);
        this._queue_processor.run ();
    }

    public void set_token (string token)
    {
        authenticator.token = token;
    }

    public void authenticate (MessageProcessedCallback callback)
    {
        var message = new QueueMessage (authenticator, "authenticate", callback);
        _request_queue.push (message);
    }

    public void get_lists (MessageProcessedCallback callback)
    {
        var message = new QueueMessage (authenticator, "rtm.lists.getList", callback);
        _request_queue.push(message);
    }

    public void get_task_series (int? list_id = null, string? filter = null, MessageProcessedCallback callback)
    {
        var message = new QueueMessage (authenticator, "rtm.tasks.getList", callback);
        message.list_id = list_id;
        message.filter = filter;

        _request_queue.push(message);
    }

    public void add_task (string task_name, MessageProcessedCallback callback)
    {
        var message = new QueueMessage (authenticator, "rtm.tasks.add", callback);

        message.name = task_name;
        message.parse = true;

        var timeline_message = new QueueMessage(authenticator, "rtm.timelines.create", (_timeline_message) => {
            var _message = _timeline_message.followup;

            _message.timeline = _timeline_message.rtm_response.timeline.timeline;
            _request_queue.push(_message);
        });

        timeline_message.followup = message;

        _request_queue.push(timeline_message);
    }

    public void complete_task (int list_id, int serie_id, int task_id, MessageProcessedCallback callback)
    {
        var message = new QueueMessage (authenticator, "rtm.tasks.complete", callback);
        message.list_id = list_id;
        message.serie_id = serie_id;
        message.task_id = task_id;
    }
}

// vim: ts=4 sw=4
