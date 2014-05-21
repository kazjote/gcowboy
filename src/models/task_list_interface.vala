namespace Models
{
    public interface TaskListInterface : Object
    {
        public abstract int id { public get; set; }
        public abstract string name { public get; set; }
        public abstract List<Task> get_tasks ();
        public abstract TaskRepository repository { get; set; }
    }
}


// vim: ts=4 sw=4
