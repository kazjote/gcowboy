using Gtk;

namespace Views
{
    class TaskList : Object
    {
        private int _list_id;
        private Box _box;
        private Models.TaskRepository _task_repository;
        private List<Task> _tasks;
        private bool active;

        public TaskList (int list_id, Models.TaskRepository task_repository, Box box, NotificationAreaView notification_area_view)
        {
            _list_id = list_id;
            _box = box;
            _task_repository = task_repository;
            _tasks = new List<Task> ();

            task_repository.tasks_updated.connect (() => {
                draw ();
            });

            task_repository.finished_compleating.connect ((task) => {
                var name = task.name;

                notification_area_view.set_notification (@"Task '$name' has been completed");
            });

            active = true;
        }

        public void remove ()
        {
            active = false;

            _tasks.foreach ((task) => {
                _box.remove (task.box);
                _tasks.remove (task);
            });
        }

        private void clear_tasks ()
        {
            _tasks.foreach ((task) => {
                _box.remove (task.box);
                _tasks.remove (task);
            });
        }

        public void draw ()
        {
            if (!active) return ;

            clear_tasks ();

            List<Models.TaskModel> task_models = new List<Models.TaskModel> ();

            _task_repository.get_task_list (_list_id).foreach ((task_model) => {
                if (!task_model.completed) {
                    task_models.insert_sorted (task_model, (a, b) => {
                        if (a.priority == b.priority) {
                            return strcmp(a.name.up (), b.name.up ());
                        }

                        return (int) (a.priority > b.priority) - (int) (a.priority < b.priority);
                    });
                }
            });

            task_models.foreach ((task_model) => {
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
