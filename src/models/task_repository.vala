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

            return (owned) sorted_list;
        }

        public void fetch_task_list (int list_id)
        {
            _rtm.get_task_series (list_id, "status:incomplete", (message) => {
                update_tasks (message.rtm_response.task_series);

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
                        _tasks.insert_sorted (new Task (rtm_task_serie, rtm_task), (a, b) => {
                            if (a.priority == b.priority) {
                                return strcmp(a.name.up (), b.name.up ());
                            }

                            return (int) (a.priority > b.priority) - (int) (a.priority < b.priority);
                        });
                    }
                });
            });
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
                stderr.puts ("Complete task");
            });
        }

    }
}

// vim: ts=4 sw=4
