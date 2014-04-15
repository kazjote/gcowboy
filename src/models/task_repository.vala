namespace Models
{
    class TaskRepository : Object
    {
        private List<Task> _tasks;
        private RtmWrapper _rtm;

        public signal void tasks_updated ();
        public signal void finished_adding ();

        public TaskRepository (RtmWrapper rtm)
        {
            _tasks = new List<Task> ();
            _rtm = rtm;
        }

        public List<Task> get_task_list (int list_id)
        {
            List<Task> sorted_list = new List<Task> ();

            _tasks.foreach ((task) => {
                if (task.list_id == list_id)
                    sorted_list.append(task);
            });

            sorted_list.sort_with_data ((a, b) => {
                return strcmp(a.name, b.name);
            });

            return (owned) sorted_list;
        }

        public void fetch_task_list (int list_id)
        {
            _rtm.get_task_series (list_id, "status:incomplete", (response) => {
                update_tasks (response.task_series);

                tasks_updated ();
            });
        }

        private void update_tasks (List<Rtm.TaskSerie> rtm_task_series)
        {
            rtm_task_series.foreach((rtm_task_serie) => {
                rtm_task_serie.tasks.foreach ((rtm_task) => {
                    Task found_task = null;

                    _tasks.foreach ((task) => {
                        if (task.id == rtm_task.id) {
                            found_task = task;
                        }
                    });

                    if (found_task != null) {
                        found_task.update_with (rtm_task_serie, rtm_task);
                    } else {
                        _tasks.append (new Task (rtm_task_serie, rtm_task));
                    }
                });
            });
        }

        public void add_task (string name)
        {
            _rtm.add_task (name, (response) => {
                update_tasks (response.task_series);

                finished_adding();
            });
        }
    }
}

// vim: ts=4 sw=4
