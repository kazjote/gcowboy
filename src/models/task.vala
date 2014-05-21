namespace Models
{
    public enum Priority {
        HIGHEST,
        MEDIUM,
        LOWEST,
        UNKNOWN
    }

    public class Task : Object
    {
        private int _id;
        private int _list_id;
        private int _serie_id;
        private string _name;
        private string _created;
        private string _url;
        private Priority _priority;

        public int id { get { return _id; } }
        public int list_id { get { return _list_id; } }
        public int serie_id { get { return _serie_id; } }
        public string name { get { return _name; } }
        public string created { get { return _created; } }
        public string url { get { return _url; } }
        public DateTime due { public get; private set; }
        public Priority priority { get { return _priority; } }
        public bool completed { get; private set; }

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
            _created = task_serie.created;
            _url = task_serie.url;
            due = task.due;
            completed = task.completed != "";

            switch (task.priority) {
                case "1":
                    _priority = Priority.HIGHEST;
                    break;
                case "2":
                    _priority = Priority.MEDIUM;
                    break;
                case "3":
                    _priority = Priority.LOWEST;
                    break;
                default:
                    _priority = Priority.UNKNOWN;
                    break;
            }
        }
    }
}

// vim: ts=4 sw=4
