namespace Rtm
{
    public class TaskSerie : Object
    {
        private int _list_id;
        private int _id;
        private List<Task> _tasks;
        private string _name;

        public int list_id { get { return _list_id; } }
        public int id { get { return _id; } }
        public List<Task> tasks { get { return _tasks; } }
        public string name { get { return _name; } }

        public TaskSerie (int list_id, Xml.Node* element)
        {
            _list_id = list_id;
            _name = element->get_prop ("name");
            _id = int.parse (element->get_prop ("id"));

            for (Xml.Node* iter = element->children; iter != null; iter = iter->next) {
                if (iter->name != "task") continue;

                _tasks.append (new Task (iter));
            }
        }
    }
}

// vim: ts=4 sw=4
