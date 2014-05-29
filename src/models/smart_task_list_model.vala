namespace Models
{
    public class SmartTaskListModel : Object, TaskListInterface
    {
        public int id { get; private set; }
        public string name { get; private set; }
        public TaskRepository repository { get; private set; }

        private List<FullTaskID> full_task_ids;
        private RtmWrapper rtm;

        public SmartTaskListModel (TaskRepository repo, RtmWrapper _rtm, Rtm.TaskList rtm_task_list)
        {
            repository = repo;
            id = rtm_task_list.id;
            name = rtm_task_list.name;
            rtm = _rtm;

            repository.tasks_updated.connect (() => {
                tasks_updated ();
            });

            repository.finished_compleating.connect ((task_model) => {
                task_completed (task_model);
            });
        }

        public void update ()
        {
            rtm.get_task_series (id, "", (message) => {
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
