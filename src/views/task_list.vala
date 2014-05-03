using Gtk;

namespace Views
{
    class TaskList : Object
    {
        private int _list_id;
        private Box _box;
        private Models.TaskRepository _task_repository;
        private List<Task> _tasks;

        public TaskList (int list_id, Models.TaskRepository task_repository, Box box)
        {
            _list_id = list_id;
            _box = box;
            _task_repository = task_repository;
            _tasks = new List<Task> ();

            task_repository.tasks_updated.connect (() => {
                draw ();
            });
        }

        public void remove ()
        {
            _tasks.foreach ((task) => {
                _box.remove (task.box);
                _tasks.remove (task);
            });
        }

        public void draw ()
        {
            remove ();

            _task_repository.get_task_list (_list_id).foreach ((task_model) => {
                var new_task = new Task (task_model);

                new_task.complete_requested.connect (() => {
                    _task_repository.complete_task (task_model);
                });

                _tasks.append (new_task);

                var task_box = new_task.box;

                task_box.reparent (_box);

                task_box.show ();
            });
        }
    }
}

// vim: ts=4 sw=4
