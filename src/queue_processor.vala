class QueueProcessor : Object
{
    private AsyncQueue<QueueMessage> _request_queue;
    private AsyncQueue<QueueMessage> _response_queue;

    public QueueProcessor (AsyncQueue<QueueMessage> request_queue, AsyncQueue<QueueMessage> response_queue)
    {
        this._response_queue = response_queue;
        this._request_queue = request_queue;
    }

    public void run ()
    {
        try {
            Thread.create<void*> (processor_func, false);
        } catch (ThreadError e) {
            stderr.printf ("%s\n", e.message);
            return;
        }
    }

    private void* processor_func ()
    {
        QueueMessage message = null;

        while ((message = _request_queue.pop ()) != null)
        {
            message.authenticator.authenticate ();

            var requester = new Rtm.Requester(new HttpProxy (), "5792b9b6adbc3847");
            apply_params (requester, message);

            var response = requester.request (message.method);

            while (response == null || response.stat != Rtm.Stat.OK) {
                message.authenticator.reauthenticate();

                requester = new Rtm.Requester(new HttpProxy (), "5792b9b6adbc3847");
                apply_params (requester, message);

                response = requester.request (message.method);
            }

            message.rtm_response = response;
            _response_queue.push (message);
        }

        return null;
    }

    private void apply_params (Rtm.Requester requester, QueueMessage message)
    {
        requester.add_parameter ("api_key", "7dfc8cb9f7985d712e355ee4526d5c88");
        requester.add_parameter ("auth_token", message.authenticator.token);

        if (message.list_id != null)
            requester.add_parameter ("list_id", message.list_id.to_string ());
        if (message.filter != null)
            requester.add_parameter ("filter", message.filter);
        if (message.name != null)
            requester.add_parameter ("name", message.name);
        if (message.timeline != null)
            requester.add_parameter ("timeline", message.timeline);
        if (message.parse)
            requester.add_parameter ("parse", "1");
        if (message.task_id != null)
            requester.add_parameter ("task_id", message.task_id.to_string ());
        if (message.serie_id != null)
            requester.add_parameter ("taskseries_id", message.serie_id.to_string ());
    }
}

// vim: ts=4 sw=4
