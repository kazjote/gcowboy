using Gtk;

namespace Views
{
    public class TaskListList : Object
    {
        private Models.TaskListsModel model { get; set; }
        private TreeView list_view { get; private set; }
        private Box task_list_box { get; set; }
        private NotificationArea notification_area { get; set; }
        private TaskList task_list_view { get; set; }

        public TaskListList (Models.TaskListsModel task_lists_model,
                TreeView _list_view,
                Box _task_list_box,
                NotificationArea _notification_area)
        {
            model = task_lists_model;
            list_view = _list_view;
            task_list_box = _task_list_box;
            notification_area = _notification_area;

            list_view.set_model (model);

            list_view.row_activated.connect ((path, column) => {
                var index = path.get_indices ()[0];
                var task_list = model.get_task_list (index);

                if (task_list_view != null) task_list_view.remove ();
                task_list_view = new Views.TaskList (task_list.id, task_list.repository, task_list_box, notification_area);
                task_list_view.draw ();

                task_list.repository.fetch_task_list (task_list.id);
            });
        }
    }
}

// vim: ts=4 sw=4
