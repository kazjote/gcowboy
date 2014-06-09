namespace Models
{
    class SearchTaskListModel : Object, TaskListInterface
    {
        public int id { get; private set; }
        public string name { get; private set; }
        public TaskRepository repository { get; private set; }

        public signal void finished_fetching ();

        private List<FullTaskID> full_task_ids;
        private RtmWrapper rtm;
        private bool fetched = false;
        private string query { get; set; }

        public SearchTaskListModel(TaskRepository repo, RtmWrapper _rtm, string _query)
        {
            query = _query;
            name = _query;
            repository = repo;
            rtm = _rtm;

            repository.finished_compleating.connect ((task_model) => {
                task_completed (task_model);
            });
        }

        public void update ()
        {
            rtm.get_task_series (null, query, (message) => {
                unowned List<Rtm.TaskSerie> rtm_task_series = message.rtm_response.task_series;

                repository.update_tasks (rtm_task_series);

                full_task_ids = new List<FullTaskID> ();

                rtm_task_series.foreach((rtm_task_serie) => {
                    rtm_task_serie.tasks.foreach ((rtm_task) => {
                        FullTaskID full_task_id = new FullTaskID (rtm_task_serie.list_id,
                            rtm_task_serie.id,
                            rtm_task.id);

                        full_task_ids.append (full_task_id);
                    });
                });

                tasks_updated ();

                if (!fetched) {
                    finished_fetching ();
                    fetched = true;
                }
            });
        }

        public List<TaskModel> get_tasks ()
        {
            return repository.get_tasks (full_task_ids);
        }

        public void complete_task (TaskModel task_model)
        {
            repository.complete_task (task_model);
        }
    }
}

// vim: ts=4 sw=4
