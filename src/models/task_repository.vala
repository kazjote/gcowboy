namespace Models
{
    public class FullTaskID
    {
        public int list_id { public get; private set; }
        public int serie_id { public get; private set; }
        public int task_id { public get ;private set; }

        public FullTaskID (int _list_id, int _serie_id, int _task_id)
        {
            list_id = _list_id;
            serie_id = _serie_id;
            task_id = _task_id;
        }
    }

    public class TaskRepository : Object
    {
        private Tree<FullTaskID, TaskModel> task_models;
        private RtmWrapper _rtm;

        public signal void tasks_updated ();
        public signal void finished_adding ();
        public signal void finished_compleating (TaskModel task_model);

        public TaskRepository (RtmWrapper rtm)
        {
            task_models = new Tree<FullTaskID, TaskModel> ((a, b) => {
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

        public List<TaskModel> get_task_list (int list_id)
        {
            List<TaskModel> sorted_list = new List<TaskModel> ();

            task_models.foreach ((full_id, task_model) => {
                if (task_model.list_id == list_id)
                    sorted_list.append(task_model);

                return false;
            });

            return (owned) sorted_list;
        }

        public List<TaskModel> get_tasks (List<FullTaskID> full_task_ids)
        {
            var ret = new List<TaskModel> ();

            full_task_ids.foreach ((full_task_id) => {
                ret.append (task_models.lookup (full_task_id));
            });

            return (owned) ret;
        }

        public void fetch_task_list (int list_id)
        {
            _rtm.get_task_series (list_id, "", (message) => {
                update_tasks (message.rtm_response.task_series);

                tasks_updated ();
            });
        }

        public void update_tasks (List<Rtm.TaskSerie> rtm_task_series)
        {
            rtm_task_series.foreach((rtm_task_serie) => {
                rtm_task_serie.tasks.foreach ((rtm_task) => {
                    FullTaskID key = new FullTaskID (rtm_task_serie.list_id,
                        rtm_task_serie.id,
                        rtm_task.id);

                    TaskModel found_task_model = task_models.lookup (key);

                    if (found_task_model != null) {
                        found_task_model.update_with (rtm_task_serie, rtm_task);
                    } else {
                        task_models.insert (key, new TaskModel (rtm_task_serie, rtm_task));
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

        public void complete_task (TaskModel task_model)
        {
            _rtm.complete_task (task_model.list_id, task_model.serie_id, task_model.id, (message) => {
                var key = new FullTaskID (message.list_id, message.serie_id, message.task_id);
                var found_task_model = task_models.lookup (key);

                fetch_task_list (message.list_id);
                if (found_task_model != null) finished_compleating (found_task_model);
            });
        }

    }
}

// vim: ts=4 sw=4
