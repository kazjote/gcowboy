namespace Rtm
{
    public class Task : Object
    {
        private int _id;
        private string _priority;

        public int id { get { return _id; } }
        public string priority { get { return _priority; } }
        public string completed { public get; private set; }

        public Task (Xml.Node* element)
        {
            _id = int.parse (element->get_prop ("id"));
            _priority = element->get_prop ("priority");
            completed = element->get_prop ("completed");
        }
    }
}

// vim: ts=4 sw=4
