namespace Models
{
    class Task : Object
    {
        private int _id;
        private int _list_id;
        private int _serie_id;
        private string _name;

        public int id { get { return _id; } }
        public int list_id { get { return _list_id; } }
        public int serie_id { get { return _serie_id; } }
        public string name { get { return _name; } }

        public Task (Rtm.TaskSerie task_serie, Rtm.Task task)
        {
            update_with (task_serie, task);
        }

        public void update_with (Rtm.TaskSerie task_serie, Rtm.Task task)
        {
            _id = task.id;
            _list_id = task_serie.list_id;
            _serie_id = task_serie.id;
            _name = task_serie.name;
        }
    }
}

// vim: ts=4 sw=4
