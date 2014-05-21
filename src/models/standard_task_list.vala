namespace Models
{
    public class StandardTaskList : Object, TaskList
    {
        public int id { get; private set; }
        public string name { get; private set; }
        public TaskRepository repository { get; private set; }

        private RtmWrapper rtm { get; private set; }

        public StandardTaskList (TaskRepository repo, RtmWrapper _rtm, Rtm.TaskList rtm_task_list)
        {
            repository = repo;
            rtm = _rtm;
            id = rtm_task_list.id;
            name = rtm_task_list.name;
        }

        public List<Task> get_tasks ()
        {
            return repository.get_task_list (id);
        }
    }
}

// vim: ts=4 sw=4