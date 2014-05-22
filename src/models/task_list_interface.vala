namespace Models
{
    public interface TaskListInterface : Object
    {
        public abstract int id { public get; set; }
        public abstract string name { public get; set; }
        public abstract List<TaskModel> get_tasks ();
        public abstract TaskRepository repository { get; set; }

        public signal void tasks_updated ();

        // later on we should have only tasks_updated signal which points to tasks
        // that have been updated.
        public signal void task_completed (TaskModel task_model);

        public abstract void complete_task (TaskModel task_model);
    }
}


// vim: ts=4 sw=4
