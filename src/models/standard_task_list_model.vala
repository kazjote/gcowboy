namespace Models
{
    public class StandardTaskListModel : Object, TaskListInterface
    {
        public int id { get; private set; }
        public string name { get; private set; }
        public TaskRepository repository { get; private set; }

        public StandardTaskListModel (TaskRepository repo, RtmWrapper _rtm, Rtm.TaskList rtm_task_list)
        {
            repository = repo;
            id = rtm_task_list.id;
            name = rtm_task_list.name;

            repository.tasks_updated.connect (() => {
                tasks_updated ();
            });

            repository.finished_compleating.connect ((task_model) => {
                task_completed (task_model);
            });
        }

        public void update ()
        {
            repository.fetch_task_list (id);
        }

        public List<TaskModel> get_tasks ()
        {
            return repository.get_task_list (id);
        }

        public void complete_task (TaskModel task_model)
        {
            repository.complete_task (task_model);
        }
    }
}

// vim: ts=4 sw=4
