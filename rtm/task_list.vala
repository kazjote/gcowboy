namespace Rtm
{
    public class TaskList : Object
    {
        private int _id;
        private string _name;

        public int id { get { return _id; } }
        public string name { get { return _name; } }
        public bool smart { public get; private set; }

        public TaskList (Xml.Node* element)
        {
            _id = int.parse (element->get_prop ("id"));
            _name = element->get_prop ("name");
            smart = element->get_prop ("smart") == "1";
        }
    }
}

// vim: ts=4 sw=4
