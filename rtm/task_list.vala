namespace Rtm
{
    public class TaskList : Object
    {
        private string _id;
        private string _name;

        public string id { get { return _id; } }
        public string name { get { return _name; } }

        public TaskList (Xml.Node* element)
        {
            _id = element->get_prop ("id");
            _name = element->get_prop ("name");
        }
    }
}

// vim: ts=4 sw=4
