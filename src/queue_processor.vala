class QueueProcessor : Object
{
    private AsyncQueue<QueueMessage> _queue;

    public QueueProcessor (AsyncQueue<QueueMessage> queue)
    {
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
            message.authenticator.reauthenticate ();
            message.callback ();
        }

        return null;
    }
}

// vim: ts=4 sw=4
