namespace Rtm
{
    public class Task : Object
    {
        private int _id;
        private string _priority;

        public int id { get { return _id; } }
        public string priority { get { return _priority; } }
        public string completed { public get; private set; }
        public DateTime due { public get; private set; }

        public Task (Xml.Node* element)
        {
            var id_string = element->get_prop ("id");
            if (id_string != null)
                _id = int.parse (id_string);

            _priority = element->get_prop ("priority");
            completed = element->get_prop ("completed");

            var due_string = element->get_prop ("due");
            if (due_string == null || due_string == "") {
                due = null;
            } else {
                var timeval = TimeVal ();
                timeval.from_iso8601 (due_string);
                due = new DateTime.from_timeval_utc (timeval);
            }
        }
    }
}

// vim: ts=4 sw=4
