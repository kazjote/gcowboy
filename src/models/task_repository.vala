namespace Models
{
    class TaskRepository : Object
    {
        class FullID
        {
            public int list_id { public get; private set; }
            public int serie_id { public get; private set; }
            public int task_id { public get ;private set; }

            public FullID (int _list_id, int _serie_id, int _task_id)
            {
                list_id = _list_id;
                serie_id = _serie_id;
                task_id = _task_id;
            }
        }

        private Tree<FullID, Task> tasks;
        private RtmWrapper _rtm;

        public signal void tasks_updated ();
        public signal void finished_adding ();
        public signal void finished_compleating (Task task);

        public TaskRepository (RtmWrapper rtm)
        {
            tasks = new Tree<FullID, Task> ((a, b) => {
                int cmp_result = 0;

                if ((cmp_result = intcmp (a.list_id, b.list_id)) != 0) {
                    return cmp_result;
                } else if ((cmp_result = intcmp (a.serie_id, b.serie_id)) != 0) {
                    return cmp_result;
                } else {
                    return intcmp (a.task_id, b.task_id);
                }
            });
            _rtm = rtm;
        }

        public List<Task> get_task_list (int list_id)
        {
            List<Task> sorted_list = new List<Task> ();

            tasks.foreach ((full_id, task) => {
                if (task.list_id == list_id)
                    sorted_list.append(task);

                return false;
            });

            return (owned) sorted_list;
        }

        public void fetch_task_list (int list_id)
        {
            _rtm.get_task_series (list_id, "", (message) => {
                update_tasks (message.rtm_response.task_series);

                tasks_updated ();
            });
        }

        private void update_tasks (List<Rtm.TaskSerie> rtm_task_series)
        {
            rtm_task_series.foreach((rtm_task_serie) => {
                rtm_task_serie.tasks.foreach ((rtm_task) => {
                    FullID key = new FullID (rtm_task_serie.list_id,
                        rtm_task_serie.id,
                        rtm_task.id);

                    Task found_task = tasks.lookup (key);

                    if (found_task != null) {
                        found_task.update_with (rtm_task_serie, rtm_task);
                    } else {
                        tasks.insert (key, new Task (rtm_task_serie, rtm_task));
                    }
                });
            });
        }

        public static int intcmp (int a, int b) {
            return (int) (a > b) - (int) (a < b);
        }

        public void add_task (string name)
        {
            _rtm.add_task (name, (message) => {
                update_tasks (message.rtm_response.task_series);

                finished_adding();
            });
        }

        public void complete_task (Task task)
        {
            _rtm.complete_task (task.list_id, task.serie_id, task.id, (message) => {
                var key = new FullID (message.list_id, message.serie_id, message.task_id);
                var found_task = tasks.lookup (key);

                fetch_task_list (message.list_id);
                if (found_task != null) finished_compleating (found_task);
            });
        }

    }
}

// vim: ts=4 sw=4
