namespace Rtm
{
    public class Task : Object
    {
        private int _id;

        public int id { get { return _id; } }

        public Task (Xml.Node* element)
        {
            _id = int.parse (element->get_prop ("id"));
        }
    }
}

// vim: ts=4 sw=4
