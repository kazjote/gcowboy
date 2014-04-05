class QueueProcessor : Object
{
    private AsyncQueue<QueueMessage> _queue;
    private AsyncQueue<RtmPostback> _postbacks;

    public QueueProcessor (AsyncQueue<QueueMessage> queue, AsyncQueue<RtmPostback> postbacks)
    {
        this._postbacks = postbacks;
        this._queue = queue;
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

        while ((message = _queue.pop ()) != null)
        {
            message.authenticator.authenticate ();

            var requester = new Rtm.Requester(new HttpProxy (), "5792b9b6adbc3847");

            requester.add_parameter ("api_key", "7dfc8cb9f7985d712e355ee4526d5c88");
            requester.add_parameter ("auth_token", message.authenticator.token);

            var response = requester.request ("rtm.lists.getList");

            while (response == null || response.stat != Rtm.Stat.OK) {
                message.authenticator.reauthenticate();

                requester = new Rtm.Requester(new HttpProxy (), "5792b9b6adbc3847");

                requester.add_parameter ("api_key", "7dfc8cb9f7985d712e355ee4526d5c88");
                requester.add_parameter ("auth_token", message.authenticator.token);

                response = requester.request ("rtm.lists.getList");
            }

            _postbacks.push (new RtmPostback (message.callback, response));
        }

        return null;
    }
}

// vim: ts=4 sw=4
